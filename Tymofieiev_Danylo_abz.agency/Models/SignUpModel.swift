//
//  SignUpModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 17.06.2025.
//

import SwiftUI

struct SignUpRequest {
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
