//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
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
