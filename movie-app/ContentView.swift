//
//  ContentView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 08..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding(.horizontal, 10)
        .background(.purple)
    }
}

#Preview {
    ContentView()
}
