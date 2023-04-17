import Combine
import Foundation

final class ListScreenViewModel: ObservableObject {
    @Published private(set) var state: State = .initial

    private let input = PassthroughSubject<Event, Never>()

    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.loading(),
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
                return .loaded((tickers: tickers, filter: ""))
            case .failedLoadTickers:
                return .error
            default:
                return state
            }
        case let .loaded(data):
            switch event {
            case let .searching(filter):
                return .loaded((tickers: data.tickers, filter: filter))
            default:
                return state
            }
        case .error:
            switch event {
            case .didSelectReload:
                return .loading
            default:
                return state
            }
        }
    }

    static func loading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }

            #warning("TODO: remove")
            guard let result = [Event.didLoadTickers(Fakes.tickers), Event.failedLoadTickers].randomElement() else { return Empty().eraseToAnyPublisher() }
            return Just(result)
                .delay(for: 1, scheduler: RunLoop.main)
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
