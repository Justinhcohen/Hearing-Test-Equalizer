//
//  RepresentedMPVolumeView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/8/23.
//

import SwiftUI
import MediaPlayer

struct RepresentedMPVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let view = MPVolumeView()
        return view
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        
    }
    
    typealias UIViewType = MPVolumeView
}

struct RepresentedMPVolumeView_Previews: PreviewProvider {
    static var previews: some View {
        RepresentedMPVolumeView()
    }
}
