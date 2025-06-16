//
//  FetchMovieReviewsRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

import Foundation

struct FetchReviewsRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return [:]
    }
}
