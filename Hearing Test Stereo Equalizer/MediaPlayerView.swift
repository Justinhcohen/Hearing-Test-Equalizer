//
//  MediaPlayerView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/27/22.
//

import SwiftUI
import AVKit
import MusicKit
import MediaPlayer



struct MediaPlayerView: View {
    
    @EnvironmentObject var model: Model
    
    let mediaPlayer: MPMusicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    @State var playlistGrouping: MPMediaQuery = MPMediaQuery.playlists()
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 30) {
            
            Text ("Track Name")
            
            Text ("Artist Name")
            
            HStack (spacing: 50) {
                
                Button { 
                    print ("My button tapped")
                }
            label: { 
                Image(systemName: "backward.fill")
            }
                
                Button {
                    print ("My button tapped")
                }
            label: {
                Image(systemName: "play.fill")
            }
                
                Button {
                    print ("My button tapped")
                }
            label: {
                Image(systemName: "forward.fill")
            }
            }
            .font(.largeTitle)
            
            HStack {
                Button {
                    print ("My button tapped")
                }
            label: {
                Image(systemName: "list.bullet")
            }
            .font (.largeTitle)
            } 
        }
        
        .onAppear {
            
            print ("PlayView On Appear CALLED")
            print (model.playQueue.count)
            
                        let allSongsQuery = MPMediaQuery()
                        let allSongs = allSongsQuery.collections
            
            if let allSongs = allSongs {
                print (allSongs.count)
                for i in 0...allSongs.count - 1 {
                    let workingItems = allSongs[i].items
                    for item in workingItems {
                        model.playQueue.append(item)
                    }
                }
             //   model.playQueue = allSongs[0].items
            }
            for item in model.playQueue {
                print (item.value(forProperty: "title"))
            }
        

                   
                
          
            
            
            
            
            
//            let myPlaylistQuery = MPMediaQuery.playlists()
//            let playlists = myPlaylistQuery.collections
//            for playlist in playlists! {
//                print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
//                
//                let songs = playlist.items
//                for song in songs {
//                    let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
//                    let songURL = song.value(forProperty: MPMediaItemPropertyAssetURL)
//                    print("\t\t", songTitle!, songURL!)
//                }
             //   model.currentURL = songs[1].value(forProperty: MPMediaItemPropertyAssetURL) as! URL
           // }
        }
    }
    
    func setQueue () {
        mediaPlayer.setQueue(with: playlistGrouping)
        mediaPlayer.prepareToPlay()
        mediaPlayer.play()
        
    }
    
    
    
}

struct MediaPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPlayerView()
            .environmentObject(Model())
    }
}
