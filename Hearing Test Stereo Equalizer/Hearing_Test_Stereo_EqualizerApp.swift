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
    @StateObject private var player = Player()
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(player)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
