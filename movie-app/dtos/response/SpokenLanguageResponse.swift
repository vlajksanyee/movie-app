//
//  SpokenLanguageResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 10..
//

struct SpokenLanguageResponse: Decodable {
    let englishName: String
    let iso_639_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso_639_1
        case name
    }
}
