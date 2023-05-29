import Charts
import SwiftUI

struct CandlesChartView: View {
    @State var patterns: [PatternViewData]
    @State var stocks: [Stock]
    @Binding var selectedTimePeriod: ChartTimePeriod

    var minPrice: Double {
        stocks.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? 0
    }

    var maxPrice: Double {
        stocks.max(by: { $0.highPrice < $1.highPrice })?.highPrice ?? 0
    }

    var body: some View {
        Chart {
            ForEach(patterns, id: \.detectedPattern.id) {
                RectangleMark(
                    xStart: .value("Date", $0.detectedPattern.startDate, unit: selectedTimePeriod.calendarComponent),
                    xEnd: .value("Date", $0.detectedPattern.endDate, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Low", minPrice),
                    yEnd: .value("High", maxPrice)
                )
                .foregroundStyle($0.color.opacity(0.4))
            }
            ForEach(stocks) { stock in
                RectangleMark(
                    x: .value("Date", stock.date, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Low", stock.lowPrice),
                    yEnd: .value("High", stock.highPrice),
                    width: 1
                )
                .foregroundStyle(Color.black)
                RectangleMark(
                    x: .value("Date", stock.date, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Open", stock.openPrice),
                    yEnd: .value("Close", stock.closePrice),
                    width: 8
                )
                .foregroundStyle(
                    stock.openPrice <= stock.closePrice ? Color.greenMain : Color.redMain
                )
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: selectedTimePeriod.xAxisStride, count: 1)) {
                AxisValueLabel(format: selectedTimePeriod.xAxisFormat, centered: false)
                AxisGridLine()
            }
        }
    }
}

private extension ChartTimePeriod {
    var xAxisStride: Calendar.Component {
        switch self {
        case .day:
            return .month
        case .week:
            return .month
        case .month:
            return .year
        }
    }

    var xAxisFormat: Date.FormatStyle {
        switch self {
        case .day:
            return .dateTime.month(.abbreviated).year()
        case .week:
            return .dateTime.month(.narrow).year(.twoDigits)
        case .month:
            return .dateTime.year()
        }
    }
}
