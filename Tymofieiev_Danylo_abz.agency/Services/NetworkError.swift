//
//  NetworkError.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case noInternet
    case badURL
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection."
        case .badURL:
            return "Invalid URL."
        case .serverError(let code):
            return "Server returned an error: \(code)."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
