
import Foundation

struct MoexTikers: Decodable {
    let history: History
}

struct History: Decodable {
    let data: [[MoexTiker]]
    let columns: [String]
}

enum MoexTiker: Decodable {
    case double(Double)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(MoexTiker.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MoexTiker"))
    }
}
