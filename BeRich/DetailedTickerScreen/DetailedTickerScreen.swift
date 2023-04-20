import SwiftUI

struct DetailedTickerScreen: View {
    @StateObject var viewModel: DetailedTickerScreenViewModel
    @State var patternId = 0
    @State var buttonTapToggle = true
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
        List {
            ChartView(stocks: chart.candles,
                      patternViewData: toViewData(chart.detectedPatterns), timePeriod: chart.parameters.period,
                      patternId: $patternId,
                      buttonTapToggle: $buttonTapToggle)
                .listRowSeparator(.hidden)
            changeTimePeriodButtons(chart.parameters)
                .navigationBarTitle(chart.parameters.tickerTitle)
                .listRowSeparator(.hidden)
            ForEach(toViewData(chart.detectedPatterns), id: \.detectedPattern.id) { pattern in
                PatternCellView(patternViewData: pattern)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        for (index, value) in chart.candles.enumerated() {
                            if value.date == pattern.detectedPattern.startDate {
                                patternId = index
                                buttonTapToggle.toggle()
                            }
                        }
                    }
            }
        }
        .padding(.top, -12)
        .padding(.horizontal, -20)
        .listStyle(.plain)
        .background(.red)
    }

    @ViewBuilder func changeTimePeriodButtons(_ parameters: DetailedTickerScreenViewModel.ChartParameters) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ChartTimePeriod.allCases) { timePeriod in

                    Button {
                        viewModel.send(event: .didChangeTimePeriod(timePeriod))
                    } label: {
                        Text(timePeriod.title)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(parameters.period == timePeriod ? Color.blueMain : Color.whiteMain).cornerRadius(20)
                            .foregroundColor(parameters.period == timePeriod ? .whiteMain : .blueMain)
                            .addBorder(Color.blueMain, width: 1, cornerRadius: 20)
                    }
                }
            }
            .padding()
        }
    }
}

private let defaultErrorMessage = "Ошибка загрузки"

private func toViewData(_ patterns: [DetectedPattern]) -> [PatternViewData] {
    let patternColors: [Color] = [.patternDarkGreen, .patternPink, .patternBlue, .patternDarkPink, .patternBrown, .patternDarkBlue]
    return patterns.enumerated().map {
        PatternViewData(
            detectedPattern: $0.element,
            color: patternColors[$0.offset % patternColors.count]
        )
    }
}

struct PatternViewData {
    let detectedPattern: DetectedPattern
    let color: Color
}
