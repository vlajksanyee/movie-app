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
                        .frame(width: 24, height: 24)
                    
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder".localized())
                        .foregroundStyle(.invertedMain)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.caption)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        viewModel.startSearch.send(())
                    }
                    .accessibilityLabel(AccessibilityLabels.searchTextField)
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(Color.searchBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.invertedMain, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.maxPadding)
                
                if viewModel.mediaItems.isEmpty {
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
                            ForEach(viewModel.mediaItems) { movie in
                                NavigationLink(destination: MediaDetailsView(mediaItem: movie)) {
                                    MediaItemCell(mediaItem: movie)
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
        .onAppear {
            viewModel.searchText = ""
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
}
