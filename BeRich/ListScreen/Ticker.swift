//
//  Ticker.swift
//  BeRich
//
//  Created by Ilya Solovyov on 13.04.2023.
//

import SwiftUI

enum PriceChange {
    case increase(Int)
    case stable
    case decrease(Int)
    
    var color: Color {
        switch self {
        case .increase:
            return .greenMain
        case .stable:
            return .gray400
        case .decrease:
            return .redMain
        }
    }
}

struct Ticker: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let subTitle: String
    let price: String
    let priceChange: PriceChange
}
