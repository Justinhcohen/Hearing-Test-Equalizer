//
//  Extensions.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/7/23.
//

import Foundation
import SwiftUI
import AVKit
import MediaPlayer



extension AVAudioFile{

    var duration: TimeInterval{
        let sampleRateSong = Double(processingFormat.sampleRate)
        let lengthSongSeconds = Double(length) / sampleRateSong
        return lengthSongSeconds
    }
    
    func seek (to framePosition: AVAudioFramePosition) {
        self.framePosition = framePosition
    }

}

extension AVAudioPlayerNode{

    var current: TimeInterval{
        if let nodeTime = lastRenderTime, let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
    
    var currentFrame: AVAudioFramePosition {
        if let nodeTime = lastRenderTime,let playerTime = playerTime(forNodeTime: nodeTime) {
            return Int64(playerTime.sampleTime) 
        }
        return 0
    }
    
    
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

extension Float {
    func decimals(_ nbr: Int) -> String {
        String(self.formatted(.number.precision(.fractionLength(nbr))))
    }
}

extension Double {
    func decimals(_ nbr: Int) -> String {
        String(self.formatted(.number.precision(.fractionLength(nbr))))
    }
}

extension Formatter {
    static let positional: DateComponentsFormatter = {
        let positional = DateComponentsFormatter()
        positional.unitsStyle = .positional
        positional.zeroFormattingBehavior = .pad
        return positional
    }()
}

extension TimeInterval {
    var positionalTime: String {
        Formatter.positional.allowedUnits = self >= 3600 ?
                                            [.hour, .minute, .second] :
                                            [.minute, .second]
        let string = Formatter.positional.string(from: self)!
        return string.hasPrefix("0") && string.count > 4 ?
            .init(string.dropFirst()) : string
    }
}
