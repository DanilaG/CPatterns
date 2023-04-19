import Charts
import SwiftUI

struct CandlesView: View {
    let stocks: [Stock]
    let patterns = Fakes.patterns
    @Binding var selectedTimePeriod: ChartTimePeriod
    @Binding var selectedChartType: ChartType
    var minPrice: Double {
        if let lP = stocks.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice {
            return lP
        } else {
            return 0
        }
    }

    var maxPrice: Double {
        if let mP = stocks.max(by: { $0.highPrice < $1.highPrice })?.highPrice {
            return mP
        } else {
            return 1000
        }
    }

    var body: some View {
        Chart {
            ForEach(patterns) { pattern in // Область паттерна
                RectangleMark(xStart: .value("Date", pattern.startTimePeriod),
                              xEnd: .value("Date", pattern.endTimePeriod),
                              yStart: .value("Low", pattern.lowPrice),
                              yEnd: .value("High", pattern.highPrice))
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
                AxisValueLabel(format: Decimal.FormatStyle.Currency.currency(code: "RUB"))
            }
        }
        .chartYScale(domain: [minPrice, maxPrice])
        .chartXAxis {
            AxisMarks(values: .stride(by: selectedTimePeriod.unit, count: 1)) {
                AxisValueLabel(format: selectedTimePeriod.format)
            }
        }
    }
}
