//
//  PositionRow.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

struct PositionRow: View {
    let position: Position
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            CustomRadioButton(isSelected: isSelected)
            Text(position.name)
                .typography(.body1)
                .padding(.leading, 8)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .contentShape(Rectangle()) // Makes full row tappable
        .onTapGesture {
            onSelect()
        }
    }
}
