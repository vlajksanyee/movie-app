//
//  Environments.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

struct Environment {
    enum Name {
        case prod
        case dev
        case tv
    }
#if ENV_PROD
    static let name: Name = .prod
#elseif ENV_TV
    static let name: Name = .tv
#else
    static let name: Name = .dev
#endif
}
