//
//  MarketListCellViewModel.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

final class MarketListCellViewModel {
    
    let symbolMarketData: SymbolMarketResponse
    
    init(symbolMarketData: SymbolMarketResponse) {
        self.symbolMarketData = symbolMarketData
    }
}
