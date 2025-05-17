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

struct CastMember: Identifiable {
    let id: Int
    let name: String
    let castImageURL: URL?

    init(dto: CastMemberResponse) {
        self.id = dto.id
        self.name = dto.name
        self.castImageURL = dto.profilePath.flatMap {
            URL(string:
            "https://image.tmdb.org/t/p/w185\($0)")
        }
    }
    
    init() {
        id = 0
        name = ""
        castImageURL = nil
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        castImageURL = nil
    }
}

extension CastMember: ParticipantItemProtocol {
    var imageUrl: URL? { castImageURL }
}
