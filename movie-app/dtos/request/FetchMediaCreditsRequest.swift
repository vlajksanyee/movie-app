//
//  FetchCreditsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

struct FetchMediaCreditsRequest: LocalizedRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
