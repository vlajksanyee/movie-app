//
//  StyledButton.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 10..
//

import SwiftUI

enum ButtonStyleType {
    case outlined
    case filled
}

enum ButtonStyleAction {
    case simple
    case link(_ url: URL?)
}

struct StyledButton: View {
    let style: ButtonStyleType
    let action: ButtonStyleAction
    let title: String
    
    var body: some View {
        baseView
            .font(Fonts.subheading)
            .foregroundColor(style == .outlined ? Color.primary : Color.main)
            .padding(.horizontal, 20.0)
            .padding(.vertical, LayoutConst.normalPadding)
            .frame(maxWidth: .infinity)
            .background(backgroundView)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.primary, lineWidth: style == .outlined ? 1 : 0)
            )
    }
    
    @ViewBuilder
    private var baseView: some View {
        switch action {
        case .simple:
            Text(LocalizedStringKey(title))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        case .link(let url):
            if let url = url {
                Link(LocalizedStringKey(title), destination: url)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            } else {
                Text(LocalizedStringKey(title))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
    
    private var backgroundView: some View {
        switch style {
        case .filled:
            Color.primary
        case .outlined:
            Color.main
        }
    }
}
