import Foundation

public struct Stock: Identifiable {
    // TODO: replace in Utils module
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return formatter
    }()

    public var id = UUID()
    public var date: Date
    public var openPrice: Double
    public var closePrice: Double
    public var highPrice: Double
    public var lowPrice: Double

    public init(
        date: Date,
        openPrice: Double,
        closePrice: Double,
        highPrice: Double,
        lowPrice: Double
    ) {
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }

    public init(
        date: String,
        openPrice: Double,
        closePrice: Double,
        highPrice: Double,
        lowPrice: Double
    ) {
        self.date = dateFormatter.date(from: date)!
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
    }
}

private let minPriceDefaultValue = 0.0
private let maxPriceDefaultValue = 1000.0
extension Stock {
    static func stockArrayMinPriceValue(_ stocks: [Stock]) -> Double {
        stocks.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? minPriceDefaultValue
    }

    static func stockArrayMaxPriceValue(_ stocks: [Stock]) -> Double {
        stocks.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? minPriceDefaultValue
    }
}
