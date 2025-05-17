//
//  ParticipantScrollView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 13..
//

import SwiftUI

protocol ParticipantItemProtocol {
    var id: Int { get }
    var name: String { get }
    var imageUrl: URL? { get }
}

struct ParticipantScrollView: View {
    
    let title: String
    let participants: [ParticipantItemProtocol]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(LocalizedStringKey(title))
                .font(Fonts.overviewText)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20.0) {
                    ForEach(participants, id: \.id) { participant in
                        ParticipantCell(imageUrl: participant.imageUrl, title: participant.name)
                            .offset(CGSize(width: LayoutConst.maxPadding, height: 0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, -LayoutConst.maxPadding)
        }
    }
}
