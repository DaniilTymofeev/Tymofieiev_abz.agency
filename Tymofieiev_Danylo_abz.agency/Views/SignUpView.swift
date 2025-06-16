//
//  SignUpView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct SignUpView: View {
    @State var name = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                CustomTextField(
                    placeholder: "Name",
                    hint: "We'll never share your namel.",
                    text: $name,
                    validation: { input in
                        if !input.contains("@") && !input.isEmpty {
                            return "Invalid email address"
                        }
                        return nil
                    }
                )
                CustomTextField(
                    placeholder: "Email",
                    hint: "We'll never share your Email.",
                    text: $name,
                    validation: { input in
                        if !input.contains("@") && !input.isEmpty {
                            return "Invalid email address"
                        }
                        return nil
                    }
                )
                
                CustomButton(title: "Submit", type: .primary, isDisabled: false) {
                    // Handle action
                }
            }
            .padding()
        }
        .background(Color.clear)
    }
}
