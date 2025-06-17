//
//  SplashScreen.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var networkMonitor: NetworkMonitor
    private let repository: SignUpRepositoryProtocol = SignUpRepository()

    var body: some View {
        ZStack {
            Color(asset: Asset.appBackgroundColor)
                .ignoresSafeArea()

            CustomProgressView()
        }
        .task {
            if AppDefaults.token == nil {
                do {
                    let token = try await repository.fetchToken()
                    AppDefaults.token = token
                    print("Token saved: \(token)")
                } catch {
                    print("Failed to fetch token:", error)
                }
            } else {
                print("ℹ️ Token already exists")
            }
            
            coordinator.proceedAfterSplash(isConnected: networkMonitor.isConnected)
        }
    }
}
