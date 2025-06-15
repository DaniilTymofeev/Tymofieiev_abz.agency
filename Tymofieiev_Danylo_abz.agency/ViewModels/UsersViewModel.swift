//
//  UsersViewModel.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

final class UsersViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var isLoading = false
    @Published var isPaginating = false
    
    private var currentPage = 0
    private let pageSize = 6
    private var canLoadMore = true
    
    let mockUsers: [UserModel] = [
        UserModel(
            id: 26469,
            name: "Alex",
            email: "zaliva59@gmail.com",
            phone: "+380989402060",
            position: "Lawyer",
            positionId: 1,
            registrationTimestamp: 1749895111,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/684d47c71ef7526469.jpg"
        ),
        UserModel(
            id: 1,
            name: "Leanne West",
            email: "onie34@lubowitz.com",
            phone: "+380936050764",
            position: "Content manager",
            positionId: 2,
            registrationTimestamp: 1604494937,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a6596d3bb1.jpeg"
        ),
        UserModel(
            id: 2,
            name: "Ahmad Rodriguez",
            email: "isadore08@zulauf.biz",
            phone: "+380993215621",
            position: "Security",
            positionId: 3,
            registrationTimestamp: 1604494937,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a6596f0072.jpeg"
        ),
        UserModel(
            id: 3,
            name: "Jeromy Schultz",
            email: "gladys74@emmerich.com",
            phone: "+380957332233",
            position: "Security",
            positionId: 3,
            registrationTimestamp: 1604494937,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a659709143.jpeg"
        ),
        UserModel(
            id: 4,
            name: "Lorine Hoppe",
            email: "ozella.block@wiza.com",
            phone: "+380996727011",
            position: "Designer",
            positionId: 4,
            registrationTimestamp: 1604494937,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a65971a714.jpeg"
        ),
        UserModel(
            id: 5,
            name: "Peaches-Honeyblossom-Michelle-Charlotte-Angel-Vanessa",
            email: "peaches.honeyblossom.michelle.charlotte.angel.vanessa@gmail.com",
            phone: "+380672278518",
            position: "Designer",
            positionId: 4,
            registrationTimestamp: 1604494937,
            photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a65972a8f5.jpeg"
        )
    ]

    func loadInitialUsers() {
        currentPage = 0
        canLoadMore = true
        users.removeAll()
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let newUsers = self.mockUsers
            // API call or mock here
            self.users.append(contentsOf: newUsers)
            self.canLoadMore = !newUsers.isEmpty
            self.currentPage += 1
            self.isLoading = false
        }
    }
    
    func loadNextPage() {
        guard !isLoading && !isPaginating && canLoadMore else { return }
        isPaginating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let newUsers = [UserModel]() // API call or mock here
            self.users.append(contentsOf: newUsers)
            self.canLoadMore = !newUsers.isEmpty
            self.currentPage += 1
            self.isPaginating = false
        }
    }
}
