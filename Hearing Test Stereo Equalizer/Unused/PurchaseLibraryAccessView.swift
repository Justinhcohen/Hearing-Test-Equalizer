//
//  PurchaseLibraryAccessView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 4/30/23.
//

import SwiftUI

struct PurchaseLibraryAccessView: View {
    var body: some View {
        VStack {
            Text("Purchase Music Library Access")
                .font(.title)
            HStack {
                Text ("Unlock access to your Music Library for a one-time purchase of $3.99. No subscription required.")
                Spacer ()
            }
            HStack {
                Text ("Final Reminder: Spex only works with DRM-free, compressed song files, such as MP3 and M4a. It DOES NOT play tracks from paid subscription servcies such as Apple Music, Spotify and Tidal.")
                Spacer ()
            }
            
        }
    }
}

struct PurchaseLibraryAccessView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseLibraryAccessView()
    }
}
