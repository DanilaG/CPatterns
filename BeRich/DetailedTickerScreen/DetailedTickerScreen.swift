import Combine
import SwiftUI

struct DetailedTickerScreen: View {
    @StateObject var viewModel: DetailedTickerScreenViewModel
    @State var scrollToPattern = PassthroughSubject<PatternViewData, Never>()

    let chartId = "chart"

    init(viewModel: DetailedTickerScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case let .initial(parameters):
                Color.background
                    .navigationTitle(parameters.tickerTitle)
            case let .loading(parameters):
                loading()
                    .navigationTitle(parameters.tickerTitle)
            case let .loaded(chart):
                present(chart)
                    .navigationTitle(chart.parameters.tickerTitle)
            case let .error(parameters):
                error()
                    .navigationTitle(parameters.tickerTitle)
            }
        }
        .background(Color.background)
        .onAppear {
            viewModel.send(event: .didAppear)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loading() -> some View {
        ZStack {
            Color.background
            ProgressView()
        }
    }

    private func error() -> some View {
        ZStack {
            Color.background
            VStack(spacing: 12.0) {
                Text(defaultErrorMessage)
                    .foregroundColor(Color(UIColor.label))
            }
            .multilineTextAlignment(.center)
        }
    }

    func present(_ chart: DetailedTickerScreenViewModel.Chart) -> some View {
        ScrollViewReader { scroll in
            List {
                VStack {
                    ScrolledCandlesChart(
                        patterns: chart.detectedPatterns,
                        stocks: chart.candles,
                        timePeriod: chart.parameters.period,
                        scrollToPattern: scrollToPattern.eraseToAnyPublisher(),
                        onPatternsSelect: { viewModel.send(event: .didSelectPatterns($0)) }
                    )
                    changeTimePeriodButtons(chart.parameters)
                        .navigationBarTitle(chart.parameters.tickerTitle)

                    VStack(alignment: .leading, spacing: 16) {
                        Text(chart.detectedPatterns.isEmpty ? "Паттерны не найдены" : "Паттерны")
                            .font(chart.detectedPatterns.isEmpty ? nil : .title)
                            .padding(.horizontal)
                        ForEach(chart.detectedPatterns, id: \.id) { pattern in
                            PatternCellView(patternViewData: pattern)
                                .onTapGesture {
                                    scrollToPattern.send(pattern)
                                    viewModel.send(event: .didSelectPatterns([pattern]))
                                    scroll.scrollTo(chartId)
                                }
                        }
                        .animation(.easeInOut, value: chart.detectedPatterns)
                    }
                }
                .id(chartId)
                .listRowSeparator(.hidden)
            }
            .padding(.top, -12)
            .padding(.horizontal, -20)
            .listStyle(.plain)
        }
    }

    func changeTimePeriodButtons(_ parameters: DetailedTickerScreenViewModel.ChartParameters) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Text("Свеча:")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                ForEach(ChartTimePeriod.allCases, id: \.rawValue) { timePeriod in
                    Button {
                        viewModel.send(event: .didChangeTimePeriod(timePeriod))
                    } label: {
                        Text(timePeriod.title)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(parameters.period == timePeriod ? Color.blueMain : Color.whiteMain).cornerRadius(20)
                            .foregroundColor(parameters.period == timePeriod ? .whiteMain : .blueMain)
                            .addBorder(Color.blueMain, width: 1, cornerRadius: 20)
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

private let defaultErrorMessage = "Ошибка загрузки"

extension ChartTimePeriod {
    var title: String {
        switch self {
        case .day:
            return "День"
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        }
    }
}
