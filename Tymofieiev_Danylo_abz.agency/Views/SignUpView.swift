//
//  SignUpView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                TextField("Email", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                
                TextField("Password", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                
                CustomButton(title: "Submit", type: .primary, isDisabled: false) {
                    // Handle action
                }
            }
            .padding()
        }
//        .background(Color(asset: Asset.appBackgroundColor))
        .background(Color.clear)
    }
}
