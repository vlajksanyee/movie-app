//
//  TV.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 02..
//

import Foundation

struct TV: Identifiable, Equatable {
    let id: Int
    let name: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    
    init(id: Int, name: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int) {
        self.id = id
        self.name = name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
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
        self.name = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        
    }
    
}
