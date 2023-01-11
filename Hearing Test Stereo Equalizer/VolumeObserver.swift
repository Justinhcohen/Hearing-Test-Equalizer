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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }

        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = session.outputVolume
//                print ("System Volume Changed")
//                let notification = Notification(name: Notification.Name(rawValue: "systemVolumeChanged"), object: nil, userInfo: nil)
//                NotificationCenter.default.post(notification)
            }
        }
    }

    func unsubscribe() {
        self.progressObserver.invalidate()
    }

    init() {
        subscribe()
    }
}
