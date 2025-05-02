//
//  TVListView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 02..
//

import SwiftUI
import InjectPropertyWrapper

struct TVListView: View {
    @StateObject private var viewModel = TVListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: LayoutConst.normalPadding)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.tv) { tv in
                    TVCell(tv: tv)
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .onAppear {
            Task {
                await viewModel.loadTV(by: genre.id)
            }
        }
    }
}
