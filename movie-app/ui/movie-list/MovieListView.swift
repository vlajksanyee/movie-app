//
//  MovieListView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: LayoutConst.normalPadding)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                    return NavigationLink(destination: MediaDetailsView(media: movie)) {
                        MovieCell(movie: movie)
                    }
                    .onAppear {
                        if index == viewModel.movies.count - 1 {
                            viewModel.genreIdSubject.send(genre.id)
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
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
