//
//  ExternalIdsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

struct ExternalIdsResponse: Decodable {
    let id: Int
    let imdbId: String?
    let wikidataId: String?
    let facebookId: String?
    let instagramId: String?
    let twitterId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imdbId = "imdb_id"
        case wikidataId = "wikidata_id"
        case facebookId = "facebook_id"
        case instagramId = "instagram_id"
        case twitterId = "twitter_id"
    }
}
