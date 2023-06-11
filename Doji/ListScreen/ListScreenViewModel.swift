import Combine
import Foundation
import YandexMobileMetrica

final class ListScreenViewModel: ObservableObject {
    @Published private(set) var state: State = .initial

    private let input = PassthroughSubject<Event, Never>()

    init(fetcher: TradingDataNetworkFetching) {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.loading(fetcher: fetcher),
                Self.userInput(input: input.eraseToAnyPublisher()),
            ]
        )
        .assign(to: &$state)
    }

    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension ListScreenViewModel {
    enum State {
        case initial
        case loading
        case loaded((tickers: Tickers, filter: String))
        case error
    }

    enum Event {
        case didAppear
        case didLoadTickers(Tickers)
        case failedLoadTickers
        case didSelectReload
        case searching(String)
        case didSelectTicker(Ticker)
    }
}

// MARK: - State Machine

extension ListScreenViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .initial:
            switch event {
            case .didAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case let .didLoadTickers(tickers):
                YMMYandexMetrica.reportEvent("listScreen_loaded")
                return .loaded((tickers: tickers, filter: ""))
            case .failedLoadTickers:
                YMMYandexMetrica.reportEvent("listScreen_error")
                return .error
            default:
                return state
            }
        case let .loaded(data):
            switch event {
            case let .searching(filter):
                return .loaded((tickers: data.tickers, filter: filter))
            case let .didSelectTicker(ticker):
                YMMYandexMetrica.reportEvent("listScreen_selectTicker", parameters: [
                    "ticker": ticker.title,
                    "searchString": data.filter,
                ])
                return state
            default:
                return state
            }
        case .error:
            switch event {
            case .didSelectReload:
                YMMYandexMetrica.reportEvent("listScreen_reload")
                return .loading
            default:
                return state
            }
        }
    }

    static func loading(fetcher: TradingDataNetworkFetching) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }

            return Future { promise in
                Task.detached {
                    guard let tickers = await fetcher.getMoexTickers() else {
                        return promise(.success(Event.failedLoadTickers))
                    }
                    promise(.success(Event.didLoadTickers(tickers)))
                }
            }
            .eraseToAnyPublisher()
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

// MARK: - Other Models

typealias Tickers = [Ticker]

extension Tickers {
    func filtered(by string: String) -> Tickers {
        guard !string.isEmpty else { return self }
        return filter {
            $0.title.lowercased().contains(string.lowercased())
        }
    }
}
