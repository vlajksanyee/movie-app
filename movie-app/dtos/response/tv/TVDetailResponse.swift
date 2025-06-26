//
//  TVDetailResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 24..
//

import Foundation

struct TVDetailResponse: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let genres: [GenreResponse]
    let episodeRunTime: [Int]
    let spokenLanguages: [SpokenLanguageResponse]
    let overview: String
    let adult: Bool
    let originCountry: [String]
    let originalName: String
    let productionCompanies: [ProductionCompanyResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genres
        case episodeRunTime = "episode_run_time"
        case spokenLanguages = "spoken_languages"
        case overview
        case adult
        case originCountry = "origin_country"
        case originalName = "original_name"
        case productionCompanies = "production_companies"
    }
}
