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

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "The request could not be sent. Please try again.")
        case .invalidResponse:
            return String(localized: "The server returned an unexpected response.")
        case .httpStatus(let code, _):
            return String(localized: "The server returned an error (status \(code)).")
        case .decoding:
            return String(localized: "The data couldn’t be read. Please try again later.")
        case .server(let error):
            return error.localizedDescription
        }
    }
}
