//
//  LoadImageView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct LoadImageView: View {
    let url: URL?
    
    var body : some View {
        if let url = url {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                        .shimmering()
                }
            }
        } else {
            ZStack {
                Color.gray.opacity(0.3)
                Image(systemName: "photo")
            }
        }
    }
}
