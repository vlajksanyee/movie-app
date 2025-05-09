//
//  DetailsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 09..
//

import Foundation

struct DetailsResponse: Decodable {
    let title: String
    let releaseDate: String?
    var year: String {
        guard let releaseDate = releaseDate else { return "0" }
        let year = releaseDate.split(separator: "-").first
        return String(year ?? "0")
        
    }
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let overview: String
    let genres: [Genre]?
    var imageUrl: URL? {
        posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }
    }
    let runtime: Int?
    let spokenLanguages: [Language]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview
        case genres
        case runtime
        case spokenLanguages = "spoken_languages"
    }
}
