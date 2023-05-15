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
                return i
            } 
        }
        return 0
    }
    var searchResults: [MPMediaItem] {
        var filteredItems = model.songList
        filteredItems.removeAll(where: {$0.hasProtectedAsset == true})
        filteredItems.removeAll (where: {$0.isCloudItem == true})
        if searchText.isEmpty {
            return filteredItems
        } else {
            return filteredItems.filter { ($0.title ?? "Unknown Title").lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {  
        
        Button("Shuffle Play", 
               action: {
            model.tapShufflePlay(searchResults: searchResults, showModalView: showModalSoloSongView)
        })    
        .font(.title)
        .padding ()
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.blue, lineWidth: 5)
        )
        .sheet(isPresented: $shouldShowModalSoloSongView, onDismiss: dismiss) {
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
                    SongsRowView(albumCover: albumCover, songName: songName ?? "Title Unknown")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.tapSongToPlay(searchResults: searchResults, queueIndex: getQueueIndex(songList: searchResults, currentMPMediaItem: item), showModalView: showModalSoloSongView)
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
        }
    }
}

struct PlaylistSongsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSongsView()
    }
}
