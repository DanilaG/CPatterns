import Charts
import SwiftUI

struct CandlesView: View {
    let stocks: [Stock]

    var body: some View {
        Chart {
            ForEach(stocks) { stock in
                // Тень свечи (минимум и максимум за день)
                RectangleMark(
                    x: .value("Date", stock.date, unit: .day),
                    yStart: .value("Low", stock.lowPrice),
                    yEnd: .value("High", stock.highPrice),
                    width: 1
                )
                .foregroundStyle(Color.black)
                // Тело свечи (где открылся и где закрылся)
                RectangleMark(
                    x: .value("Date", stock.date, unit: .day),
                    yStart: .value("Open", stock.openPrice),
                    yEnd: .value("Close", stock.closePrice),
                    width: 6
                )
                .foregroundStyle(
                    stock.openPrice <= stock.closePrice ? Color.greenMain : Color.redMain
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 10))
        }
        // Вертикальный масштаб
        .chartYScale(domain: 140 ... 170)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 10))
        }
    }
}
