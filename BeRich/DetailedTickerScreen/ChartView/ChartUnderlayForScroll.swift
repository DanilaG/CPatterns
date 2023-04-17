import SwiftUI

struct ChartUnderlayForScroll: View {
    let stocksCount: Int
    @ObservedObject var chartWidth = ChartWidth()
    var body: some View {
        HStack {
            // Куча rectangle'ов, каждый из которых соответсвует свече
            // Пока у них id это их порядковый номер, потом можем как-нибудь
            // привязать по-другому
            // Полосочки нужны для перемещения скролла, так как у них есть id
            ForEach(0 ..< stocksCount, id: \.self) { index in
                HStack {
                    Rectangle()
                        .frame(width: 1, height: 0)
                        .id(index)
                    Spacer()
                }
            }
        }
        .frame(width: chartWidth.chartWidth)
    }
}
