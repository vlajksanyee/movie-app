//
//  ReviewCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

import SwiftUI

struct ReviewCell: View {
    let review: MediaReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            HStack {
                Text(review.author)
                    .font(Fonts.subheading)
                Spacer()
                if let rating = review.rating {
                    MovieLabel(type: .rating(rating))
                }
            }
            Text(review.content)
                .font(Fonts.paragraph)
                .lineLimit(4)
        }
    }
}
