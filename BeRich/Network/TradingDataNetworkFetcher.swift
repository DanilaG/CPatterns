
import Foundation

protocol TradingDataNetworkFetching {
    func getTickers() async -> BinanceTikers?
}

final class TradingDataNetworkFetcher: TradingDataNetworkFetching, ObservableObject {
    func getTickers() async -> BinanceTikers? {
        guard let url = BinanceApi.Method.exchangeInfo.url() else {
            assertionFailure()
            return nil
        }
        do {
            let data = try await request(url)
            let binanceTickers = try decodeJSON(type: BinanceTikers.self, from: data)
            return binanceTickers
        } catch URLError.badServerResponse {
            print(URLError.badServerResponse)
        } catch let DecodingError.dataCorrupted(error) {
            print(error)
        } catch {
            print(error)
        }
        return nil
    }

    func getMoexTickers() async {
        guard let url = MoexApi.Method.allTikers.url() else { return }
        do {
            let data = try await request(url)
            let moexTickers = try decodeJSON(type: MoexTikers.self, from: data)
            print(moexTickers)
        } catch {
            print(error)
        }
    }
}

private func decodeJSON<T: Decodable>(type: T.Type, from data: Data) throws -> T {
    let decoder = JSONDecoder()
    let response = try decoder.decode(type, from: data)
    return response
}

private func request(_ url: URL) async throws -> Data {
    let session = URLSession(configuration: .default)
    let (data, response) = try await session.data(for: URLRequest(url: url))
    guard let httpURLResponse = response.httpURLResponse, httpURLResponse.isSuccessful else {
        throw NetworkingError.requestFailed
    }
    print(httpURLResponse.statusCode)
    print(httpURLResponse.allHeaderFields)
    return data
}

enum NetworkingError: Error {
    case requestFailed
}

extension URLResponse {
    /// Returns casted HTTPURLResponse
    var httpURLResponse: HTTPURLResponse? {
        self as? HTTPURLResponse
    }
}

extension HTTPURLResponse {
    /// Returns true if statusCode is in range 200...299.
    /// Otherwise false.
    var isSuccessful: Bool {
        200 ... 299 ~= statusCode
    }
}
