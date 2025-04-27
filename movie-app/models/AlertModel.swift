//
//  AlertModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import Foundation

struct AlertModel: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var dismissButtonTitle: String
}
