//
//  SignUpView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case name, email, phone
    }
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = SignUpViewModel()
    
    @FocusState private var focusedField: Field?
    
    @State private var showPhotoOptions = false
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showResult = false
    @State private var attempts = 0
    @State private var triggerFormValidation = false
    
    var body: some View {
        ZStack {
            // Background layer to detect taps anywhere to dismiss keyboard
            Color.white
                .ignoresSafeArea()
                .contentShape(Rectangle()) // Makes entire area tappable
                .onTapGesture {
                    focusedField = nil
                }
            
            ScrollView {
                VStack(spacing: 12) {
                    nameField
                    emailField
                    phoneField
                    positionSelector
                    photoUploader
                    signUpButton
                }
                .padding()
            }
        }
        .hideKeyboardOnTap()
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
        .onChange(of: viewModel.signUpMessage) { _, message in
            if message != nil {
                showResult = true
            }
        }
        .fullScreenCover(isPresented: $showResult) {
            SignUpResultView(
                isSuccess: viewModel.signUpSuccess,
                message: viewModel.signUpMessage ?? L10n.somethingWentWrong,
                onClose: {
                    showResult = false
                    if !viewModel.signUpSuccess {
                        viewModel.clearSignUpResultState()
                    }
                },
                onMainAction: {
                    showResult = false
                    if viewModel.signUpSuccess {
                        viewModel.resetForm()
                        coordinator.selectedTab = .users
                        viewModel.clearSignUpResultState()
                        return
                    }
                    
                    Task {
                        if viewModel.signUpError == .tokenExpired {
                            await viewModel.retryAfterTokenRefresh()
                        } else {
                            await viewModel.uploadUser()
                        }
                        
                        if viewModel.signUpSuccess {
                            viewModel.resetForm()
                            coordinator.selectedTab = .users
                        } else {
                            showResult = true
                        }
                        
                        viewModel.clearSignUpResultState()
                    }
                }
            )
        }
    }
    
    private func triggerErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Extracted Subviews

private extension SignUpView {
    var nameField: some View {
        CustomTextField(
            id: Field.name,
            placeholder: L10n.namePlaceholder,
            hint: "",
            keyboardType: .default,
            textInputAutocapitalization: .sentences,
            text: $viewModel.name,
            validation: { _ in ValidationHelper.validateName(viewModel.name) },
            triggerValidation: $triggerFormValidation,
            focusedField: $focusedField,
            onSubmit: {
                focusedField = .email
            }
        )
    }
    
    var emailField: some View {
        CustomTextField(
            id: Field.email,
            placeholder: L10n.email,
            hint: "",
            keyboardType: .emailAddress,
            textInputAutocapitalization: .never,
            text: $viewModel.email,
            validation: { _ in ValidationHelper.validateEmail(viewModel.email) },
            triggerValidation: $triggerFormValidation,
            focusedField: $focusedField,
            onSubmit: {
                focusedField = .phone
            }
        )
    }
    
    var phoneField: some View {
        CustomTextField(
            id: Field.phone,
            placeholder: L10n.phone,
            hint: L10n.phoneFormatHint,
            keyboardType: .phonePad,
            textInputAutocapitalization: .never,
            text: $viewModel.phone,
            validation: { _ in ValidationHelper.validatePhone(viewModel.phone) },
            triggerValidation: $triggerFormValidation,
            focusedField: $focusedField
            // No onSubmit here since it's the last field
        )
    }
    
    var positionSelector: some View {
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
        }
    }
    
    var photoUploader: some View {
        UploadPhotoView(
            title: L10n.uploadPhotoTitle,
            hint: "",
            imageData: $viewModel.selectedImage,
            onUploadTap: {
                showPhotoOptions = true
            },
            validation: {
                viewModel.selectedImage == nil ? L10n.photoRequired : nil
            },
            triggerValidation: $triggerFormValidation
        )
    }
    
    var signUpButton: some View {
        CustomButton(
            title: L10n.signUp,
            type: .primary,
            isDisabled: !viewModel.isAnyFieldFilled
        ) {
            triggerFormValidation = true
            DispatchQueue.main.async {
                triggerFormValidation = false
            }
            if viewModel.isFormValid {
                viewModel.clearSignUpResultState()
                Task {
                    await viewModel.uploadUser()
                }
            } else {
                triggerErrorHaptic()
                withAnimation(.default) {
                    attempts += 1
                }
            }
        }
        .shake(animatableData: CGFloat(attempts))
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
}

extension View {
    /// Dismiss keyboard when tapping anywhere in the view hierarchy,
    /// but still allow taps to pass through.
    func hideKeyboardOnTap() -> some View {
        self
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
    }
}
