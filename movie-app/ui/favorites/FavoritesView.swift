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
                            NavigationLink(destination: MediaDetailsView(media: movie)) {
                                MovieCell(movie: movie)
                                    .frame(height: 277)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                    .padding(.top, LayoutConst.normalPadding)
                }
                .navigationTitle("favorites.title")
            }
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    FavoritesView()
}
