//
//  RootView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {
        Group {
            switch coordinator.route {
            case .splash:
                SplashScreenView()
            case .mainTabs:
                MainTabView()
            case .noConnection:
                NoInternetConnectionView()
            }
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            if !isConnected {
                coordinator.updateRouteBasedOnConnection(false)
            }
        }
    }
}
