//
//  MovieDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 07..
//

import SwiftUI

struct MediaDetailsView: View {
    @StateObject private var viewModel = MediaDetailsViewModel()
    var media: MediaItem
    
    @State private var showSafari = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                LoadImageView(url: viewModel.media.imageUrl)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        MovieLabel(type: .rating(viewModel.media.rating))
                        MovieLabel(type: .voteCount(viewModel.media.voteCount))
                        MovieLabel(type: .popularity(viewModel.media.popularity))
                        Spacer()
                        MovieLabel(type: .adult(viewModel.media.adult))
                    }
                    .padding(.bottom, LayoutConst.normalPadding)
                    
                    //MARK: GENRES
                    Text(viewModel.media.genreList)
                        .font(Fonts.paragraph)
                    
                    //MARK: TITLE
                    Text(viewModel.media.title)
                        .font(Fonts.detailsTitle)
                        .padding(.vertical, LayoutConst.normalPadding)
                    
                    //MARK: RELEASE DATE, RUNTIME, LANGUAGE
                    HStack(spacing: LayoutConst.normalPadding) {
                        DetailsLabel(title: "details.label.release", desc: viewModel.media.year)
                        DetailsLabel(title: "details.label.runtime", desc: "\(viewModel.media.runtime)")
                        DetailsLabel(title: "details.label.languages", desc: viewModel.media.spokenLanguages)
                    }
                    
                    //MARK: BUTTONS
                    HStack(spacing: LayoutConst.largePadding) {
                        StyledButton(style: .outlined, title: "details.button.rate") {
                            showSafari = true
                        }
                        .sheet(isPresented: $showSafari) {
                            if let url = viewModel.media.imdbUrl {
                                SafariView(url: url)
                            } else {
                                Text("Invalid URL")
                            }
                        }
                        Spacer()
                        StyledButton(style: .filled, title: "details.button.imdb") {
                            showSafari = true
                        }
                        .sheet(isPresented: $showSafari) {
                            if let url = viewModel.media.imdbUrl {
                                SafariView(url: url)
                            } else {
                                Text("Invalid URL")
                            }
                        }
                    }
                    .padding(.vertical, LayoutConst.normalPadding)
                    
                    //MARK: SYNOPSIS
                    VStack(alignment: .leading, spacing: 12) {
                        Text(LocalizedStringKey("details.overview"))
                            .font(Fonts.overviewText)
                        Text(viewModel.media.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    
                    //MARK: PUBLISHERS
                    ParticipantScrollView(title: "details.publishers", participants: viewModel.media.productionCompanies)
                    
                    //MARK: CAST
                    ParticipantScrollView(title: "details.cast", participants: viewModel.credits)
                }
                .padding(.vertical, LayoutConst.normalPadding)
            }
            .padding(LayoutConst.maxPadding)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.favoriteButtonTapped.send(())
                }) {
                    Image(viewModel.isFavorite ? .favorite : .nonfavorite)
                        .resizable()
                        .frame(height: 30.0)
                        .frame(width: 30.0)
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaIdSubject.send(media.id)
        }
    }
}
