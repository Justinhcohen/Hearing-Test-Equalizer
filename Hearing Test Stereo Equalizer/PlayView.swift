//
//  PlayView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit

struct PlayView: View {
    
    @EnvironmentObject var model: Model
    
    @State private var selectedValue: Int = 0
    @State private var trackIsPlaying = false
    let listTracks = ["rumour", "water", "levitating", "edamame"]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Text("Play a Song!")
                    .font(.largeTitle)
                    .padding(25)
              
                
                HStack {
                    
                    Text("Select a track:")
                    
                    Picker ("Tracks:", selection: $selectedValue) {
                        ForEach(listTracks.indices, id: \.self) { value in
                            Text(listTracks[value])
                                .tag(value)
                            
                        }
                    }
                   
                }
                .font(.title3)
                
                    Button("Play", 
                           action: {
                        model.playTrack(currentTrack: listTracks[selectedValue])
                    })
                    .font(.title)
                    .foregroundColor(.purple)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.purple, lineWidth: 5)
                        )
                    .padding(25)
                
                    
                    Button("Stop", 
                           action: {
                        model.stopTrack()
                    })
                    .font(.title)
                    .foregroundColor(.purple)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.purple, lineWidth: 5)
                        )
                    .padding(25)
                
                
                Text("Set Intensity:")
                    .font(.title3)
                   
                HStack (spacing: 30) {
               
                    Button("01", 
                           action: {
                        model.setIntensity1()
                    })
                    .frame(width: 35, height: 35)
                    .background(model.currentIntensity == 1 ? Color.green : Color.clear)
                    .border(Color.white)
                  //  .padding(10)    
                    
                    Button("02", 
                           action: {
                        model.setIntensity2()
                    })
                    .frame(width: 35, height: 35)
                    .background(model.currentIntensity == 2 ? Color.green : Color.clear)
                    .border(Color.white)
                  //  .padding(10)
                    
                    
                    Button("03", 
                           action: {
                        model.setIntensity3()
                    })
                    .frame(width: 35, height: 35)
                    .background(model.currentIntensity == 3 ? Color.green : Color.clear)
                    .border(Color.white)
                //    .padding(10)
                    
                    Button("04", 
                           action: {
                        model.setIntensity4()
                    })
                    .frame(width: 35, height: 35)
                    .background(model.currentIntensity == 4 ? Color.green : Color.clear)
                    .border(Color.white)
                //    .padding(10)
                    
                    Button("05", 
                           action: {
                        model.setIntensity5()
                    })
                    .frame(width: 35, height: 35)
                    .background(model.currentIntensity == 5 ? Color.green : Color.clear)
                    .border(Color.white)
                  //  .padding(10)
                }
                .font(.title3)
                .padding()
                
                Toggle("Equalizer", isOn: $model.equalizerIsActive)
                    .onChange(of: model.equalizerIsActive) { value in
                        model.toggleEqualizer()
                    }
                    .padding(25)
                    .font(.title3)
            }
        }
        
        .onAppear {
            
            print ("PlayView On Appear CALLED")
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
            .environmentObject(Model())
    }
}
