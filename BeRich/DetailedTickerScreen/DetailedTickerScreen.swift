import SwiftUI

struct DetailedTickerScreen: View {
    @State var selectedTimePeriod: ChartTimePeriod = .day
    @State private var isFavourite = false

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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isFavourite.toggle()
                        } label: {
                            Image(systemName: isFavourite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yellowMain)
                        }
                    }
                }
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

struct DetailedTickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTickerScreen(
            ticker: Ticker(title: "Title",
                           subTitle: "Subtitle",
                           price: "price",
                           priceChange: .stable)
        )
    }
}
