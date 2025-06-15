//
//  ReviewScrollView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 15..
//

import SwiftUI

struct ReviewScrollView: View {
    let reviews: [MediaReview]
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
            Text("details.topreviews".localized())
                .font(Fonts.overviewText)
            
            if reviews.isEmpty {
                Text("details.noreviews".localized())
                    .font(Fonts.paragraph)
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                    HStack {
                        if reviews.indices.contains(0) {
                            ReviewCell(review: reviews[0])
                        }
                        Spacer()
                        if reviews.indices.contains(1) {
                            ReviewCell(review: reviews[1])
                        }
                    }
                    HStack {
                        if reviews.indices.contains(2) {
                            ReviewCell(review: reviews[2])
                        }
                        Spacer()
                        if reviews.indices.contains(3) {
                            ReviewCell(review: reviews[3])
                        }
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
            }
        }
    }
}
