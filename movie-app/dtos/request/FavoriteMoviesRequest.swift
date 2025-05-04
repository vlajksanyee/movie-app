//
//  Untitled.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 04..
//

struct FavoriteMoviesRequest {
    let accessToken: String = Config.bearerToken
    let account_id: String
    
    func asRequestParams() -> [String: Any] {
        return ["account_id": account_id]
    }
}
