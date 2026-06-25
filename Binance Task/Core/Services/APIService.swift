//
//  APIService.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

final class APIService {
    
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func fetch<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        let request = try makeRequest(for: endpoint)

        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.server(error)
        }

        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200..<300).contains(httpUrlResponse.statusCode) else {
            throw APIError.httpStatus(httpUrlResponse.statusCode, data)
        }

        do {
            return try decoder.decode(E.Response.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    private func makeRequest<E: Endpoint>(for endpoint: E) throws -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        return request
    }
}
