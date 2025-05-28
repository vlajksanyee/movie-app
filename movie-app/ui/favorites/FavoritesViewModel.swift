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
    var mediaItems: [MediaItem] { get set }
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    init() {
        
        viewLoaded
            .flatMap { [weak self] _ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self else {
                    preconditionFailure("There is no self")
                }
                return self.repository.fetchFavoriteMovies(req: FetchFavoriteMoviesRequest(), fromLocal: false)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]mediaItems in
                self?.mediaItems = mediaItems
            }
            .store(in: &cancellables)
    }
}
