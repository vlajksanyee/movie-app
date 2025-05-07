//
//  Untitled.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 04..
//

struct FetchFavoriteMoviesRequest {
    let accessToken: String = Config.bearerToken
    let account_id: String = "21958080"
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
