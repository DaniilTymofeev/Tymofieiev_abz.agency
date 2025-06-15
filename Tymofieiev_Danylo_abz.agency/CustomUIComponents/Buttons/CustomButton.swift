//
//  CustomButton.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let type: ButtonType
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(CustomButtonStyle(type: type, isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}
