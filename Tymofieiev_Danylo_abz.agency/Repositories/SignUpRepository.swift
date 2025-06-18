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
    func signUpUser(_ requestModel: SignUpRequest) async throws -> SignUpResponse?
}

final class SignUpRepository: SignUpRepositoryProtocol {
    func fetchToken() async throws -> String {
        let response = try await NetworkManager.shared.request(
            endpoint: APIEndpoint.postToken,
            responseType: TokenResponse.self
        )
        return response.token
    }
    
    func getPositions() async throws -> [Position] {
        let response = try await NetworkManager.shared.request(
            endpoint: APIEndpoint.getPositions,
            responseType: PositionResponse.self
        )
        return response.positions
    }
    
    func signUpUser(_ requestModel: SignUpRequest) async throws -> SignUpResponse? {
        guard let token = AppDefaults.token else { return nil }
        
        let boundary = UUID().uuidString
        let bodyData = createMultipartBody(requestModel: requestModel, boundary: boundary)
        
        let headers = [
            "Accept": "application/json",
            "Token": token,
            "Content-Type": "multipart/form-data"  // boundary added by NetworkManager.makeRequest
        ]
        
        let signUpEndpoint = APIEndpoint.postUser(httpMethod: "POST", headers: headers)
        
        let logModel = LoggableSignUpRequest(from: requestModel)
        
        let response = try await NetworkManager.shared.request(
            endpoint: signUpEndpoint,
            bodyData: bodyData,
            boundary: boundary,
            responseType: SignUpResponse.self,
            logModel: logModel
        )
        return response
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
