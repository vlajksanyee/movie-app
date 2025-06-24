//
//  MovieCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import SwiftUI

// TODO: Height, width
struct MediaItemCell: View {
    let movie: MediaItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(height: MovieCellConst.height)
                        .frame(maxHeight: MovieCellConst.maxHeight)
                        .cornerRadius(12)
                }
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(movie.rating))
                    MovieLabel(type: .voteCount(movie.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }

            HStack {
                VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                    Text("\(movie.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(movie.duration)")
                        .font(Fonts.caption)
                }
                
                Spacer()
                
                Image(.playButton)
            }
        }
    }
}

#Preview {
    MediaItemCell(movie: MediaItem(id: 2,
                           title: "Mock movie2",
                           year: "2024",
                           duration: "1h 34m",
                           imageUrl: nil,
                           rating: 1.0,
                           voteCount: 1000)
    )
}
