//
//  FetchSimilarsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 18..
//

struct FetchSimilarsRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}

