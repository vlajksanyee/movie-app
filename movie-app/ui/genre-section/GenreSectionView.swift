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
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: MovieListView(genre: genre)) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    GenreSectionCell(genre: genre)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title")
            .accessibilityLabel("testCollectionView")
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    GenreSectionView()
}
