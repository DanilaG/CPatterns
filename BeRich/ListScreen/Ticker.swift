import SwiftUI

// TODO: to be replaced with Stock
struct Ticker: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let subTitle: String
    let price: String
    let priceChange: PriceChange

    func stocks(timePeriod: ChartTimePeriod) -> [Stock] {
        switch timePeriod {
        case .tenMin:
            return Fakes.stocksInTenMinutesPeriod
        case .thirtyMin:
            return Fakes.stocksInThirtyMinutesPeriod
        default:
            return Fakes.defaultStocks
        }
    }
}
