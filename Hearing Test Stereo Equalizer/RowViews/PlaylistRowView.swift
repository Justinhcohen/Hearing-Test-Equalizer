//
//  PlaylistRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/5/23.
//

import SwiftUI

struct PlaylistRowView: View {
    var albumCover: Image
    
    var playlistName: String
    
    var body: some View {
        HStack {
            albumCover
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(playlistName)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

//struct PlaylistRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistRowView()
//    }
//}
