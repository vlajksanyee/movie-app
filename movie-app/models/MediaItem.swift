//
//  Movie.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Foundation

struct MediaItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
    }
    
    init(dto: MovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = dto.releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
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
    }
    
    init(dto: TVResponse) {
        let firstAirDate: String? = dto.firstAirDate
        let prefixedYear: Substring = dto.firstAirDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "58 min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
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
    }
    
}
