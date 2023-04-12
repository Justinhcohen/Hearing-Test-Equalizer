//
//  PlaylistSongsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/3/23.
//

import SwiftUI
import MediaPlayer

struct PlaylistSongsView: View {
    @EnvironmentObject var model: Model
    @Environment(\.colorScheme) var colorScheme
    
    var playlistName = ""
    
    
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
    
    
    var body: some View {  
        
        Button("Shuffle Play", 
               action: {
            model.cachedAudioFrame = 0
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
                let size = CGSize(width: 30, height: 30)
                let songName = item.title
                let mediatImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                let defaultUIImage = UIImage(systemName: "photo")!
                let UIAlbumCover = mediatImage?.image(at: size) ?? defaultUIImage
                let albumCover = Image(uiImage: UIAlbumCover)
                let albumCover2 = Image(uiImage: defaultUIImage)
                SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
             //   SongsRowView(songName: songName ?? "Title Unknown")
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
        .navigationTitle(playlistName)
        .onAppear{
            print ("PLAYLIST SONGS VIEW APPEARED")
            print ("Song List Count = \(model.songList.count)")
        }
    }
}

struct PlaylistSongsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSongsView()
    }
}
