//
//  AppCoordinator.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import Combine
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    enum Route {
        case splash
        case users
        case registration
        case noConnection
    }

    @Published var route: Route = .splash
    private var lastValidRoute: Route = .splash

    func updateRouteBasedOnConnection(_ isConnected: Bool) {
        if isConnected {
            if route == .noConnection {
                route = lastValidRoute
            }
        } else {
            if route != .noConnection {
                lastValidRoute = route
                route = .noConnection
            }
        }
    }

    func proceedAfterSplash(connected: Bool) {
        if connected {
            route = .users
            lastValidRoute = .users
        } else {
            route = .noConnection
        }
    }

    func goToRegistration() {
        route = .registration
        lastValidRoute = .registration
    }
}


