//
//  SignUpView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @State private var showPhotoOptions = false
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                CustomTextField(
                    placeholder: "Name",
                    hint: "We'll never share your name.",
                    text: $viewModel.name,
                    validation: { input in
                        if input.isEmpty {
                            return "Name cannot be empty"
                        }
                        return nil
                    }
                )
                
                CustomTextField(
                    placeholder: "Email",
                    hint: "We'll never share your Email.",
                    text: $viewModel.email,
                    validation: { input in
                        if !input.contains("@") && !input.isEmpty {
                            return "Invalid email address"
                        }
                        return nil
                    }
                )
                
                CustomTextField(
                    placeholder: "Phone",
                    hint: "Your phone number.",
                    text: $viewModel.phone,
                    validation: { input in
                        if input.isEmpty {
                            return "Phone cannot be empty"
                        }
                        return nil
                    }
                )
                
                VStack(alignment: .leading) {
                    Text(L10n.selectPositionTitle)
                        .typography(.body2)
                        .padding(.top, 16)
                    
                    if viewModel.isLoadingPositions {
                        CustomProgressView()
                            .scaleEffect(0.5)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)
                    } else {
                        ForEach(viewModel.positions) { position in
                            PositionRow(
                                position: position,
                                isSelected: viewModel.selectedPositionId == position.id,
                                onSelect: {
                                    viewModel.selectedPositionId = position.id
                                }
                            )
                        }
                    }
                    
                    Spacer()
                }
                
                UploadPhotoView(
                    title: L10n.uploadPhotoTitle,
                    hint: "",
                    imageData: $viewModel.selectedImage,
                    onUploadTap: {
                        showPhotoOptions = true
                    },
                    validation: {
                        viewModel.selectedImage == nil ? "Photo required" : nil
                    }
                )
                
                CustomButton(title: L10n.signUp, type: .primary, isDisabled: false) {
                    Task {
                        await viewModel.uploadUser()
                    }
                }
                .confirmationDialog(L10n.photoSelectionTitle, isPresented: $showPhotoOptions, titleVisibility: .visible) {
                    Button(L10n.camera) {
                        imagePickerSource = .camera
                        showImagePicker = true
                    }
                    Button(L10n.gallery) {
                        imagePickerSource = .photoLibrary
                        showImagePicker = true
                    }
                    Button(L10n.cancel, role: .cancel) {}
                }
            }
            .padding()
        }
        .background(Color.clear)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSource) { image in
                if let data = image.jpegData(compressionQuality: 0.8) {
                    viewModel.selectedImage = data
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getPositions()
            }
        }
    }
}
