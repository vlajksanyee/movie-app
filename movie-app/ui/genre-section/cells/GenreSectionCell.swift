//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    
    @StateObject private var movieListViewModel = MovieListViewModel()
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(genre.name)
                Spacer()
                Image(.rightArrow)
                    .onTapGesture {
                        isExpanded = !isExpanded
                    }
            }
            .onAppear {
                movieListViewModel.genreIdSubject.send(genre.id)
            }
            if (isExpanded) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20.0) {
                        ForEach(movieListViewModel.movies.prefix(3)) { media in
                            NavigationLink(destination: MediaDetailsView(media: media)) {
                                GenreSectionMovieCell(media: media)
                                    .frame(maxWidth: 200, maxHeight: 200)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}
