//
//  NetworkManager.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let monitor = NetworkMonitor.shared

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        bodyData: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard monitor.isConnected else {
            LogManager.logError(APIError.noInternet, url: endpoint.url?.absoluteString ?? "")
            throw APIError.noInternet
        }

        guard let url = endpoint.url else {
            LogManager.logError(APIError.badURL, url: "")
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod

        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.httpBody = bodyData

        LogManager.logRequest(url.absoluteString, method: request.httpMethod ?? "GET")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            LogManager.logError(error, url: url.absoluteString)
            throw APIError.unknownError
        }

        #if DEBUG
        if let pretty = prettyPrintedJSON(from: data) {
            print("✅ API Response:\n\(pretty)")
        } else {
            print("❌ Failed to pretty print response")
        }
        #endif

        guard let httpResponse = response as? HTTPURLResponse else {
            LogManager.logError(APIError.unknownError, url: url.absoluteString)
            throw APIError.unknownError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let error = APIError.serverError(statusCode: httpResponse.statusCode)
            LogManager.logError(error, url: url.absoluteString)
            throw error
        }

        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            let decodingError = APIError.decodingError
            LogManager.logError(decodingError, url: url.absoluteString)
            throw decodingError
        }
    }
}
