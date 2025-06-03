//
//  SplashScreen.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 31..
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    @State var selectedTab: TabType = TabType.genre
    
    @State var animationFinished: Bool = false
    
    var body: some View {
        if animationFinished {
            RootView(selectedTab: selectedTab)
        } else {
            LottieView(animation: LottieAnimation.named("movies"))
                .playing(loopMode: .repeatBackwards(1.0))
                .animationSpeed(5.0)
                .animationDidFinish { finished in
                    animationFinished.toggle()
                }
        }
    }
}
