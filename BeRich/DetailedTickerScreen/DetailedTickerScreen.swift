import SwiftUI

struct DetailedTickerScreen: View {
    @State var selectedTimePeriod: ChartTimePeriod = .day

    init(ticker: Ticker) {
        self.ticker = ticker
    }

    private let ticker: Ticker

    var body: some View {
        ScrollView {
            ChartView(stocks: ticker.stocks(timePeriod: selectedTimePeriod),
                      timePeriod: selectedTimePeriod)
            changeTimePeriodButtons()
                .navigationBarTitle(ticker.title)
            PatternListView(patterns: Fakes.patterns)
        }
    }

    @ViewBuilder func changeTimePeriodButtons() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ChartTimePeriod.allCases) { timePeriod in

                    Button {
                        selectedTimePeriod = timePeriod
                    } label: {
                        Text(timePeriod.title)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(selectedTimePeriod == timePeriod ? Color.blueMain : Color.whiteMain).cornerRadius(20)
                            .foregroundColor(selectedTimePeriod == timePeriod ? Color.whiteMain : Color.blueMain)
                            .addBorder(Color.blueMain, width: 1, cornerRadius: 20)
                    }
                }
            }
            .padding()
        }
    }
}

extension Ticker {
    func stocks(timePeriod: ChartTimePeriod) -> [Stock] {
        switch timePeriod {
        case .tenMin:
            return Fakes.stocksInTenMinutesPeriod
        case .thirtyMin:
            return Fakes.stocksInThirtyMinutesPeriod
        default:
            return Fakes.defaultStocks
        }
    }
}

struct DetailedTickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTickerScreen(
            ticker: Ticker(title: "Title",
                           subTitle: "Subtitle",
                           price: "price",
                           priceChange: 100.0)
        )
    }
}
