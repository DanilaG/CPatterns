import Foundation

enum CandlePattern: CaseIterable {
    case marubozuBlack
    case marubozuWhite
    case hammer
    case piercingPattern
    case twoCrowns
    case concealingBabySwallow
    case ladderBottom
    case takuriLine
    case kickingBullish
    case belt_hold_bullish
    case marubozu_closing_black
    case marubozu_opening_white
    case shooting_star_one_candle
    case doji_gravestone
    case belt_hold_bearish
    case doji_dragonfly
    case hanging_man
    case doji_northern
    case doji_long_legged
    case matching_low
    case hammer_inverted
    case kicking_bearish
    case harami_cross_bullish
    case morning_doji_star
    case above_the_stomach
    case dark_cloud_cover
}

extension CandlePattern {
    var title: String {
        switch self {
        case .marubozuBlack:
            return "Marubozu Black"
        case .marubozuWhite:
            return "Marubozu White"
        case .hammer:
            return "Hammer"
        case .piercingPattern:
            return "Piercing Pattern"
        case .twoCrowns:
            return "Two Crowns"
        case .concealingBabySwallow:
            return "Concealing Baby Swallow"
        case .ladderBottom:
            return "Ladder Bottom"
        case .takuriLine:
            return "Takuri Line"
        case .kickingBullish:
            return "Kicking Bullish"
        case .belt_hold_bullish:
            return "Belt Hold Bullish"
        case .marubozu_closing_black:
            return "Marubozu Closing Black"
        case .marubozu_opening_white:
            return "Marubozu Opening White"
        case .shooting_star_one_candle:
            return "Shooting Star One Candle"
        case .doji_gravestone:
            return "Doji Gravestone"
        case .belt_hold_bearish:
            return "Belt Hold Bearish"
        case .doji_dragonfly:
            return "Doji Dragonfly"
        case .hanging_man:
            return "Hanging Man"
        case .doji_northern:
            return "Doji Northern"
        case .doji_long_legged:
            return "Doji Long Legged"
        case .matching_low:
            return "Matching Low"
        case .hammer_inverted:
            return "Hammer Inverted"
        case .kicking_bearish:
            return "Kicking Bearish"
        case .harami_cross_bullish:
            return "Harami Cross Bullish"
        case .morning_doji_star:
            return "Morning Doji Star"
        case .above_the_stomach:
            return "Above The Stomach"
        case .dark_cloud_cover:
            return "Above The Stomach"
        }
    }

    var patternLenght: Int {
        switch self {
        case .marubozuBlack:
            return 1
        case .marubozuWhite:
            return 1
        case .hammer:
            return 9
        case .piercingPattern:
            return 10
        case .twoCrowns:
            return 11
        case .concealingBabySwallow:
            return 12
        case .ladderBottom:
            return 13
        case .takuriLine:
            return 9
        case .kickingBullish:
            return 2
        case .belt_hold_bullish:
            return 9
        case .marubozu_closing_black:
            return 1
        case .marubozu_opening_white:
            return 1
        case .shooting_star_one_candle:
            return 9
        case .doji_gravestone:
            return 1
        case .belt_hold_bearish:
            return 9
        case .doji_dragonfly:
            return 1
        case .hanging_man:
            return 9
        case .doji_northern:
            return 9
        case .doji_long_legged:
            return 1
        case .matching_low:
            return 10
        case .hammer_inverted:
            return 10
        case .kicking_bearish:
            return 2
        case .harami_cross_bullish:
            return 10
        case .morning_doji_star:
            return 11
        case .above_the_stomach:
            return 10
        case .dark_cloud_cover:
            return 10
        }
    }

    var patternSignificantLength: Int {
        switch self {
        case .marubozuBlack:
            return 1
        case .marubozuWhite:
            return 1
        case .hammer:
            return 1
        case .piercingPattern:
            return 2
        case .twoCrowns:
            return 3
        case .concealingBabySwallow:
            return 4
        case .ladderBottom:
            return 5
        case .takuriLine:
            return 1
        case .kickingBullish:
            return 2
        case .belt_hold_bullish:
            return 1
        case .marubozu_closing_black:
            return 1
        case .marubozu_opening_white:
            return 1
        case .shooting_star_one_candle:
            return 1
        case .doji_gravestone:
            return 1
        case .belt_hold_bearish:
            return 1
        case .doji_dragonfly:
            return 1
        case .hanging_man:
            return 1
        case .doji_northern:
            return 1
        case .doji_long_legged:
            return 1
        case .matching_low:
            return 2
        case .hammer_inverted:
            return 2
        case .kicking_bearish:
            return 2
        case .harami_cross_bullish:
            return 2
        case .morning_doji_star:
            return 3
        case .above_the_stomach:
            return 2
        case .dark_cloud_cover:
            return 2
        }
    }

    var logicalCondition: (Timeseries) -> Bool {
        switch self {
        case .marubozuBlack:
            return { t in
                t.len == 1 &&
                    t.candlesticks[0].no_us &&
                    t.candlesticks[0].long_black_body &&
                    t.candlesticks[0].no_ls
            }
        case .marubozuWhite:
            return { t in
                t.len == 1 &&
                    t.candlesticks[0].no_us &&
                    t.candlesticks[0].long_white_body &&
                    t.candlesticks[0].no_ls
            }
        case .hammer:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].small_body &&
                    (!t.candlesticks[8].no_ls) &&
                    (2 * t.candlesticks[8].hb < t.candlesticks[8].ls &&
                        t.candlesticks[8].ls < 3 * t.candlesticks[8].hb) &&
                    (t.candlesticks[8].small_us || t.candlesticks[8].no_us)
            }
        case .piercingPattern:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].black_body &&
                    t.candlesticks[9].white_body &&
                    (t.candlesticks[9].openPrice < t.candlesticks[8].lowPrice) &&
                    ((0.5 * (t.candlesticks[8].closePrice + t.candlesticks[8].openPrice) < t.candlesticks[9].closePrice) &&
                        (t.candlesticks[9].closePrice < t.candlesticks[8].openPrice))
            }
        case .twoCrowns:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].long_white_body &&
                    t.candlesticks[9].black_body &&
                    up_body_gap(t.candlesticks[8], t.candlesticks[9]) &&
                    t.candlesticks[10].black_body &&
                    ((t.candlesticks[9].closePrice < t.candlesticks[10].openPrice && t.candlesticks[10].openPrice < t.candlesticks[9].openPrice) ||
                        (t.candlesticks[8].openPrice < t.candlesticks[10].closePrice && t.candlesticks[10].closePrice < t.candlesticks[8].closePrice))
            }
        case .concealingBabySwallow:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].no_us &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[8].no_ls &&
                    t.candlesticks[9].no_us &&
                    t.candlesticks[9].long_black_body &&
                    t.candlesticks[9].no_ls &&
                    t.candlesticks[10].black_body &&
                    t.candlesticks[10].long_us &&
                    down_body_gap(t.candlesticks[8], t.candlesticks[10]) &&
                    down_body_gap(t.candlesticks[9], t.candlesticks[10]) &&
                    (t.candlesticks[9].openPrice > t.candlesticks[10].highPrice &&
                        t.candlesticks[10].highPrice > t.candlesticks[9].closePrice) &&
                    t.candlesticks[11].black_body &&
                    t.candlesticks[11].highPrice > t.candlesticks[10].highPrice &&
                    t.candlesticks[10].lowPrice > t.candlesticks[11].lowPrice
            }
        case .ladderBottom:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[9].long_black_body &&
                    t.candlesticks[10].long_black_body &&
                    t.candlesticks[9].openPrice < t.candlesticks[8].openPrice &&
                    t.candlesticks[10].openPrice < t.candlesticks[9].openPrice &&
                    t.candlesticks[9].closePrice < t.candlesticks[8].closePrice &&
                    t.candlesticks[10].closePrice < t.candlesticks[9].closePrice &&
                    t.candlesticks[11].black_body &&
                    !t.candlesticks[11].no_us &&
                    t.candlesticks[12].white_body &&
                    up_body_gap(t.candlesticks[11], t.candlesticks[12])
            }
        case .takuriLine:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].small_body &&
                    t.candlesticks[8].no_us &&
                    (t.candlesticks[8].ls > 3 * t.candlesticks[8].hb)
            }
        case .kickingBullish:
            return { t in
                t.candlesticks[0].long_black_body &&
                    t.candlesticks[0].no_us &&
                    t.candlesticks[0].no_ls &&
                    up_body_gap(t.candlesticks[0], t.candlesticks[1]) &&
                    t.candlesticks[1].long_white_body &&
                    t.candlesticks[1].no_us &&
                    t.candlesticks[1].no_ls
            }
        case .belt_hold_bullish:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_white_body &&
                    t.candlesticks[8].no_ls &&
                    mod_near(t.candlesticks[8].closePrice, t.candlesticks[8].highPrice)
            }
        case .marubozu_closing_black:
            return { t in
                (!t.candlesticks[0].no_us) &&
                    t.candlesticks[0].long_black_body &&
                    t.candlesticks[0].no_ls
            }
        case .marubozu_opening_white:
            return { t in
                !t.candlesticks[0].no_us &&
                    t.candlesticks[0].long_white_body &&
                    t.candlesticks[0].no_ls
            }
        case .shooting_star_one_candle:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].long_us &&
                    t.candlesticks[8].no_ls &&
                    t.candlesticks[8].small_body &&
                    t.candlesticks[8].us > 2 * t.candlesticks[8].hb
            }
        case .doji_gravestone:
            return { t in
                t.candlesticks[0].doji &&
                    t.candlesticks[0].no_ls &&
                    t.candlesticks[0].long_us
            }
        case .belt_hold_bearish:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[8].no_us &&
                    t.candlesticks[8].small_ls
            }
        case .doji_dragonfly:
            return { t in
                t.candlesticks[0].doji &&
                    t.candlesticks[0].small_us &&
                    t.candlesticks[0].long_ls
            }
        case .hanging_man:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].small_body &&
                    t.candlesticks[8].no_us &&
                    t.candlesticks[8].long_ls
            }
        case .doji_northern:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].doji
            }
        case .doji_long_legged:
            return { t in
                t.candlesticks[0].doji &&
                    t.candlesticks[0].long_us &&
                    t.candlesticks[0].long_ls
            }
        case .matching_low:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[9].black_body &&
                    ext_near(t.candlesticks[8].closePrice, t.candlesticks[9].closePrice)
            }
        case .hammer_inverted:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[8].small_ls &&
                    t.candlesticks[9].small_body &&
                    t.candlesticks[9].long_us &&
                    t.candlesticks[9].no_ls &&
                    down_body_gap(t.candlesticks[8], t.candlesticks[9])
            }
        case .kicking_bearish:
            return { t in
                t.candlesticks[0].no_us &&
                    t.candlesticks[0].no_ls &&
                    t.candlesticks[0].long_white_body &&
                    t.candlesticks[1].no_us &&
                    t.candlesticks[1].no_ls &&
                    t.candlesticks[1].long_black_body &&
                    down_shadow_gap(t.candlesticks[0], t.candlesticks[1])
            }
        case .harami_cross_bullish:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[9].doji &&
                    (t.candlesticks[8].lowPrice < t.candlesticks[9].lowPrice) &&
                    (t.candlesticks[9].highPrice < t.candlesticks[8].highPrice)
            }
        case .morning_doji_star:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].long_black_body &&
                    t.candlesticks[9].doji &&
                    down_body_gap(t.candlesticks[8], t.candlesticks[9]) &&
                    t.candlesticks[10].long_white_body &&
                    up_body_gap(t.candlesticks[9], t.candlesticks[10])
            }
        case .above_the_stomach:
            return { t in
                CandlePattern.pt(t) == -1 &&
                    t.candlesticks[8].black_body &&
                    t.candlesticks[9].white_body &&
                    (t.candlesticks[9].openPrice >= (0.5 * (t.candlesticks[8].closePrice + t.candlesticks[8].openPrice))) &&
                    (t.candlesticks[9].closePrice >= (0.5 * (t.candlesticks[8].closePrice + t.candlesticks[8].openPrice)))
            }
        case .dark_cloud_cover:
            return { t in
                CandlePattern.pt(t) == 1 &&
                    t.candlesticks[8].long_white_body &&
                    t.candlesticks[9].black_body &&
                    (t.candlesticks[9].openPrice > t.candlesticks[8].highPrice) &&
                    (t.candlesticks[9].closePrice >= (0.5 * (t.candlesticks[8].closePrice + t.candlesticks[8].openPrice)))
            }
        }
    }
}

extension CandlePattern {
    private static func ap(_ t: Timeseries, _ k: Int) -> Double {
        // средняя close по 5 свечам, начиная с k
        if t.len < k + 5 { return 0 }
        var s = 0.0
        for i in k ..< k + 5 {
            s += t.candlesticks[i].closePrice
        }
        return s / 5
    }

    private static func pt(_ t: Timeseries) -> Int {
        // тренд по 1-м 8 свечам
        if t.len < 8 { return 0 }
        if ap(t, 0) < ap(t, 1),
           ap(t, 1) < ap(t, 2),
           ap(t, 2) < ap(t, 3)
        {
            return 1
        }
        if ap(t, 0) > ap(t, 1),
           ap(t, 1) > ap(t, 2),
           ap(t, 2) > ap(t, 3)
        {
            return -1
        }
        return 0
    }
}

private func up_body_gap(_ c1: PatternDetectorCandle, _ c2: PatternDetectorCandle) -> Bool {
    c1.tp_body < c2.bm_body
}

private func down_body_gap(_ c1: PatternDetectorCandle, _ c2: PatternDetectorCandle) -> Bool {
    c1.bm_body > c2.tp_body
}

private func mod_near(_ x: Double, _ y: Double) -> Bool {
    let z = abs(x - y) / max(x, y)
    return z >= 0.003 && z < 0.01
}

private func ext_near(_ x: Double, _ y: Double) -> Bool {
    abs(x - y) / max(x, y) <= 0.003
}

private func down_shadow_gap(_ c1: PatternDetectorCandle, _ c2: PatternDetectorCandle) -> Bool {
    c1.lowPrice > c2.highPrice
}
