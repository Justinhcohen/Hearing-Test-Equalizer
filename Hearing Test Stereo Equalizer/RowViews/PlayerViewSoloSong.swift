//
//  PlayerViewSoloSong.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/3/23.
//

import SwiftUI

struct PlayerViewSoloSong: View {
    @EnvironmentObject var model: Model
 //   @ObservedObject private var volObserver = VolumeObserver() 
    
    @State var soundLevelIsEditing = false
    @State private var fineTuneSoundLevel: Float = 0 
    @State private var shouldShowSwitchUserProfileViewModal = false
    
    func showSwitchUserProfileViewModal () {
        shouldShowSwitchUserProfileViewModal = true
    }
    
    func dismiss () {
    }
    
    
    var body: some View {
        VStack {
            
            if model.showSpexToggle {
                
                ZStack {
//                    if model.equalizerIsActive {
//                        Image("SpexOwl1024")
//                            .resizable()
//                            .frame(width: 50, height: 50, alignment: .center)
//                    } else {
//                        Image("SpexOwl1024BW")
//                            .resizable()
//                            .frame(width: 50, height: 50, alignment: .center)
//                    }
                    if model.equalizerIsActive {
                        Button (action: showSwitchUserProfileViewModal) {
                            Image("SpexOwl1024")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                            
                    } else {
                        Button (action: showSwitchUserProfileViewModal) {
                            Image("SpexOwl1024BW")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
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
                .sheet(isPresented: $shouldShowSwitchUserProfileViewModal, onDismiss: dismiss) {
                    SwitchUserProfileView()
                }
            }
            
            if model.showSubtleVolumeSlider {
                
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
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .onAppear {
                    fineTuneSoundLevel = model.fineTuneSoundLevel
                }
            }
            
            ZStack {
                if model.showAirPlayButton {
                    HStack {
                        AirPlayButton().frame(width: 40, height: 40)
                        Spacer()
                    }
                    .padding()
                }
                
                HStack (spacing: 30) {
                    Button (action: model.playPreviousTrack) {
                        Image(systemName: "backward.fill")
                    }
                    .disabled(model.songList.isEmpty || model.demoIsPlaying)
                    
                    Button (action: model.playOrPauseCurrentTrack) {
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
                if model.showRepeatButton {
                    HStack {
                        Spacer()
                       
                            Button (action: model.tapRepeatSetting) {
                                switch model.repeatSetting {
                                case .off:
                                    Image(systemName: "repeat")
                                        .opacity(0.3)
                                case .on:
                                    Image(systemName: "repeat")
                                        .opacity(1.0)
                                case .one:
                                    Image(systemName: "repeat.1")
                                        .opacity(1.0)
                                }
                            }
                            .disabled(model.songList.isEmpty || model.demoIsPlaying)
                        }
                    .padding()
                    }
            }
            .font(.largeTitle)
            .padding()
        }
    }
}

//struct PlayerViewSoloSong_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerViewSoloSong()
//    }
//}
