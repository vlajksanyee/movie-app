//
//  MovieDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 07..
//

import SwiftUI

struct MediaDetailsView: View {
    @StateObject private var viewModel = MediaDetailsViewModel()
    let media: MediaDetailsResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//                AsyncImage(url: media.imageUrl) { phase in
//                    switch phase {
//                    case .empty:
//                        ZStack {
//                            Color.gray.opacity(0.3)
//                            ProgressView()
//                        }
//
//                    case let .success(image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//
//                    case .failure(let error):
//                        ZStack {
//                            Color.red.opacity(0.3)
//                            Image(systemName: "photo")
//                                .foregroundColor(.white)
//                        }
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//                .frame(height: 185)
//                .frame(maxHeight: 185)
//                .frame(maxWidth: .infinity)
//                .cornerRadius(30)
                
                VStack(alignment: .leading) {
                    HStack {
                        MediaDetailsLabel(type: .rating(media.rating))
                        MediaDetailsLabel(type: .voteCount(media.voteCount))
                    }
                    .padding(.bottom, LayoutConst.maxPadding)
                    
                    HStack {
                        
                    }
                    
                    Text(media.title)
                        .font(Fonts.detailsTitle)
                    
                    HStack {
                        Button(action: {}) {
                            Text("Rate this movie")
                                .foregroundColor(.invertedMain)
                                .font(Fonts.subheading)
                                .padding(.vertical, LayoutConst.normalPadding)
                                .padding(.horizontal, LayoutConst.maxPadding)
                        }
                        .frame(height: 56)
                        .background(.main)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(.invertedMain, lineWidth: 1)
                        )
                        .cornerRadius(28)
                        Spacer()
                        Button(action: {}) {
                            Text("Visit at IMDB")                                .foregroundColor(.main)
                                .font(Fonts.subheading)
                                .padding(.vertical, LayoutConst.normalPadding)
                                .padding(.horizontal, LayoutConst.maxPadding)
                        }
                        .frame(height: 56)
                        .background(.invertedMain)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(.main, lineWidth: 1)
                        )
                        .cornerRadius(28)
                    }
                    .padding(.vertical, 20)
                }
                .padding(.top, LayoutConst.normalPadding)
            }
            .padding(LayoutConst.maxPadding)
        }
        
    }
}
