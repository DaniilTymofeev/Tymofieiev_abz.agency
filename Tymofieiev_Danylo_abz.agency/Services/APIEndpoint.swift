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
    case postUser(httpMethod: String = "POST", headers: [String: String]? = nil)
    
    var url: URL? {
        switch self {
        case .getUsers(let page, let count):
            return URL(string: "\(Self.baseURL)/users?page=\(page)&count=\(count)")
        case .getUserById(let id):
            return URL(string: "\(Self.baseURL)/users/\(id)")
        case .getPositions:
            return URL(string: "\(Self.baseURL)/positions")
        case .postToken:
            return URL(string: "\(Self.baseURL)/token")
        case .postUser:
            return URL(string: "\(Self.baseURL)/users")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .postToken:
            return "POST"
        case .postUser(let method, _):
            return method
        default:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postUser(_, let headers):
            return headers
        case .postToken:
            return ["Accept": "application/json"]
        default:
            return nil
        }
    }
    
    func makeRequest(body: Data? = nil, boundary: String? = nil) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        headers?.forEach { key, value in
            if key == "Content-Type", let boundary = boundary {
                request.setValue("\(value); boundary=\(boundary)", forHTTPHeaderField: key)
            } else {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.httpBody = body
        return request
    }
}
