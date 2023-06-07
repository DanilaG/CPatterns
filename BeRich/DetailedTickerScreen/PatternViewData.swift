import Foundation

struct PatternViewData: Identifiable, Equatable {
    private let pattern: DetectedPattern

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

    var isSelected = false

    init(_ pattern: DetectedPattern) {
        self.pattern = pattern
    }

    init(_ pattern: PatternViewData, isSelected: Bool = false) {
        self.pattern = pattern.pattern
        self.isSelected = isSelected
    }
}
