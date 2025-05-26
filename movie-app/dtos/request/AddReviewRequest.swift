//
//  AddRatingRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 24..
//

import Foundation

struct AddReviewBodyRequest: Codable {
    let mediaId: Int
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case mediaId = "movie_id"
        case value
    }
}

struct AddReviewRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let value: Double
    
    func asRequestParams() -> [String: Any] {
        return [
            "movie_id": mediaId,
            "value": value
        ]
    }
}
