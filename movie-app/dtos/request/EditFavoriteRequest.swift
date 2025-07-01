//
//  AddFavoriteMovieRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 06..
//

struct EditFavoriteBodyRequest: Encodable {
    let mediaId: Int
    let isFavorite: Bool
    let mediaType = "movie"
    
    enum CodingKeys: String, CodingKey {
        case isFavorite = "favorite"
        case mediaId = "media_id"
        case mediaType = "media_type"
    }
}

struct EditFavoriteRequest: LocalizedRequest {
    let accessToken: String = Config.bearerToken
    let account_id: String = Config.accountId
    let mediaId: Int
    let isFavorite: Bool
    
    func asRequestParams() -> [String: Any] {
        return [
            "media_type": "movie",
            "media_id": mediaId,
            "favorite": isFavorite
        ] + languageParam
    }
}
