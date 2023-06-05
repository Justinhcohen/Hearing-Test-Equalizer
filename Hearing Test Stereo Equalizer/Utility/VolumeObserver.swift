//
//  VolumeObserver.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/8/23.
//

import Foundation
import AVKit


final class VolumeObserver: ObservableObject {

    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume 
    
    let NC = NotificationCenter.default
            

    // Audio session object
    private let session = AVAudioSession.sharedInstance()

    // Observer
    private var progressObserver: NSKeyValueObservation!

    func subscribe() {
        print ("CALLED SUBSCRIBE TO VOLUME OBSERVER")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }

        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = session.outputVolume

            }
        }
    }

    func unsubscribe() {
        print ("CALLED UNSUBSCRIBE ON VOLUME OBSERVER")
        self.progressObserver.invalidate()
    }

    init() {
        print ("CALLED INIT ON VOLUME OBSERVER")
        subscribe()
    }
}
