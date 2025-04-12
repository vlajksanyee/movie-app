//
//  MovieService.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation
import Moya

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
}

class MoviesService: MoviesServiceProtocol {
    
    var moya : MoyaProvider<MultiTarget>!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        self.moya = MoyaProvider<MultiTarget>(
            session: Session(configuration: configuration,
                             startRequestsImmediately: false),
            plugins: [
                NetworkLoggerPlugin()
            ])
    }
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
//                        var genres = [Genre]()
//                        for genreResponse in decodedResponse.genres {
//                            genres.append(Genre(dto: genreResponse))
//                        }
                        
                        let genres = decodedResponse.genres.map { genreResponse in
                            Genre(dto: genreResponse)
                        }
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
