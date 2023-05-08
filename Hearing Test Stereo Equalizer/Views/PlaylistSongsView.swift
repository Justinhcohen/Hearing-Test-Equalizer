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
    
    @State private var shouldShowModalSoloSongView = false
    
    func dismiss() {
        shouldShowModalSoloSongView = false
    }
    
    func showModalSoloSongView () {
        shouldShowModalSoloSongView = true
    }
    
    func getQueueIndex (songList: [MPMediaItem], currentMPMediaItem: MPMediaItem) -> Int {
        for i in 0...songList.count - 1 {
            if songList[i] == currentMPMediaItem {
                model.queueIndex = i
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
    
    var searchResults: [MPMediaItem] {
        var filteredItems = model.songList
        filteredItems.removeAll(where: {$0.hasProtectedAsset == true})
        filteredItems.removeAll (where: {$0.isCloudItem == true})
        if searchText.isEmpty {
            return filteredItems
        } else {
            return filteredItems.filter { ($0.title ?? "Unknown Title").contains(searchText) }
        }
    }
    
    //  @State var refreshState = UUID()
    
    
    var body: some View {  
        
        Button("Shuffle Play", 
               action: {
            model.cachedAudioFrame = 0
            model.cachedAudioTime = 0
            //            model.songList = model.songList.shuffled()
            //            model.playQueue = model.songList
            model.playQueue = model.songList.shuffled()
            model.queueIndex = 0
            model.startFadeInTimer()
            model.playTrack()
            showModalSoloSongView()
        })    
        .font(.title)
        .padding ()
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.blue, lineWidth: 5)
        )
        .sheet(isPresented: $shouldShowModalSoloSongView, onDismiss: dismiss) {
            //SoloSongView(albumCover: albumCover, songName: songName, artistName: artistName)
            SoloSongView()
        }        
        ScrollViewReader { proxy in
            List {
                ForEach(searchResults, id: \.self) {item in 
                    let size = CGSize(width: 30, height: 30)
                    let songName = item.title
                    let mediatImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                    let defaultUIImage = UIImage(systemName: "photo")!
                    let UIAlbumCover = mediatImage?.image(at: size) ?? defaultUIImage
                    let albumCover = Image(uiImage: UIAlbumCover)
                    //        let albumCover2 = Image(uiImage: defaultUIImage)
                    SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
                    //   SongsRowView(songName: songName ?? "Title Unknown")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.didTapSongName = true
                            model.cachedAudioFrame = nil
                            model.cachedAudioTime = nil
                            model.playQueue = model.songList
                            let index = getQueueIndex(songList: model.songList, currentMPMediaItem: item)
                            model.queueIndex = index
                            model.setVolumeToZero()
                            model.startFadeInTimer()
                            model.playTrack()
                            showModalSoloSongView()
                        } 
                        .foregroundColor(item == model.currentMediaItem ? Color.green : colorScheme == .dark ? Color.white : Color.black) 
                    
                }     
            }
            
            .searchable(text: $searchText)
            .disableAutocorrection(true)
       
            .onChange(of: model.songName, perform: {_ in
                if !model.didTapSongName {
                    proxy.scrollTo(model.currentMediaItem, anchor: .top)
                }
            })
            .listStyle(PlainListStyle())
            .navigationTitle(playlistName)
            .onAppear{
                print ("PLAYLIST SONGS VIEW APPEARED")
                print ("Song List Count = \(model.songList.count)")
            }
        }
    }
}

struct PlaylistSongsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSongsView()
    }
}
