//
//  APIEndpoint.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import Foundation

enum APIEndpoint {
    private static let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    case getUsers(page: Int = 1, count: Int = 6)
    case getUserById(id: Int)
    case getPositions
    case postToken
    case postUser
    
    var url: URL? {
        switch self {
        case .getUsers(let page, let count):
            return URL(string: "\(APIEndpoint.baseURL)/users?page=\(page)&count=\(count)")
            
        case .getUserById(let id):
            return URL(string: "\(APIEndpoint.baseURL)/users/\(id)")
            
        case .getPositions:
            return URL(string: "\(APIEndpoint.baseURL)/positions")
            
        case .postToken:
            return URL(string: "\(APIEndpoint.baseURL)/token")
            
        case .postUser:
            return URL(string: "\(APIEndpoint.baseURL)/users")
        }
    }
    
    // HTTP method for each endpoint
    var httpMethod: String {
        switch self {
        case .postToken, .postUser:
            return "POST"
        default:
            return "GET"
        }
    }
    
    // For special headers, e.g. Token
    var headers: [String: String]? {
        switch self {
        case .postUser:
            return [
                "Accept": "application/json",
                // The Token here should be dynamically injected from your auth manager or similar
                "Token": "YOUR_TOKEN_HERE",
                "Content-Type": "multipart/form-data"
            ]
        default:
            return nil
        }
    }
}
