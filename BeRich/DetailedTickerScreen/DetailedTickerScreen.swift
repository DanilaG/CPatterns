import SwiftUI

struct DetailedTickerScreen: View {
    @StateObject var viewModel: DetailedTickerScreenViewModel

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
        ScrollView {
            ChartView(stocks: chart.candles,
                      timePeriod: chart.parameters.period)
            changeTimePeriodButtons(chart.parameters)
                .navigationBarTitle(chart.parameters.tickerTitle)
            PatternListView(patterns: chart.patterns)
        }
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
                            .foregroundColor(parameters.period == timePeriod ? Color.whiteMain : Color.blueMain)
                            .addBorder(Color.blueMain, width: 1, cornerRadius: 20)
                    }
                }
            }
            .padding()
        }
    }
}

private let defaultErrorMessage = "Ошибка загрузки"

struct DetailedTickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTickerScreen(
            viewModel: DetailedTickerScreenViewModel(tickerTitle: "Test")
        )
    }
}
