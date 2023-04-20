import Charts
import SwiftUI

private let unitWidth: CGFloat = 100

class ChartWidth: ObservableObject {
    @Published var chartWidth: CGFloat = .init(Fakes.defaultStocks.count) * unitWidth
}

struct InternalChartView: View {
    @Environment(\.refresh) private var refresh
    var stocks: [Stock]
    @State private var selectedChartType: ChartType = .candleChart
    var currencyFormater = Decimal.FormatStyle.Currency.currency(code: "RUB")

    // Свойство благодаря которому работает скролл
    @State private var scrollTo = true
    @State var patternViewData: [PatternViewData]
    @Binding var selectedElement: PatternViewData?
    @State var selectedTimePeriod: ChartTimePeriod

    // Ширина чарта, высчитывается в зависимости от количества элементов дата сорса
    // 16 - ширина свечи + расстояние до другой свечи
    @ObservedObject var chartWidth = ChartWidth()

    // Свойство, хранещее id свечи,
    // к которой нам нужно проскроллиться по нажатию на кнопку
    // Далее это будет либо id паттерна, либо закостылено id свечи в нужном паттерне
    @Binding var candleScrollTo: Int

    // Свойство благодаря которому работает скролл
    @Binding var buttonTapToggle: Bool

    init(stocks: [Stock],
         patternViewData: [PatternViewData],
         selectedTimePeriod: ChartTimePeriod,
         selectedElement: Binding<PatternViewData?>,
         patterns _: [PatternViewData],
         candleScrollTo: Binding<Int>,
         buttonTapToggle: Binding<Bool>)
    {
        self.stocks = stocks
//        self.patternViewData = patternViewData
        _selectedTimePeriod = State(initialValue: selectedTimePeriod)
        _candleScrollTo = Binding(projectedValue: candleScrollTo)
        _selectedElement = Binding(projectedValue: selectedElement)
        _patternViewData = State(initialValue: patternViewData)
        _buttonTapToggle = Binding(projectedValue: buttonTapToggle)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                ScrollViewReader { scrollPosition in
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            ZStack {
                                ChartUnderlayForScroll(stocksCount: stocks.count,
                                                       chartWidth: chartWidth)
                                CandlesView(stocks: stocks,
                                            selectedTimePeriod: $selectedTimePeriod,
                                            selectedChartType: $selectedChartType,
                                            patterns: patternViewData)
                                    .chartOverlay { proxy in
                                        GeometryReader { nthGeometryItem in
                                            Rectangle().fill(.clear).contentShape(Rectangle())
                                                .gesture(
                                                    SpatialTapGesture()
                                                        .onEnded {
                                                            let element = findElement(location: $0.location,
                                                                                      proxy: proxy,
                                                                                      geometry: nthGeometryItem,
                                                                                      data: patternViewData)
                                                            if selectedElement?.detectedPattern.startDate == element?.detectedPattern.startDate {
                                                                // If tapping the same element, clear the selection.
                                                                selectedElement = nil
                                                            } else {
                                                                selectedElement = element
                                                            }
                                                        }
                                                        .exclusively(
                                                            before: DragGesture()
                                                                .onChanged {
                                                                    selectedElement = findElement(location: $0.location,
                                                                                                  proxy: proxy,
                                                                                                  geometry: nthGeometryItem,
                                                                                                  data: patternViewData)
                                                                }
                                                        )
                                                )
                                                .foregroundStyle(Color.black)
                                        }
                                    }
                                    .chartYAxis {
                                        AxisMarks(position: .trailing, values: .automatic(desiredCount: 10)) {
                                            AxisValueLabel(format: currencyFormater)
                                        }
                                    }
                                    .chartYScale(domain: [Stock.stocksMinPriceValue(stocks), Stock.stocksMaxPriceValue(stocks)])
                                    .chartXAxis {
                                        AxisMarks(values: .automatic(desiredCount: 10))
                                    }
                                    .frame(width: chartWidth.chartWidth)
                            }
                        }
                        Chart {
                            RectangleMark(
                                x: .value("Date", Date()),
                                yStart: .value("Open", 0),
                                yEnd: .value("Close", 0),
                                width: 0
                            )
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .automatic(desiredCount: 10)) {
                                AxisValueLabel(format: currencyFormater)
                            }
                        }
                        .chartYScale(domain: [Stock.stocksMinPriceValue(stocks), Stock.stocksMaxPriceValue(stocks)])
                        .frame(width: 40)
                        .background(.white)
                    }
                    .onAppear {
                        scrollPosition.scrollTo(candleScrollTo)
                    }
                    .onChange(of: buttonTapToggle) { _ in
                        withAnimation {
                            scrollPosition.scrollTo(candleScrollTo, anchor: .center)
                            print(candleScrollTo)
                        }
                    }
                }

                VStack {
                    HStack {
                        Button(action: {
                            selectedChartType.toggle()
                        }, label: { Image(systemName: selectedChartType.sfTitle)
                            .foregroundColor(Color.white)
                            .frame(width: 15, height: 20)

                        })
                        .buttonStyle(.bordered)
                        .background((Color.blueMain).cornerRadius(10))
                        .padding()
                        Spacer()
                    }
                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            buttonTapToggle.toggle()
                            candleScrollTo = stocks.count - 1
                        }, label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 20)
                        })
                        .buttonStyle(.bordered)
                        .background((Color.blueMain).cornerRadius(10))
                        .padding(.trailing, 50)
                        .padding(.bottom, 25)
                    }
                }
            }
            .frame(height: 400)
        }
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy, data: [PatternViewData]) -> PatternViewData? {
        let data = data
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = 100 * 3600
            var foundIndex: Int?
            for index in data.indices {
                let nthDistance = data[index].detectedPattern.startDate.distance(to: date)
                if abs(nthDistance) < minDistance {
                    minDistance = abs(nthDistance)
                    foundIndex = index
                }
            }
            if let foundIndex {
                return data[foundIndex]
            }
        }
        return nil
    }
}
