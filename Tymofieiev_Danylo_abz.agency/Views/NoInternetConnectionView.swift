//
//  NoInternetConnectionView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct NoInternetConnectionView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color(asset: Asset.appBackgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(asset: Asset.noInternetConnection)
                Text(L10n.noConnectionTitle)
                    .foregroundStyle(.black)
                    .font(AppFonts.nunitoRegular(size: 20))
                Button(L10n.tryAgain) {
                    if networkMonitor.isConnected {
                        coordinator.tryReconnect()
                    } else {
                        showAlert = true
                    }
                }
                .foregroundStyle(.black)
            }
        }
        .alert(L10n.stillNoConnection, isPresented: $showAlert) {
            Button(L10n.gotIt, role: .cancel) { }
        }
    }
}
