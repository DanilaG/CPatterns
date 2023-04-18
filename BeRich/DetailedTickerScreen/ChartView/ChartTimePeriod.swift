import Foundation

enum ChartTimePeriod: Int {
    case tenMin
    case thirtyMin
    case hour
    case day
    case month
    case year
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
        case .tenMin:
            return "10 МИН"
        case .thirtyMin:
            return "30 МИН"
        case .hour:
            return "Ч"
        case .day:
            return "Д"
        case .month:
            return "M"
        case .year:
            return "Г"
        }
    }

    var unit: Calendar.Component {
        switch self {
        case .tenMin, .thirtyMin:
            return .hour
        case .hour:
            return .day
        case .day:
            return .month
        case .month, .year:
            return .year
        }
    }

    var format: Date.FormatStyle {
        switch self {
        case .tenMin, .thirtyMin:
            return .dateTime.hour()
        case .hour:
            return .dateTime.day()
        case .day:
            return .dateTime.month()
        case .month, .year:
            return .dateTime.year()
        }
    }
}
