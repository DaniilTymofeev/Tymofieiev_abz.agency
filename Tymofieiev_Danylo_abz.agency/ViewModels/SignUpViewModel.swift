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
    @Published var uploadSuccess: Bool = false
    @Published var uploadError: String?
    @Published var positionsError: String?
    @Published var isLoadingPositions: Bool = false

    // MARK: - Init
    init(repository: SignUpRepositoryProtocol = SignUpRepository()) {
        self.repository = repository
    }

    // MARK: - Actions
    func uploadUser() async {
        guard let selectedPositionId, let image = selectedImage else {
            uploadError = "Please fill all fields and select a photo"
            return
        }

        isUploading = true
        uploadError = nil
        uploadSuccess = false
        
        let userRequest = SignUpRequest(name: name, email: email, phone: phone, positionId: selectedPositionId, photoData: image)

        do {
            try await repository.signUpUser(userRequest)
            uploadSuccess = true
        } catch {
            uploadError = error.localizedDescription
        }

        isUploading = false
    }
    
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
}
