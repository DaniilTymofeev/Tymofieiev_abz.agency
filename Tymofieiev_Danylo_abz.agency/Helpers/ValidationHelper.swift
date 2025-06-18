//
//  ValidationHelper.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 18.06.2025.
//

import Foundation
import UIKit

enum ValidationHelper {
    static func validateName(_ name: String) -> String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 || name.count > 60 {
            return L10n.invalidName
        }
        return nil
    }
    
    static func validateEmail(_ email: String) -> String? {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(email.startIndex..., in: email)
        if regex?.firstMatch(in: email, options: [], range: range) == nil {
            return L10n.invalidEmail
        }
        return nil
    }
    
    static func validatePhone(_ phone: String) -> String? {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"^\+380\d{9}$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(trimmed.startIndex..., in: trimmed)
        if regex?.firstMatch(in: trimmed, options: [], range: range) == nil {
            return L10n.invalidPhone
        }
        return nil
    }
    
    static func validatePhoto(_ data: Data?) -> String? {
        guard let data = data else {
            return L10n.photoRequired
        }
        
        // Check size (max 5 MB)
        let maxSizeMB = 5.0
        let sizeMB = Double(data.count) / 1024.0 / 1024.0
        if sizeMB > maxSizeMB {
            return L10n.invalidPhotoSize
        }
        
        // Check image format (only jpg/jpeg)
        if let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
           let uti = CGImageSourceGetType(imageSource),
           let utiString = uti as String?,
           !(utiString.lowercased().contains("jpeg") || utiString.lowercased().contains("jpg")) {
            return L10n.invalidPhotoFormat
        }
        
        // Check dimensions (min 70x70)
        if let image = UIImage(data: data) {
            if image.size.width < 70 || image.size.height < 70 {
                return L10n.invalidPhotoDimension
            }
        }
        
        return nil
    }
}
