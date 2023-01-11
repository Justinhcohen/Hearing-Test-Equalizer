//
//  PlaylistView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/6/23.
//

import SwiftUI
import MediaPlayer

struct PlaylistView: View {
    
    var allPlaylists: [MPMediaItemCollection] {
        let query = MPMediaQuery.playlists()
        return query.collections!
    }
    
    var body: some View {
        
        NavigationView {
            List (allPlaylists, id: \.self) { playlist in
                let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
                
                NavigationLink {
                    SongsView(playQueue: playlist.items)
                } label: {
                    Text (playlistName ?? "No Playlist Name")
                }
                
            }
        }
        .navigationTitle("Playlists")
        
        
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
