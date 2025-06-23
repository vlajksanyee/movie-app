//
//  SimilarsScrollView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 18..
//

import SwiftUI

struct SimilarScrollView: View {
    @StateObject private var viewModel = SimilarScrollViewModel()
    let title: String
    let mediaItemId: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(title.localized())
                .font(Fonts.overviewText)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(viewModel.similars.indices, id: \.self) { index in
                        let similar = viewModel.similars[index]
                        NavigationLink(destination: MediaDetailsView(mediaItem: similar)) {
                            MovieCell(movie: similar)
                                .onAppear {
                                    if index == viewModel.similars.count - 1 {
                                        viewModel.similarsSubject.send(mediaItemId)
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())                        .offset(CGSize(width: LayoutConst.maxPadding, height: 0))
                    }
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(width: MovieCellConst.maxWidth, height: MovieCellConst.height)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onAppear {
                viewModel.similarsSubject.send(mediaItemId)
            }
            .padding(.horizontal, -LayoutConst.maxPadding)
            
        }
    }
}
