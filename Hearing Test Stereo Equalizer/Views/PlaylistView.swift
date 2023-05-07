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
 
    var allPlaylists: [MPMediaItemCollection] {
        let query = MPMediaQuery.playlists()
        return query.collections!
    }
    
    var allPlaylistsFiltered: [MPMediaItemCollection] {
        var filteredMPMediaItemCollection = [MPMediaItemCollection]()
        let query = MPMediaQuery.playlists()
        let playlistsArray = query.collections! 
        var playlistCounts = [Int]()
        for playlist in playlistsArray {
            var filteredPlaylistItems = playlist.items
            filteredPlaylistItems.removeAll(where: {$0.hasProtectedAsset == true})
            filteredPlaylistItems.removeAll(where: {$0.isCloudItem == true})
            playlistCounts.append (filteredPlaylistItems.count)
            if filteredPlaylistItems.count > 0 {
                filteredMPMediaItemCollection.append (playlist)
            }
        } 
      //  print (playlistCounts)
        return filteredMPMediaItemCollection
    }
    
   // @State var refreshState = UUID()
       
    
//    func loadLibraryPlaylists () async throws {
//        let request = MusicLibraryRequest<Playlist>()
//        let response = try await request.response()
//        self.response = response
//    }
    
 
    
    var body: some View {
        
        List (allPlaylistsFiltered, id: \.self) { playlist in
            let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
            let size = CGSize(width: 30, height: 30)
           // let songName = item.title ?? "Unknown title"
            let firstTrack = playlist.items[0]
            let artist = firstTrack.artist ?? "Unknown Artist"
            let mediaImage = firstTrack.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
            let UIAlbumCover = mediaImage?.image(at: size)
            let defaultUIImage = UIImage(systemName: "photo")!
            let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
            NavigationLink {
                
                PlaylistSongsView(playlistName: playlistName ?? "No Name").onAppear {
                   
                    model.songList = playlist.items
                }
            } label: {
                HStack {    
                    PlaylistRowView(albumCover: albumCover, playlistName: playlistName ?? "Unknown Playlist Name")
                }
                .contentShape(Rectangle())
            }
        }
        .listStyle(PlainListStyle())
//        .refreshable {
//            let updatedAllPlaylists = allPlaylists
//            let updatedAllPlaylistsFiltered = allPlaylistsFiltered
//        }
        .navigationTitle("Playlists")
            
        
        if allPlaylists.isEmpty {
            HStack {
                Text ("You have no playlists.")
                Spacer()
            }
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
