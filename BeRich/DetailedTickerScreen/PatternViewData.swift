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
