//
//  CustomTextField.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

struct CustomTextField<ID: Hashable>: View {
    enum FieldState {
        case normal
        case focused
        case error(String)
    }
    
    let id: ID
    let placeholder: String
    let hint: String
    let keyboardType: UIKeyboardType
    let textInputAutocapitalization: TextInputAutocapitalization
    @Binding var text: String
    let validation: (String) -> String?
    @Binding var triggerValidation: Bool
    @FocusState.Binding var focusedField: ID?
    
    var onSubmit: (() -> Void)? = nil
    
    @State private var showMiniLabel: Bool = false
    @State private var fieldState: FieldState = .normal
    @State private var wasFocusedAtLeastOnce: Bool = false
    @State private var isTyping: Bool = false
    
    private var isFocused: Bool {
        focusedField == id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(currentBorderColor, lineWidth: 1)
                    .background(Color(asset: Asset.appBackgroundColor))
                    .frame(height: 56)
                
                VStack(alignment: .leading, spacing: showMiniLabel ? 2 : 0) {
                    if showMiniLabel {
                        Text(placeholder)
                            .font(Font.custom("NunitoSans-Regular", size: 12))
                            .foregroundColor(currentMiniLabelColor)
                            .padding(.top, 8)
                            .padding(.horizontal, 16)
                    }
                    
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .typography(.body1, color: fieldStateColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 32)
                                .padding(.horizontal, 16)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                        
                        TextField("", text: $text)
                            .focused($focusedField, equals: id)
                            .typography(.body1)
                            .accentColor(Color.black.opacity(0.87))
                            .frame(height: 32)
                            .padding(.horizontal, 16)
                            .frame(maxHeight: .infinity, alignment: showMiniLabel ? .top : .center)
                            .background(Color.clear)
                            .keyboardType(keyboardType)
                            .textInputAutocapitalization(textInputAutocapitalization)
                            .autocapitalization(.none)
                            .submitLabel(.next)
                            .onSubmit {
                                onSubmit?()
                            }
                            .padding(.bottom, showMiniLabel ? 8 : 0)
                            .onChange(of: text) { _, newValue in
                                isTyping = true
                                showMiniLabel = isFocused || !newValue.isEmpty
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    if text == newValue {
                                        isTyping = false
                                        updateFieldState()
                                    }
                                }
                            }
                    }
                    .frame(height: 32)
                    .frame(maxHeight: .infinity)
                }
                .frame(height: 56)
            }
            
            Text(currentHintText)
                .font(Font.custom("NunitoSans-Regular", size: 12))
                .foregroundColor(currentHintColor)
                .padding(.horizontal, 16)
        }
        .onChange(of: focusedField) { _, _ in
            showMiniLabel = isFocused || !text.isEmpty
            if isFocused {
                wasFocusedAtLeastOnce = true
            }
            updateFieldState()
        }
        .onChange(of: triggerValidation) { _, newValue in
            if newValue {
                wasFocusedAtLeastOnce = true
                updateFieldState()
            }
        }
        .onAppear {
            showMiniLabel = !text.isEmpty
        }
    }
    
    private var currentBorderColor: Color {
        switch fieldState {
        case .normal: return Color(asset: Asset.textFieldGrayColor)
        case .focused: return Color(asset: Asset.appSecondaryColor)
        case .error: return Color(asset: Asset.textFieldRedColor)
        }
    }
    
    private var currentMiniLabelColor: Color {
        switch fieldState {
        case .focused:
            return !text.isEmpty ? Color(asset: Asset.textFieldFocusedFilledMiniLabelColor) : Color(asset: Asset.appSecondaryColor)
        case .error:
            return Color(asset: Asset.textFieldRedColor)
        default:
            return .black.opacity(0.6)
        }
    }
    
    private var currentHintText: String {
        switch fieldState {
        case .error(let message): return message
        default: return hint
        }
    }
    
    private var currentHintColor: Color {
        switch fieldState {
        case .error: return Color(asset: Asset.textFieldRedColor)
        case .focused: return .black.opacity(0.6)
        default: return .black.opacity(0.6)
        }
    }
    
    private var fieldStateColor: Color {
        switch fieldState {
        case .error: return Color(asset: Asset.textFieldRedColor)
        case .focused: return Color(asset: Asset.appBackgroundColor)
        default: return .black.opacity(0.48)
        }
    }
    
    private func updateFieldState() {
        if isTyping {
            fieldState = .focused
            return
        }
        
        if isFocused {
            fieldState = .focused
        } else if wasFocusedAtLeastOnce, let error = validation(text) {
            fieldState = .error(error)
        } else {
            fieldState = .normal
        }
    }
}
