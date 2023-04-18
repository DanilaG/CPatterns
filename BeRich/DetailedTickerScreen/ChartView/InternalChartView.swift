import Charts
import SwiftUI

private let unitWidth: CGFloat = 35

class ChartWidth: ObservableObject {
    @Published var chartWidth: CGFloat = .init(Fakes.defaultStocks.count) * unitWidth
}

struct InternalChartView: View {
    @Environment(\.refresh) private var refresh
    var stocks: [Stock]
    @Binding private var selectedElement: Stock?
    @State private var selectedTimePeriod: ChartTimePeriod
    @State private var selectedChartType: ChartType = .candleChart

    // Свойство благодаря которому работает скролл
    @State private var scrollTo = true

    // Ширина чарта, высчитывается в зависимости от количества элементов дата сорса
    // 16 - ширина свечи + расстояние до другой свечи
    @ObservedObject var chartWidth = ChartWidth()

    // Свойство, хранещее id свечи,
    // к которой нам нужно проскроллиться по нажатию на кнопку
    // Далее это будет либо id паттерна, либо закостылено id свечи в нужном паттерне
    @State private var candleScrollTo: Int

    init(stocks: [Stock],
         selectedTimePeriod: ChartTimePeriod,
         selectedElement: Binding<Stock?>)
    {
        self.stocks = stocks
        _selectedTimePeriod = State(initialValue: selectedTimePeriod)
        _candleScrollTo = State(initialValue: stocks.count - 1)
        _selectedElement = Binding(projectedValue: selectedElement)
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
                                CandlesView(stocks: stocks, selectedTimePeriod: $selectedTimePeriod, selectedChartType: $selectedChartType)
                                    .chartOverlay { proxy in
                                        GeometryReader { nthGeometryItem in
                                            Rectangle().fill(.clear).contentShape(Rectangle())
                                                .gesture(
                                                    SpatialTapGesture()
                                                        .onEnded {
                                                            let element = findElement(location: $0.location,
                                                                                      proxy: proxy,
                                                                                      geometry: nthGeometryItem,
                                                                                      data: stocks)
                                                            if selectedElement?.date == element?.date {
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
                                                                                                  data: stocks)
                                                                }
                                                        )
                                                )
                                                .foregroundStyle(Color.black)
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
                                    .chartOverlay { proxy in
                                        GeometryReader { nthGeometryItem in
                                            Rectangle().fill(.clear).contentShape(Rectangle())
                                                .gesture(
                                                    SpatialTapGesture()
                                                        .onEnded {
                                                            let element = findElement(location: $0.location,
                                                                                      proxy: proxy,
                                                                                      geometry: nthGeometryItem,
                                                                                      data: stocks)
                                                            if selectedElement?.date == element?.date {
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
                                                                                                  data: stocks)
                                                                }
                                                        )
                                                )
                                        }
                                    }
                                    .frame(width: chartWidth.chartWidth)
                            }
                        }
                    }
                    .onAppear {
                        scrollPosition.scrollTo(candleScrollTo)
                    }
                    .onChange(of: scrollTo) { _ in
                        withAnimation {
                            scrollPosition.scrollTo(candleScrollTo)
                        }
                    }
                }

                Chart {
                    RectangleMark(
                        x: .value("Date", Fakes.defaultStocks[0].date, unit: .day),
                        yStart: .value("Open", Fakes.defaultStocks[0].openPrice),
                        yEnd: .value("Close", Fakes.defaultStocks[0].closePrice),
                        width: 0
                    )
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 10))
                }
                .chartYScale(domain: 140 ... 170)
                // задаем фиксированную ширину контейнера с осью Y
                .frame(width: 25)
                .background(.white)

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
                            scrollTo.toggle()
                            candleScrollTo = stocks.count - 1
                        }, label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 20)
                        })
                        .buttonStyle(.bordered)
                        .background((Color.blueMain).cornerRadius(10))
                        .padding(.trailing, 35)
                        .padding(.bottom, 25)
                    }
                }
            }
            .frame(height: 400)
            Button {
                scrollTo.toggle()
                candleScrollTo = stocks.count - 1
            } label: {
                Text("Scroll to end")
                    .foregroundColor(Color.black)
            }
        }
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy, data: [Stock]) -> Stock? {
        let data = data
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var foundIndex: Int?
            for index in data.indices {
                let nthDistance = data[index].date.distance(to: date)
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
