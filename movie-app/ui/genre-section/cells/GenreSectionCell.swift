//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
        
    @State var isExpanded: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(genre.name)
                Spacer()
                RotatingArrow(isExpanded: isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        }
    }
}
