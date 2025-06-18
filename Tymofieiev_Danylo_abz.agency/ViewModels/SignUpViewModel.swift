//
//  SignUpViewModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    // MARK: - Dependencies
    private let repository: SignUpRepositoryProtocol
    
    // MARK: - Input fields
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPositionId: Int?
    @Published var positions: [Position] = []
    @Published var selectedImage: Data?
    
    // MARK: - Upload state
    @Published var isUploading: Bool = false
    @Published var signUpSuccess: Bool = false
    @Published var signUpMessage: String?
    @Published var signUpError: APIError?
    @Published var positionsError: String?
    @Published var isLoadingPositions: Bool = false
    
    // MARK: - Init
    init(repository: SignUpRepositoryProtocol = SignUpRepository()) {
        self.repository = repository
    }
    
    // MARK: - Upload user without retry
    func uploadUser() async {
        guard let selectedPositionId, let image = selectedImage else { return }
        
        isUploading = true
        signUpSuccess = false
        signUpMessage = nil
        signUpError = nil
        
        let userRequest = SignUpRequest(
            name: name,
            email: email,
            phone: phone,
            positionId: selectedPositionId,
            photoData: image
        )
        
        do {
            guard let response = try await repository.signUpUser(userRequest) else { return }
            signUpSuccess = response.success
            signUpMessage = response.message
        } catch {
            signUpError = error as? APIError
            signUpSuccess = false
            signUpMessage = error.localizedDescription
        }
        
        isUploading = false
    }
    
    // MARK: - Retry flow after manual token refresh trigger
    func retryAfterTokenRefresh() async {
        do {
            AppDefaults.token = try await repository.fetchToken()
            signUpError = nil
            await uploadUser()
        } catch {
            signUpError = error as? APIError
            signUpSuccess = false
            signUpMessage = error.localizedDescription
        }
    }
    
    // MARK: - Positions
    func getPositions() async {
        isLoadingPositions = true
        do {
            positions = try await repository.getPositions()
            positionsError = nil
        } catch {
            positionsError = error.localizedDescription
        }
        isLoadingPositions = false
    }
    
    // MARK: - Helpers
    func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedPositionId = nil
        selectedImage = nil
        isUploading = false
        signUpSuccess = false
        signUpMessage = nil
        signUpError = nil
        positionsError = nil
    }
    
    func clearSignUpResultState() {
        signUpSuccess = false
        signUpMessage = nil
        signUpError = nil
    }
    
    var isAnyFieldFilled: Bool {
        !name.isEmpty || !email.isEmpty || !phone.isEmpty || selectedImage != nil || selectedPositionId != nil
    }
    
    var isFormValid: Bool {
        ValidationHelper.validateName(name) == nil &&
        ValidationHelper.validateEmail(email) == nil &&
        ValidationHelper.validatePhone(phone) == nil &&
        ValidationHelper.validatePhoto(selectedImage) == nil &&
        selectedPositionId != nil
    }
}
