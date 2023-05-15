//
//  PlaylistView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/6/23.
//

import SwiftUI
import MediaPlayer
import MusicKit

struct PlaylistView: View {
    
    @EnvironmentObject var model: Model
    @State private var searchText = ""
  
    
    var allCollectionsFiltered: [MPMediaItemCollection] {
        var filteredMPMediaItemCollection = [MPMediaItemCollection]()
        let query = MPMediaQuery.playlists()
        let collectionsArray = query.collections! 
        var collectionCounts = [Int]()
        for collection in collectionsArray {
            var filteredCollectionItems = collection.items
            filteredCollectionItems.removeAll(where: {$0.hasProtectedAsset == true})
            filteredCollectionItems.removeAll(where: {$0.isCloudItem == true})
            collectionCounts.append (filteredCollectionItems.count)
            if filteredCollectionItems.count > 0 {
                filteredMPMediaItemCollection.append (collection)
            }
        } 
        return filteredMPMediaItemCollection
    }
    var searchResults: [MPMediaItemCollection] {
        if searchText.isEmpty {
            return allCollectionsFiltered
        } else {
            return allCollectionsFiltered.filter {($0.value(forProperty: MPMediaPlaylistPropertyName) as! String).lowercased().contains(searchText.lowercased())}
        }
    }
    
    var body: some View {
        List (searchResults, id: \.self) { collection in
            let firstTrack = collection.items[0]
            let playlistName = collection.value(forProperty: MPMediaPlaylistPropertyName) as? String
            let size = CGSize(width: 30, height: 30)
            let mediaImage = firstTrack.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
            let UIAlbumCover = mediaImage?.image(at: size)
            let defaultUIImage = UIImage(systemName: "photo")!
            let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
            NavigationLink {
//                PlaylistSongsView(playlistName: playlistName ?? "No Name").onAppear {
//                    model.songList = playlist.items
//                }
              
                SongsView(navigationTitleText: playlistName ?? "Unknown Name").onAppear {
                    model.songList = collection.items
                }
            } label: {
                HStack {    
                    CollectionRowView(collectionImage: albumCover, collectionName: playlistName ?? "Unknown name")
                }
                .contentShape(Rectangle())
            }
        }
        .searchable(text: $searchText)
        .disableAutocorrection(true)
        .listStyle(PlainListStyle())
        .navigationTitle("Playlists")
        
        if allCollectionsFiltered.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("There are no playlists.")
                    Spacer()
                }
                HStack {
                    Text ("Tap the question mark in the upper right for tips on how to add playlists.")
                    Spacer()
                }
            }
            .padding()
        }
    }
}

//struct PlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistView()
//    }
//}
