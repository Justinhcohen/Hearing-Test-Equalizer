//
//  LibraryRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/6/23.
//

import SwiftUI

struct LibraryRowView: View {
    
    var image: Image
    var text: String
    
    var body: some View {
        HStack {
            image
                .foregroundColor(.red)
            
            Text(text)	
            
            Spacer()
        }
        .padding()
        .font(.title)
    }
}

struct LibraryRowView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryRowView(image: Image(systemName: "music.note.list"), text: "Playlists")
    }
}
