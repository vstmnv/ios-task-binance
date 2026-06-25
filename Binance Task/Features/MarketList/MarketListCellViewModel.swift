//
//  MarketListCellViewModel.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

final class MarketListCellViewModel {
    
    let symbol: String
    let priceChangePercentage: String
    let bidPrice: String
    let askPrice: String
    
    init(symbolMarketData: SymbolMarketResponse) {
        symbol = symbolMarketData.symbol
        priceChangePercentage = symbolMarketData.priceChangePercent + " %"
        bidPrice = symbolMarketData.bidPrice
        askPrice = symbolMarketData.askPrice
    }
}
