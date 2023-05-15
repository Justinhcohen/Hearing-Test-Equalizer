//
//  AlbumRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/4/23.
//

import SwiftUI

struct AlbumRowView: View {
    
    var albumCover: Image
    var albumName: String
    
    var body: some View {
        HStack {
            albumCover
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(albumName)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

//struct AlbumRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumRowView()
//    }
//}
