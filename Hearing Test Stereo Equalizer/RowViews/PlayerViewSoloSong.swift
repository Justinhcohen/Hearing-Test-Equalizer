//
//  PlayerViewSoloSong.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/3/23.
//

import SwiftUI

struct PlayerViewSoloSong: View {
    @EnvironmentObject var model: Model
    @ObservedObject private var volObserver = VolumeObserver() 
    
    @State var soundLevelIsEditing = false
    @State private var fineTuneSoundLevel: Float = 0 {
        willSet {
          //  model.fineTuneSoundLevel =  (0.7 + (fineTuneSoundLevel * 0.003))
         //   model.fineTuneSoundLevel = fineTuneSoundLevel
            print ("New solo fine tune sound level = \(newValue)")
            print ("fine tune sound level = \(fineTuneSoundLevel)")
        }
    }
    @State private var shouldShowEQViewModal = false
    
    func showEQViewModal () {
        shouldShowEQViewModal = true
    }
    
    func dismiss () {
        
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                if model.equalizerIsActive {
                    Image("SpexOwl1024")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                } else {
                    Image("SpexOwl1024BW")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                }
                Toggle("", isOn: $model.equalizerIsActive)
                    .onChange(of: model.equalizerIsActive) { value in
                        model.setEQBands(for: model.currentUserProfile)
                    }
                    .padding(.trailing)
                    .padding(.leading)
                    .font(.title3)
                    .foregroundColor(model.equalizerIsActive ? .blue : .gray)
            }
            HStack {
                Image(systemName: "speaker.wave.2")
                    .foregroundColor((model.songList.isEmpty || model.demoIsPlaying) ? .gray : .blue)
                    .font(.callout)
                
                Slider(value: $fineTuneSoundLevel, in: 0...100, onEditingChanged: { editing in
                    model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    model.fineTuneSoundLevel = fineTuneSoundLevel
                    soundLevelIsEditing = editing
                })
             //   .padding()
//                .onChange(of: volObserver.volume, perform: {value in
//                    print ("CHANGE IN VOLUME OBSERVED")
//                    fineTuneSoundLevel = 0.0
//                    model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
//                    model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
//                })
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top, 10)
            .onAppear {
                print ("CALLED ON APPEAR ON SOLO SLIDER")
                print ("Model fine tune slider value = \(model.fineTuneSoundLevel)")
                print ("Solo fineTuneSoundLevel = \(fineTuneSoundLevel)")
                fineTuneSoundLevel = model.fineTuneSoundLevel
               // refreshState()
            }
            
            HStack (spacing: 30) {
                Button (action: model.playPreviousTrack) {
                    Image(systemName: "backward.fill")
                }
                .disabled(model.songList.isEmpty || model.demoIsPlaying)
                
                Button (action: model.playOrPauseCurrentTrack) {
                    if model.playState == .stopped || model.playState == .paused {
                        Image(systemName: "play.fill")
                    } else {
                        Image(systemName: "pause.fill")
                    }
                }
                .disabled(model.songList.isEmpty || model.demoIsPlaying)
                
                Button (action: model.playNextTrack) {
                    Image(systemName: "forward.fill")
                }
                .disabled(model.songList.isEmpty || model.demoIsPlaying)
                
            }
            
            .font(.largeTitle)
            .padding()
            
        }
    }
}

struct PlayerViewSoloSong_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewSoloSong()
    }
}
