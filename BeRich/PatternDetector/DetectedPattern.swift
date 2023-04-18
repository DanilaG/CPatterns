import Foundation

struct DetectedPattern: Identifiable, Equatable, Hashable {
    let id: String = UUID().uuidString
    let pattern: CandlePattern
    let startDate: Date
    let endDate: Date
    // Наименьшая цена в паттерне для отображения графика
    let lowPrice: Double
    // Наибольшая цена в паттерне для отображения графика
    let highPrice: Double
}
