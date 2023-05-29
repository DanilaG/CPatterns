import Charts
import SwiftUI

struct ScrolledCandlesChart: View {

    @State var patterns: [PatternViewData]
    @State var stocks: [Stock]
    @State var timePeriod: ChartTimePeriod
    @Binding var scrollToPattern: PatternViewData?

    private let candleWidth: CGFloat = 12.0

    var width: CGFloat {
        CGFloat(stocks.numberTimeUnits(timePeriod)) * candleWidth
    }

    var lastCandleId: String {
        idForCandle(stocks.numberTimeUnits(timePeriod) - 1)
    }

    var body: some View {
        ScrollViewReader { scrollPosition in
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        candleScrollUnderlie
                        chart
                    }
                }
                .onAppear {
                    scrollPosition.scrollTo(lastCandleId)
                }
                .onChange(of: scrollToPattern) { newValue in
                    print("!!Change")
                    guard let newValue else {
                        print("!!!nil")
                        return
                    }
                    let candleIndex = stocks.timeUnitFromFirst(newValue.detectedPattern.endDate, timePeriod)
                    withAnimation {
                        scrollPosition.scrollTo(idForCandle(candleIndex), anchor: .center)
                    }
                    print(candleIndex)
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
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
        }.frame(height: 400)
    }

    private var chart: some View {
        CandlesChartView(
            patterns: patterns,
            stocks: stocks,
            selectedTimePeriod: $timePeriod
        )
        .chartYScale(
            domain: Stock.stocksMinPriceValue(stocks)...Stock.stocksMaxPriceValue(stocks)
        )
        .frame(width: width)
    }
    
    private var candleScrollUnderlie: some View {
        HStack(spacing: 0) {
            ForEach(0..<(stocks.numberTimeUnits(timePeriod)), id: \.self) { candleNumber in
                Rectangle()
                    //.fill(.clear)
                    .fill((candleNumber % 2 == 0 ? Color.red : Color.blue).opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 0)
                    .id(idForCandle(candleNumber))
            }
        }
    }
    
    private func idForCandle(_ number: Int) -> String {
        "candle_\(number)"
    }
}

extension Array<Stock> {
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

extension PatternViewData: Equatable {
    static func == (lhs: PatternViewData, rhs: PatternViewData) -> Bool {
        lhs.detectedPattern.id == rhs.detectedPattern.id
    }
}
