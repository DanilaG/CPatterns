import SwiftUI

struct Ticker: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let subTitle: String
    let price: String
    let priceChange: PriceChange

    var priceChangeText: String {
        switch priceChange {
        case let .increase(priceChange):
            return "+\(priceChange)"
        case .stable:
            return "0.0"
        case let .decrease(priceChange):
            return "-\(priceChange)"
        }
    }
}
