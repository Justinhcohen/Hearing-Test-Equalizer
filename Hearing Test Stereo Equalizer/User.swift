//
//  User.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/13/22.
//

import Foundation
import SwiftUI
import MediaPlayer

// Save the user decibel levels to user defaults

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
