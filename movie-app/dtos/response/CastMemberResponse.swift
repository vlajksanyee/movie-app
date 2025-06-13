//
//  CastMemberResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

import Foundation

struct CastMemberResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}

struct PersonDetailsResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let biography: String?
    let birthday: String?
    let placeOfBirth: String?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case biography
        case birthday
        case placeOfBirth = "place_of_birth"
        case popularity
    }
}
