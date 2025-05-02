//
//  FetchTVGenreRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 02..
//

struct FetchTVGenreRequest {
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: String] {
        return [:]
    }
}
