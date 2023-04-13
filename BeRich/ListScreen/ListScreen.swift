//
//  ListScreen.swift
//  BeRich
//
//  Created by Danila on 11.04.2023.
//

import SwiftUI

struct ListScreen: View {
    
    @State private var tickers: [Ticker] = Fakes.tickersFakes
    
    var body: some View {
        
        NavigationStack {
            List(tickers) { ticker in
                TickerCellView(ticker: ticker)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .background(Color.background)
            .navigationTitle("BeRich")
            .navigationBarColor(
                backgroundColor: Color.blueMain,
                titleColor: Color.white
            )
        }
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
    }
}
