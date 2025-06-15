//
//  Typography.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

// MARK: - Typography Styles

enum TypographyStyle {
    case heading1
    case body1
    case body2
    case body3

    var font: Font {
        Font.custom("NunitoSans-Regular", size: fontSize)
    }

    var fontSize: CGFloat {
        switch self {
        case .heading1: return 20
        case .body1: return 16
        case .body2: return 18
        case .body3: return 14
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .heading1, .body1, .body2: return 24
        case .body3: return 20
        }
    }
}

// MARK: - Typography ViewModifier

struct TypographyModifier: ViewModifier {
    let style: TypographyStyle
    let color: Color?

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundStyle(color ?? Color.black.opacity(0.87))
            .lineSpacing(style.lineHeight - style.fontSize)
            .multilineTextAlignment(.leading)
    }
}

// MARK: - View Extension

extension View {
    func typography(_ style: TypographyStyle, color: Color? = nil) -> some View {
        self.modifier(TypographyModifier(style: style, color: color))
    }
}
