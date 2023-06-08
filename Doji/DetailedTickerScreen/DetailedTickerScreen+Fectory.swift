extension DetailedTickerScreen {
    static func make(title: String) -> DetailedTickerScreen {
        DetailedTickerScreen(viewModel:
            DetailedTickerScreenViewModel(tickerTitle: title,
                                          fetcher: TradingDataNetworkFetcher(),
                                          patternDetector: PatternDetector()))
    }
}
