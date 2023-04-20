import SwiftUI

struct ChartView: View {
    var stocks: [Stock]
    @State private var selectedElement: PatternViewData? = nil
    @State var timePeriod: ChartTimePeriod
    @State var patternViewData: [PatternViewData]
    @Binding var patternId: Int
    @Binding var buttonTapToggle: Bool
    @Environment(\.layoutDirection) var layoutDirection

    init(stocks: [Stock],
         patternViewData: [PatternViewData],
         selectedElement: PatternViewData? = nil,
         timePeriod: ChartTimePeriod,
         patternId: Binding<Int>,
         buttonTapToggle: Binding<Bool>)
    {
        self.stocks = stocks
        _selectedElement = State(initialValue: selectedElement)
        _timePeriod = State(initialValue: timePeriod)
        _patternViewData = State(initialValue: patternViewData)
        _patternId = Binding(projectedValue: patternId)
        _buttonTapToggle = Binding(projectedValue: buttonTapToggle)
    }

    var body: some View {
        InternalChartView(stocks: stocks,
                          patternViewData: patternViewData,
                          selectedTimePeriod: timePeriod,
                          selectedElement: $selectedElement,
                          patterns: patternViewData,
                          candleScrollTo: $patternId,
                          buttonTapToggle: $buttonTapToggle)
            .chartBackground { proxy in
                ZStack(alignment: .topLeading) {
                    GeometryReader { nthGeoItem in
                        if let selectedElement {
                            let dateInterval = Calendar.current.dateInterval(of: .minute, for: selectedElement.detectedPattern.startDate) ?? DateInterval()
                            let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                            let startPositionX2 = proxy.position(forX: dateInterval.end) ?? 0
                            let midStartPositionX = (startPositionX1 + startPositionX2) / 2 + nthGeoItem[proxy.plotAreaFrame].origin.x

                            let lineX = layoutDirection == .rightToLeft ? nthGeoItem.size.width - midStartPositionX : midStartPositionX
                            let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                            let boxWidth: CGFloat = 150
                            let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))
                            annotation(stock: selectedElement)
                                .frame(width: boxWidth, alignment: .leading)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.8))
                                    }
                                    .padding([.leading, .trailing], -8)
                                    .padding([.top, .bottom], -4)
                                }
                                .offset(x: boxOffset + boxWidth / 1.7, y: 10)
                        }
                    }
                }
            }
    }

    @ViewBuilder func annotation(stock: PatternViewData) -> some View {
        VStack(alignment: .leading) {
            Text("\(stock.detectedPattern.startDate, format: .dateTime.year().month().day()) - \n \(stock.detectedPattern.endDate, format: .dateTime.year().month().day())")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(stock.detectedPattern.title)
                .font(.caption.bold())
                .foregroundColor(.primary)
        }
    }
}
