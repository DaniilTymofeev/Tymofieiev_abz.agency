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
            if viewModel.users.isEmpty && !viewModel.isLoading {
                EmptyUsersView()
            } else {
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

                    // Loader at the bottom when paginating
                    if viewModel.isPaginating {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
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

            // Loader covering whole screen during initial load
            if viewModel.isLoading && viewModel.users.isEmpty {
                Color(asset: Asset.appBackgroundColor).opacity(0.8)
                    .ignoresSafeArea()

                CustomProgressView()
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
