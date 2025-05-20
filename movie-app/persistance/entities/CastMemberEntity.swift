//
//  CastMemberEntity.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 20..
//

import RealmSwift
import Foundation

class CastMemberEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrlString: String?
    @Persisted var mediaId: Int
}

extension CastMemberEntity {
    var toDomain: CastMember {
        CastMember(
            id: id,
            name: name,
            castImageURL: imageUrlString.flatMap(URL.init(string:))
        )
    }
    
    convenience init(from domain: CastMember, mediaId: Int) {
        self.init()
        self.id = domain.id
        self.name = domain.name
        self.imageUrlString = domain.imageUrl?.absoluteString
        self.mediaId = mediaId
    }
}
