//
//  Movie.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let page: Int
    let totalPages: Int
    let mediaItems: [MediaItem]
    
    init(dto: MoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
    
    init(dto: TVPageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
}
