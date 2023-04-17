import SwiftUI

// TODO: to be replaced with Stock
struct Pattern: Identifiable {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    let id: String = UUID().uuidString
    let title: String
    let lowPrice: Double
    let highPrice: Double
    let count: Int // Количество паттернов этого типа на графике, возможно, стоит перенести куда-нибудь
    let startTimePeriod: Date
    let endTimePeriod: Date

    init(title: String,
         lowPrice: CGFloat,
         highPrice: CGFloat,
         count: Int,
         startTimePeriod: String,
         endTimePeriod: String)
    {
        self.title = title
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.count = count
        self.startTimePeriod = dateFormatter.date(from: startTimePeriod)!
        self.endTimePeriod = dateFormatter.date(from: endTimePeriod)!
    }
}
