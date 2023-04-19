import Foundation

struct Timeseries {
    // Длинна серии свечей
    let len: Int
    // Количество значимых свечей
    // Значимые свечи всегда в конце
    let numberOfSignificantCandles: Int
    let candlesticks: [PatternDetectorCandle]
    // Начало паттерна
    var startDate: Date {
        candlesticks[len - numberOfSignificantCandles].date
    }

    // Конец паттерна
    var endDate: Date {
        candlesticks[len - 1].date
    }

    // Наибольшая цена среди значимых свечей (нужно для отрисовки графика)
    var highPriceForSignificantCandles: Double {
        let significantCandles: [PatternDetectorCandle] = Array(candlesticks[len - numberOfSignificantCandles ..< len])
        return significantCandles.reduce(into: DBL_MIN) { partialResult, candlestick in
            max(candlestick.highPrice, partialResult)
        }
    }

    // Наименьшая цена среди значимых свечей (нужно для отрисовки графика)
    var lowPriceForSignificantCandles: Double {
        let significantCandles: [PatternDetectorCandle] = Array(candlesticks[len - numberOfSignificantCandles ..< len])
        return significantCandles.reduce(into: DBL_MAX) { partialResult, candlestick in
            min(candlestick.lowPrice, partialResult)
        }
    }

    init(len: Int,
         numberOfSignificantCandles: Int,
         candlesticks: [PatternDetectorCandle])
    {
        self.len = len
        self.numberOfSignificantCandles = numberOfSignificantCandles
        guard candlesticks.count == len else {
            self.candlesticks = []
            print("timeseries len is wrong")
            return
        }
        self.candlesticks = candlesticks
    }
}
