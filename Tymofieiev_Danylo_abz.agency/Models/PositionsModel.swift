//
//  PositionsModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

struct PositionResponse: Decodable {
    let success: Bool
    let positions: [Position]
}

struct Position: Identifiable, Decodable {
    let id: Int
    let name: String
}
