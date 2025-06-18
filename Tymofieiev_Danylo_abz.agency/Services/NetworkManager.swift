//
//  NetworkManager.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let monitor = NetworkMonitor.shared
    
    /// Generic request method for any HTTP method, with optional bodyData and boundary
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        bodyData: Data? = nil,
        boundary: String? = nil,
        responseType: T.Type,
        logModel: Encodable? = nil
    ) async throws -> T {
        guard monitor.isConnected else {
            LogManager.logError(APIError.noInternet, url: endpoint.url?.absoluteString ?? "")
            throw APIError.noInternet
        }
        
        // Use APIEndpoint.makeRequest to build URLRequest with correct headers and body
        guard let request = endpoint.makeRequest(body: bodyData, boundary: boundary) else {
            LogManager.logError(APIError.badURL, url: endpoint.url?.absoluteString ?? "")
            throw APIError.badURL
        }
#if DEBUG
        LogManager.logFullRequest(request, model: logModel)
#endif
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            LogManager.logError(error, url: request.url?.absoluteString ?? "")
            throw APIError.unknownError
        }
        
#if DEBUG
        LogManager.logResponse(data, url: request.url?.absoluteString ?? "")
#endif
        
        guard let httpResponse = response as? HTTPURLResponse else {
            LogManager.logError(APIError.unknownError, url: request.url?.absoluteString ?? "")
            throw APIError.unknownError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                let error = APIError.tokenExpired
                LogManager.logError(error, url: request.url?.absoluteString ?? "")
                throw error
            }

            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
               let message = apiError.message {
                let error = APIError.serverErrorWithMessage(statusCode: httpResponse.statusCode, message: message)
                LogManager.logError(error, url: request.url?.absoluteString ?? "")
                throw error
            } else {
                let error = APIError.serverError(statusCode: httpResponse.statusCode)
                LogManager.logError(error, url: request.url?.absoluteString ?? "")
                throw error
            }
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            let decodingError = APIError.decodingError
            LogManager.logError(decodingError, url: request.url?.absoluteString ?? "")
            throw decodingError
        }
    }
    
    /// Convenience GET method using APIEndpoint
    func get<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        try await request(endpoint: endpoint, bodyData: nil, responseType: responseType)
    }
}

// MARK: - Helper to pretty print JSON

func prettyPrintedJSON(from data: Data) -> String? {
    guard
        let object = try? JSONSerialization.jsonObject(with: data, options: []),
        let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
        let prettyString = String(data: prettyData, encoding: .utf8)
    else {
        return nil
    }
    return prettyString
}

// MARK: - APIErrorResponse for error message decoding

struct APIErrorResponse: Decodable {
    let success: Bool?
    let message: String?
}
