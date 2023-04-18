
import Foundation

protocol TradingDataNetworkFetching {
    func getBinanceTickers() async -> BinanceTikers?
}

final class TradingDataNetworkFetcher: TradingDataNetworkFetching, ObservableObject {
    func getBinanceTickers() async -> BinanceTikers? {
        guard let url = BinanceApi.Method.exchangeInfo.url(queryItems: nil) else {
            assertionFailure()
            return nil
        }
        print(url)
        do {
            let data = try await request(url)
            let binanceTickers = try decodeJSON(type: BinanceTikers.self, from: data)
            return binanceTickers
        } catch NetworkingError.requestFailed {
            print(NetworkingError.requestFailed)
        } catch let DecodingError.dataCorrupted(error) {
            print(error)
        } catch {
            print(error)
        }
        return nil
    }

    func getBinanceCandles(queryItems: [URLQueryItem]?) async -> BinanceCandles? {
        guard let url = BinanceApi.Method.candles.url(queryItems: queryItems) else {
            assertionFailure()
            return nil
        }
        print(url)
        do {
            let data = try await request(url)
            let binanceCandles = try decodeJSON(type: BinanceCandles.self, from: data)
            return binanceCandles
        } catch NetworkingError.requestFailed {
            print(NetworkingError.requestFailed)
        } catch let DecodingError.dataCorrupted(error) {
            print(error)
        } catch {
            print(error)
        }
        return nil
    }

    func getMoexTickers() async -> MoexTikers? {
        guard let url = MoexApi.Method.allTikers.url(tiket: nil, queryItems: nil) else {
            assertionFailure()
            return nil
        }
        print(url)
        do {
            let data = try await request(url)
            let moexTickers = try decodeJSON(type: MoexTikers.self, from: data)
            return moexTickers
        } catch NetworkingError.requestFailed {
            print(NetworkingError.requestFailed)
        } catch let DecodingError.dataCorrupted(error) {
            print(error)
        } catch {
            print(error)
        }
        return nil
    }

    func getMoexCandles(tiket: String, queryItems: [URLQueryItem]) async -> MoexCandles? {
        guard let url = MoexApi.Method.candles.url(tiket: tiket, queryItems: queryItems) else {
            assertionFailure()
            return nil
        }
        print(url)
        do {
            let data = try await request(url)
            let moexCandles = try decodeJSON(type: MoexCandles.self, from: data)
            return moexCandles
        } catch NetworkingError.requestFailed {
            print(NetworkingError.requestFailed)
        } catch let DecodingError.dataCorrupted(error) {
            print(error)
        } catch {
            print(error)
        }
        return nil
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
