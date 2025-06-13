//
//  CastMember.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

//
//  CastMembers.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import Foundation

struct CastMember: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let castImageURL: URL?
    // Real person details
    let biography: String?
    let birthday: String?
    let placeOfBirth: String?
    let popularity: Double?

    init(dto: CastMemberResponse) {
        self.id = dto.id
        self.name = dto.name
        self.castImageURL = dto.profilePath.flatMap {
            URL(string:
            "https://image.tmdb.org/t/p/w500\($0)")
        }
        self.biography = nil
        self.birthday = nil
        self.placeOfBirth = nil
        self.popularity = nil
    }
    
    // New initializer for person details
    init(person: PersonDetailsResponse) {
        self.id = person.id
        self.name = person.name
        self.castImageURL = person.profilePath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }
        self.biography = person.biography
        self.birthday = person.birthday
        self.placeOfBirth = person.placeOfBirth
        self.popularity = person.popularity
    }
    
    init() {
        id = 0
        name = ""
        castImageURL = nil
        biography = nil
        birthday = nil
        placeOfBirth = nil
        popularity = nil
    }
    
    init(id: Int, name: String, castImageURL: URL? = nil, biography: String? = nil, birthday: String? = nil, placeOfBirth: String? = nil, popularity: Double? = nil) {
        self.id = id
        self.name = name
        self.castImageURL = castImageURL
        self.biography = biography
        self.birthday = birthday
        self.placeOfBirth = placeOfBirth
        self.popularity = popularity
    }
}

extension CastMember: ParticipantItemProtocol {
    var imageUrl: URL? { castImageURL }
}
