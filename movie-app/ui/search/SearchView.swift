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
    @State private var debounceTimer: Timer?
    
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
                              prompt: Text("search.textfield.placeholder")
                        .foregroundStyle(.invertedMain))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.searchText)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        debounceTimer?.invalidate() // Cancel any previous timer to avoid double calls
                        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                            Task {
                                await viewModel.searchMovies()
                            }
                        }
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
                        Text("search.empty.title")
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: LayoutConst.normalPadding) {
                            ForEach(viewModel.movies) { movie in
                                MovieCell(movie: movie)
                                    .frame(height: 277)
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
            }
        }
        .alert(item: $viewModel.alertModel) { model in
            return Alert(
                title: Text(model.title),
                message: Text(model.message),
                dismissButton: .default(Text(model.dismissButtonTitle)) {
                    viewModel.alertModel = nil
                }
            )
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
}
