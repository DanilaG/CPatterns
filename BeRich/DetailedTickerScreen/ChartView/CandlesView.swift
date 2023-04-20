import Charts
import SwiftUI

struct CandlesView: View {
    let stocks: [Stock]
    let patterns: [DetectedPattern]
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var selectedChartType: ChartType
    var currencyFormater = Decimal.FormatStyle.Currency.currency(code: "RUB")

    var body: some View {
        Chart {
            ForEach(patterns) { pattern in // Область паттерна
                RectangleMark(xStart: .value("Date", pattern.startDate),
                              xEnd: .value("Date", pattern.endDate),
                              // TODO: Fix height
                              yStart: .value("Low", 0),
                              // yStart: .value("Low", pattern.lowPrice),
                              yEnd: .value("High", 400)
                              // yStart: .value("Low", pattern.lowPrice),
                )
                .foregroundStyle(Color.patternBlue)
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
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 10)) {
                AxisValueLabel(format: currencyFormater)
            }
        }
        .chartYScale(domain: [Stock.stocksMinPriceValue(stocks), Stock.stocksMaxPriceValue(stocks)])
        .chartXAxis {
            AxisMarks(values: .stride(by: selectedTimePeriod.unit, count: 1)) {
                AxisValueLabel(format: selectedTimePeriod.format)
            }
        }
    }
}
