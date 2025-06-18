////
////  APIClient.swift
////  Tymofieiev_Danylo_abz.agency
////
////  Created by Danil Tymofeev on 15.06.2025.
////
//
//import Foundation
//
//final class APIClient {
//    static let shared = APIClient()
//    private let monitor = NetworkMonitor.shared
//    
//    private init() {}
//    
//    // Generic GET method
//    func get<T: Decodable>(
//        endpoint: String,
//        decodeType: T.Type
//    ) async throws -> T {
//        guard monitor.isConnected else {
//            throw APIError.noInternet
//        }
//        
//        guard let url = URL(string: endpoint) else {
//            throw APIError.badURL
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw APIError.unknownError
//        }
//        
//        if 200..<300 ~= httpResponse.statusCode {
//            do {
//                return try JSONDecoder().decode(T.self, from: data)
//            } catch {
//                throw APIError.decodingError
//            }
//        } else {
//            // Try decode error message from server
//            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
//               let message = apiError.message {
//                throw APIError.serverErrorWithMessage(statusCode: httpResponse.statusCode, message: message)
//            } else {
//                throw APIError.serverError(statusCode: httpResponse.statusCode)
//            }
//        }
//    }
//    
//    
//    // Generic request method for any URLRequest (POST, multipart, etc)
//    func request<T: Decodable>(
//        request: URLRequest,
//        decodeType: T.Type
//    ) async throws -> T {
//        guard monitor.isConnected else {
//            throw APIError.noInternet
//        }
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw APIError.unknownError
//        }
//        
//        if 200..<300 ~= httpResponse.statusCode {
//            do {
//                return try JSONDecoder().decode(T.self, from: data)
//            } catch {
//                throw APIError.decodingError
//            }
//        } else {
//            // Try decode error message from server
//            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
//               let message = apiError.message {
//                throw APIError.serverErrorWithMessage(statusCode: httpResponse.statusCode, message: message)
//            } else {
//                throw APIError.serverError(statusCode: httpResponse.statusCode)
//            }
//        }
//    }
//}
//
//struct APIErrorResponse: Decodable {
//    let success: Bool?
//    let message: String?
//}
