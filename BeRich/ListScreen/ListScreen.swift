//
//  ListScreen.swift
//  BeRich
//
//  Created by Danila on 11.04.2023.
//

import SwiftUI

struct Ticker: Identifiable {
    var id: String = UUID().uuidString
    var title: String
}

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
            .toolbarBackground(Color.blueMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
    }
}
