//
//  MediaReviewsResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

import Foundation

struct MediaReviewsResponse: Decodable {
    let id: Int
    let page: Int
    let results: [MediaReviewResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MediaReviewResponse: Decodable {
    let author: String
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String
    let authorDetails: AuthorDetailsResponse
    
    enum CodingKeys: String, CodingKey {
        case author
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
        case authorDetails = "author_details"
    }
}

struct AuthorDetailsResponse: Decodable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
