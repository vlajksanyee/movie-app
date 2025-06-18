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
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func fetchDetails(req: FetchDetailsRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchCredits(req: FetchMediaCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchReviews(req: FetchReviewsRequest) -> AnyPublisher<[MediaReview], MovieError>
    func fetchCastMemberDetail(req: FetchCastMemberDetailsRequest) -> AnyPublisher<CastDetail, MovieError>
    func fetchCompanyDetail(req: FetchCastMemberDetailsRequest) -> AnyPublisher<CastDetail, MovieError>
    func fetchSimilars(req: FetchSimilarsRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func searchMedia(req: SearchMediaRequest) -> AnyPublisher<[MediaItem], MovieError>
    func addReview(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError>
}

class MovieRepositoryImpl: MovieRepository {
    
    @Inject var moya: MoyaProvider<MultiTarget>!
    
    @Inject private var store: MediaItemStoreProtocol
    @Inject private var detailStore: MediaItemDetailStoreProtocol
    @Inject private var castMemberStore: CastMemberStoreProtocol
    @Inject private var networkMonitor: NetworkMonitorProtocol
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
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
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchDetails(req: FetchDetailsRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        
        let serviceResponse: AnyPublisher<MediaItemDetail, MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchDetails(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail(dto: $0) }
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
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCredits(req: FetchMediaCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[CastMember], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchCredits(req: req)),
                        decodeTo: CreditsResponse.self,
                        transform: { $0.cast.map(CastMember.init(dto:)) }
                    )
                    .handleEvents(receiveOutput: { [weak self] castMembers in
                        self?.castMemberStore.saveCastMembers(castMembers, forMediaId: req.mediaId)
                    })
                    .eraseToAnyPublisher()
                } else {
                    return self.castMemberStore.getCastMembers(fromMediaId: req.mediaId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchReviews(req: FetchReviewsRequest) -> AnyPublisher<[MediaReview], MovieError> {
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MediaReview], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchReviews(req: req)),
                        decodeTo: MediaReviewsResponse.self,
                        transform: { $0.results.map(MediaReview.init(dto:)) }
                    )
                    .eraseToAnyPublisher()
                } else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCastMemberDetail(req: FetchCastMemberDetailsRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCastMemberDetails(req: req)),
            decodeTo: CastMemberDetailResponse.self,
            transform: { CastDetail(dto: $0) }
        )
    }
    
    func fetchCompanyDetail(req: FetchCastMemberDetailsRequest) -> AnyPublisher<CastDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCompanyDetails(req: req)),
            decodeTo: CompanyDetailResponse.self,
            transform: { CastDetail(dto: $0) }
        )
    }
    
    func fetchSimilars(req: FetchSimilarsRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchSimilars(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func searchMedia(req: SearchMediaRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMedia(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { response in
                response.results.map { MediaItem(dto: $0) }
            }
        )
    }
    
    func addReview(req: AddReviewRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.addReview(req: req)),
            decodeTo: ModifyMediaResponse.self,
            transform: { ModifyMediaResult(dto: $0) }
        )
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<ModifyMediaResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: ModifyMediaResponse.self,
            transform: { ModifyMediaResult(dto: $0) }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { promise in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            promise(.success(output))
                        } catch {
                            print("<<< Decoding error: \(error)")
                            if let jsonStr = String(data: response.data, encoding: .utf8) {
                                print("<<< Raw JSON:\n\(jsonStr)")
                            }
                            promise(.failure(.mappingError))
                        }
                    case 400..<500:
                        promise(.failure(.clientError))
                    case 500..<600:
                        promise(.failure(.serverError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                promise(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                promise(.failure(.unexpectedError))
                            }
                        } else {
                            promise(.failure(.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError {
                        promise(.failure(.noInternetError))
                    } else {
                        promise(.failure(.unexpectedError))
                    }
                }
            }
        }
        return future.eraseToAnyPublisher()
    }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
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
