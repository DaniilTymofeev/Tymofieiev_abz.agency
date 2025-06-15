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
            case .users:
                Text("Users")
                    .foregroundStyle(.blue)
            case .registration:
                Text("registration")
                    .foregroundStyle(.blue)
            case .noConnection:
                Text("noConnection")
                    .foregroundStyle(.red)
            }
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            coordinator.updateRouteBasedOnConnection(isConnected)
        }
    }
}

