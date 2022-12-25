//
//  Hearing_Test_Stereo_EqualizerApp.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI

@main
struct Hearing_Test_Stereo_EqualizerApp: App {
    
   @StateObject private var model = Model()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
