//
//  Endpoint.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

protocol Endpoint {
    associatedtype Response: Decodable

    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem] { [] }
}
