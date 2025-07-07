//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation

struct FetchGenreRequest: LocalizedRequest {
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}

protocol LocalizedRequest {
    var languageParam: [String: Any] { get }
}

extension LocalizedRequest {
    var languageParam: [String: Any] {
        ["language": Bundle.getLangCode()]
    }
}

func + (lhs: [String: Any], rhs: [String: Any]) -> [String: Any] {
    var result = lhs
    rhs.forEach { result[$0.key] = $0.value }
    return result
}
