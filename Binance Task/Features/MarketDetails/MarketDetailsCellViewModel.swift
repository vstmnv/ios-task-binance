//
//  MarketDetailsCellViewModel.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 26.06.26.
//

import Foundation

final class MarketDetailsCellViewModel {

    let key: String
    let value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
