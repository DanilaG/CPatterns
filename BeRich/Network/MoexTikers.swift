
import Foundation

struct MoexTikers: Decodable {
    let history: History
}

struct History: Decodable {
    let data: [[(any Decodable)?]]
    let columns: [String]
}

// struct Tiker: Decodable {
//    let a: [a]
// }
// struct a: Decodable {
//    let f: String
// }
enum Datum: Decodable {
    case double(Double)
    case string(String)
//    case d(Data)
    case null
}
