//
//  OfflineBannerView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text(LocalizedStringKey("noInternet".localized()))
                .font(Fonts.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red.opacity(0.9))
        .foregroundColor(.white)
    }
}
