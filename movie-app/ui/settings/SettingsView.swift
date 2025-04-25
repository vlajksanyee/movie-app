//
//  SettingsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Text("Settings Screen")
                .navigationTitle("settings.title")
        }
    }
}

#Preview {
    SettingsView()
}
