//
//  Movie.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let mediaItems: [MediaItem]
    let totalPages: Int
    
    init(dto: MoviePageResponse) {
        self.mediaItems = dto.results.map(MediaItem.init)
        self.totalPages = dto.totalPages
    }
}
