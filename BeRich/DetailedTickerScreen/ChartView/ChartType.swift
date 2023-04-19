import Foundation

enum ChartType {
    case candleChart
    case lineChart
    mutating func toggle() {
        switch self {
        case .candleChart:
            self = .lineChart
        case .lineChart:
            self = .candleChart
        }
    }
}

extension ChartType {
    var sfTitle: String {
        switch self {
        case .candleChart:
            return "waveform.path.ecg"
        case .lineChart:
            return "waveform"
        }
    }
}
