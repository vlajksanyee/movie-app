//
//  MovieListView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 12) {
                    Image(.icSearch)
                        .renderingMode(.template)
                        .foregroundColor(.invertedMain)
                        .frame(width: 24, height: 24)
                    
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder".localized())
                        .foregroundStyle(.invertedMain))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.caption)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        viewModel.startSearch.send(())
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(.searchBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(.invertedMain, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.maxPadding)
                
                if viewModel.movies.isEmpty {
                    // Üres állapot
                    VStack {
                        Spacer()
                        Text("search.empty".localized())
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: LayoutConst.normalPadding) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MediaDetailsView(media: movie)) {
                                    MovieCell(movie: movie)
                                        .frame(height: 277)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
}
