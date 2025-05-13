//
//  FetchDetailsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 07..
//

struct FetchDetailsRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
