//
//  PlayerView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/1/23.
//

import SwiftUI
import MediaPlayer

struct PlayerView: View {
    
    @EnvironmentObject var model: Model
    @State private var shouldShowModalSoloSongView = false
    
    func dismiss() {

    }
    
    func showModalSoloSongView () {
        shouldShowModalSoloSongView = true
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                HStack (spacing: 30) {
                    Button (action: model.playPreviousTrack) {
                        Image(systemName: "backward.fill")
                    }
                    .disabled(model.songList.isEmpty || model.demoIsPlaying)
                    
                    Button (action: {
                        if model.playState == .stopped || model.playState == .paused || model.playState == .interrupted{
                            showModalSoloSongView()
                        }
                        model.playOrPauseCurrentTrack()
                        model.updateOnNewSong()
                    
                        
                    }) {
                        if model.playState == .stopped || model.playState == .paused || model.playState == .interrupted {
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
                HStack {
                    
                    Spacer ()
                    Button (action: showModalSoloSongView) {
                        Image(systemName: "arrow.up")
                    }
                    .disabled(!model.audioEngine.isRunning || model.songList.isEmpty || model.demoIsPlaying || !model.audioPlayerNodeL1.isPlaying)
                    .sheet(isPresented: $shouldShowModalSoloSongView, onDismiss: dismiss) {
                        SoloSongView()
                    }
                    
                    
                }
            }
            .font(.largeTitle)
            .padding()
        }
    }
}






//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView()
//    }
//}
