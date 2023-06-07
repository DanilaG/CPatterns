import Charts
import Combine
import SwiftUI

struct ScrolledCandlesChart: View {
    var patterns: [PatternViewData]
    var stocks: [Stock]
    @State var timePeriod: ChartTimePeriod
    let scrollToPattern: AnyPublisher<PatternViewData, Never>
    let onPatternsSelect: ([PatternViewData]) -> Void

    @State private var scrollToPatternBag: AnyCancellable? = nil
    private let candleWidth: CGFloat = 20.0

    var width: CGFloat {
        CGFloat(stocks.numberTimeUnits(timePeriod)) * candleWidth
    }

    var lastCandleId: String {
        idForCandle(stocks.numberTimeUnits(timePeriod) - 1)
    }

    var body: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { scrollPosition in
                ZStack(alignment: .bottomTrailing) {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            ZStack(alignment: .leading) {
                                chart
                                candleScrollUnderlie
                            }
                        }
                        .onAppear {
                            scrollToPatternBag?.cancel()
                            scrollToPatternBag = scrollToPattern.sink { newValue in
                                let candleIndex = stocks.timeUnitFromFirst(newValue.endDate, timePeriod)
                                withAnimation {
                                    scrollPosition.scrollTo(idForCandle(candleIndex), anchor: .center)
                                }
                            }
                            scrollPosition.scrollTo(lastCandleId)
                        }

                        Chart {}
                            .chartYAxis {
                                AxisMarks(position: .leading) {
                                    AxisValueLabel(format: Decimal.FormatStyle.Currency.currency(code: "RUB"))
                                }
                            }
                            .background(.clear)
                            .chartYScale(domain: Stock.stocksMinPriceValue(stocks) ... Stock.stocksMaxPriceValue(stocks))
                            .frame(width: 60)
                    }

                    Button(action: {
                        withAnimation {
                            scrollPosition.scrollTo(lastCandleId)
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.white)
                            .frame(width: 16, height: 20)
                    })
                    .buttonStyle(.bordered)
                    .background((Color.blueMain).cornerRadius(8))
                    .padding(.trailing, 80)
                    .padding(.bottom, 20)
                }
            }.frame(height: 400)
        }
    }

    private var chart: some View {
        CandlesChartView(
            patterns: patterns,
            stocks: stocks,
            selectedTimePeriod: $timePeriod
        )
        .chartYScale(
            domain: Stock.stocksMinPriceValue(stocks) ... Stock.stocksMaxPriceValue(stocks)
        )
        .frame(width: width)
    }

    private var candleScrollUnderlie: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< (stocks.numberTimeUnits(timePeriod)), id: \.self) { candleNumber in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        let date = stocks.toDate(unitNumber: candleNumber, timePeriod)
                        onPatternsSelect(patterns.filter { $0.startDate <= date && date <= $0.endDate })
                    }
                    .id(idForCandle(candleNumber))
            }
        }
    }

    private func idForCandle(_ number: Int) -> String {
        "candle_\(number)"
    }
}

extension [Stock] {
    func toDate(unitNumber: Int, _ timePeriod: ChartTimePeriod) -> Date {
        let min = self.min(by: { $0.date < $1.date })?.date ?? Date()
        return Calendar.current.date(byAdding: timePeriod.calendarComponent, value: unitNumber, to: min) ?? Date()
    }

    func numberTimeUnits(_ timePeriod: ChartTimePeriod) -> Int {
        let min = self.min(by: { $0.date < $1.date })?.date ?? Date()
        let max = self.max(by: { $0.date < $1.date })?.date ?? Date()
        return (unitDistance(from: min, to: max, timePeriod) ?? 0) + 1
    }

    func timeUnitFromFirst(_ date: Date, _ timePeriod: ChartTimePeriod) -> Int {
        let min = self.min(by: { $0.date < $1.date })?.date ?? Date()
        let numberOfDays = Calendar.current.dateComponents([timePeriod.calendarComponent], from: min, to: date)
        return unitDistance(from: min, to: date, timePeriod) ?? 0
    }

    func unitDistance(from: Date, to: Date, _ timePeriod: ChartTimePeriod) -> Int? {
        let result = Calendar.current.dateComponents([timePeriod.calendarComponent], from: from, to: to)
        switch timePeriod {
        case .day:
            return result.day
        case .week:
            return result.weekOfYear
        case .month:
            return result.month
        }
    }
}
