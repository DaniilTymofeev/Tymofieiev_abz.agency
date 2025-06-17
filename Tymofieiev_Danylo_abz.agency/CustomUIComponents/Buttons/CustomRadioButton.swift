//
//  CustomRadioButton.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

struct CustomRadioButton: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            // Outer ring — always shown
            Circle()
                .strokeBorder(
                    isSelected ? Color(asset: Asset.appSecondaryColor) : Color(asset: Asset.textFieldGrayColor),
                    lineWidth: isSelected ? 4 : 1
                )
                .frame(width: 14, height: 14)

            // Inner shadow on selection (subtle dispersion)
            if isSelected {
                Circle()
                    .stroke(Color.black.opacity(0.16), lineWidth: 1)
                    .blur(radius: 2)
                    .clipShape(Circle())
                    .frame(width: 14, height: 14)
            }
        }
        .frame(width: 14, height: 14)
    }
}
