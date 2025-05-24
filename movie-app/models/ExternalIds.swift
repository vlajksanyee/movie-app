//
//  ExternalIds.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

struct ExternalIds: Identifiable, Hashable, Equatable, Decodable {
    let id: Int
    let imdbId: String?
    let wikidataId: String?
    let facebookId: String?
    let instagramId: String?
    let twitterId: String?
    
    init(id: Int, imdbId: String?, wikidataId: String?, facebookId: String?, instagramId: String?, twitterId: String?) {
        self.id = id
        self.imdbId = imdbId
        self.wikidataId = wikidataId
        self.facebookId = facebookId
        self.instagramId = instagramId
        self.twitterId = twitterId
    }
    
    init() {
        self.id = 0
        self.imdbId = ""
        self.wikidataId = ""
        self.facebookId = ""
        self.instagramId = ""
        self.twitterId = ""
    }
    
    init(dto: ExternalIdsResponse) {
        self.id = dto.id
        self.imdbId = dto.imdbId
        self.wikidataId = dto.wikidataId
        self.facebookId = dto.facebookId
        self.instagramId = dto.instagramId
        self.twitterId = dto.twitterId
    }
}
