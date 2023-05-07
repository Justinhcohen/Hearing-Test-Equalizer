//
//  ArtistRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/5/23.
//

import SwiftUI

struct ArtistRowView: View {
    var albumCover: Image
    
    var artistName: String
    
    var body: some View {
        HStack {
            albumCover
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(artistName)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}
//
//struct ArtistRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistRowView()
//    }
//}
