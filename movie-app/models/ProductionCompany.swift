//
//  ProductionCompany.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

import Foundation

struct ProductionCompany: Decodable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
    
    var imageUrl: URL? {
        guard let logoPath = logoPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
    
    init(id: Int,
         name: String,
         logoPath: String,
         originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
    
    init(dto: ProductionCompanyResponse) {
        self.id = dto.id
        self.name = dto.name
        self.logoPath = dto.logoPath
        self.originCountry = dto.originCountry
    }
}

extension ProductionCompany: ParticipantItemProtocol {}
