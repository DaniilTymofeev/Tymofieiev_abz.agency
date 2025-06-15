//
//  CustomButtonStyle.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let type: ButtonType
    let isDisabled: Bool
    private let primaryFont = Font.custom("NunitoSans-SemiBold", size: 16)
    private let secondaryFont = Font.custom("NunitoSans-SemiBold", size: 16)

    func makeBody(configuration: Configuration) -> some View {
        // Determine button state:
        let state: ButtonState = isDisabled ? .disabled : (configuration.isPressed ? .pressed : .normal)
        let colors = ButtonColors.colors(for: type, state: state)

        return configuration.label
            .font(type == .primary ? primaryFont : secondaryFont)
            .foregroundColor(colors.foreground)
            .padding(.vertical, 12)
            .padding(.horizontal, type == .primary ? 37 : (state == .pressed ? 16 : 0))
            .background(
                (type == .primary || (type == .secondary && state == .pressed))
                    ? colors.background
                    : Color.clear
            )
            .clipShape(Capsule())
            .opacity(isDisabled ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
