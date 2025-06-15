//
//  EmptyUsersView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct EmptyUsersView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(asset: Asset.noUsersBackground)
            
            Text(L10n.usersEmptyText)
                .typography(.heading1)
            Spacer()
        }
        .padding()
    }
}
