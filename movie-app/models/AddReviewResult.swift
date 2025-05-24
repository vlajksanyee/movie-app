//
//  AddReviewResult.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 24..
//

import Foundation

public struct AddReviewResult {
    let statusCode: Int
    let statusMessage: String
    
    init(dto: AddReviewResponse) {
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
