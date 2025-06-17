//
//  NetworkError.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case noInternet
    case badURL
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection."
        case .badURL:
            return "Invalid URL."
        case .serverError(let code):
            return "Server returned status code \(code)."
        case .decodingError:
            return "Failed to decode response."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
    
// Error: response status is 401
//    {
//      "success": false,
//      "message": "Invalid token. Try to get a new one by the method POST api/v1/token."
//    }
    
}
