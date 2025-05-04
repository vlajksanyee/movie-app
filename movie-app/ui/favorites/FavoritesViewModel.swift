//
//  FavoritesViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol FavoritesViewModelProtocol: ObservableObject {
    var movies: [Movie] { get set }
    func favoriteMovies() async
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MoviesServiceProtocol
        
    func favoriteMovies() async {
        do {
            let request = FavoriteMoviesRequest(account_id: "21958080")
            let movies = try await service.favoriteMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
}
