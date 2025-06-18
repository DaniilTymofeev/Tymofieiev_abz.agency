//
//  SignUpResultView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 18.06.2025.
//

import SwiftUI

struct SignUpResultView: View {
    let isSuccess: Bool
    let message: String
    let onClose: () -> Void
    let onMainAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(asset: Asset.appBackgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Image(asset: isSuccess ? Asset.registrationSuccess : Asset.registrationFailed)
                
                Text(message)
                    .font(Font.custom("NunitoSans-Regular", size: 20))
                    .foregroundStyle(.black.opacity(0.87))
                    .multilineTextAlignment(.center) // to apply, chose not to use typography
                
                CustomButton(title: isSuccess ? L10n.gotIt : L10n.tryAgain, type: .primary, isDisabled: false, action: onMainAction)
                
                Spacer()
            }
            .padding(.horizontal, 54)
            
            HStack {
                Spacer()
                
                Button(action: onClose) {
                    Image(asset: Asset.closeButtonCrossIcon)
                        .padding(16)
                }
            }
        }
    }
}
