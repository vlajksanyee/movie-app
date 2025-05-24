//
//  FetchExternalIdsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

struct FetchExternalIdsRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
