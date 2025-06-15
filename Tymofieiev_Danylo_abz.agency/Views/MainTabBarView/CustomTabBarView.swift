//
//  CustomTabBarView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            tabBarItem(tab: .users)
            tabBarItem(tab: .signUp)
        }
        .frame(maxWidth: .infinity)
        .background(Color.secondary)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private func tabBarItem(tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }, label: {
            HStack(spacing: 8) {
                tab.icon
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == tab ? Color(asset: Asset.appSecondaryColor) : Color.black.opacity(0.6))
                    .animation(.easeInOut(duration: 0.1), value: selectedTab)
                Text(tab.title)
                    .foregroundColor(selectedTab == tab ? Color(asset: Asset.appSecondaryColor) : Color.black.opacity(0.6))
                    .font(Font.custom("NunitoSans-SemiBold", size: 16))
                    .animation(.easeInOut(duration: 0.1), value: selectedTab)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        })
        .buttonStyle(PlainButtonStyle())
    }
}
