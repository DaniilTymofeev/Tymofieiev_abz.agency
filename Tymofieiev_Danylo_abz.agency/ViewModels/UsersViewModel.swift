//
//  UsersViewModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var isLoading = false          // general loading state
    @Published var isInitialLoading = false   // true only during first initial load
    @Published var isPaginating = false
    @Published var errorMessage: String?
    @Published var showEmptyView = false      // Used to control when EmptyUsersView is shown
    
    private var currentPage = 1
    private let pageSize = 6
    private var totalPages: Int?
    private var canLoadMore: Bool {
        totalPages == nil || currentPage <= totalPages!
    }
    
    func loadInitialUsers() async {
        currentPage = 1
        totalPages = nil
        users = []
        errorMessage = nil
        isLoading = true
        isInitialLoading = true
        showEmptyView = false
        
        do {
            let endpoint = APIEndpoint.getUsers(page: currentPage, count: pageSize)
            let response = try await NetworkManager.shared.request(endpoint: endpoint, responseType: UsersResponse.self)
            self.users = response.users
            self.totalPages = response.totalPages
            self.currentPage += 1
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoading = false
        isInitialLoading = false
        
        // ⏱ Delay showing empty view to avoid flicker
        evaluateEmptyState()
    }
    
    func loadNextPage() async {
        guard !isPaginating && canLoadMore else { return }
        
        isPaginating = true
        errorMessage = nil
        
        do {
            let endpoint = APIEndpoint.getUsers(page: currentPage, count: pageSize)
            let response = try await NetworkManager.shared.request(endpoint: endpoint, responseType: UsersResponse.self)
            self.users += response.users
            self.currentPage += 1
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        
        isPaginating = false
    }
    
    private func evaluateEmptyState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.showEmptyView = !self.isInitialLoading && self.users.isEmpty
        }
    }
}
