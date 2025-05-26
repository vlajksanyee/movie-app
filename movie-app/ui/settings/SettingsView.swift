//
//  SettingsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var selectedLanguage: String = "en"
    @State private var selectedTheme: String = "dark"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("settings.chooseLanguage")
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: selectedLanguage == "en" ? .filled : .outlined, action: .simple, title: "settings.lang.english")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "en"
                        }
                    StyledButton(style: selectedLanguage == "de" ? .filled : .outlined, action: .simple, title: "settings.lang.german")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "de"
                        }
                    StyledButton(style: selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.lang.hungarian")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "hu"
                        }
                }
                .padding(.bottom, 43)
                
                Text("settings.chooseTheme")
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: selectedTheme == "light" ? .filled : .outlined, action: .simple, title: "settings.theme.light")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedTheme = "light"
                        }
                    StyledButton(style: selectedTheme == "dark" ? .filled : .outlined, action: .simple, title: "settings.theme.dark")
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedTheme = "dark"
                        }
                }
                .padding(.bottom, 43)
                
                Spacer()
                VStack(spacing: LayoutConst.smallPadding) {
                    Text("Version 0.9.1")
                    Text("Created by Hell yeah")
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)
            }
            .padding(LayoutConst.maxPadding)
            .navigationTitle("settings.title")
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SettingsView()
}
