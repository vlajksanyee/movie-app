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
    @Published var selectedTheme: AppColorScheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "color-scheme")
        }
    }
    
    init() {
        let storedTheme = UserDefaults.standard.string(forKey: "color-scheme")
        self.selectedTheme = AppColorScheme(rawValue: storedTheme ?? "") ?? .light
    }
    
    func changeSelectedLanguage(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: AppColorScheme) {
        self.selectedTheme = theme
    }
}
