//
//  SearchMovieView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 19..
//

import SwiftUI
import InjectPropertyWrapper

protocol SearchMovieViewModelProtocol: ObservableObject {
    
}

class SearchMovieViewModel: SearchMovieViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func loadMovies(by searchText: String) async {
        do {
            let request = SearchMovieRequest(searchText: searchText)
            let movies = try await service.searchMovie(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }

}


struct SearchMovieView: View {
    @StateObject private var viewModel = SearchMovieViewModel()
    @State private var searchText: String = ""

    let columns = [
        GridItem(spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.movies.isEmpty {
                        Text("Kezdj el gépelni a kereséshez").font(.title2)
                    }
                }
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(viewModel.movies) { movie in
                        MovieCellView(movie: movie, cellHeight: 200)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .onChange(of: searchText) {
                Task {
                    await viewModel.loadMovies(by: searchText)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Movies, Director, Actor, Actress, etc.")
    }
}
