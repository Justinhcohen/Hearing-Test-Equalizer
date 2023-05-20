//
//  SoloSongView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/3/23.
//

import SwiftUI
import MediaPlayer

struct SoloSongView: View {
    
    @EnvironmentObject var model: Model
    @State var currentTime: TimeInterval = 0
    @State var currentTimeRemaining: TimeInterval = 0
    @State var soloViewPlaybackTimer: Timer?
    
    func updatePlaybackTime () {
        currentTime = model.currentSongTime
        currentTimeRemaining = model.audioFile.duration - model.currentSongTime
    }
    
    func startPlaybackTimer () {
        if soloViewPlaybackTimer == nil {
            soloViewPlaybackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                self.updatePlaybackTime()
            })
            soloViewPlaybackTimer?.fire()
        } 
    }
    
    func stopPlayBackTimer () {
        if soloViewPlaybackTimer != nil {
            soloViewPlaybackTimer?.invalidate()
            soloViewPlaybackTimer = nil
            }
    }
    
    func respondToChangeInPlayState () {
        switch model.playState {
        case .stopped, .paused, .interrupted:
            stopPlayBackTimer()
            updatePlaybackTime()
        case .playing:
            startPlaybackTimer()
        }
    }
    
   
    
    var body: some View {
        UserProfileHeaderView()
            .padding(.top, 10)
        VStack (spacing: 20) {
            model.albumCover
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .padding(10)
            if model.showPlaytimeSlider {
                VStack {
                    Slider(value: $currentTime, in: 0...model.audioFile.duration, onEditingChanged: { editing in
                        model.cachedAudioFrame = Int64 (Double(currentTime) * Double(model.audioFile.processingFormat.sampleRate))
                        switch model.playState {
                        case .paused, .stopped, .interrupted:
                            break
                        case .playing:
                            model.playTrack()
                        }
                        updatePlaybackTime()
                    })
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    
                    
                    HStack {
                        Text (currentTime.positionalTime)
                        Spacer()
                        Text (currentTimeRemaining.positionalTime)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .opacity(0.3)
                    .font(.body)
                }
            }
            
            
            VStack {
                
                if model.showSongInformation {
                    
                    HStack{
                        Text (model.artistName)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    .font(.title)
                    HStack {
                        Text(model.songName)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    .font(.title3)
                    
                    HStack {
                        Text (model.albumName)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    .font(.title3)
                    .opacity(0.7 )
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            Spacer()
            PlayerViewSoloSong()
        }
        .onChange(of: model.playState, perform: { _ in
            respondToChangeInPlayState()
        })
        .onChange(of: model.songName, perform: { _ in 
            updatePlaybackTime()
        })
        .onAppear {
            startPlaybackTimer()
        }
    }
}

//struct SoloSongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoloSongView()
//    }
//}
