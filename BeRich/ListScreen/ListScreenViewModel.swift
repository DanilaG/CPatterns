import Combine
import Foundation

final class ListScreenViewModel: ObservableObject {
    @Published private(set) var state: State = .loading

    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [Self.loading()]
        )
        .assign(to: &$state)
    }
}

// MARK: - Inner Types

extension ListScreenViewModel {
    enum State {
        case loading
        case loaded([Ticker])
    }

    enum Event {
        case didLoadTickers([Ticker])
    }
}

// MARK: - State Machine

extension ListScreenViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .loading:
            switch event {
            case let .didLoadTickers(tickers):
                return .loaded(tickers)
            }
        case .loaded:
            return state
        }
    }

    static func loading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }

            return Just(Event.didLoadTickers(Fakes.tickers))
                .delay(for: 1, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
