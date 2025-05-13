//
//  DetailsLabel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 10..
//

import SwiftUI

struct DetailsLabel: View {
    let title: String
    let desc: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(title))
                .font(Fonts.caption)
            Text(desc)
                .font(Fonts.paragraph)
        }
    }
}
