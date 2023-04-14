import SwiftUI

struct TickerCellView: View {
    let ticker: Ticker

    var body: some View {
        Group {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ticker.title)
                        .font(.title2)
                        .foregroundColor(.black)
                    Text(ticker.subTitle)
                        .font(Font.subheadline)
                        .foregroundColor(.gray500)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text(ticker.price)
                        .font(.title)
                        .foregroundColor(Color.yellowMain)
                    Text(String(ticker.priceChange))
                        .frame(width: 70)
                        .font(Font.subheadline)
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
        if priceChange > 0 { return .greenMain }
        if priceChange < 0 { return .redMain }
        return .gray400
    }
}

struct TickerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TickerCellView(ticker: Ticker(title: "Title",
                                      subTitle: "Subtitle",
                                      price: "100$",
                                      priceChange: 100))
    }
}
