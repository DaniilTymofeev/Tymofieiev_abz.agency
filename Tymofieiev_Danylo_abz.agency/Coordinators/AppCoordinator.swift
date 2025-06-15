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
        case mainTabs
        case noConnection
    }

    @Published var route: Route = .splash
    private var lastValidRoute: Route = .splash
    private var didFinishInitialRouting = false

    func updateRouteBasedOnConnection(_ isConnected: Bool) {
        guard didFinishInitialRouting else { return }
        
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

    func proceedAfterSplash(isConnected: Bool) {
        if !isConnected {
            if route != .noConnection {
                lastValidRoute = route
                route = .noConnection
            }
        } else {
            route = .mainTabs
            lastValidRoute = .mainTabs
        }
        didFinishInitialRouting = true
    }
    
    func tryReconnect() {
        if lastValidRoute != .noConnection {
            route = lastValidRoute
        } else {
            route = .mainTabs
        }
    }
}
