
import Foundation

typealias BinanceCandles = [[BinanceCandle]]
enum BinanceCandle: Decodable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(BinanceCandle.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BinanceCandle"))
    }
}
