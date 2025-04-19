//
//  ContentView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ?
                try await movieService.fetchTVGenres(req: request) :
                try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        TabView {
            // Genres
            NavigationView {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 400, height: 400)
                        .position(x: 375, y: -150)
                    List(viewModel.genres) { genre in
                        ZStack {
                            NavigationLink(destination: MovieListView(genre: genre)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            HStack {
                                Text(genre.name)
                                    .font(Fonts.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(.rightArrow)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle(Environment.name == .dev ? "DEV" : Environment.name == .prod ? "PROD" : "TV")
                }
            }
            .tabItem {
                Label("Genres", systemImage: "list.bullet")
            }
            .onAppear {
                Task {
                    await viewModel.fetchGenres()
                }
            }
            // Search
            SearchMovieView()
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
