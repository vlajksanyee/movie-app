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
            if viewModel.mediaItems.isEmpty {
                VStack {
                    Spacer()
                    Text("favorites.empty".localized())
                        .multilineTextAlignment(.center)
                        .font(Fonts.emptyStateText)
                        .foregroundColor(.invertedMain)
                        .navigationTitle("favorites.title".localized())
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: LayoutConst.normalPadding) {
                        ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                            let movie = viewModel.mediaItems[index]
                            NavigationLink(destination: MediaDetailsView(mediaItem: movie)) {
                                MediaItemCell(mediaItem: movie)
                                    .frame(height: 277)
                            }
                            .accessibilityLabel("MediaItem\(index)")
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                    .padding(.top, LayoutConst.normalPadding)
                }
                .navigationTitle("favorites.title".localized())
                .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}

#Preview {
    FavoritesView()
}
