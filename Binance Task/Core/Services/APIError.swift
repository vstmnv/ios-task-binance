//
//  APIError.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int, Data)
    case decoding(Error)
    case server(Error)
}
