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
        case loaded([Ticker])
    }

    enum Event {
        case didAppear
        case didLoadTickers([Ticker])
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
                return .loaded(tickers)
            default:
                return state
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

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
