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
            urlString = "https://thepatternsite.com/BlackMarubozu.html#C0"
        case .marubozuWhite:
            urlString = "https://thepatternsite.com/WhiteMarubozu.html#C0"
        case .hammer:
            urlString = "https://thepatternsite.com/Hammer.html#C0"
        case .piercingPattern:
            urlString = "https://thepatternsite.com/Piercing.html#C0"
        case .twoCrowns:
            urlString = "https://www.candlescanner.com/candlestick-patterns/two-crows/"
        case .concealingBabySwallow:
            urlString = "https://thepatternsite.com/ConcealBaby.html#C0"
        case .ladderBottom:
            urlString = "https://thepatternsite.com/LadderBottom.html#C0"
        case .takuriLine:
            urlString = "https://thepatternsite.com/TakuriLine.html#C0"
        case .kickingBullish:
            urlString = "https://thepatternsite.com/KickingBull.html#C0"
        case .belt_hold_bullish:
            urlString = "https://thepatternsite.com/BeltHoldBull.html#C0"
        case .marubozu_closing_black:
            urlString = "https://thepatternsite.com/CloseBlkMarubozu.html#C0"
        case .marubozu_opening_white:
            urlString = "https://thepatternsite.com/OpenWhiteMarubozu.html#C0"
        case .shooting_star_one_candle:
            urlString = "https://thepatternsite.com/ShootingStar.html#C0"
        case .doji_gravestone:
            urlString = "https://thepatternsite.com/Gravestone.html#C0"
        case .belt_hold_bearish:
            urlString = "https://thepatternsite.com/BeltHoldBear.html#C0"
        case .doji_dragonfly:
            urlString = "https://thepatternsite.com/Dragonfly.html#C0"
        case .hanging_man:
            urlString = "https://thepatternsite.com/HangingMan.html#C0"
        case .doji_northern:
            urlString = "https://thepatternsite.com/NorthernDoji.html#C0"
        case .doji_long_legged:
            urlString = "https://thepatternsite.com/LongLegDoji.html#C0"
        case .matching_low:
            urlString = "https://thepatternsite.com/MatchingLow.html#C0"
        case .hammer_inverted:
            urlString = "https://thepatternsite.com/HammerInv.html#C0"
        case .kicking_bearish:
            urlString = "https://thepatternsite.com/KickingBear.html#C0"
        case .harami_cross_bullish:
            urlString = "https://thepatternsite.com/HaramiCrossBull.html#C0"
        case .morning_doji_star:
            urlString = "https://thepatternsite.com/MorningDojiStar.html#C0"
        case .above_the_stomach:
            urlString = "https://thepatternsite.com/AboveStomach.html#C0"
        case .dark_cloud_cover:
            urlString = "https://thepatternsite.com/DarkCloudCover.html#C0"
        }

        return URL(string: urlString)!
    }
}
