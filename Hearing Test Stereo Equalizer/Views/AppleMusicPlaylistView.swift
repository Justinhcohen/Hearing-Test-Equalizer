//
//  AppleMusicPlaylistView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 4/29/23.
//

import SwiftUI
import MediaPlayer
import MusicKit

struct AppleMusicPlaylistView: View {
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
        print (playlistCounts)
        return filteredMPMediaItemCollection
    }
    
   @State var appleMusicPlaylists = MusicItemCollection<Playlist>()
       
    
    func loadLibraryPlaylists () async throws {
        let request = MusicLibraryRequest<Playlist>()
        let response = try await request.response()
        let playlists = response.items
        appleMusicPlaylists = playlists
        print (playlists[0].name)
        for playlist in playlists {
            print (playlist.name)
            
        }
        let playlist: Playlist = playlists[3]
        let detailedPlaylist = try await playlist.with([.tracks])
        if let tracks = detailedPlaylist.tracks {
            print ("Playlist tracks: \(tracks)")
        }
    }
    
    
 
    
    var body: some View {
        
        List (appleMusicPlaylists, id: \.self) { playlist in
            let playlistName = playlist.name
            NavigationLink {
                
                AppleMusicPlaylistSongsView(playlistName: playlistName).onAppear {
                    Task {
                        let detailedPlaylist = try await playlist.with([.tracks])
                        if let tracks = detailedPlaylist.tracks {
                            model.appleMusicTrackList = tracks
                        }
                    }
                }
            } label: {
                HStack {    
                    Text (playlistName)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Playlists")
        .onAppear {
            Task {
              try await loadLibraryPlaylists()
            }
        }
        
//        List (allPlaylistsFiltered, id: \.self) { playlist in
//            let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
//            NavigationLink {
//                
//                PlaylistSongsView(playlistName: playlistName ?? "No Name").onAppear {
//                   
//                    model.songList = playlist.items
//                }
//            } label: {
//                HStack {    
//                    Text (playlistName ?? "No Playlist Name")
//                    Spacer()
//                }
//                .contentShape(Rectangle())
//            }
//        }
//        .listStyle(PlainListStyle())
//        .navigationTitle("Playlists")
//        .onAppear {
//            Task {
//              try await loadLibraryPlaylists()
//            }
//        }
            
        
        if allPlaylists.isEmpty {
            HStack {
                Text ("You have no playlists.")
                Spacer()
            }
        }
    }
}

struct AppleMusicPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMusicPlaylistView()
    }
}
