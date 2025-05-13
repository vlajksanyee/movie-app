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
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: MediaDetailsView(media: movie)) {
                        MovieCell(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
