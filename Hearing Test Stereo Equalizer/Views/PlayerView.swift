//
//  PlayerView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/1/23.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        HStack (spacing: 30) {
            
            Button (action: model.playPreviousTrack) {
                Image(systemName: "backward.fill")
            }
            
            Button (action: model.playOrPauseCurrentTrack) {
                if !model.isPlaying || model.isPaused {
                    Image(systemName: "play.fill")
                } else {
                    Image(systemName: "pause.fill")
                }
            }
            
            Button (action: model.playNextTrack) {
                Image(systemName: "forward.fill")
            }
            
        }
        .font(.largeTitle)
        .padding()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
