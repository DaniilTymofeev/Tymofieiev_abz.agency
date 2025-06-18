//
//  NetworkError.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
    case noInternet
    case badURL
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    case tokenExpired
    case serverErrorWithMessage(statusCode: Int, message: String)
    
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
        case .tokenExpired:
            return "Your token has expired. Please try again."
        case .serverErrorWithMessage(_, let message):
            return message
        }
    }
    
    // to compare responses if message text different (tokenExpired)
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternet, .noInternet),
            (.badURL, .badURL),
            (.decodingError, .decodingError),
            (.unknownError, .unknownError),
            (.tokenExpired, .tokenExpired):
            return true
        case (.serverError(let left), .serverError(let right)):
            return left == right
        case (.serverErrorWithMessage(let lCode, let lMsg),
              .serverErrorWithMessage(let rCode, let rMsg)):
            return lCode == rCode && lMsg == rMsg
        default:
            return false
        }
    }
}
