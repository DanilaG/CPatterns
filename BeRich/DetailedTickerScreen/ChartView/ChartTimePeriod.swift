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
        case .tenMin:
            return .minute
        case .thirtyMin:
            return .minute
        case .hour:
            return .hour
        case .day:
            return .day
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}
