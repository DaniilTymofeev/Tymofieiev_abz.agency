//
//  TokenModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 17.06.2025.
//

import Foundation

struct TokenResponse: Decodable {
    let success: Bool
    let token: String
}
