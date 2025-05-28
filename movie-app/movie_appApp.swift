//
//  movie_appApp.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI

@main
struct movie_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = UserDefaults.standard.string(forKey: "color-scheme") ?? "light"
    
    var colorScheme: ColorScheme {
        if colorSchemeRawValue == "light" {
            return .light
        } else {
            return .dark
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
                .preferredColorScheme(colorScheme)
        }
    }
}
