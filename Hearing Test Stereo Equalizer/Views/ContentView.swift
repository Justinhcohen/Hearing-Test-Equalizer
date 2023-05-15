//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
@State private var tabSelection = 1
    
var body: some View {

        TabView (selection: $tabSelection) { 
            LibraryView(tabSelection: $tabSelection)
                .tabItem({ Label("Library", systemImage: "music.note.list")})
                .tag(1)
            EQView(tabSelection: $tabSelection)
                .tabItem({ Label("Spex", systemImage: "sparkles") }) 
                .tag (2)
            TestView(tabSelection: $tabSelection)
                .tabItem({ Label("Test", systemImage: "ear.and.waveform") }) 
                .tag (3)
            UserProfileView(tabSelection: $tabSelection)
                .tabItem({ Label("Profiles", systemImage: "person.crop.circle")})
                .tag (4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

