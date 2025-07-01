//
//  Untitled.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 04..
//

struct FetchFavoriteMediaItemsRequest: LocalizedRequest {
    let accessToken: String = Config.bearerToken
    let account_id: String = Config.accountId
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}
