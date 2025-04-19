//
//  SearchMovieRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 19..
//

struct SearchMovieRequest {
    let accessToken: String = Config.bearerToken
    let searchText: String
    
    func asRequestParams() -> [String: Any] {
        return ["query": searchText]
    }
}
