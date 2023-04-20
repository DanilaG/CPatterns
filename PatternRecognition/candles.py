import pandas as pd
import json

df=pd.read_csv("sber2.csv")
a=df.iloc[0,4:8]
d=df.iloc[0:1,4:8]
print (a)

def ext_near(x, y):
    return abs(x - y)/max(x, y) <= 0.003

def lar_less(x, y):
    z=(y-x)/x
    return (0.025<=z) and (z<0.05)

def lar_greater(x, y):
    z=(x-y)/x
    return (0.025<=z) and (z<0.05)

def sli_less(x, y):
    z=(y-x)/x
    return (0.003<=z) and (z<0.01)

def sli_greater(x, y):
    z=(x-y)/x
    return (0.003<=z) and (z<0.01)

def mod_near (x,y):
    z=abs(x-y)/max(x,y)
    return 0.003<=z and z<0.01

class Candlestick:
    def __init__(self,b):
        self.op=b[0]
        self.hp=b[1]
        self.lp=b[2]
        self.cp=b[3]

#    def hb(self):
#        return abs(self.cp-self.op)
        self.hb=abs(self.cp-self.op)
        self.tp_body=max(self.op,self.cp)
        self.bm_body= min(self.op, self.cp)
        self.us = self.hp - self.tp_body
        self.ls= self.bm_body- self.lp
        self.hs = self.us + self.ls
        self.black_body= self.op>self.cp
        self.white_body= self.op<self.cp
        self.long_body= lar_less(self.bm_body, self.tp_body)
        self.small_body= sli_less(self.bm_body, self.tp_body)
        self.small_us = sli_greater(self.hp, self.tp_body)
        self.small_ls = sli_less(self.lp, self.bm_body)
        self.long_us = lar_greater(self.hp, self.tp_body)
        self.long_ls = lar_less (self.lp, self.bm_body)
        self.long_black_body= self.long_body and self.black_body
        self.long_white_body= self.long_body and self.white_body
        self.no_ls= ext_near(self.lp, self.bm_body)
        self.no_us= ext_near(self.hp, self.tp_body)
        self.doji = ext_near(self.op, self.cp)

class Timeseries:
    def __init__(self,t):
        self.candls=[]
        self.len = len(t)
        for i in range (0,self.len):
            self.candls.append(Candlestick(t.iloc[i]))

def up_body_gap (c1:Candlestick, c2:Candlestick):
    return c1.tp_body < c2.bm_body

def down_body_gap (c1:Candlestick, c2:Candlestick):
    return c1.bm_body  > c2.tp_body

def ap(t:Timeseries, k):
    #средняя close по 5 свечам, начиная с k
    if t.len<k+5: return 0
    s=0
    for i in range (k,k+5):
        s+=t.candls[i].cp
    return s/5

def pt(t:Timeseries):
    # тренд по 1-м 8 свечам
    if t.len<8: return 0
    if ap(t,0)<ap(t,1) and ap(t,1)<ap(t,2) and ap(t,2)<ap(t,3) : return 1
    if ap(t,0)>ap(t,1) and ap(t,1)>ap(t,2) and ap(t,2)>ap(t,3) : return -1
    return 0

#PATTERNS

def marubozu_black(t:Timeseries):
    return (t.len == 1) and t.candls[0].no_us and t.candls[0].long_black_body and t.candls[0].no_ls

def marubozu_white(t:Timeseries):
    return (t.len == 1) and t.candls[0].no_us and t.candls[0].long_white_body and t.candls[0].no_ls

def hammer (t:Timeseries):
#9 свечей - 8 тренд + 1 значимая
    if t.len != 9: return False
    return pt(t)==-1 and t.candls[8].small_body and (not t.candls[8].no_ls) and (2*t.candls[8].hb < t.candls[8].ls and \
        t.candls[8].ls < 3*t.candls[8].hb) and (t.candls[8].small_us or t.candls[8].no_us)

def piercing_pattern (t:Timeseries):
#10 свечей - 8 тренд + 2 значимых
    if t.len != 10: return False
    return pt(t)==-1 and t.candls[8].black_body and t.candls[9].white_body and \
        (t.candls[9].op < t.candls[8].lp) and \
        ((0.5* (t.candls[8].cp + t.candls[8].op) < t.candls[9].cp) and (t.candls[9].cp < t.candls[8].op))

def two_crowns (t:Timeseries):
#11 свечей - 8 тренд + 3 значимых
    if t.len != 11: return False
    return pt(t)==1 and t.candls[8].long_white_body and t.candls[9].black_body and up_body_gap(t.candls[8], t.candls[9]) \
            and t.candls[10].black_body and ((t.candls[9].cp <t.candls[10].op and t.candls[10].op < t.candls[9].op) or \
            (t.candls[8].op <t.candls[10].cp and t.candls[10].cp < t.candls[8].cp))

def concealing_baby_swallow (t:Timeseries):
#12 свечей - 8 тренд + 4 значимых
    if t.len != 12: return False
    return pt(t)==-1 and \
        t.candls[8].no_us and t.candls[8].long_black_body and t.candls[8].no_ls and \
        t.candls[9].no_us and t.candls[9].long_black_body and t.candls[9].no_ls and\
        t.candls[10].black_body and t.candls[10].long_us and down_body_gap (t.candls[8], t.candls[10]) and \
        down_body_gap (t.candls[9], t.candls[10]) and (t.candls[9].op > t.candls[10].hp and t.candls[10].hp > t.candls[9].cp) \
        and t.candls[11].black_body and t.candls[11].hp > t.candls[10].hp and t.candls[10].lp > t.candls[11].lp

def ladder_bottom (t:Timeseries):
#13 свечей - 8 тренд + 5 значимых
    if t.len != 13: return False
    return pt(t)==-1 and \
        t.candls[8].long_black_body and t.candls[9].long_black_body and t.candls[10].long_black_body and \
        t.candls[9].op < t.candls[8].op and t.candls[10].op < t.candls[9].op and \
        t.candls[9].cp < t.candls[8].cp and t.candls[10].cp < t.candls[9].cp and \
        t.candls[11].black_body and (not t.candls[11].no_us) and t.candls[12].white_body and \
        up_body_gap(t.candls[11], t.candls[12])

def takuri_line (t:Timeseries):
# 9 candles = 8 trend + 1 significant
    if t.len != 9: return False
    return pt(t)==-1 and t.candls[8].small_body and t.candls[8].no_us and ( t.candls[8].ls > 3*t.candls[8].hb)

def kicking_bullish (t:Timeseries):
# 2 candles = 2 significant, trend is not important
    if t.len != 2: return False
    return t.candls[0].long_black_body and \
        t.candls[0].no_us and t.candls[0].no_ls and\
        up_body_gap(t.candls[0], t.candls[1]) and t.candls[1].long_white_body and\
        t.candls[1].no_us and t.candls[1].no_ls

def belt_hold_bullish (t:Timeseries):
# 9 candles = 8 trend + 1 significant
    if t.len != 9: return False
    return pt(t)==-1 and t.candls[8].long_white_body and t.candls[8].no_ls and mod_near(t.candls[8].cp, t.candls[8].hp)

def marubozu_closing_black (t:Timeseries):
# 1 significant
    return (t.len == 1) and (not t.candls[0].no_us) and t.candls[0].long_black_body and t.candls[0].no_ls

def marubozu_opening_white (t:Timeseries):
# 1 significant
    return (t.len == 1) and (not t.candls[0].no_us) and t.candls[0].long_white_body and t.candls[0].no_ls

def shooting_star_one_candle (t:Timeseries):
# 9 candles = 8 trend + 1 significant
    if t.len != 9: return False
    return pt(t)==1 and t.candls[8].long_us and t.candls[8].no_ls and t.candls[8].small_body and \
        (t.candls[8].us > 2*t.candls[8].hb)

def doji_gravestone (t:Timeseries):
# 1 significant
    return (t.len == 1) and t.candls[0].doji and t.candls[0].no_ls and t.candls[0].long_us

def belt_hold_bearish (t:Timeseries):
# 9 candles = 8 trend + 1 significant
    if t.len != 9: return False
    return pt(t)==1 and t.candls[8].long_black_body and t.candls[8].no_us and t.candls[8].small_ls

def doji_dragonfly (t:Timeseries):
# 1 significant
    return (t.len == 1) and t.candls[0].doji and t.candls[0].small_us and t.candls[0].long_ls

pat1=   [{"funct": doji_dragonfly, "tot_len" : 1, "sig_len":1, "name":"Doji, Dragonfly"},
        {"funct":doji_gravestone, "tot_len":1, "sig_len":1, "name":"Doji, Gravestone"},
        {"funct":marubozu_opening_white, "tot_len":1, "sig_len":1, "name":"Marubozu, Opening White"},
        {"funct":marubozu_closing_black, "tot_len":1, "sig_len":1, "name":"Marubozu, Closing Black"},
        {"funct":marubozu_white, "tot_len":1, "sig_len":1, "name":"Marubozu White"},
        {"funct":marubozu_black, "tot_len":1, "sig_len":1, "name":"Marubozu Black"},
        {"funct":hammer, "tot_len":9, "sig_len":1, "name":"Hammer"},
        {"funct":piercing_pattern, "tot_len":10, "sig_len":2, "name":"Piercing Pattern"},
        {"funct":two_crowns, "tot_len":11, "sig_len":3, "name":"Two Crowns"},
        {"funct":concealing_baby_swallow, "tot_len":12, "sig_len":4, "name":"Concealing Baby Swallow"},
        {"funct":ladder_bottom, "tot_len":13, "sig_len":5, "name":"Ladder Bottom"},
        {"funct":takuri_line, "tot_len":9, "sig_len":1, "name":"Takuri Line"},
        {"funct":kicking_bullish, "tot_len":2, "sig_len":2, "name":"Kicking Bullish"},
        {"funct":belt_hold_bullish, "tot_len":9, "sig_len":1, "name":"Belt Hold, Bearish"},
        {"funct":shooting_star_one_candle, "tot_len":9, "sig_len":1, "name":"Shooting Star, One-Candle"},
        {"funct":belt_hold_bearish, "tot_len":9, "sig_len":1, "name":"Belt Hold, Bearish"}]


c=Candlestick(a)
ts=Timeseries(d)
#print (d.iloc[0])
print(ts.len)
print(ts.candls[0].no_ls)

ja =[]

for i in range(0,len(df)):
    jw={}
    for k in range (0, len(pat1)):
        if i<(pat1[k]["tot_len"] - 1) : continue
        d=df.iloc[(i-pat1[k]["tot_len"]+1):(i+1),4:8]
        ts=Timeseries(d)
        if pat1[k]["funct"](ts):
            fr=i-pat1[k]["sig_len"]+1
            jw["Pattern"] = pat1[k]["name"]
            jw["From line"] = str(fr)
            jw["To line"] = str(i)
            jw["From"] = str(df.iloc[fr,2]) + " " + str(df.iloc[fr,3])
            jw["To"] = str(df.iloc[i,2]) + " " + str(df.iloc[i,3])
            ja.append(jw)

with open("out2_1.json","w") as jf:
    json.dump(ja, jf)

