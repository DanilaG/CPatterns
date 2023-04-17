import Foundation
enum MoexApi {
    enum Method: String {
        case allTikers = "/iss/history/engines/stock/markets/shares/boards/tqbr/securities.json"

        func url() -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = rawValue
            return components.url
        }
    }
}

private let scheme = "https"
private let host = "iss.moex.com"
