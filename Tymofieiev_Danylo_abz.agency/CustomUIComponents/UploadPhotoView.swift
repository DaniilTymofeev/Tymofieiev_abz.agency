//
//  UploadPhotoView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

struct UploadPhotoView: View {
    enum FieldState {
        case normal
        case error(String)
    }

    let title: String
    let hint: String
    let imageData: Binding<Data?>
    let onUploadTap: () -> Void
    let validation: () -> String?

    @State private var fieldState: FieldState = .normal

    private var currentBorderColor: Color {
        switch fieldState {
        case .normal: return Color(asset: Asset.textFieldGrayColor)
        case .error: return Color(asset: Asset.textFieldRedColor)
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
        default: return .black.opacity(0.6)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(currentBorderColor, lineWidth: 1)
                    .background(Color(asset: Asset.appBackgroundColor))
                    .frame(height: 56)

                HStack {
                    if let imageData = imageData.wrappedValue,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.leading, 16)
                    } else {
                        Text(title)
                            .typography(.body1, color: currentBorderColor)
                            .padding(.leading, 16)
                    }

                    Spacer()

                    Button(action: onUploadTap) {
                        Text(imageData.wrappedValue == nil ? L10n.upload : L10n.replace)
                            .font(Font.custom("NunitoSans-Semibold", size: 16))
                            .foregroundStyle(Color(asset: Asset.appSecondaryColor))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 8)
                }
            }

            Text(currentHintText)
                .font(Font.custom("NunitoSans-Regular", size: 12))
                .foregroundColor(currentHintColor)
                .padding(.horizontal, 16)
        }
        .onAppear {
            updateFieldState()
        }
        .onChange(of: imageData.wrappedValue) {
            updateFieldState()
        }
    }

    private func updateFieldState() {
        if let error = validation() {
            fieldState = .error(error)
        } else {
            fieldState = .normal
        }
    }
}
