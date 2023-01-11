//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @EnvironmentObject var model: Model
    
    
    let audioSession = AVAudioSession.sharedInstance()
    
    
    var body: some View {
        
//        Text ("Hello World")
        
        TabView { 
            LibraryView()
                .tabItem({ Label("Library", systemImage: "music.note.list")})
            EQView()
                .tabItem({ Label("EQ", systemImage: "speaker") }) 
            TestView()
                .tabItem({ Label("Test", systemImage: "ear.and.waveform") }) 
        }
        .onAppear {
            print ("ContentView on Appear CALLED")
            model.readFromUserDefaults()
            do {
                try audioSession.setCategory(.playback)
                try audioSession.setActive(true)
            } catch _ {
                
            }
            model.printUserDefaults()
            
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

