import Combine
import Foundation
import YandexMobileMetrica

final class DetailedTickerScreenViewModel: ObservableObject {
    @Published private(set) var state: State

    private let input = PassthroughSubject<Event, Never>()

    init(tickerTitle: String, fetcher: TradingDataNetworkFetching,
         patternDetector: PatternDetector)
    {
        state = .initial(ChartParameters(tickerTitle: tickerTitle, period: .day))

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: DispatchQueue.main,
            feedbacks: [
                Self.loading(fetcher: fetcher, patternDetector: patternDetector, patternDetector: patternDetector),
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
        enum SelectPatternSource: String {
            case chart
            case list
        }

        case didAppear
        case didLoad(Chart)
        case failedLoad
        case didChangeTimePeriod(ChartTimePeriod)
        case didSelectPatterns([PatternViewData], SelectPatternSource)
    }

    struct ChartParameters {
        let tickerTitle: String
        let period: ChartTimePeriod
    }

    struct Chart {
        let parameters: ChartParameters
        let candles: [Stock]
        let detectedPatterns: [PatternViewData]
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
                YMMYandexMetrica.reportEvent("detailedTickerScreen_error")
                return .error(parameters)
            case let .didLoad(chart):
                YMMYandexMetrica.reportEvent("detailedTickerScreen_loaded")
                return .loaded(chart)
            default:
                return state
            }
        case let .loaded(chart):
            switch event {
            case let .didChangeTimePeriod(period):
                YMMYandexMetrica.reportEvent("detailedTickerScreen_changeTimePeriod", parameters: [
                    "period": period.title,
                ])
                return .loading(ChartParameters(tickerTitle: chart.parameters.tickerTitle, period: period))
            case let .didSelectPatterns(selectedPatterns, source):
                YMMYandexMetrica.reportEvent("detailedTickerScreen_selectedPatterns", parameters: [
                    "patterns": selectedPatterns.map(\.title),
                    "ticker": chart.parameters.tickerTitle,
                    "source": source.rawValue,
                ])
                return .loaded(Chart(
                    parameters: chart.parameters,
                    candles: chart.candles,
                    detectedPatterns: chart.detectedPatterns.map { pattern in
                        PatternViewData(pattern, isSelected: selectedPatterns.contains(where: { $0.id == pattern.id }))
                    }.sorted()
                ))
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

    static func loading(fetcher: TradingDataNetworkFetching,
                        patternDetector _: PatternDetector,
                        patternDetector: PatternDetector) -> Feedback<State, Event>
    {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loading(chartParameters) = state else { return Empty().eraseToAnyPublisher() }
            return Future { promise in
                Task.detached {
                    guard let candles = await fetcher.getMoexCandles(
                        ticker: chartParameters.tickerTitle,
                        timePeriod: chartParameters.period
                    ) else {
                        return promise(.success(Event.failedLoad))
                    }

                    let detectedPatterns = patternDetector.detectPatterns(candles: candles)

                    promise(.success(Event.didLoad(Chart(
                        parameters: chartParameters,
                        candles: candles,
                        detectedPatterns: detectedPatterns
                            .map { PatternViewData($0, chartParameters.period) }
                            .sorted()
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

extension [PatternViewData] {
    func sorted() -> [PatternViewData] {
        sorted(by: {
            if $0.isSelected, !$1.isSelected { return true }
            if !$0.isSelected, $1.isSelected { return false }
            return $0.startDate > $1.startDate
        })
    }
}
