//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Combine
import Foundation
import InjectPropertyWrapper

protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaListRequest(genreId: genreId)
                return Environment.name == .tv ?
                self.service.fetchTV(req: request) :
                self.service.fetchMovies(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
