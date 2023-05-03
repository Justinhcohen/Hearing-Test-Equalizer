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
        didSet {
            model.fineTuneSoundLevel =  (0.7 + (fineTuneSoundLevel * 0.003))
        }
    }
    @State private var shouldShowModalSoloSongView = false
    
    func dismiss() {
        shouldShowModalSoloSongView = false
    }
    
    func showModalSoloSongView () {
        shouldShowModalSoloSongView = true
    }
    
    var body: some View {
        HStack {
            
            Slider(value: $fineTuneSoundLevel, in: 0...100, onEditingChanged: { editing in
                model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                soundLevelIsEditing = editing
            })
            .padding()
            .onChange(of: volObserver.volume, perform: {value in
                fineTuneSoundLevel = 0.0
                model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
            })
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

struct PlayerViewSoloSong_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewSoloSong()
    }
}
