//
//  ContentView.swift
//  MotorTrack
//
//  Created by Javier Heisecke on 2025-03-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BasicMapRepresentable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
