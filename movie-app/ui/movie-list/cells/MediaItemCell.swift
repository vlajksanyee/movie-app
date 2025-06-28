//
//  MovieCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import SwiftUI

// TODO: Height, width
struct MediaItemCell: View {
    let mediaItem: MediaItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: mediaItem.imageUrl)
                        .frame(height: MovieCellConst.height)
                        .frame(maxHeight: MovieCellConst.maxHeight)
                        .cornerRadius(12)
                }
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(mediaItem.rating))
                    MovieLabel(type: .voteCount(mediaItem.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }

            HStack {
                VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
                    Text(mediaItem.title)
                        .font(Fonts.subheading)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                    Text("\(mediaItem.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(mediaItem.duration)")
                        .font(Fonts.caption)
                }
                
                Spacer()
                
                Image(.playButton)
            }
        }
    }
}
