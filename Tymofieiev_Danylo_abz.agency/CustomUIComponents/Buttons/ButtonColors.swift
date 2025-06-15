//
//  ButtonColors.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct ButtonColors {
    let background: Color
    let foreground: Color

    static func colors(for type: ButtonType, state: ButtonState) -> ButtonColors {
        switch (type, state) {
        // Primary buttons - colored pill + colored text
        case (.primary, .normal):
            return ButtonColors(background: Color(asset: Asset.appPrimaryColor), foreground: Color.black.opacity(0.87))
        case (.primary, .pressed):
            return ButtonColors(background: Color(asset: Asset.primaryButtonPressedColor), foreground: Color.black.opacity(0.87))
        case (.primary, .disabled):
            return ButtonColors(background: Color(asset: Asset.primaryButtonDisabledColor), foreground: Color.black.opacity(0.48))
            
        // Secondary buttons
        case (.secondary, .normal):
            return ButtonColors(background: Color.clear, foreground: Color(asset: Asset.secondaryButtonTextDarkColor))
        case (.secondary, .pressed):
            return ButtonColors(background: Color(asset: Asset.secondaryButtonPressedColor), foreground: Color(asset: Asset.secondaryButtonTextDarkColor))
        case (.secondary, .disabled):
            return ButtonColors(background: Color.clear, foreground: Color.black.opacity(0.48))
        }
    }
}
