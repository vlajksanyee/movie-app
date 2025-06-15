//
//  MediaReview.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

import Foundation

struct MediaReview: Identifiable {
    let id: String
    let author: String
    let content: String
    let rating: Double?
    let avatarURL: URL?
    
    init(dto: MediaReviewResponse) {
        self.id = dto.id
        self.author = dto.author
        self.content = dto.content
        self.rating = dto.authorDetails.rating
        self.avatarURL = dto.authorDetails.avatarPath.flatMap { path in
            if path.hasPrefix("/") {
                return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            } else {
                return URL(string: path)
            }
        }
    }
}
