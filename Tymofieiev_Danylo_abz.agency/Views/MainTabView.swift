//
//  MainTabView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: coordinator.selectedTab == .users ? L10n.topBarTitleGet : L10n.topBarTitlePost)

            ZStack {
                switch coordinator.selectedTab {
                case .users:
                    UsersView()
                case .signUp:
                    SignUpView()
                }
            }
            .background(Color(asset: Asset.appBackgroundColor))

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .ignoresSafeArea(edges: .horizontal)

            CustomTabBar(selectedTab: $coordinator.selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color(asset: Asset.appBackgroundColor).ignoresSafeArea())
    }
}

