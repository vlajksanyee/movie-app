//
//  MovieDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 07..
//

import SwiftUI

func formatRuntime(minutes: Int) -> String {
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    return "\(hours)h \(remainingMinutes)m"
}

struct MediaDetailsView: View {
    @StateObject private var viewModel = MediaDetailsViewModel()
    var media: MediaItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: viewModel.media?.imageUrl) { phase in
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
                .frame(height: 185)
                .frame(maxHeight: 185)
                .frame(maxWidth: .infinity)
                .cornerRadius(30)
                
                VStack(alignment: .leading) {
                    HStack {
                        MediaDetailsLabel(type: .rating(viewModel.media?.voteAverage ?? 0))
                        MediaDetailsLabel(type: .voteCount(viewModel.media?.voteCount ?? 0))
                    }
                    .padding(.bottom, LayoutConst.normalPadding)
                    
                    if let genres = viewModel.media?.genres {
                        let genreNames = genres.map(\.self).map(\.name).joined(separator: ", ")
                        Text(genreNames)
                            .font(Fonts.paragraph)
                    }
                    
                    Text(viewModel.media?.title ?? "No title")
                        .font(Fonts.detailsTitle)
                    
                    //MARK: RELEASE DATE, RUNTIME, LANGUAGE
                    HStack(spacing: LayoutConst.normalPadding) {
                        VStack(alignment: .leading) {
                            if let year = viewModel.media?.year {
                                Text("Release Date")
                                    .font(Fonts.caption)
                                Text(year)                                    .font(Fonts.paragraph)
                            }
                        }
                        VStack(alignment: .leading) {
                            if let runtime = viewModel.media?.runtime {
                                Text("Runtime")
                                    .font(Fonts.caption)
                                Text(formatRuntime(minutes: runtime))                                    .font(Fonts.paragraph)
                            }
                        }
                        VStack(alignment: .leading) {
                            if let languages = viewModel.media?.spokenLanguages, !languages.isEmpty {
                                let languageNames = languages.map(\.self).map(\.englishName).joined(separator: ", ")
                                Text("Language")
                                    .font(Fonts.caption)
                                Text(languageNames)
                                    .font(Fonts.paragraph)
                            }
                        }
                    }
                    
                    //MARK: BUTTONS
                    HStack {
                        Button(action: {}) {
                            Text("Rate this movie")
                                .foregroundColor(.invertedMain)
                                .font(Fonts.detailsButton)
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
                                .font(Fonts.detailsButton)
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
                    
                    //MARK: SYNOPSIS
                    Text("Synopsis")
                        .font(Fonts.subheading)
                        .padding(.bottom, LayoutConst.normalPadding)
                    Text(viewModel.media?.overview ?? "")
                        .font(Fonts.paragraph)
                }
                .padding(.top, LayoutConst.normalPadding)
            }
            .padding(LayoutConst.maxPadding)
        }
        .onAppear {
            viewModel.mediaIdSubject.send(media.id)
        }
    }
}
