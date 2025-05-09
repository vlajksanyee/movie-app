//
//  Language.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 09..
//

struct Language: Hashable, Equatable, Decodable {
    let englishName: String
    let iso6391: String
    let name: String
    
    init(englishName: String, iso6391: String, name: String) {
        self.englishName = englishName
        self.iso6391 = iso6391
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
