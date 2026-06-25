//
//  SymbolMarketListEndpoint.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

struct SymbolMarketListEndpoint: Endpoint {
    
    typealias Response = [SymbolMarketResponse]

    var httpMethod: HTTPMethod {
        .get
    }
    
    var path: String {
        "/api/v3/ticker/24hr"
    }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "type", value: "FULL"),
            URLQueryItem(name: "symbolStatus", value: "TRADING"),
        ]
    }
}
