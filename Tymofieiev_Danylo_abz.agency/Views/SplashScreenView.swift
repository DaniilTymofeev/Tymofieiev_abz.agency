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
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color(asset: Asset.appBackgroundColor)
                .ignoresSafeArea()
            
            CustomProgressView()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {// artificial delay to show SplashScreen
                isLoading = false
                coordinator.proceedAfterSplash(isConnected: networkMonitor.isConnected)
            }
        }
    }
}
