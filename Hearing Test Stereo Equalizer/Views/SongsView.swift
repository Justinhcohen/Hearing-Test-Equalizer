//
//  SongsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/3/23.
//

import SwiftUI
import MediaPlayer

struct SongsView: View {
    
    @EnvironmentObject var model: Model
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var searchText = ""
    @State private var shouldShowModalSoloSongView = false
    
    func dismiss() {
        shouldShowModalSoloSongView = false
    }
    
    func showModalSoloSongView () {
        shouldShowModalSoloSongView = true
    }
 
    func getQueueIndex (songList: [MPMediaItem], currentMPMediaItem: MPMediaItem) -> Int {
        for i in 0...songList.count - 1 {
            if songList[i] == currentMPMediaItem {
                model.queueIndex = i
                return i
            } 
        }
        return 0
    }
    
    var searchResults: [MPMediaItem] {
        if searchText.isEmpty {
            return model.songList
        } else {
            return model.songList.filter { ($0.title ?? "Unknown Title").lowercased().contains(searchText.lowercased()) }
        }
    }
    
  //  @State var refreshState = UUID()
    
    var body: some View {  
            Button("Shuffle Play", 
                   action: {
                model.cachedAudioFrame = nil
                model.cachedAudioTime = nil
               // model.songList = model.songList.shuffled()
                model.playQueue = model.songList.shuffled()
                model.queueIndex = 0
                model.startFadeInTimer()
                model.playTrack()
                showModalSoloSongView()
            })
            .font(.title)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(!model.songList.isEmpty ? .blue : .gray, lineWidth: 5)
            ) 
           .disabled(model.songList.isEmpty)
           .sheet(isPresented: $shouldShowModalSoloSongView, onDismiss: dismiss) {
               //SoloSongView(albumCover: albumCover, songName: songName, artistName: artistName)
               SoloSongView()
           }
        
        
        ScrollViewReader { proxy in
            List {
                    ForEach(searchResults, id: \.self) {item in 
                        let size = CGSize(width: 30, height: 30)
                        let songName = item.title ?? "Unknown title"
                        let mediaImage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                        let UIAlbumCover = mediaImage?.image(at: size)
                        let defaultUIImage = UIImage(systemName: "photo")!
                        let albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
                        SongsRowView(albumCover: albumCover, songName: songName)
                        //  SongsRowView(songName: songName)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                model.didTapSongName = true
                                model.cachedAudioFrame = nil
                                model.cachedAudioTime = nil
                                model.playQueue = searchResults
                                let index = getQueueIndex(songList: model.songList, currentMPMediaItem: item)
                                model.queueIndex = index
                                model.setVolumeToZero()
                                model.startFadeInTimer()
                                model.playTrack()
                                showModalSoloSongView()
                                
                            } 
                            .foregroundColor(item == model.currentMediaItem ? Color.green : colorScheme == .dark ? Color.white : Color.black)
                    }
            }
            .searchable(text: $searchText)
            .disableAutocorrection(true)
            .onChange(of: model.songName, perform: {_ in
                if !model.didTapSongName {
                    proxy.scrollTo(model.currentMediaItem, anchor: .top)
                }
            })
            .listStyle(PlainListStyle())
            //            .refreshable {
            //                refreshState = UUID()
            //            }
            .navigationTitle("Songs")
            
        }
            
        if model.songList.isEmpty {
            VStack (spacing: 30) {
                HStack {
                    Text ("Your music library is empty.")
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


//struct SongsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongsView()
//            .environmentObject(Model())
//    }
//}
