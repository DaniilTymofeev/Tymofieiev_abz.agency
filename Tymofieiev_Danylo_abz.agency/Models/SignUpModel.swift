//
//  SignUpModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 17.06.2025.
//

import SwiftUI

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photoData: Data?
}

struct SignUpResponse: Decodable {
    let success: Bool
    let userId: Int
    let message: String

    private enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case message
    }
}

struct LoggableSignUpRequest: Encodable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photoDataDescription: String

    init(from original: SignUpRequest) {
        self.name = original.name
        self.email = original.email
        self.phone = original.phone
        self.positionId = original.positionId
        self.photoDataDescription = original.photoData != nil ? "Attached (\(original.photoData!.count) bytes)" : "nil"
    }
}
