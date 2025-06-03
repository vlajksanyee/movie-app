//
//  FetchMovieRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Foundation

struct FetchMediaListRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    let includeAdult: Bool
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "language": Bundle.getLangCode(),
            "with_genres": genreId,
            "include_adult": includeAdult,
            "page": page
        ]
    }
}
