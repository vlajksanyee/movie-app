//
//  GenreResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

struct GenreListResponse: Decodable {
    let genres: [GenreResponse]
}

struct GenreResponse : Decodable {
    let id: Int
    let name: String
}
