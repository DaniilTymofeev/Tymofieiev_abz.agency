//
//  APIClient.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

enum APIError: Error {
    case noConnection
    case invalidResponse
    case decodingError
    case serverError(String)
}

final class APIClient {
    static let shared = APIClient()

    private let monitor = NetworkMonitor.shared

    private init() {}

    func get<T: Decodable>(
        endpoint: String,
        decodeType: T.Type
    ) async throws -> T {
        guard monitor.isConnected else {
            throw APIError.noConnection
        }

        guard let url = URL(string: endpoint) else {
            throw APIError.invalidResponse
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.serverError("Bad status code")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
