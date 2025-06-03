//
//  RotatingArrow.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 31..
//

import SwiftUI

struct RotatingArrow: View {
    let isExpanded: Bool
    
    var body: some View {
        Image(.rightArrow)
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
            .animation(.linear(duration: 0.5), value: isExpanded)
    }
}
