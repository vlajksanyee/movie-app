//
//  CombinedCreditsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 27..
//

struct CombinedCreditsPageResponse: Decodable {
    let id: Int
    let cast: [CombinedCreditsResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}

struct CombinedCreditsResponse: Decodable {
    let id: Int
    let originalTitle: String?
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let mediaType: String

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case mediaType = "media_type"
    }
}
