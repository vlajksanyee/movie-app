//
//  ReactiveMovieService.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine
import Alamofire

protocol MovieRepository {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchDetails(req: FetchDetailsRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchCredits(req: FetchCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
    func fetchExternalIds(req: FetchExternalIdsRequest) -> AnyPublisher<ExternalIds, MovieError>
    func addReview(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
}

class MovieRepositoryImpl: MovieRepository {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (response: MoviePageResponse) -> [MediaItem] in
                response.results.map{ (result: MovieResponse) in
                    MediaItem(dto: result)
                }
            }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
        
        let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput: { [weak self] mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
            
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MediaItem], MovieError> in
                if isConnected {
                    return serviceResponse
                }
                else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDetails(req: FetchDetailsRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        
        let serviceResponse: AnyPublisher<MediaItemDetail, MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchDetails(req: req)),
            decodeTo: DetailsResponse.self,
            transform: { MediaItemDetail.init(dto: $0) }
        )
            .handleEvents(receiveOutput: { [weak self] mediaItemDetail in
                self?.detailStore.saveMediaItemDetail(mediaItemDetail)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<MediaItemDetail, MovieError> = detailStore.getMediaItemDetail(withId: req.mediaId)
            
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<MediaItemDetail, MovieError> in
                if isConnected {
                    return serviceResponse
                }
                else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCredits(req: FetchCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[CastMember], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchCredits(req: req)),
                        decodeTo: CreditsResponse.self,
                        transform: { dto in
                            dto.cast.map(CastMember.init(dto:))
                        }
                    )
                    .handleEvents(receiveOutput: { [weak self]castMembers in
                        self?.castMemberStore.saveCastMembers(castMembers, forMediaId: req.mediaId)
                    })
                    .eraseToAnyPublisher()
                } else {
                    return self.castMemberStore.getCastMembers(fromMediaId: req.mediaId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchExternalIds(req: FetchExternalIdsRequest) -> AnyPublisher<ExternalIds, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchExternalIds(req: req)),
            decodeTo: ExternalIdsResponse.self,
            transform: { response in
                ExternalIds(dto: response)
            }
        )
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: ModifyMediaResponse.self,
            transform: { response in
                ModifyMediaResult(dto: response)
            }
        )
    }
    
    func addReview(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.addReview(req: req)),
            decodeTo: ModifyMediaResponse.self,
            transform: { response in
                ModifyMediaResult(dto: response)
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(.mappingError))
                        }
                    case 400..<500:
                        future(.failure(.clientError))
                    case 500..<600:
                        future(.failure(.serverError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(.unexpectedError))
                            }
                        } else {
                            future(.failure(.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(.noInternetError))
                    } else {
                        future(.failure(.unexpectedError))
                    }
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
