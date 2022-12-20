//
//  Play.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/5/22.
//

import Foundation
import AVKit




var player: AVAudioPlayer?

func playSound(tone: String, volume: Float) {
        guard let url = Bundle.main.url(forResource: tone, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)            
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.volume = volume
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
}
