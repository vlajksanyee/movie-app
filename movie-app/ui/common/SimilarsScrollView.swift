//
//  SimilarsScrollView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 18..
//

import SwiftUI

struct SimilarsScrollView: View {
    
    let title: String
    let similars: [MediaItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title.localized())
                .font(Fonts.overviewText)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(similars.indices, id: \.self) { index in
                        let similar = self.similars[index]
                        NavigationLink(destination: MediaDetailsView(mediaItem: similar)) {
                            MovieCell(movie: similar)
                        }
                        .buttonStyle(PlainButtonStyle())                        .offset(CGSize(width: LayoutConst.maxPadding, height: 0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, -LayoutConst.maxPadding)
            
        }
    }
}
