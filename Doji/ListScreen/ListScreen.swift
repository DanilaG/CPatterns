import SwiftUI

struct ListScreen: View {
    @StateObject private var viewModel: ListScreenViewModel
    @State private var searchText = ""
    @State private var tickers: Tickers = Fakes.tickers
    @StateObject private var tradingDataNetworkFetcher = TradingDataNetworkFetcher()
    @State private var path = NavigationPath()

    init(viewModel: ListScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.state {
                case .initial:
                    Color.background
                case .loading:
                    loading()
                case let .loaded(data):
                    list(data.tickers.filtered(by: data.filter))
                case .error:
                    error()
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .foregroundColor(.white)
            .navigationTitle(screenTitle)
            .navigationDestination(for: Ticker.self) { ticker in
                DetailedTickerScreen.make(title: ticker.title)
            }
        }
        .accentColor(.white)
        .onAppear { viewModel.send(event: .didAppear) }
    }

    private func loading() -> some View {
        ZStack {
            Color.background
            ProgressView()
        }
    }

    private func list(_ tickers: Tickers) -> some View {
        Group {
            if !tickers.isEmpty {
                List(tickers, id: \.title) { ticker in
                    TickerCellView(ticker: ticker)
                        .contentShape(Rectangle())
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Color.white
                                .cornerRadius(cellCornerRadius)
                                .addBorder(Color.stroke, width: 0.5, cornerRadius: cellCornerRadius)
                                .shadow(color: .shadow, radius: 8, y: 4)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16.0)
                        )
                        .onTapGesture {
                            path.append(ticker)
                            viewModel.send(event: .didSelectTicker(ticker))
                        }
                        .padding(.horizontal, 16.0)
                }
            } else {
                ZStack {
                    Color.background
                    Text(notFound)
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .searchable(
            text: $searchText
        )
        .onChange(of: searchText) { text in
            viewModel.send(event: .searching(text))
        }
    }

    private func error() -> some View {
        ZStack {
            Color.background
            VStack(spacing: 12.0) {
                Text(defaultErrorMessage)
                    .foregroundColor(Color(UIColor.label))
                Button(tryAgain) { viewModel.send(event: .didSelectReload) }
                    .foregroundColor(Color.blueMain)
                    .font(Font.headline)
            }
            .multilineTextAlignment(.center)
        }
    }
}

private let cellCornerRadius = 16.0
private let screenTitle = "Акции"
private let defaultErrorMessage = "К сожалению, что-то пошло не так"
private let tryAgain = "Попробовать ещё раз"
private let notFound = "Ничего не найдено"

extension Ticker: Hashable {
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen(viewModel: Fakes.makeListScreenViewModel())
    }
}
