//
//  FetchCastMemberDetailRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

struct FetchCastMemberDetailsRequest: LocalizedRequest {
    let accessToken: String = Config.bearerToken
    let castMemberId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
