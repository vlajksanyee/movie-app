//
//  FetchSimilarsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 18..
//

struct FetchSimilarsRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "page": page
        ]
    }
}
