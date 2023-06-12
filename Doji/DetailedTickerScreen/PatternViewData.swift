import Foundation

struct PatternViewData: Identifiable, Equatable {
    private let pattern: DetectedPattern
    private let timePeriod: ChartTimePeriod

    var id: String {
        pattern.id
    }

    var title: String {
        pattern.pattern.title
    }

    var startDate: Date {
        pattern.startDate
    }

    var endDate: Date {
        pattern.endDate
    }

    var dateInterval: String {
        let start: String
        let end: String

        switch timePeriod {
        case .day:
            start = DateFormatting.patternCellDate.string(from: startDate)
            end = DateFormatting.patternCellDate.string(from: endDate)
        case .week:
            start = DateFormatting.patternCellDate.string(from: startDate)
            end = DateFormatting.patternCellDate.string(from:
                Calendar.current.date(
                    byAdding: .weekday,
                    value: 6,
                    to: pattern.endDate
                ) ?? pattern.endDate
            )
        case .month:
            start = DateFormatting.monthYear.string(from: startDate)
            end = DateFormatting.monthYear.string(from: endDate)
        }

        return start == end ? end : "\(start) - \(end)"
    }

    var isSelected = false

    init(_ pattern: DetectedPattern, _ timePeriod: ChartTimePeriod) {
        self.pattern = pattern
        self.timePeriod = timePeriod
    }

    init(_ pattern: PatternViewData, isSelected: Bool = false) {
        self.pattern = pattern.pattern
        timePeriod = pattern.timePeriod
        self.isSelected = isSelected
    }
}

extension PatternViewData {
    var urlWithDescription: URL {
        let urlString: String

        switch pattern.pattern {
        case .marubozuBlack:
            urlString = "https://thepatternsite.com/BlackMarubozu.html"
        case .marubozuWhite:
            urlString = "https://thepatternsite.com/WhiteMarubozu.html"
        case .hammer:
            urlString = "https://thepatternsite.com/Hammer.html"
        case .piercingPattern:
            urlString = "https://thepatternsite.com/Piercing.html"
        case .twoCrowns:
            urlString = "https://www.candlescanner.com/candlestick-patterns/two-crows/"
        case .concealingBabySwallow:
            urlString = "https://thepatternsite.com/ConcealBaby.html"
        case .ladderBottom:
            urlString = "https://thepatternsite.com/LadderBottom.html"
        case .takuriLine:
            urlString = "https://thepatternsite.com/TakuriLine.html"
        case .kickingBullish:
            urlString = "https://thepatternsite.com/KickingBull.html"
        case .belt_hold_bullish:
            urlString = "https://thepatternsite.com/BeltHoldBull.html"
        case .marubozu_closing_black:
            urlString = "https://thepatternsite.com/CloseBlkMarubozu.html"
        case .marubozu_opening_white:
            urlString = "https://thepatternsite.com/OpenWhiteMarubozu.html"
        case .shooting_star_one_candle:
            urlString = "https://thepatternsite.com/ShootingStar.html"
        case .doji_gravestone:
            urlString = "https://thepatternsite.com/Gravestone.html"
        case .belt_hold_bearish:
            urlString = "https://thepatternsite.com/BeltHoldBear.html"
        case .doji_dragonfly:
            urlString = "https://thepatternsite.com/Dragonfly.html"
        case .hanging_man:
            urlString = "https://thepatternsite.com/HangingMan.html"
        case .doji_northern:
            urlString = "https://thepatternsite.com/NorthernDoji.html"
        case .doji_long_legged:
            urlString = "https://thepatternsite.com/LongLegDoji.html"
        case .matching_low:
            urlString = "https://thepatternsite.com/MatchingLow.html"
        case .hammer_inverted:
            urlString = "https://thepatternsite.com/HammerInv.html"
        case .kicking_bearish:
            urlString = "https://thepatternsite.com/KickingBear.html"
        case .harami_cross_bullish:
            urlString = "https://thepatternsite.com/HaramiCrossBull.html"
        case .morning_doji_star:
            urlString = "https://thepatternsite.com/MorningDojiStar.html"
        case .above_the_stomach:
            urlString = "https://thepatternsite.com/AboveStomach.html"
        case .dark_cloud_cover:
            urlString = "https://thepatternsite.com/DarkCloudCover.html"
        }

        return URL(string: urlString)!
    }
}
