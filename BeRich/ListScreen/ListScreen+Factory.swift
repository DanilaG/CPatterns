import SwiftUI

extension ListScreen {
    static func make() -> some View {
        Self(viewModel: ListScreenViewModel(fetcher: TradingDataNetworkFetcher()))
    }
}
