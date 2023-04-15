import SwiftUI

struct ListScreen: View {
    private let navigationTitle = "BeRich"
    @State private var tickers: [Ticker] = Fakes.tickers
    @State private var searchText = ""
    @StateObject private var tradingDataNetworkFetcher = TradingDataNetworkFetcher(request: NetworkService.request)

    var body: some View {
        NavigationStack {
            List(tickers) { ticker in
                TickerCellView(ticker: ticker)
                    .background(
                        NavigationLink("", destination: DetailedTickerScreen(ticker: ticker)).opacity(0)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Color.white
                            .cornerRadius(cellCornerRadius)
                            .addBorder(Color.stroke, width: 0.5, cornerRadius: cellCornerRadius)
                            .shadow(color: .shadow, radius: 8, y: 4)
                            .padding(.vertical, 8)
                    )
            }
            .padding(.horizontal, 16.0)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .navigationTitle(navigationTitle)
            .searchable(
                text: $searchText
            )
            .foregroundColor(.white)
        }
        .accentColor(.white)
    }
}

private let cellCornerRadius = 16.0

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
    }
}
