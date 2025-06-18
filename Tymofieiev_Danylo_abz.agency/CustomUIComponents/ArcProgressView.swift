//
//  ArcProgressView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 17.06.2025.
//

import SwiftUI

struct ArcProgressView: View {
    @State private var isAnimating = false

    var body: some View {
        CircleArc(startAngle: .degrees(0), endAngle: .degrees(270))
            .stroke(Color(asset: Asset.appSecondaryColor), lineWidth: 4)
            .frame(width: 48, height: 48)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

struct CircleArc: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}
