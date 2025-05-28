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
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
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
                    MediaItemHeaderView(
                        title: viewModel.media.title,
                        year: viewModel.media.year,
                        runtime: "\(viewModel.media.runtime)",
                        spokenLanguages: viewModel.media.spokenLanguages
                    )
                    
                    //MARK: BUTTONS
                    HStack(spacing: LayoutConst.largePadding) {
                        NavigationLink(destination: AddReviewView(mediaItemDetail: viewModel.media)) {
                            StyledButton(style: .outlined, action: .simple, title: "details.button.rate".localized())
                        }
                        StyledButton(style: .filled, action: .link(viewModel.media.imdbUrl), title: "details.button.imdb".localized())
                    }
                    .padding(.vertical, LayoutConst.normalPadding)
                    
                    //MARK: SYNOPSIS
                    VStack(alignment: .leading, spacing: 12) {
                        Text(LocalizedStringKey("details.overview".localized()))
                            .font(Fonts.overviewText)
                        Text(viewModel.media.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    .padding(.bottom, LayoutConst.normalPadding)
                    
                    //MARK: PUBLISHERS
                    ParticipantScrollView(title: "details.publishers".localized(), participants: viewModel.media.productionCompanies)
                        .padding(.bottom, LayoutConst.normalPadding)
                    
                    //MARK: CAST
                    ParticipantScrollView(title: "details.cast".localized(), participants: viewModel.credits)
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
