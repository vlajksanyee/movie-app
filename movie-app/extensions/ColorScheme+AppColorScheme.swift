//
//  ColorScheme+AppColorScheme.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 31..
//

import SwiftUI

extension ColorScheme {
    init(theme: AppColorScheme) {
        if theme == .light {
            self = .light
        } else {
            self = .dark
        }
    }
}
