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
    @ObservedObject private var volObserver = VolumeObserver() 
    
    //         nowPlayingInfo[MPMediaItemPropertyArtwork] = currentMediaItem.artwork
    @State var songName = ""
    @State var albumCover = Image(systemName: "photo")
    @State var soundLevelIsEditing = false
    @State private var fineTuneSoundLevel: Float = 0 {
        didSet {
            model.fineTuneSoundLevel =  (0.7 + (fineTuneSoundLevel * 0.003))
        }
    }
    
    func updateMetadata () {
        //     let size = CGSize(width: 30, height: 30)
     //   songName = (model.currentMediaItem.value(forProperty: MPMediaItemPropertyTitle) as? String)!
        //        let mediatImage = model.currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        // let UIAlbumCover = mediatImage?.image(at: size)
        //        let defaultUIImage = UIImage(systemName: "photo")!
        //        albumCover = Image(uiImage: defaultUIImage)
        
    }
    
    var body: some View {
        //        ZStack {
        //            HStack{
        //                albumCover
        //                    .resizable()
        //                    .frame(width: 30, height: 30)
        //                Spacer()
        //            }
        HStack {
            //                            Text ("Subtle Volume Adjustment")
            //                                .foregroundColor(soundLevelIsEditing ? .gray : .blue)
            //                        }
            //                        .font(.title3)
            //                        .foregroundColor(.blue)
            //                        .padding (.top, 50)
            
            Slider(value: $fineTuneSoundLevel, in: 0...100, onEditingChanged: { editing in
                model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                soundLevelIsEditing = editing
            })
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
            
            //   }
        }
        .font(.largeTitle)
        .padding()
        
        //        .onChange(of: model.queueIndex, perform: {value in
        //            updateMetadata()
        //        })
        //        .onChange(of: model.playState, perform: {value in
        //            updateMetadata()
        //        })
        
    }
}






struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
