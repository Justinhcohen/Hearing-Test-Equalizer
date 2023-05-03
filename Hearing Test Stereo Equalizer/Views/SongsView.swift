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
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var searchText = ""
 
    func getQueueIndex (songList: [MPMediaItem], currentMPMediaItem: MPMediaItem) -> Int {
        for i in 0...songList.count - 1 {
            if songList[i] == currentMPMediaItem {
                model.queueIndex = i
                return i
            } 
        }
        return 0
    }
    
    var searchResults: [MPMediaItem] {
        if searchText.isEmpty {
            return model.songList
        } else {
            return model.songList.filter { $0.title!.contains(searchText) }
        }
    }
    
  //  @State var refreshState = UUID()
    
    var body: some View {  
            Button("Shuffle Play", 
                   action: {
                model.cachedAudioFrame = nil
                model.songList = model.songList.shuffled()
                model.playQueue = model.songList
                model.queueIndex = 0
                model.startFadeInTimer()
                model.playTrack()
            })
            .font(.title)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(!model.songList.isEmpty ? .blue : .gray, lineWidth: 5)
            ) 
           .disabled(model.songList.isEmpty)
            
            List {
                ForEach(searchResults, id: \.self) {item in 
                    let size = CGSize(width: 30, height: 30)
                    let songName = item.title ?? "Unknown title"
                    let mediaImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                    let UIAlbumCover = mediaImage?.image(at: size)
                    let defaultUIImage = UIImage(systemName: "photo")!
                    let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                    SongsRowView(albumCover: albumCover, songName: songName)
                  //  SongsRowView(songName: songName)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.cachedAudioFrame = nil
                            model.playQueue = model.songList
                            let index = getQueueIndex(songList: model.songList, currentMPMediaItem: item)
                            model.queueIndex = index
                            model.setVolumeToZero()
                            model.startFadeInTimer()
                            model.playTrack()
                        } 
                        .foregroundColor(item == model.currentMediaItem ? Color.green : colorScheme == .dark ? Color.white : Color.black)
                }
            }
            .searchable(text: $searchText)
            .listStyle(PlainListStyle())
//            .refreshable {
//                refreshState = UUID()
//            }
            .navigationTitle("Songs")
        
        if model.songList.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("Your music library is empty.")
                    Spacer()
                }
//                HStack {
//                    Text ("Add MP3s to Apple Music and then sync them to your phone through Finder.")
//                    Spacer()
//                }
                HStack {
                    Text ("As mentioned in the App Store description, for now, only local, unencrypted song files are supported. We hope to add support for streaming services in a future update.")
                    Spacer()
                }
            }
        }
    }
}


struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
            .environmentObject(Model())
    }
}
