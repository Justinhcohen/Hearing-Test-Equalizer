//
//  SwiftUIView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/7/23.
//

import SwiftUI


struct SongsRowView: View {
    
    var albumCover: Image
    
    var songName: String
    
    var body: some View {
        HStack {
            albumCover
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(songName)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct SongsRowView_Previews: PreviewProvider {
    static var previews: some View {
       SongsRowView(albumCover: Image(systemName: "photo"), songName: "Cool Song")
    }
}
