//
//  AddReviewResponse.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 24..
//

struct AddReviewResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
