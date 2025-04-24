//
//  GlobalMethods.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import UIKit

func safeArea() -> UIEdgeInsets {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows.first?.safeAreaInsets ?? .zero
}

