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
    
    func soloViewPlaybackTimerAction () {
        currentTime = model.currentSongTimeStatic
        currentTimeRemaining = model.audioFile.duration - model.currentSongTimeStatic
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .positional
//        let formattedTime = currentTime.positionalTime
//        let formattedTimeRemaining = currentTimeRemaining.positionalTime
//        print (formattedTime as Any)
//        print (formattedTimeRemaining as Any)
    }
    
    func startPlaybackTimer () {
        print ("START TIMER CALLED")
        if soloViewPlaybackTimer == nil {
            soloViewPlaybackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                self.soloViewPlaybackTimerAction()
            })
            soloViewPlaybackTimer?.fire()
        } 
    }
    
//   @State var albumCover: Image
//    @State var songName: String
//   @State var artistName: String
//    
//    func updateMetadata () {
//        let size = CGSize(width: 300, height: 300)
//         songName = model.currentMediaItem.title ?? "Unknown title"
//         artistName = model.currentMediaItem.artist ?? "Unknown artist"
//        let mediaImage = model.currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//        let UIAlbumCover = mediaImage?.image(at: size)
//        let defaultUIImage = UIImage(systemName: "photo")!
//         albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
//    }
    
    var body: some View {
        
        UserProfileHeaderView()
        
        VStack (spacing: 20) {
            model.albumCover
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .padding(10)
            
            VStack {
                
                Slider(value: $currentTime, in: 0...model.audioFile.duration, onEditingChanged: { editing in
                    let sampleRateSong = model.audioFile.processingFormat.sampleRate
                    model.cachedAudioFrame = Int64 (Double(currentTime) * Double(sampleRateSong))
                    model.cachedAudioTime = currentTime
                    model.currentSongTimeStatic = currentTime
                    model.playTrackAfterSeek()
                    //                model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    //                model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    //                model.fineTuneSoundLevel = fineTuneSoundLevel
                    //                soundLevelIsEditing = editing
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
            }
            VStack {
                HStack{
                    Text (model.artistName)
                    Spacer()
                }
                    .font(.title)
                HStack {
                    Text(model.songName)
                    Spacer()
                }
                .font(.title3)
     
                HStack {
                    Text (model.albumName)
                    Spacer()
                }
                .font(.title3)
                    .opacity(0.7 )
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            Spacer()
            PlayerViewSoloSong()
        }
        .onAppear {
            model.updateSongMetadata()
            startPlaybackTimer()
        }
    }
}

//struct SoloSongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoloSongView()
//    }
//}
