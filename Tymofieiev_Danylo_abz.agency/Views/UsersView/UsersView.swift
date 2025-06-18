//
//  UsersView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        ZStack {
            Color.clear
                .background(Color(asset: Asset.appBackgroundColor))
                .ignoresSafeArea()
            // Show list only when there are users
            if !viewModel.users.isEmpty {
                List {
                    ForEach(viewModel.users) { user in
                        UserRowView(user: user)
                            .onAppear {
                                if user == viewModel.users.last {
                                    Task {
                                        await viewModel.loadNextPage()
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color(asset: Asset.appBackgroundColor))
                            .listRowInsets(EdgeInsets())
                    }
                    
                    if viewModel.isPaginating {
                        HStack {
                            Spacer()
                            ArcProgressView()
                                .padding(8)
                                .background(Color(asset: Asset.appBackgroundColor))
                                .clipShape(Circle())
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(asset: Asset.appBackgroundColor))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Show empty view only if not loading AND no users
            if viewModel.showEmptyView {
                EmptyUsersView()
            }
            
            // Show fullscreen loader on top during initial load
            if viewModel.isInitialLoading {
                ZStack {
                    Color(asset: Asset.appBackgroundColor)
                        .opacity(0.85)
                        .ignoresSafeArea()
                    CustomProgressView()
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInitialUsers()
            }
        }
        .background(Color(asset: Asset.appBackgroundColor))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(asset: Asset.appBackgroundColor), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
