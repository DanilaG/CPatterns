import SwiftUI

struct TickerCellView: View {
    let ticker: Ticker

    var body: some View {
        Group {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(ticker.title)
                        .font(.title2)
                        .foregroundColor(.black)
                    Text(ticker.subTitle)
                        .font(Font.subheadline)
                        .foregroundColor(.gray500)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(describing: ticker.price))
                        .font(.title2)
                        .foregroundColor(Color.black)
                    HStack(alignment: .center) {
                        Spacer()
                        Text(String(describing: ticker.priceChange))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .padding(.horizontal, 4.0)
                            .font(.subheadline.bold())
                    }
                    .frame(width: 84)
                    .foregroundColor(Color.white)
                    .padding(2)
                    .background(ticker.priceChangeColor)
                    .cornerRadius(4)
                }
                .padding(.trailing, 8)
            }
            .padding(.vertical, 12)
        }
    }
}

extension Ticker {
    var priceChangeColor: Color {
        if priceChange.amount > 0 { return .greenMain }
        if priceChange.amount < 0 { return .redMain }
        return .gray400
    }
}

struct TickerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TickerCellView(ticker: Ticker(title: "Title",
                                      subTitle: "Subtitle",
                                      price: Money(amount: 100, currency: .rub),
                                      priceChange: Money(amount: 100, currency: .rub)))
    }
}
