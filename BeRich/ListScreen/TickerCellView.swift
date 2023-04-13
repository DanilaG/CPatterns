//
//  TickerCellView.swift
//  BeRich
//
//  Created by Ilya Solovyov on 13.04.2023.
//

import SwiftUI

struct TickerCellView: View {
    
    let ticker: Ticker
    
    @State private var isFavourite = false
    
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AAPL")
                        .font(.title2)
                    Text("Apple inc.")
                        .font(Font.subheadline)
                }
                Spacer()
                
                Button {
                    isFavourite.toggle()
                } label: {
                    Image(systemName: isFavourite ? "star.fill": "star")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.yellowMain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.stroke, lineWidth: 1)
        )
        .addBorder(Color.stroke, width: 0.5, cornerRadius: 16)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(Color.background)

    }
}

struct TickerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TickerCellView(ticker: Ticker(title: "Title"))
    }
}
