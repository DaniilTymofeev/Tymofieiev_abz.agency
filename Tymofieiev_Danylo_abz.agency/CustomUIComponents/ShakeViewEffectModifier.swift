//
//  ButtonShakeEffectModifier.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 18.06.2025.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX:
                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                              y: 0)
        )
    }
}

extension View {
    func shake(animatableData: CGFloat) -> some View {
        self.modifier(ShakeEffect(animatableData: animatableData))
    }
}
