import Charts
import SwiftUI

struct CandlesChartView: View {
    var patterns: [PatternViewData]
    var stocks: [Stock]
    @Binding var selectedTimePeriod: ChartTimePeriod

    var minPrice: Double {
        stocks.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? 0
    }

    var maxPrice: Double {
        stocks.max(by: { $0.highPrice < $1.highPrice })?.highPrice ?? 0
    }

    var body: some View {
        Chart {
            ForEach(patterns, id: \.id) {
                RectangleMark(
                    xStart: .value("Date", $0.startDate, unit: selectedTimePeriod.calendarComponent),
                    xEnd: .value("Date", $0.endDate, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Low", minPrice),
                    yEnd: .value("High", maxPrice)
                )
                .foregroundStyle(($0.isSelected ? Color.blueMain : Color.gray400).opacity($0.isSelected ? 1.0 : 0.4))
            }
            ForEach(stocks) { stock in
                RectangleMark(
                    x: .value("Date", stock.date, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Low", stock.lowPrice),
                    yEnd: .value("High", stock.highPrice),
                    width: 1.5
                )
                .foregroundStyle(patterns.isSelected(stock) ? Color.white : Color.black)
                RectangleMark(
                    x: .value("Date", stock.date, unit: selectedTimePeriod.calendarComponent),
                    yStart: .value("Open", stock.openPrice),
                    yEnd: .value("Close", stock.closePrice),
                    width: 16
                )
                .foregroundStyle(
                    (stock.openPrice <= stock.closePrice) ?
                        (patterns.isSelected(stock) ? Color.greenSelected : Color.greenMain) :
                        (patterns.isSelected(stock) ? Color.redSelected : Color.redMain)
                )
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: selectedTimePeriod.xAxisStride, count: 4)) {
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

private extension [PatternViewData] {
    func isSelected(_ stock: Stock) -> Bool {
        contains(where: {
            $0.isSelected && $0.startDate <= stock.date && stock.date <= $0.endDate
        })
    }
}
