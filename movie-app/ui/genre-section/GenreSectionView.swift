//
//  ContentView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    
    var body: some View {
        NavigationView {
            List {
                if let recommended = viewModel.recommended {
                    GenreMotdCell(mediaItem: recommended)
                        .background(Color.clear)
                        .listStyle(.plain)
                }
                ForEach(viewModel.genres) { genre in
                    VStack(alignment: .leading) {
                        ZStack {
                            NavigationLink(destination: MediaItemListView(genre: genre)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            let mediaItems = viewModel.getMediaItemsByGenre(genre.id)
                            MediaItemListByGenre(genre: genre, mediaItems: mediaItems)
                                .onAppear {
                                    if viewModel.mediaItemsByGenre[genre.id] == nil {
                                        viewModel.loadMediaItems(genreId: genre.id)
                                    }
                                }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title".localized())
            .accessibilityLabel(AccessibilityLabels.genreSectionCollectionView)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.loadGenres()
            viewModel.genresAppeared()
        }
    }
}

#Preview {
    GenreSectionView()
}
