//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation

protocol SettingsViewModel: ObservableObject {
    // TODO: Add settings related properties and methods
}

class SettingsViewModelImpl: SettingsViewModel {
    @Published var selectedLanguage: String = Bundle.getLangCode()
    
    var selectedTheme: AppColorScheme {
        get {
            let raw = UserDefaults.standard.string(forKey: "color-scheme") ?? "light"
            return AppColorScheme(rawValue: raw) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "color-scheme")
        }
    }
    
    func changeSelectedLanguage(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: AppColorScheme) {
        self.selectedTheme = theme
    }
}
