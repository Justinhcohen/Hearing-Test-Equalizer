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
            return allArtists.filter { ($0.representativeItem!.artist ?? "Unknown Artist").lowercased().contains(searchText.lowercased()) }
        }
    }
    
 //   @State var refreshState = UUID()
    
    var body: some View {
        
        List {
            ForEach (searchResults, id: \.self) {artist in
                let artistName = artist.representativeItem?.artist as? String
                let size = CGSize(width: 30, height: 30)
                let firstTrack = artist.items[0]
                let mediaImage = firstTrack.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                let UIAlbumCover = mediaImage?.image(at: size)
                let defaultUIImage = UIImage(systemName: "photo")!
                let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                NavigationLink {
                    ArtistSongsView(artistName: artistName ?? "No Name").onAppear {
                        model.songList = artist.items
                    }
                        .contentShape(Rectangle())
                } label: {
                    HStack {
                        ArtistRowView(albumCover: albumCover, artistName: artistName ?? "Unknown Artist")
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
        .navigationTitle("Artists")
        
        if allArtists.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("There are no artists.")
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

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
    }
}
