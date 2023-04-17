import SwiftUI

struct ListScreen: View {
    private let navigationTitle = "BeRich"
    @State private var searchText = ""

    @StateObject private var viewModel: ListScreenViewModel

    init(viewModel: ListScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial:
                    Color.background
                case .loading:
                    loading()
                case let .loaded(tickers):
                    list(tickers)
                }
            }
            .padding(.horizontal, 16.0)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .searchable(
                text: $searchText
            )
            .foregroundColor(.white)
            .navigationTitle(screenTitle)
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

    private func list(_ tickers: [Ticker]) -> some View {
        List(tickers, id: \.title) { ticker in
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
    }
}

private let cellCornerRadius = 16.0
private let screenTitle = "BeRich"

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen(viewModel: ListScreenViewModel())
    }
}
