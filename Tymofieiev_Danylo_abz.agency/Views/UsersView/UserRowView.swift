//
//  UserRowView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct UserRowView: View {
    let user: UserModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: URL(string: user.photo)) { image in
                    image.resizable()
                    image.scaledToFit()
                } placeholder: {
                    Image(asset: Asset.noAvatarCover)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .typography(.body2)
                    
                    Text(user.position)
                        .typography(.body3, color: Color.black.opacity(0.6))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.email)
                            .typography(.body3)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        Text(user.phone)
                            .typography(.body3)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)

            // Separator
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.leading, 82) // aligns with text (50 img + 16 spacing + 16 inner margin)
        }
        .background(Color(asset: Asset.appBackgroundColor))
    }
}
