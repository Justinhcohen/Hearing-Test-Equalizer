//
//  AlbumView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/4/23.
//

import SwiftUI
import MediaPlayer

struct AlbumView: View {
    @EnvironmentObject var model: Model
 
    var allAlbums: [MPMediaItemCollection] {
        let query = MPMediaQuery.albums()
        return query.collections!
    }
    
    @State private var searchText = ""
    
    var searchResults: [MPMediaItemCollection] {
        if searchText.isEmpty {
            return allAlbums
        } else {
            return allAlbums.filter { ($0.representativeItem!.albumTitle ?? "Unknown Album Name").lowercased().contains(searchText.lowercased()) || ($0.representativeItem!.artist ?? "Unknown Artist").lowercased().contains(searchText.lowercased())}
        }
    }
    
 //   @State var refreshState = UUID()
    
    var body: some View {
        
        List {
            ForEach (searchResults, id: \.self) {album in
                let albumName = album.representativeItem?.albumTitle ?? "Unknown Album"
                let size = CGSize(width: 30, height: 30)
               // let songName = item.title ?? "Unknown title"
                let firstTrack = album.items[0]
                let artist = firstTrack.artist ?? "Unknown Artist"
                let combinedAlbumPlusArtist = "\(albumName) - \(artist)"
                let mediaImage = firstTrack.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                let UIAlbumCover = mediaImage?.image(at: size)
                let defaultUIImage = UIImage(systemName: "photo")!
                let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                NavigationLink {
                    AlbumSongsView(albumName: combinedAlbumPlusArtist).onAppear {
                        model.songList = album.items
                    }
                        .contentShape(Rectangle())
                } label: {
                    HStack {
                        AlbumRowView(albumCover: albumCover, albumName: combinedAlbumPlusArtist)
                      //  Text (albumName ?? "No Album Name")
                        Spacer()
                    }
                }  
            }
            
        }
        .searchable(text: $searchText)
        .disableAutocorrection(true)
        .listStyle(PlainListStyle())
//        .refreshable {
//            refreshState = UUID()
//        }
        .navigationTitle("Albums")
        
        if allAlbums.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("There are no albums.")
                    Spacer()
                }
                HStack {
                    Text ("Tap the question mark in the upper right for tips on how to add songs.")
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
