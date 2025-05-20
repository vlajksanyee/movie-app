//
//  StarView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 20..
//

import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Image(isFilled ? .rateStarFill : .rateStarNofill)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40.0, height: 40.0)
            .onTapGesture {
                onTap()
            }
    }
}
