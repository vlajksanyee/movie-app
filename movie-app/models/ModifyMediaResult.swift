//
//  EditFavoriteResult.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

import Foundation

public struct ModifyMediaResult {
    let success : Bool
    let statusCode : Int
    let statusMessage : String
    
    init(dto: ModifyMediaResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
