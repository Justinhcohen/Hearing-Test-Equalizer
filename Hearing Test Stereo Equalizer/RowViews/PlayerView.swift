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
    
    //         nowPlayingInfo[MPMediaItemPropertyArtwork] = currentMediaItem.artwork
    @State var songName = ""
    @State var albumCover = Image(systemName: "photo")
    
    func updateMetadata () {
        let size = CGSize(width: 30, height: 30)
        songName = (model.currentMediaItem.value(forProperty: MPMediaItemPropertyTitle) as? String)!
        let mediatImage = model.currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        let UIAlbumCover = mediatImage?.image(at: size)
        let defaultUIImage = UIImage(systemName: "photo")!
        albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
        
    }
    
    var body: some View {
//        ZStack {
//            HStack{
//                albumCover
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                Spacer()
//            }
            HStack (spacing: 30) {
                
                Button (action: model.playPreviousTrack) {
                    Image(systemName: "backward.fill")
                }
                .disabled(model.songList.isEmpty)
                
                Button (action: model.playOrPauseCurrentTrack) {
                    if model.playState == .stopped || model.playState == .paused {
                        Image(systemName: "play.fill")
                    } else {
                        Image(systemName: "pause.fill")
                    }
                }
                .disabled(model.songList.isEmpty)
                
                Button (action: model.playNextTrack) {
                    Image(systemName: "forward.fill")
                }
                .disabled(model.songList.isEmpty)
                
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
