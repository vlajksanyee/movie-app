//
//  MovieListView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct MediaItemListView: View {
    @StateObject private var viewModel = MediaItemListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: LayoutConst.normalPadding)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                    let mediaItem = viewModel.mediaItems[index]
                    NavigationLink(destination: MediaDetailsView(mediaItem: mediaItem)) {
                        MediaItemCell(mediaItem: mediaItem)
                            .onAppear {
                                if index == viewModel.mediaItems.count - 1 {
                                    viewModel.genreIdSubject.send(genre.id)
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle(genre.name)
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
        .refreshable {
            viewModel.refreshSubject.send()
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    MediaItemListView(genre: Genre(id: 28, name: "Action") )
}
