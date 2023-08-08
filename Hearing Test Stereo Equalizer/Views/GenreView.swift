//
//  GenreView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/15/23.
//

import SwiftUI
import MediaPlayer

struct GenreView: View {
    @EnvironmentObject var model: Model
    var allGenres: [MPMediaItemCollection] {
        let query = MPMediaQuery.genres()
        return query.collections!
    }
    @State private var searchText = ""
    var searchResults: [MPMediaItemCollection] {
        if searchText.isEmpty {
            return allGenres
        } else {
            return allGenres.filter { ($0.representativeItem!.genre ?? "Unknown Genre").lowercased().contains(searchText.lowercased())}
        }
    }

    var body: some View {
        List {
            ForEach (searchResults, id: \.self) {genre in
                let genreName = genre.representativeItem?.genre ?? "Unknown Genre"
                let size = CGSize(width: 30, height: 30)
                let firstTrack = genre.items[0]
                let mediaImage = firstTrack.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                let UIAlbumCover = mediaImage?.image(at: size)
                let defaultUIImage = UIImage(systemName: "photo")!
                let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                NavigationLink {
//                    AlbumSongsView(albumName: combinedAlbumPlusArtist).onAppear {
//                        model.songList = album.items
//                    }
                    SongsView(navigationTitleText: genreName).onAppear {
                        model.songList = genre.items
                        if !model.audioPlayerNodeL1.isPlaying {
                            model.cachedAudioFrame = nil
                            model.playQueue = [MPMediaItem]()
                        }
                    }
                        .contentShape(Rectangle())
                } label: {
                    HStack {
                        CollectionRowView(collectionImage: albumCover, collectionName: genreName)
                        Spacer()
                    }
                }  
            }
        }
        .searchable(text: $searchText)
        .disableAutocorrection(true)
        .listStyle(PlainListStyle())
        .navigationTitle("Genres")

        if allGenres.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("There are no genres. Genres can be added to tracks in Apple's Music app.")
                    Spacer()
                }
                HStack {
                    Text ("Tap the question mark in the upper right if you would like tips on how to add songs to Spex.")
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView()
    }
}
