//
//  SoloSongView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/3/23.
//

import SwiftUI
import MediaPlayer

struct SoloSongView: View {
    
    @EnvironmentObject var model: Model
    
//   @State var albumCover: Image
//    @State var songName: String
//   @State var artistName: String
//    
//    func updateMetadata () {
//        let size = CGSize(width: 300, height: 300)
//         songName = model.currentMediaItem.title ?? "Unknown title"
//         artistName = model.currentMediaItem.artist ?? "Unknown artist"
//        let mediaImage = model.currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//        let UIAlbumCover = mediaImage?.image(at: size)
//        let defaultUIImage = UIImage(systemName: "photo")!
//         albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
//    }
    
    var body: some View {
        VStack (spacing: 30) {
            model.albumCover
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text (model.artistName)
            Text(model.songName)
//            ProgressView(value: model.currentSongTimeStatic, total: modelI'm I'm .currentSongDuration)
//                .padding()
            Spacer()
            PlayerViewSoloSong()
        }
        .onAppear {
            model.updateSongMetadata()
        }
    }
}

//struct SoloSongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoloSongView()
//    }
//}
