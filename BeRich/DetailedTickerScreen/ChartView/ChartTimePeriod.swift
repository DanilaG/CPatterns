import Foundation

enum ChartTimePeriod: Int {
    case day
    case week
    case month
}

extension ChartTimePeriod: CaseIterable {}

extension ChartTimePeriod {
    var calendarComponent: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        }
    }
}
