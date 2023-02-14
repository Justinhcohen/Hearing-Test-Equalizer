//
//  PlaylistView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/6/23.
//

import SwiftUI
import MediaPlayer

struct PlaylistView: View {
    
    @EnvironmentObject var model: Model
 
    var allPlaylists: [MPMediaItemCollection] {
        let query = MPMediaQuery.playlists()
        return query.collections!
    }
    
    var body: some View {
        
        List (allPlaylists, id: \.self) { playlist in
            let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
            NavigationLink {
                PlaylistSongsView(playlistName: playlistName ?? "No Name").onAppear {
                    model.songList = playlist.items
                }
            } label: {
                HStack {    
                    Text (playlistName ?? "No Playlist Name")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Playlists")
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
