//
//  FavoritesView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Text("Favorites Screen")
                .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
