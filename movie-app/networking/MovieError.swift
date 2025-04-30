//
//  MovieError.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import Foundation

enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    case mappingError
    
    var domain: String {
        switch self {
        case .invalidApiKeyError,
                .unexpectedError,
                .clientError,
                .mappingError:
            return "MovieError"
        }
    }
}

extension MovieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .clientError:
            return "Client error"
        case .unexpectedError:
            return "Unexpected error"
        case .mappingError:
            return "Mapping error"
        }
    }
}

extension MovieError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.invalidApiKeyError, .invalidApiKeyError):
            return true
        case (.unexpectedError, .unexpectedError):
            return true
        case (.clientError, .clientError):
            return true
        case (.mappingError, .mappingError):
            return true
        default:
            return false
        }
    }
}
