//
//  GenreSectionMovieCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 29..
//

import SwiftUI

struct GenreSectionMovieCell: View {
    var media: MediaItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: media.imageUrl)
                        .frame(width: 200, height: 100)
                        .clipped()
                        .cornerRadius(12)
                }
                HStack(spacing: 12.0) {
                    MediaItemLabel(type: .rating(media.rating))
                    MediaItemLabel(type: .voteCount(media.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }
            .padding(.bottom, LayoutConst.normalPadding)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(media.title)
                        .font(Fonts.subheading)
                        .lineLimit(2)
                    
                    Text("\(media.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(media.duration)")
                        .font(Fonts.caption)
                }
                Spacer()
                VStack {
                    Image(.playButton)
                }
            }
        }
    }
}
