//
//  RootView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

import SwiftUI
import Combine

struct RootView: View {
    @State var selectedTab: TabType = TabType.genre
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            MainTabView(selectedTab: $selectedTab)
            
            OfflineBannerView()
                .padding(.top, viewModel.isBannerVisible ? 0.0 : -200.0)
                .animation(.easeInOut(duration: 0.3), value: viewModel.isBannerVisible)
        }
    }
}
