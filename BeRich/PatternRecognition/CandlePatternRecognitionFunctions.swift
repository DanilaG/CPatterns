
func ext_near(x: Double, y: Double) -> Bool {
    return abs(x - y)/max(x, y) <= 0.003
}

func lar_less(x: Double , y: Double) -> Bool {
    let z=(y-x)/x
    return (0.025<=z) && (z<0.05)
}

func lar_greater(x: Double , y: Double) -> Bool {
    let z=(x-y)/x
    return (0.025<=z) && (z<0.05)
}

func sli_less(x: Double , y: Double) -> Bool {
    let z=(y-x)/x
    return (0.003<=z) && (z<0.01)
}

func sli_greater(x: Double , y: Double) -> Bool {
    let z=(x-y)/x
    return (0.003<=z) && (z<0.01)
}


print(ext_near(x:1000.0,y:1005.0))
print(lar_less(x:1000.0,y:1030.0))
print(lar_greater(x:1030.0,y:1000.0))
print(sli_less(x:1000.0,y:1004.0))
print(sli_greater(x:1004.0,y:1000.0))
