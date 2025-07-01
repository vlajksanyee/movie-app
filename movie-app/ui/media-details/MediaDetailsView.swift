//
//  MovieDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 07..
//

import SwiftUI

struct MediaDetailsView: View {
    @StateObject private var viewModel = MediaDetailsViewModel()
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        var mediaItemDetail: MediaItemDetail {
            viewModel.mediaItemDetail
        }
        
        var credits: [CastMember] {
            viewModel.credits
        }
        
        return ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                
                HStack(spacing: 12.0) {
                    MediaItemLabel(type: .rating(mediaItemDetail.rating))
                    MediaItemLabel(type: .voteCount(mediaItemDetail.voteCount))
                    MediaItemLabel(type: .popularity(mediaItemDetail.popularity))
                    Spacer()
                    MediaItemLabel(type: .adult(mediaItemDetail.adult))
                }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: mediaItemDetail.year,
                                    runtime: "\(mediaItemDetail.runtime)",
                                    spokenLanguages: mediaItemDetail.spokenLanguages)
                
                HStack {
                    NavigationLink(destination: AddReviewView(mediaItemDetail: mediaItemDetail)) {
                        StyledButton(style: .outlined, action: .simple, title: "details.button.rate".localized())
                    }
                    
                    Spacer()
                    StyledButton(style: .filled, action: .link(mediaItemDetail.imdbUrl), title: "details.button.imdb".localized())
                }
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("details.overview".localized())
                        .font(Fonts.overviewText)
                    
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil)
                }
                ParticipantScrollView(title: "details.publishers".localized(), participants: mediaItemDetail.productionCompanies, navigationType: .company)
                
                ParticipantScrollView(title: "details.cast".localized(), participants: credits, navigationType: .castMember)
                
                ReviewScrollView(reviews: viewModel.reviews)
                
                // TODO: Localization
                SimilarScrollView(title: "Similars", mediaItemId: mediaItem.id)
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)

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
            viewModel.mediaItemSubject.send(mediaItem)
        }
    }
}
