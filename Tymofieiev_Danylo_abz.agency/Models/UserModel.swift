//
//  UserModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct UserModel: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}
