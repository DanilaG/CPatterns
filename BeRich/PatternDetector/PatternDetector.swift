import Foundation

struct PatternDetector {
    func detectPatterns(candles: [Stock]) -> [DetectedPattern] {
        let candlesticks = candles.map {
            PatternDetectorCandle(candle: $0)
        }

        var detectedPatterns: [DetectedPattern] = []

        for pattern in CandlePattern.allCases {
            detectedPatterns.append(contentsOf: detectPattern(candelsticks: candlesticks,
                                                              pattern: pattern))
        }

        return detectedPatterns
    }

    func detectPattern(candelsticks: [PatternDetectorCandle],
                       pattern: CandlePattern) -> [DetectedPattern]
    {
        let patternLenght = pattern.patternLenght
        let patternSignificantLength = pattern.patternSignificantLength
        var timeserieses: [Timeseries] = []
        for ind in patternLenght ... candelsticks.count {
            timeserieses.append(Timeseries(len: patternLenght,
                                           numberOfSignificantCandles: pattern.patternSignificantLength,
                                           candlesticks: Array(candelsticks[ind - patternLenght ..< ind])))
        }

        var detectedPatterns: [DetectedPattern] = []
        for ind in 0 ..< timeserieses.count {
            let timeseries = timeserieses[ind]
            if pattern.logicalCondition(timeseries) {
                detectedPatterns.append(DetectedPattern(pattern: pattern,
                                                        startDate: timeseries.startDate,
                                                        endDate: timeseries.endDate,
                                                        lowPrice: timeseries.lowPriceForSignificantCandles,
                                                        highPrice: timeseries.highPriceForSignificantCandles))
            }
        }

        return detectedPatterns
    }
}
