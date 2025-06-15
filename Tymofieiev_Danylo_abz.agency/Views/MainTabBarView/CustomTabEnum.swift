//
//  CustomTabEnum.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

enum Tab {
    case users
    case signUp
    
    var title: String {
        switch self {
        case .users: return L10n.users
        case .signUp: return L10n.signUp
        }
    }
    
    var icon: Image {
        switch self {
        case .users: return Image(asset: Asset.usersSymbol)
        case .signUp: return Image(asset: Asset.signUpSymbol)
        }
    }
}
