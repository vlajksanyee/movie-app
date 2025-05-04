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
            if viewModel.movies.isEmpty {
                VStack {
                    Spacer()
                    Text("favorites.empty")
                        .multilineTextAlignment(.center)
                        .font(Fonts.emptyStateText)
                        .foregroundColor(.invertedMain)
                        .navigationTitle("favorites.title")
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: LayoutConst.normalPadding) {
                        ForEach(viewModel.movies) { movie in
                            MovieCell(movie: movie)
                                .frame(height: 277)
                        }
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                    .padding(.top, LayoutConst.normalPadding)
                }
                .navigationTitle("favorites.title")
            }
        }
        .onAppear {
            Task {
                await viewModel.favoriteMovies()
            }
        }
    }
}

#Preview {
    FavoritesView()
}
