//
//  TVCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 02..
//

import SwiftUI

struct TVCell: View {
    let tv: TV
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    AsyncImage(url: tv.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }

                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure(let error):
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 100)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(tv.rating))
                    MovieLabel(type: .voteCount(tv.voteCount))
                }
                .padding(LayoutConst.smallPadding)
            }

            Text(tv.name)
                .font(Fonts.subheading)
                .lineLimit(2)

            Text("\(tv.year)")
                .font(Fonts.paragraph)

            Text("\(tv.duration)")
                .font(Fonts.caption)

            Spacer()
        }
    }
}
