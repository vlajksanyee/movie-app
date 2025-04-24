//
//  ContentView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Circle()
                    .fill(.red)
                    .frame(width: 400, height: 400)
                    .position(x: 375, y: -150)
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack {
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(.primary)
                                .accessibilityLabel(genre.name)
                            Spacer()
                            Image(.rightArrow)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle(Environment.name == .tv ? "TV" : "genreSection.title")
                .accessibilityLabel("testCollectionView")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchGenres()
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
