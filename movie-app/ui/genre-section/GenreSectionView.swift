//
//  ContentView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    func loadGenres() {
        self.genres = [
            Genre(id: 1, name: "Adventure"),
            Genre(id: 2, name: "Sci-fi"),
            Genre(id: 3, name: "Fantasy"),
            Genre(id: 4, name: "Comedy")
        ]
    }
}

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
<<<<<<< HEAD
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(.red)
                    .frame(width: 400, height: 400)
                    .position(x: 375, y: -150)
                
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: Color.gray) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack {
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(.rightArrow)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("genreSection.title")
            }
=======
        NavigationView {
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: Color.gray) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    HStack {
                        Text(genre.name)
                            .font(Fonts.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(.rightArrow)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("genreSection.title")
>>>>>>> 5385288ad03b66421399468757bec69b1334c7a5
        }
        .onAppear {
            viewModel.loadGenres()
        }
    }
    
}

#Preview {
    GenreSectionView()
}
