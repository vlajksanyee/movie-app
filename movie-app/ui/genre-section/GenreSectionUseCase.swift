//
//  GenreSectionUseCase.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 27..
//

import InjectPropertyWrapper
import Combine

protocol GenreSectionUseCase {
    var showAppearPopup: AnyPublisher<Bool, Never> { get }
    func loadGenres() -> AnyPublisher<[Genre], MovieError>
    func genresAppeared()
    func loadMediaItems(genreId: Int) -> AnyPublisher<MediaItemPage, MovieError>
    func loadMotdMovie(movie: MediaItem) -> AnyPublisher<MediaItemDetail, MovieError>
}

class GenreSectionUseCaseImpl: GenreSectionUseCase {
    
    @Inject
    private var repository: MovieRepository
    
    private var appearCounter = 0
    
    private var appearSubject = CurrentValueSubject<Int, Never>(0)
    
    var showAppearPopup: AnyPublisher<Bool, Never> {
        appearSubject.map { counter in
            counter == 3
        }
        .eraseToAnyPublisher()
    }
    
    func loadGenres() -> AnyPublisher<[Genre], MovieError> {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.repository.fetchTVGenres(req: request) :
        self.repository.fetchGenres(req: request)
        
        return genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .eraseToAnyPublisher()
    }
    
    func genresAppeared() {
        appearCounter += 1
        appearSubject.send(appearCounter)
    }
    
    func loadMediaItems(genreId: Int) -> AnyPublisher<MediaItemPage, MovieError> {
        let request = FetchMediaListRequest(genreId: genreId, includeAdult: true, page: 1)
//        return Environments.name == .tv ?
//        self.repository.fetchTV(req: request) :
        return self.repository.fetchMovies(req: request)
    }
    
    func loadMotdMovie(movie: MediaItem) -> AnyPublisher<MediaItemDetail, MovieError> {
        let request = FetchDetailsRequest(mediaId: movie.id)
        let detailMediaItem = self.repository.fetchDetails(req: request)
        
        return detailMediaItem
    }
}
