//
//  Tymofieiev_Danylo_abz_agencyApp.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 14.06.2025.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .environmentObject(networkMonitor)
        }
    }
}
