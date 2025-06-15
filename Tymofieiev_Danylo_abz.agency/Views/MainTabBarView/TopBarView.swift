//
//  TopBarView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 15.06.2025.
//

import SwiftUI

struct TopBarView: View {
    let title: String

    var body: some View {
        ZStack {
            Color(asset: Asset.appPrimaryColor)
                .frame(height: 56)
            
            Text(title)
                .typography(.heading1, color: Color(asset: Asset.topBarTitleColor))
        }
    }
}
