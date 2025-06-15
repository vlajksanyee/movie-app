//
//  MovieDetailResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 09..
//

import Foundation

struct MovieDetailResponse: Decodable {
    let id: Int
    let title: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let adult: Bool
    let genres: [GenreResponse]
    let runtime: Int
    let spokenLanguages: [SpokenLanguageResponse]
    let overview: String
    let imdbId: String
    let productionCompanies: [ProductionCompanyResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case adult
        case genres
        case runtime
        case spokenLanguages = "spoken_languages"
        case overview
        case imdbId = "imdb_id"
        case productionCompanies = "production_companies"
    }
}
