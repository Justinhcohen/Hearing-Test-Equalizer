//
//  AppleMusicPlaylistSongsViiew.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 4/29/23.
//

import SwiftUI
import MediaPlayer
import MusicKit

struct AppleMusicPlaylistSongsView: View {
    @EnvironmentObject var model: Model
    @Environment(\.colorScheme) var colorScheme
    
    var playlistName = ""
    
    
    @State private var searchText = ""
 
    func getAppleMusicQueueIndex (appleMusicTrackList: MusicItemCollection<Track>, currentAppleMusicTrack: Track) -> Int {
        
        for i in 0...appleMusicTrackList.count - 1 {
            if appleMusicTrackList[i] == currentAppleMusicTrack {
                model.appleMusicQueueIndex = i
                return i
            } 
        }
        return 0
    }
    
//    var searchResults: [MPMediaItem] {
//        if searchText.isEmpty {
//            return model.songList
//        } else {
//            return model.songList.filter { $0.title!.contains(searchText) }
//        }
//    }
    
    var searchResults: [Track] {
        var allAppleMusicTracks = [Track]()
        for track in model.appleMusicTrackList {
            allAppleMusicTracks.append(track)
        }
        var filteredItems = allAppleMusicTracks
        if searchText.isEmpty {
            return filteredItems
        } else {
            return filteredItems.filter { $0.title.contains(searchText) }
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
              //  let size = CGSize(width: 30, height: 30)
                let songName = item.title
                let mediatImage = item.artwork
                let defaultUIImage = UIImage(systemName: "photo")!
          //      let UIAlbumCover = mediatImage
               // let albumCover = Image(uiImage: UIAlbumCover)
                let albumCover2 = Image(uiImage: defaultUIImage)
                SongsRowView(albumCover: albumCover2, songName: songName)
             //   SongsRowView(songName: songName ?? "Title Unknown")
                    .contentShape(Rectangle())
                    .onTapGesture {
//                        model.cachedAudioFrame = nil
//                        model.playQueue = model.songList
//                        let index = getAppleMusicQueueIndex(appleMusicTrackList: model.appleMusicTrackList, currentAppleMusicTrack: item)
//                        model.queueIndex = index
//                        model.setVolumeToZero()
//                        model.startFadeInTimer()
//                        model.playTrack()
                        print (item.description)
                        switch item {
                        case .musicVideo(let video):
                            print ("\(video)")
                        case .song(let song):
                            print ("\(song.url as Any)")
                        @unknown default:
                            break
                        }
                        
                    } 
                 //   .foregroundColor(item == model.currentMediaItem ? Color.green : colorScheme == .dark ? Color.white : Color.black) 
               
                    
            }
        }
        .searchable(text: $searchText)
        .listStyle(PlainListStyle())
        .navigationTitle(playlistName)
        .onAppear{
            print ("Apple Music PLAYLIST SONGS VIEW APPEARED")
            print ("Song List Count = \(model.songList.count)")
            print ("Apple Music Track List Count = \(model.appleMusicTrackList.count)")
        }
    }
}

struct AppleMusicPlaylistSongsViiew_Previews: PreviewProvider {
    static var previews: some View {
        AppleMusicPlaylistSongsView()
    }
}
