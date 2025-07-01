//
//  Config.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation

enum Config {
    private static let config: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) else {
            preconditionFailure("Config.plist file not found")
        }
        return dict
    }()

    private static func value(forKey key: String) -> String {
        guard let value = config[key] as? String else {
            preconditionFailure("Missing value for key: \(key)")
        }
        return value
    }

    static var apiToken: String {
        value(forKey: "API_TOKEN")
    }

    static var accountId: String {
        value(forKey: "ACCOUNT_ID")
    }

    static var bearerToken: String {
        "Bearer \(apiToken)"
    }
}

