//
//  MovieLabel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import SwiftUI

enum MediaItemLabelType {
    case rating(_ value: Double)
    case voteCount(_ vote: Int)
    case popularity(_ popularity: Double)
    case adult(_ adult: Bool)
}

struct MediaItemLabel: View {

    let type: MediaItemLabelType
    
    var body: some View {
        var imageRes: ImageResource
        var text: String
        
        switch type {
        case .rating(let value):
            text = String(format: "%.1f", value)
            imageRes = .star
        case .voteCount(let vote):
            text = "\(vote)"
            imageRes = .heart
        case .popularity(let popularity):
            text = "\(popularity)"
            imageRes = .person
        case .adult(let adult):
            text = adult ? "details.adultOnly".localized() : "details.nonAdultOnly".localized()
            imageRes = .closedCaption
        }
        
        return HStack(spacing: 6.0) {
            Image(imageRes)
            Text(LocalizedStringKey(text))
                .font(Fonts.labelBold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(6.0)
        .background(.mediaItemLabel)
        .cornerRadius(12)
    }
}
