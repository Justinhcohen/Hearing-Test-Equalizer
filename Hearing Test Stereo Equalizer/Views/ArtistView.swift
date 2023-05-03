//
//  ArtistView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/19/23.
//

import SwiftUI
import MediaPlayer

struct ArtistView: View {
    @EnvironmentObject var model: Model
 
    var allArtists: [MPMediaItemCollection] {
        let query = MPMediaQuery.artists()
        return query.collections!
    }
    
    @State private var searchText = ""
    
    var searchResults: [MPMediaItemCollection] {
        if searchText.isEmpty {
            return allArtists
        } else {
            return allArtists.filter { $0.representativeItem!.artist!.contains(searchText) }
        }
    }
    
 //   @State var refreshState = UUID()
    
    var body: some View {
        
        List {
            ForEach (searchResults, id: \.self) {artist in
                let artistName = artist.representativeItem?.artist as? String
                NavigationLink {
                    ArtistSongsView(artistName: artistName ?? "No Name").onAppear {
                        model.songList = artist.items
                    }
                        .contentShape(Rectangle())
                } label: {
                    HStack {
                        Text (artistName ?? "No Artist Name")
                        Spacer()
                    }
                }  
            }
            
        }
        .searchable(text: $searchText)
        .listStyle(PlainListStyle())
//        .refreshable {
//            refreshState = UUID()
//        }
        .navigationTitle("Artists")
        
        if allArtists.isEmpty {
            HStack {
                Text ("You have no artists.")
                Spacer()
            }
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
    }
}
