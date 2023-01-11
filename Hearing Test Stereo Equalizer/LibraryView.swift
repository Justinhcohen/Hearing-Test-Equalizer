//
//  LibraryView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/3/23.
//

import SwiftUI
import MediaPlayer



struct LibraryView: View {
    
   
    
    var allSongs: [MPMediaItem] {
        let query = MPMediaQuery()
        let filterOnDownloaded: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: false, forProperty: "isCloudItem")
        query.addFilterPredicate(filterOnDownloaded)
        return query.items!
    }
    
    var body: some View {
        NavigationStack {
            List {
                    
                NavigationLink {
                    PlaylistView()
                } label: {
                    LibraryRowView(image: Image(systemName: "music.note.list"), text: "Playlists")
                }
                NavigationLink {
                    SongsView(playQueue: allSongs)
                } label: {
                    LibraryRowView(image: Image(systemName: "music.note"), text: "Songs")
                }
                
            }
            .navigationTitle("Library")
        }
       
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
