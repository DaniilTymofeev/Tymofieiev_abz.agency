//
//  AppDefaults.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 17.06.2025.
//

import Foundation

enum AppDefaults {
    private enum Keys {
        static let token = "user_token"
    }

    static var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.token)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.token)
        }
    }

    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: Keys.token)
    }
}
