//
//  MovieService.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation
import Moya
import InjectPropertyWrapper

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem]
    func fetchTV(req: FetchMediaListRequest) async throws -> [MediaItem]
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem]
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest) async throws -> [MediaItem]
}

class MoviesService: MoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(MediaItem.init(dto:))
            }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(MediaItem.init(dto:))
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            moya.request(target) { result in
                switch result {
                case .success(let response):
                    
                    switch response.statusCode {
                    case 200..<300:
                        // Státuszkód ellenőrzése
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            continuation.resume(returning: output)
                        } catch {
                            continuation.resume(throwing: MovieError.mappingError)
                        }
                    case 400..<500:
                        continuation.resume(throwing: MovieError.clientError)
                    default:
                        // Megnézzük, hogy mégis hibás-e az API logikailag (status: false)
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                continuation.resume(throwing: MovieError.invalidApiKeyError(message: apiError.statusMessage))
                            } else {
                                continuation.resume(throwing: MovieError.unexpectedError)
                            }
                            return
                        }
                    }
                case .failure:
                    continuation.resume(throwing: MovieError.unexpectedError)
                }
            }
        }
    }
}
