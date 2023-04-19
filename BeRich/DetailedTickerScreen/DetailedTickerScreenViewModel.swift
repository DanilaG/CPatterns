import Combine
import Foundation

final class DetailedTickerScreenViewModel: ObservableObject {
    @Published private(set) var state: State

    private let input = PassthroughSubject<Event, Never>()

    init(tickerTitle: String, fetcher: TradingDataNetworkFetching) {
        state = .initial(ChartParameters(tickerTitle: tickerTitle, period: .day))

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

extension DetailedTickerScreenViewModel {
    enum State {
        case initial(ChartParameters)
        case loading(ChartParameters)
        case loaded(Chart)
        case error(ChartParameters)
    }

    enum Event {
        case didAppear
        case didLoad(Chart)
        case failedLoad
        case didChangeTimePeriod(ChartTimePeriod)
    }

    struct ChartParameters {
        let tickerTitle: String
        let period: ChartTimePeriod
    }

    struct Chart {
        let parameters: ChartParameters
        let candles: [Stock]
        let patterns: [Pattern]
    }
}

// MARK: - State Machine

extension DetailedTickerScreenViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case let .initial(parameters):
            switch event {
            case .didAppear:
                return .loading(parameters)
            default:
                return state
            }
        case let .loading(parameters):
            switch event {
            case .failedLoad:
                return .error(parameters)
            case let .didLoad(chart):
                return .loaded(chart)
            default:
                return state
            }
        case let .loaded(chart):
            switch event {
            case let .didChangeTimePeriod(period):
                return .loading(ChartParameters(tickerTitle: chart.parameters.tickerTitle, period: period))
            default:
                return state
            }
        case let .error(parameters):
            switch event {
            case .didAppear:
                return .loading(parameters)
            default:
                return state
            }
        }
    }

    static func loading(fetcher: TradingDataNetworkFetching) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loading(chartParameters) = state else { return Empty().eraseToAnyPublisher() }
            return Future { promise in
                Task.detached {
                    guard let candles = await fetcher.getMoexCandles(ticker: chartParameters.tickerTitle, timePeriod: chartParameters.period) else {
                        return promise(.success(Event.failedLoad))
                    }
                    #warning("TODO: add patterns")
                    promise(.success(Event.didLoad(Chart(
                        parameters: chartParameters,
                        candles: candles,
                        patterns: Fakes.patterns
                    ))))
                }
            }
            .eraseToAnyPublisher()
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
