//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit
import StoreKit

struct ContentView: View {
    
@EnvironmentObject var model: Model
@State private var tabSelection = 1
    func onPurchase (_ product: Product) {
        
    }
    
var body: some View {

        TabView (selection: $tabSelection) { 
            LibraryView(tabSelection: $tabSelection)
                .tabItem({ Label(!model.initialHearingTestHasBeenCompleted ? "" : "Library", systemImage: !model.initialHearingTestHasBeenCompleted ? "lock" : "music.note.list")})
                .tag(1)
            EQView(tabSelection: $tabSelection)
                .tabItem({ Label(!model.initialHearingTestHasBeenCompleted ? "" : "Spex", systemImage: !model.initialHearingTestHasBeenCompleted ? "lock" : "sparkles") }) 
                .tag (2)
            TestView(tabSelection: $tabSelection)
                .tabItem({ Label("Test", systemImage: "ear.and.waveform") }) 
                .tag (3)
            UserProfileView(tabSelection: $tabSelection)
                .tabItem({ Label(!model.initialHearingTestHasBeenCompleted ? "" : "Profiles", systemImage: !model.initialHearingTestHasBeenCompleted ? "lock" : "person.crop.circle")})
                .tag (4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

