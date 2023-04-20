import SwiftUI

struct ChartView: View {
    var stocks: [Stock]
    let detectedPatterns: [DetectedPattern]
    @State private var selectedElement: Stock? = nil
    @State var timePeriod: ChartTimePeriod
    @Environment(\.layoutDirection) var layoutDirection

    var body: some View {
        InternalChartView(stocks: stocks,
                          detectedPatterns: detectedPatterns,
                          selectedTimePeriod: timePeriod,
                          selectedElement: $selectedElement)
            .chartBackground { proxy in
                ZStack(alignment: .topLeading) {
                    GeometryReader { nthGeoItem in
                        if let selectedElement {
                            let dateInterval = Calendar.current.dateInterval(of: .minute, for: selectedElement.date)!
                            let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                            let startPositionX2 = proxy.position(forX: dateInterval.end) ?? 0
                            let midStartPositionX = (startPositionX1 + startPositionX2) / 2 + nthGeoItem[proxy.plotAreaFrame].origin.x

                            let lineX = layoutDirection == .rightToLeft ? nthGeoItem.size.width - midStartPositionX : midStartPositionX
                            let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                            let boxWidth: CGFloat = 150
                            let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))

                            Rectangle()
                                .fill(.quaternary)
                                .frame(width: 2, height: lineHeight)
                                .position(x: lineX, y: lineHeight / 2)

                            annotation(stock: selectedElement)
                                .frame(width: boxWidth, alignment: .leading)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.7))
                                    }
                                    .padding([.leading, .trailing], -8)
                                    .padding([.top, .bottom], -4)
                                }
                                .offset(x: boxOffset, y: 10)
                        }
                    }
                }
            }
    }

    @ViewBuilder func annotation(stock: Stock) -> some View {
        VStack(alignment: .leading) {
            Text("\(stock.date, format: .dateTime.year().month().day())")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("""
            Open: \(stock.openPrice, format: .number)
            Close: \(stock.closePrice, format: .number)
            Low: \(stock.lowPrice, format: .number)
            High: \(stock.highPrice, format: .number)
            """)
            .font(.caption.bold())
            .foregroundColor(.primary)
        }
    }
}
