//
//  Player.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/16/23.
//

import Foundation
import MediaPlayer
import SwiftUI

class Player: ObservableObject {
   
// //   var playQueue = [MPMediaItem]()
//    var currentURL: URL = URL(fileURLWithPath: "")
//    var currentPersistentID: MPMediaEntityPersistentID = UInt64()
//    var currentMediaItem = MPMediaItem()
// //   var currentUserProfile = UserProfile()
//    
//    @Published var queueIndex: Int = 0
//    @Published var isPlaying: Bool = false
//    @Published var isPaused: Bool = false
//    @Published var timer: Timer?
//    
//    let audioEngine: AVAudioEngine = AVAudioEngine()
//    var mixerL1 = AVAudioMixerNode()
//    var mixerR1 = AVAudioMixerNode()
//    var equalizerL1: AVAudioUnitEQ!
//    var equalizerR1: AVAudioUnitEQ!
//    let audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioFile: AVAudioFile!
//    var bandsGain = [Float]()
//    
//    let userDefaults = UserDefaults.standard
//    
//    let bandNames = ["L60", "L100", "L230", "L500", "L1100", "L2400", "L5400", "R60", "R100", "R230", "R500", "R1100", "R2400", "R5400", "L12000", "R12000"]
//
//    @Published var equalizerIsActive = true {
//        willSet {
//            userDefaults.set(newValue, forKey: "equalizerIsActive")
//        }
//    }
//    
//    func setEnabledStatusOnRemoteCommands () {
//        let rmc = MPRemoteCommandCenter.shared()
//        rmc.pauseCommand.isEnabled = false
//        rmc.playCommand.isEnabled = true
//        rmc.stopCommand.isEnabled = false
//        rmc.togglePlayPauseCommand.isEnabled = true
//        rmc.nextTrackCommand.isEnabled = true
//        rmc.previousTrackCommand.isEnabled = true
//        rmc.changeRepeatModeCommand.isEnabled = false
//        rmc.changeShuffleModeCommand.isEnabled = false
//        rmc.changePlaybackRateCommand.isEnabled = false
//        rmc.seekBackwardCommand.isEnabled = false
//        rmc.seekForwardCommand.isEnabled = false
//        rmc.skipBackwardCommand.isEnabled = false
//        rmc.skipForwardCommand.isEnabled = false
//        rmc.changePlaybackPositionCommand.isEnabled = false
//        rmc.ratingCommand.isEnabled = false
//        rmc.likeCommand.isEnabled = false
//        rmc.dislikeCommand.isEnabled = false
//        rmc.bookmarkCommand.isEnabled = false
//        rmc.enableLanguageOptionCommand.isEnabled = false
//        rmc.disableLanguageOptionCommand.isEnabled = false
//    }
//    
//    func activateAudioSession () {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback)
//            try audioSession.setActive(true)
//        } catch _ {
//            
//        }
//    }
//    
//    func prepareAudioEngine () {
//        
//        print ("CALLED PREPARE AUDIO ENGINE")
//        
//        guard !audioEngine.isRunning else {return}
//        
//        let bandwidth: Float = 0.5
//        let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
//   //     let multiplier = Float (.intensity / 6.0)
//        
//        // Left Ear 
//        equalizerL1 = AVAudioUnitEQ(numberOfBands: 8)
//        audioEngine.attach(audioPlayerNodeL1) 
//        audioEngine.attach(equalizerL1) 
//        audioEngine.attach(mixerL1)
//        audioEngine.connect(audioPlayerNodeL1, to: mixerL1, format: nil)
//        audioEngine.connect(mixerL1, to: equalizerL1, format: nil)
//        audioEngine.connect(equalizerL1, to: audioEngine.mainMixerNode, format: nil)
//        
//        let bandsL = equalizerL1.bands
//        for i in 0...(bandsL.count - 1) {
//            bandsL[i].frequency = Float(freqs[i])
//            bandsL[i].bypass = false
//            bandsL[i].bandwidth = bandwidth
//            bandsL[i].filterType = .parametric
//        }
//        
//        // Right Ear
//        equalizerR1 = AVAudioUnitEQ(numberOfBands: 8)
//        audioEngine.attach(audioPlayerNodeR1) 
//        audioEngine.attach(equalizerR1) 
//        audioEngine.attach(mixerR1)
//        audioEngine.connect(audioPlayerNodeR1, to: mixerR1, format: nil)
//        audioEngine.connect(mixerR1, to: equalizerR1, format: nil)
//        audioEngine.connect(equalizerR1, to: audioEngine.mainMixerNode, format: nil)
//        
//        let bandsR = equalizerR1.bands
//        for i in 0...(bandsR.count - 1) {
//            bandsR[i].frequency = Float(freqs[i])
//            bandsR[i].bypass = false
//            bandsR[i].bandwidth = bandwidth
//            bandsR[i].filterType = .parametric
//        }
//        
//    }
//    
//    func setEQBandsForCurrentProfile () {
//        print ("CALLED SET EQ BAND FOR CURRENT PROFILE")
//        
//        let multiplier = equalizerIsActive ? Float (currentUserProfile.intensity / 6.0) : 0.0
//        
//        // Left Ear
//        let bandsL = equalizerL1.bands
//        bandsL[0].gain = currentUserProfile.left60 * multiplier
//        bandsL[1].gain = currentUserProfile.left100 * multiplier
//        bandsL[2].gain = currentUserProfile.left230 * multiplier
//        bandsL[3].gain = currentUserProfile.left500 * multiplier
//        bandsL[4].gain = currentUserProfile.left1100 * multiplier
//        bandsL[5].gain = currentUserProfile.left2400 * multiplier
//        bandsL[6].gain = currentUserProfile.left5400 * multiplier
//        bandsL[7].gain = currentUserProfile.left12000 * multiplier
//        
//        // Right Ear
//        let bandsR = equalizerR1.bands
//        bandsR[0].gain = currentUserProfile.right60 * multiplier
//        bandsR[1].gain = currentUserProfile.right100 * multiplier
//        bandsR[2].gain = currentUserProfile.right230 * multiplier
//        bandsR[3].gain = currentUserProfile.right500 * multiplier
//        bandsR[4].gain = currentUserProfile.right1100 * multiplier
//        bandsR[5].gain = currentUserProfile.right2400 * multiplier
//        bandsR[6].gain = currentUserProfile.right5400 * multiplier
//        bandsR[7].gain = currentUserProfile.right12000 * multiplier
//    }
//    
//    func playTrack (for userProfile: UserProfile, with playQueue: [MPMediaItem]) {
//        
//        print ("CALLED PLAY TRACK")
//        
//        if audioPlayerNodeL1.isPlaying {
//            self.stopTrack()
//        }
//        prepareAudioEngine() 
//        setEQBandsForCurrentProfile(for: userProfile)
//        do {
//            print ("Index = \(queueIndex)")
//            let currentMPMediaItem = playQueue[queueIndex]
//            currentPersistentID = currentMPMediaItem.persistentID
//            if let currentURL = currentMPMediaItem.assetURL {
//                audioFile = try AVAudioFile(forReading: currentURL)
//                
//                //    Start your Engines 
//                if !audioEngine.isRunning {
//                    print ("PREPAING THE AUDIO ENGINE")
//                    audioEngine.prepare()
//                    try audioEngine.start()
//                    print ("AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
//                }
//
//                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
//                
//                // Left Ear Play
//                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: self.onSongEnd) 
//                audioPlayerNodeL1.pan = -1
//                audioPlayerNodeL1.play()              
//                
//                // Right Ear Play
//                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR1.pan = 1
//                audioPlayerNodeR1.play()
//                
//            }
//            
//        } catch _ {print ("Catching Audio Engine Error")}
//    }
//    
//    func toggleEqualizer (for userProfile: UserProfile) {
//        if equalizerIsActive {
//            equalizerIsActive = false
//            userDefaults.set(false, forKey: "equalizerIsActive")
//            print ("Equalizer is off")
//        } else {
//            equalizerIsActive = true
//            userDefaults.set(true, forKey: "equalizerIsActive")
//            print ("Equalizer is active")
//        }
//        setEQBandsForCurrentProfile(for: userProfile)
//    }
//    
//    func onSongEnd(for userProfile: UserProfile, with playQueue: [MPMediaItem]){
//        print ("CALLED ON SONG END")
//        if audioPlayerNodeL1.current >= audioFile.duration {
//            playNextTrack(for: userProfile, with: playQueue)
//        }
//    }
//    
//    func playOrPauseCurrentTrack (for userProfile: UserProfile, with playQueue: [MPMediaItem]) {
//        if !isPlaying && !isPaused {
//            playTrack(for: userProfile, with: playQueue)
//            isPlaying = true
//            isPaused = false
//           // startTimer()
//        } else if !isPlaying && isPaused {
//            unPauseTrack()
//            isPlaying = true
//            isPaused = false
//        } else {
//            pauseTrack()
//            isPlaying = false
//            isPaused = true
//        }
//    }
//    
//    func playNextTrack (for userProfile: UserProfile, with playQueue: [MPMediaItem]) {
//        print ("CALLED PLAYED NEXT TRACK")
//        print ("queueIndex is \(queueIndex)")
//        guard queueIndex < playQueue.count - 1 else {
//            return
//        }
//        queueIndex += 1
//        playTrack(for: userProfile, with: playQueue)
//        if !isPlaying {
//            isPlaying = true
//        }
//    }
//    
//    func playPreviousTrack (for userProfile: UserProfile, with playQueue: [MPMediaItem]) {
//         guard queueIndex > 0 else {
//             return
//         }
//         queueIndex -= 1
//        playTrack(for: userProfile, with: playQueue)
//         if !isPlaying {
//             isPlaying = true
//         }
//     }
//    
//    func pauseTrack () {
//        audioPlayerNodeL1.pause()
//        audioPlayerNodeR1.pause()
//    }
//    
//    func unPauseTrack () {
//        let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
//        audioPlayerNodeL1.play(at: audioTime)
//        audioPlayerNodeR1.play(at: audioTime)
//    }
//    
//    func stopTrack () {
//        audioPlayerNodeL1.stop()
//        audioPlayerNodeR1.stop()
//    }
//    
//    
//    
//    func assignRemoteCommands() {
//        let remoteCommandCenter = MPRemoteCommandCenter.shared()
////            remoteCommandCenter.pauseCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
////                guard let self = self else {
////                    return.noActionableNowPlayingItem
////                }
////                self.pauseTrack()
////                return.success
////            }
//        remoteCommandCenter.playCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
//            guard let self = self else {
//                return.noActionableNowPlayingItem
//            }
//            self.playOrPauseCurrentTrack()
//            return.success
//        }
////        remoteCommandCenter.stopCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
////            guard let self = self else {
////                return.noActionableNowPlayingItem
////            }
////            self.playOrPauseCurrentTrack()
////            return.success
////        }
//        remoteCommandCenter.togglePlayPauseCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
//            guard let self = self else {
//                return.noActionableNowPlayingItem
//            }
//            self.playOrPauseCurrentTrack()
//            return.success
//        }
//        remoteCommandCenter.nextTrackCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
//            guard let self = self else {
//                return.noActionableNowPlayingItem
//            }
//            self.playNextTrack()
//            return.success
//        }
//        remoteCommandCenter.previousTrackCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in 
//            guard let self = self else {
//                return.noActionableNowPlayingItem
//            }
//            self.playPreviousTrack()
//            return.success
//        }
//    }
//    
//    init () {
//        setEnabledStatusOnRemoteCommands()
//    }
    
}
