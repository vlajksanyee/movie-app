//
//  Genre.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

struct Genre: Identifiable, Hashable, Equatable, Decodable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(dto: GenreResponse) {
        self.id = dto.id
        self.name = dto.name
    }
}
