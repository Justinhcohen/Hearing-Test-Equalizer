//
//  ArtistSongView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/19/23.
//

import SwiftUI
import MediaPlayer

struct ArtistSongsView: View {
    @EnvironmentObject var model: Model
    @Environment(\.colorScheme) var colorScheme
    
    var artistName = ""
    
    
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
    
   // @State var refreshState = UUID()
    
    
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
                .stroke(Color.blue, lineWidth: 5)
        )        
        
        List {
            ForEach(searchResults, id: \.self) {item in 
                let size = CGSize(width: 10, height: 10)
                let songName = item.title
                let mediatImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                let UIAlbumCover = mediatImage?.image(at: size)
                let defaultUIImage = UIImage(systemName: "photo")!
                let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
         //       SongsRowView(songName: songName ?? "Title Unknown")
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
//        .refreshable {
//            refreshState = UUID()
//        }
        .navigationTitle(artistName)
    }
}

struct ArtisttSongsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSongsView()
    }
}
