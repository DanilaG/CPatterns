import Charts
import SwiftUI

struct CandlesView: View {
    let stocks: [Stock]
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var selectedChartType: ChartType
    var currencyFormater = Decimal.FormatStyle.Currency.currency(code: "RUB")
    @State var patterns: [PatternViewData]
    var body: some View {
        Chart {
            ForEach(patterns, id: \.detectedPattern.id) { // Область паттерна
                RectangleMark(
                    xStart: .value("Date", $0.detectedPattern.startDate - selectedTimePeriod.timePeriodForPatternView,
                                   unit: selectedTimePeriod.unitForPatternView),
                    xEnd: .value("Date", $0.detectedPattern.endDate + selectedTimePeriod.timePeriodForPatternView,
                                 unit: selectedTimePeriod.unitForPatternView),
                    yStart: .value("Low", 0),
                    yEnd: .value("High", 100_000)
                )
                .foregroundStyle($0.color.opacity(0.4))
            }
            ForEach(stocks) { stock in
                switch selectedChartType {
                case .candleChart:
                    // Тень свечи (минимум и максимум за день)
                    RectangleMark(
                        x: .value("Date", stock.date),
                        yStart: .value("Low", stock.lowPrice),
                        yEnd: .value("High", stock.highPrice),
                        width: 1
                    )
                    .foregroundStyle(Color.black)
                    // Тело свечи (где открылся и где закрылся)
                    RectangleMark(
                        x: .value("Date", stock.date),
                        yStart: .value("Open", stock.openPrice),
                        yEnd: .value("Close", stock.closePrice),
                        width: 5
                    )
                    .foregroundStyle(
                        stock.openPrice <= stock.closePrice ? Color.greenMain : Color.redMain
                    )
                case .lineChart:
                    LineMark(
                        x: .value("Date", stock.date),
                        y: .value("Price", stock.closePrice)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.orange)
                    AreaMark(
                        x: .value("Date", stock.date),
                        yStart: .value("Price", stock.closePrice),
                        yEnd: .value("PriceEnd", 120)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(.orange).opacity(0.2),
                                    Color(.orange).opacity(0.1),
                                    Color(.orange).opacity(0.05),
                                    Color(.orange).opacity(0.0),
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: selectedTimePeriod.unit, count: 1)) {
                AxisValueLabel(format: selectedTimePeriod.format)
            }
        }
    }
}
