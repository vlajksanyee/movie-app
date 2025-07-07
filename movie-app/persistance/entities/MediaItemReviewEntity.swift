//
//  MediaItemReviewEntity.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 07. 05..
//

import RealmSwift
import Foundation

class MediaItemReviewEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var author: String
    @Persisted var content: String
    @Persisted var rating: Double?
    @Persisted var avatarUrlString: String?
    @Persisted var mediaId: Int
}

extension MediaItemReviewEntity {
    var toDomain: MediaReview {
        MediaReview(
            id: id,
            author: author,
            content: content,
            rating: rating,
            avatarURL: avatarUrlString.flatMap(URL.init(string:))
        )
    }
    
    convenience init(from domain: MediaReview, mediaId: Int) {
        self.init()
        self.id = domain.id
        self.author = domain.author
        self.content = domain.content
        self.rating = domain.rating
        self.avatarUrlString = domain.avatarURL?.absoluteString
        self.mediaId = mediaId
    }
}
