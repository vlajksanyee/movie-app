//
//  FetchMovieRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

struct FetchMediaListRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    let includeAdult: Bool
    
    func asRequestParams() -> [String: Any] {
        return [
            "with_genres": genreId,
            "include_adult": includeAdult
        ]
    }
}
