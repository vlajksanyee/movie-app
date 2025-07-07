//
//  Movie.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Foundation

struct MediaItem: Identifiable, Equatable {
    var id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let mediaType: MediaItemType
    
    init(id: Int = -1) {
        self.id = id
        self.title = ""
        self.year = ""
        self.duration = ""
        self.imageUrl = nil
        self.rating = 0
        self.voteCount = 0
        self.mediaType = .unknown
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, mediaType: MediaItemType) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.mediaType = mediaType
    }
    
    init(dto: MovieResponse) {
        let prefixedYear: Substring = dto.releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.mediaType = .movie
    }
    
    init(dto: TVResponse) {
        let prefixedYear: Substring = dto.firstAirDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.mediaType = .tv
    }
    
    init(detail: MediaItemDetail) {
        self.id = detail.id
        self.title = detail.title
        self.year = detail.year
        self.duration = "-"
        self.imageUrl = detail.imageUrl
        self.rating = detail.rating
        self.voteCount = detail.voteCount
        self.mediaType = detail.mediaType
    }
    
    init(dto: CombinedCreditsResponse) {
        let prefixedYear: Substring = dto.releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "-" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.originalTitle ?? ""
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.mediaType = dto.mediaType ?? .unknown
    }
}
