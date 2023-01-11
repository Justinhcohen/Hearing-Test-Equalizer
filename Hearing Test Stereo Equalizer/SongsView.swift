//
//  SongsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/3/23.
//

import SwiftUI
import MediaPlayer

struct SongsView: View {
    
    @EnvironmentObject var model: Model
    
    
    @State var playQueue = [MPMediaItem]()
    @State var collections = [MPMediaItemCollection]()
    @State var queueIndex: Int = 0
    @State var isPlaying: Bool = false
    @State var isPaused: Bool = false
    @State var timer: Timer?
    @State private var searchText = ""
    
   

    func onSongEnd(){
//        print("counting...")
//        print ("Audio File Duration = \(model.audioFile.duration)")
//        print ("Audio Player Current = \(model.audioPlayerNodeL1.current)")
        if model.audioPlayerNodeL1.current >= model.audioFile.duration {
            playNextTrack()
        }
    }
    
    func startTimer () {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                onSongEnd()
            })
            timer?.fire()
        } 
    }
    
//    func stopTimer () {
//        timer?.invalidate()
//        timer = nil
//    }
                                     
    
    
    func getQueueIndex (playQueue: [MPMediaItem], currentMPMediaItem: MPMediaItem) -> Int {
        for i in 0...playQueue.count - 1 {
            if playQueue[i].persistentID == currentMPMediaItem.persistentID {
                queueIndex = i
                return i
            } 
        }
        return 0
    }
    
    func playPreviousTrack () {
        guard queueIndex > 0 else {
            return
        }
        queueIndex -= 1
        model.playTrack(playQueue: playQueue, index: queueIndex)
        if !isPlaying {
            isPlaying = true
        }
    }
    
    func playOrPauseCurrentTrack () {
        if !isPlaying && !isPaused {
            model.playTrack(playQueue: playQueue, index: queueIndex)
            isPlaying = true
            isPaused = false
            startTimer()
        } else if !isPlaying && isPaused {
            model.unPauseTrack()
            isPlaying = true
            isPaused = false
        } else {
            model.pauseTrack()
            isPlaying = false
            isPaused = true
        }
    }
    
    
    
    func playNextTrack () {
        print ("CALLED PLAYED NEXT TRACK")
        print ("queueIndex is \(queueIndex)")
        guard queueIndex < playQueue.count - 1 else {
            return
        }
        queueIndex += 1
        model.playTrack(playQueue: playQueue, index: queueIndex)
        if !isPlaying {
            isPlaying = true
        }
    }
    
    func receivedTrackFinishedPlaying () {
        print ("Received Track Finished Playing")
        playNextTrack()
    }
    
    var searchResults: [MPMediaItem] {
            if searchText.isEmpty {
                return playQueue
            } else {
                return playQueue.filter { $0.title!.contains(searchText) }
            }
        }
    
    
    var body: some View {  
       
//            HStack {
//                
//                Text ("Songs")
//                    .font(.largeTitle)
//                   
//                
//                Spacer()
//            }
                       
            
            
   //     NavigationStack { 
            List {
                ForEach(searchResults, id: \.self) {item in 
                    let size = CGSize(width: 10, height: 10)
                    let songName = item.title
                    let mediatImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                    let UIAlbumCover = mediatImage?.image(at: size)
                    let defaultUIImage = UIImage(systemName: "photo")!
                    let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                    SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                            let index = getQueueIndex(playQueue: playQueue, currentMPMediaItem: item)
                            model.playTrack(playQueue: playQueue, index: index)
                            isPlaying = true
                            startTimer()
                        } 
                }
            
        
                         
                         
            
//            List (playQueue, id: \.self) { item in
//                let size = CGSize(width: 10, height: 10)
//                let songName = item.title
//                let mediatImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//                let UIAlbumCover = mediatImage?.image(at: size)
//                let defaultUIImage = UIImage(systemName: "photo")!
//                let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
//                //            HStack {
//                //                Text (songName ?? "Title Unknown")
//                //                Spacer()
//                //            }
//                SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        
//                        let index = getQueueIndex(playQueue: playQueue, currentMPMediaItem: item)
//                        model.playTrack(playQueue: playQueue, index: index)
//                        isPlaying = true
//                        startTimer()
//                    }
            }
            .searchable(text: $searchText)
          //  .navigationTitle("Songs")
    //    }
       
            
        
          
            
            
            
            
            HStack (spacing: 30) {
                
                Button (action: playPreviousTrack) {
                    Image(systemName: "backward.fill")
                }
                
                Button (action: playOrPauseCurrentTrack) {
                    if !isPlaying {
                        Image(systemName: "play.fill")
                    } else {
                        Image(systemName: "pause.fill")
                    }
                }
                
                Button (action: playNextTrack) {
                    Image(systemName: "forward.fill")
                }
                
            }
            .font(.largeTitle)
            .padding()
        
        
        
    }
}





struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
            .environmentObject(Model())
    }
}
