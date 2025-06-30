//
//  SettingsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModelImpl()
        
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("settings.chooseLanguage".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, action: .simple, title: "settings.lang.english".localized())
                        .font(Fonts.detailsButton)
                        .onTapGesture {
                            viewModel.changeSelectedLanguage("en")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "ru" ? .filled : .outlined, action: .simple, title: "settings.lang.russian".localized())
                        .font(Fonts.detailsButton)
                        .onTapGesture {
                            viewModel.changeSelectedLanguage("ru")
                        }
                    StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.lang.hungarian".localized())
                        .font(Fonts.detailsButton)
                        .onTapGesture {
                            viewModel.changeSelectedLanguage("hu")
                        }
                }
                .padding(.bottom, 43)
                
                Text("settings.chooseTheme".localized())
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, action: .simple, title: "settings.theme.light".localized())
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .onTapGesture {
                            viewModel.changeTheme(AppColorScheme.light)
                        }
                    StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, action: .simple, title: "settings.theme.dark".localized())
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .onTapGesture {
                            viewModel.changeTheme(AppColorScheme.dark)
                        }
                }
                .padding(.bottom, 43)
                
                Spacer()
                VStack(spacing: LayoutConst.smallPadding) {
                    Text("Version \(viewModel.appInfo)")
                    Text("Created by iOS Academy")
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)
            }
            .padding(LayoutConst.maxPadding)
            .navigationTitle("settings.title".localized())
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SettingsView()
}
