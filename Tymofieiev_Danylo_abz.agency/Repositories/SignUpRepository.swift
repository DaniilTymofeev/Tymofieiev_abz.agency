//
//  SignUpRepository.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import UIKit

protocol SignUpRepositoryProtocol {
    func fetchToken() async throws -> String
    func getPositions() async throws -> [Position]
    func signUpUser(_ requestModel: SignUpRequest) async throws
}

final class SignUpRepository: SignUpRepositoryProtocol {
    func fetchToken() async throws -> String {
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let response = try await APIClient.shared.request(
            request: request,
            decodeType: TokenResponse.self
        )
        return response.token
    }
    
    func getPositions() async throws -> [Position] {
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/positions")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let response = try await APIClient.shared.request(
            request: request,
            decodeType: PositionResponse.self
        )
        return response.positions
    }
    
    func signUpUser(_ requestModel: SignUpRequest) async throws {
        guard let token = AppDefaults.token else { return }
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let httpBody = createMultipartBody(
            requestModel: requestModel,
            boundary: boundary
        )
        request.httpBody = httpBody
        
        let _ = try await APIClient.shared.request(
            request: request,
            decodeType: SignUpResponse.self
        )
    }
    
    private func createMultipartBody(
        requestModel: SignUpRequest,
        boundary: String
    ) -> Data {
        var body = Data()
        
        func addField(name: String, value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        addField(name: "name", value: requestModel.name)
        addField(name: "email", value: requestModel.email)
        addField(name: "phone", value: requestModel.phone)
        addField(name: "position_id", value: String(requestModel.positionId))
        
        if let imageData = requestModel.photoData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"avatar.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
