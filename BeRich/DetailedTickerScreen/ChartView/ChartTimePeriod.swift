import Foundation

enum ChartTimePeriod: Int {
    case day
    case week
    case month
}

extension ChartTimePeriod: Identifiable {
    var id: String {
        UUID().uuidString
    }
}

extension ChartTimePeriod: CaseIterable {}

extension ChartTimePeriod {
    var title: String {
        switch self {
        case .day:
            return "Д"
        case .week:
            return "Н"
        case .month:
            return "M"
        }
    }

    var unit: Calendar.Component {
        switch self {
        case .day, .week:
            return .month
        case .month:
            return .year
        }
    }

    var format: Date.FormatStyle {
        switch self {
        case .day:
            return .dateTime.month()
        case .week:
            return .dateTime.week()
        case .month:
            return .dateTime.year()
        }
    }
}
