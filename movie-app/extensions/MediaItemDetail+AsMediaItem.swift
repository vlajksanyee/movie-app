//
//  MediaItemDetail+AsMediaItem.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

extension MediaItemDetail {
    func asMediaItem () -> MediaItem {
        print("Image URL: \(self.imageUrl?.absoluteString ?? "nil")")
        return MediaItem(
            id: self.id, title: self.title, year: self.year, duration: String(self.runtime), imageUrl: self.imageUrl, rating: self.rating, voteCount: self.voteCount, mediaType: .unknown
        )
    }
}
