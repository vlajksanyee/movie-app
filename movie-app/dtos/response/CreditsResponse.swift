//
//  CreditsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

import Foundation

struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
