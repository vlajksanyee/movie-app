//
//  MediaDetailsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 08..
//

struct MediaDetailsResponse: Decodable {
    let genres: [Genre]?
    let overview: String?
    let spokenLanguages: [String]?
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case genres
        case overview
        case spokenLanguages = "spoken_languages"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
