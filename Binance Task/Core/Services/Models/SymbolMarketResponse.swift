//
//  SymbolMarketResponse.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

struct SymbolMarketResponse: Decodable {
    let symbol: String
    let lastPrice: String
    let priceChangePercent: String
}
