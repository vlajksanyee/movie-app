//
//  ProductionCompanyResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

struct ProductionCompanyResponse: Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
