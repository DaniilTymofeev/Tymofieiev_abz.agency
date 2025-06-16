//
//  CustomTextField.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

struct CustomTextField: View {
    enum FieldState {
        case normal
        case focused
        case error(String)
    }

    let placeholder: String
    let hint: String
    @Binding var text: String
    let validation: (String) -> String? // returns error message or nil

    @FocusState private var isFocused: Bool
    @State private var showMiniLabel: Bool = false
    @State private var fieldState: FieldState = .normal
    @State private var wasFocusedAtLeastOnce: Bool = false
    @State private var isTyping: Bool = false

    private var currentBorderColor: Color {
        switch fieldState {
        case .normal: return Color(asset: Asset.textFieldGrayColor)
        case .focused: return Color(asset: Asset.appSecondaryColor)
        case .error: return Color(asset: Asset.textFieldRedColor)
        }
    }

    private var currentMiniLabelColor: Color {
        switch fieldState {
        case .focused: return !text.isEmpty ? Color(asset: Asset.textFieldFocusedFilledMiniLabelColor) : Color(asset: Asset.appSecondaryColor)
        case .error: return Color(asset: Asset.textFieldRedColor)
        default: return .black.opacity(0.6)
        }
    }

    private var currentHintText: String {
        switch fieldState {
        case .error(let errorMessage): return errorMessage
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
                                .typography(.body1, color: isFocused ? Color(asset: Asset.appBackgroundColor) : .black.opacity(0.48))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 32)
                                .padding(.horizontal, 16)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }

                        TextField("", text: $text)
                            .focused($isFocused)
                            .typography(.body1)
                            .frame(height: 32)
                            .padding(.horizontal, 16)
                            .frame(maxHeight: .infinity, alignment: showMiniLabel ? .top : .center)
                            .background(Color.clear)
                            .padding(.bottom, showMiniLabel ? 8 : 0)
                            .onChange(of: text) { oldValue, newValue in
                                isTyping = true
                                showMiniLabel = isFocused || !newValue.isEmpty
                                fieldState = .focused

                                // Schedule a delay to detect end of typing
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
        .onChange(of: isFocused) { oldValue, focused in
            showMiniLabel = focused || !text.isEmpty
            if focused {
                wasFocusedAtLeastOnce = true
            }
            updateFieldState()
        }
    }

    private func updateFieldState() {
        if let error = validation(text), wasFocusedAtLeastOnce, !isTyping {
            fieldState = .error(error)
        } else if isFocused {
            fieldState = .focused
        } else {
            fieldState = .normal
        }
    }
}
