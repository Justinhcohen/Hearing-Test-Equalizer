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
    
    var body: some View {
        
        TabView { 
            PlayView() 
                .tabItem({ Label("Play", systemImage: "book.circle") }) 
            TestView() 
                .tabItem({ Label("Test", systemImage: "gear") }) }
        .onAppear {
            print ("ContentView on Appear CALLED")
            model.readFromUserDefaults()
            model.printUserDefaults()
            
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

