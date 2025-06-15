//
//  CastDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 13..
//

import SwiftUI

struct CastDetailView: View {
    @StateObject private var viewModel = CastDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let castDetailType: CastDetailType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    if let castMember = viewModel.castDetail {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Spacer()
                                LoadImageView(url: castMember.profileImageURL)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 370, height: 185)
                                    .cornerRadius(20)
                                Spacer()
                            }
                            
                            Text(castMember.name)
                                .font(Fonts.detailsTitle)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                            
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("Birth year")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(castMember.birthYear ?? "" )
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("City")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(castMember.originPlace ?? "")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                Text(castMember.biography ?? "")
                                    .font(Fonts.paragraph)
                                    .foregroundColor(Color.primary)
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Popularity")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                HStack {
                                    Spacer()
                                    StarRatingView(rating: $viewModel.rating, starSize: 24)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        .padding(.bottom, 48)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.castTypeSubject.send(castDetailType)
        }
    }
}
