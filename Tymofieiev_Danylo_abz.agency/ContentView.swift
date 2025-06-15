//
//  ContentView.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 14.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Gayle Weimann").font(AppFonts.nunitoRegular(size: 18))
            Text("Gayle Weimann").font(AppFonts.nunitoSemiBold(size: 18))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
