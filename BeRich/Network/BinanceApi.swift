import Foundation
enum BinanceApi {
    enum Method: String {
        case exchangeInfo = "/api/v3/exchangeInfo"
        case candles = "/api/v3/klines"

        func url(queryItems: [URLQueryItem]?) -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = rawValue
            if let queryItems {
                components.queryItems = queryItems
            }
            return components.url
        }
    }
}

private let scheme = "https"
private let host = "data.binance.com"
