//
//  MediaItemHeaderView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 20..
//

import SwiftUI

struct MediaItemHeaderView: View {
    
    let title: String
    let year: String
    let runtime: String
    let spokenLanguages: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(Fonts.detailsTitle)
                .padding(.vertical, LayoutConst.normalPadding)
            
            //MARK: RELEASE DATE, RUNTIME, LANGUAGE
            HStack(spacing: LayoutConst.normalPadding) {
                DetailsLabel(title: "details.label.release", desc: year)
                DetailsLabel(title: "details.label.runtime", desc: "\(runtime)")
                DetailsLabel(title: "details.label.languages", desc: spokenLanguages)
            }
        }
    }
}
