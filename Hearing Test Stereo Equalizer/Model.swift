//
//  Model.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import Foundation
import AVKit
import MediaPlayer

class Model: ObservableObject, RemoteCommandHandler {
    
    enum NowPlayableInterruption {
        case began, ended(Bool), failed(Error)
    }
    
    enum PlayState {
        case playing, paused, stopped
    }
    
    @Published var playState: PlayState = .stopped
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    let userDefaults = UserDefaults.standard
    
    // The observer of audio session interruption notifications.
    private var interruptionObserver: NSObjectProtocol!
    private var routeChangeObserver: NSObjectProtocol!
    private var headphonesConnected = false
    
    // The handler to be invoked when an interruption begins or ends.
    private var interruptionHandler: (NowPlayableInterruption) -> Void = { _ in }
    
    var cachedAudioFrame: AVAudioFramePosition? {
        didSet {
            print ("CACHED AUDIO FRAME = \(cachedAudioFrame ?? 0)")
        }
    }
    
//    private var isInterrupted = false {
//        didSet {
//            print ("IS INTERRUPTED = \(isInterrupted)")
//        }
//    }
    
    func setInterruptionObserver () {
        let audioSession = AVAudioSession.sharedInstance()
        
        // Observe interruptions to the audio session.
        
        interruptionObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: .main) {
            [unowned self] notification in
            self.handleAudioSessionInterruption(notification: notification)
        }
    }	
    
    func setRouteChangeObserver() {
        let audioSession = AVAudioSession.sharedInstance()
        
        // Observe route change interruptions
        
        routeChangeObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) {
            [unowned self] notification in
            self.handleRouteChangeNotification(notification: notification)
        }
    }
    
    func setEnabledStatusOnRemoteCommands () {
        let rmc = MPRemoteCommandCenter.shared()
        rmc.pauseCommand.isEnabled = false
        rmc.playCommand.isEnabled = false
        rmc.stopCommand.isEnabled = false
        rmc.togglePlayPauseCommand.isEnabled = true
        rmc.nextTrackCommand.isEnabled = true
        rmc.previousTrackCommand.isEnabled = true
        rmc.changeRepeatModeCommand.isEnabled = false
        rmc.changeShuffleModeCommand.isEnabled = false
        rmc.changePlaybackRateCommand.isEnabled = false
        rmc.seekBackwardCommand.isEnabled = false
        rmc.seekForwardCommand.isEnabled = false
        rmc.skipBackwardCommand.isEnabled = false
        rmc.skipForwardCommand.isEnabled = false
        rmc.changePlaybackPositionCommand.isEnabled = false
        rmc.ratingCommand.isEnabled = false
        rmc.likeCommand.isEnabled = false
        rmc.dislikeCommand.isEnabled = false
        rmc.bookmarkCommand.isEnabled = false
        rmc.enableLanguageOptionCommand.isEnabled = false
        rmc.disableLanguageOptionCommand.isEnabled = false
    }
    
    func performRemoteCommand(_ command: RemoteCommand) {
        
        switch command {
            
        case .pause:
            print ("RECEIVED REMOTE PAUSE COMMAND")
            pauseTrack()
            
        case .play:
            print ("RECEIVED REMOTE PLAY COMMAND")
            playTrack()
            
        case .nextTrack:
            print ("RECIEVED REMOTE NEXT TRACK COMMAND")
            playNextTrack()
            
        case .previousTrack:
            print ("RECEIVED REMOTE PREVIOUS TRACK COMMAND")
            playPreviousTrack()
            
        case .togglePlayPause:
            print ("RECEIVED REMOTE TOGGLE PLAY PAUSE")
            playOrPauseCurrentTrack()
        }
    }
    
    
    func handleAudioSessionInterruption(notification: Notification) {
        print ("CALLED HANDLE AUDIO INTERRUPTION")
        guard let userInfo = notification.userInfo,
                let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
            }
        switch type {

            case .began:
            print ("INTERRUPTION BEGAN")
            playState = .stopped 
            if audioPlayerNodeL1.currentFrame > 0 {
                cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
                //isInterrupted = true
            }
            setNowPlayingMetadata()

            case .ended:
            print ("INTERRUPTION ENDED")
               // An interruption ended. Resume playback, if appropriate.

                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    playTrack()
                } else {
                    print ("I'm guessing after a call ends, we should not resume")
                    return
                }
       //     setNowPlayingMetadata()

            default: print ("WE CALLED THE DEFAULT")
            }
       // playState = .stopped 
        if audioPlayerNodeL1.currentFrame > 0 {
            cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
            //isInterrupted = true
        }
    }
    
    func handleRouteChangeNotification(notification: Notification) {
        print ("CALLED HANDLE ROUTE CHANGE")
        playState = .stopped 
        guard let userInfo = notification.userInfo,
               let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
               let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                   return
           }
           
           // Switch over the route change reason.
           switch reason {

           case .newDeviceAvailable: // New device found.
               print ("CALLED NEW DEVICE AVAILABLE")
               let session = AVAudioSession.sharedInstance()
               headphonesConnected = hasHeadphones(in: session.currentRoute)
               print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
               
               if headphonesConnected {
                   if audioPlayerNodeL1.currentFrame > 0 {
                       cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
                   }
                   setNowPlayingMetadata()
                   playTrack()
               } else {
                   if audioPlayerNodeL1.currentFrame > 0 {
                       cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
                   }
                   setNowPlayingMetadata()
               }
           
           case .oldDeviceUnavailable: // Old device removed.
               print ("CALLED NEW DEVICE AVAILABLE")
               if let previousRoute =
                   userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                   headphonesConnected = hasHeadphones(in: previousRoute)
                   print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
                   if headphonesConnected {
                       if audioPlayerNodeL1.currentFrame > 0 {
                           cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
                       }
                       setNowPlayingMetadata()
                       playTrack()
                   } else {
                       if audioPlayerNodeL1.currentFrame > 0 {
                           cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
                       }
                       setNowPlayingMetadata()
                   }
               }
           
           default: break
           }
    }
    
    func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }
    
    func printUserDefaults () {
        
     //   print ("currentProfile = \(currentProfileID)")
        print ("equalizerIsActive = \(equalizerIsActive)")
    }
    
    func readFromUserDefaults () {
        initialHearingTestHasBeenCompleted = userDefaults.bool(forKey: "initialHearingTestHasBeenCompleted")
        libraryAccessIsGranted = userDefaults.bool(forKey: "libraryAccessIsGranted")
    }
    
    func setInitialVolumeToFineTuneSoundLevel () {
        if !initialSoundLevelSet {
            audioPlayerNodeL1.volume = 0.0
            audioPlayerNodeR1.volume = 0.0
            initialSoundLevelSet = true
        }
    }
    
    // Music Player (Hearing Test is Below)
    var initialSoundLevelSet = false
    @Published var libraryAccessIsGranted = false {
        willSet {
            userDefaults.set(newValue, forKey: "libraryAccessIsGranted")
        }
    }
    @Published var currentUserProfile = UserProfile()
    @Published var currentUserProfileName = ""
    @Published var currentIntensity = 0.0
    @Published var playQueue = [MPMediaItem]()
    @Published var songList = [MPMediaItem] ()
    var currentURL: URL = URL(fileURLWithPath: "")
    @Published var queueIndex: Int = 0
   // @Published var isPlaying: Bool = false
   // @Published var isPaused: Bool = false
    @Published var timer: Timer?
    @Published var fadeInTimer: Timer?
    @Published var fadeOutTimer: Timer?
    @Published var fineTuneSoundLevel: Float = 0.0
    var fadeOutSoundLevel: Float = 0.0
    @Published var currentVolume: Float = 0.0
    @Published var systemVolume = AVAudioSession.sharedInstance().outputVolume
    var currentMediaItem = MPMediaItem()
    let audioEngine: AVAudioEngine = AVAudioEngine()
    var mixerL1 = AVAudioMixerNode()
    var mixerR1 = AVAudioMixerNode()
    var equalizerL1: AVAudioUnitEQ!
    var equalizerR1: AVAudioUnitEQ!
    let audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile!
    var bandsGain = [Float]()
    @Published var equalizerIsActive = true {
        willSet {
            userDefaults.set(newValue, forKey: "equalizerIsActive")
        }
    }
    
    
    func onSongEnd(){
        if audioPlayerNodeL1.current >= audioFile.duration {
            playNextTrack()
        }
    }
    
    func fadeInAudio () {
//        print ("CALLED FADE IN AUDIO")
//        print ("Volume in progress is \(audioPlayerNodeL1.volume)")
      
        if audioPlayerNodeL1.volume < 0.7 + (fineTuneSoundLevel * 0.003) {
          audioPlayerNodeL1.volume = min (audioPlayerNodeL1.volume + 0.05, 0.7 + (fineTuneSoundLevel * 0.003))
                audioPlayerNodeR1.volume = min (audioPlayerNodeR1.volume + 0.05, 0.7 + (fineTuneSoundLevel * 0.003))
        } else {
            fadeInComplete()
        }
    }
    
    func fadeOutAudio () {
        print ("CALLED FADE OUT AUDIO")
        
        audioPlayerNodeL1.volume = 0
        audioPlayerNodeR1.volume = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.pauseTrack()
        }        
    }
    
    func startFadeInTimer () {
        print ("CALLED START FADE IN TIMER")
        if fadeInTimer == nil {
            audioPlayerNodeL1.volume = 0
            audioPlayerNodeR1.volume = 0
            fadeInTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { _ in
                self.fadeInAudio()
            })
            fadeInTimer?.fire()
        } else {
            return
        }
    }
    
//    func startFadeOutTimer () {
//        fadeInTimer?.invalidate()
//        fadeInTimer = nil
//        if fadeOutTimer == nil {
//            fadeOutTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { _ in
//                self.fadeOutAudio()
//            })
//            fadeOutTimer?.fire()
//        }
//    }
    
    func fadeInComplete () {
        print ("CALLED FADE IN COMPLETE")
        fadeInTimer?.invalidate()
        fadeInTimer = nil
    }
    
    func fadeOutComplete () {
        print ("CALLED FADE OUT COMPLETE")
        pauseTrack()
        playState = .paused
        fadeOutTimer?.invalidate()
        fadeOutTimer = nil
    }
    
    func startTimer () {
        print ("START TIMER CALLED")
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.onSongEnd()
            })
            timer?.fire()
        } 
    }
    
    func stopTimer () {
        timer?.invalidate()
        timer = nil
    }
    
    func prepareAudioEngine () {
        
        print ("CALLED PREPARE AUDIO ENGINE")
        
    //    guard !audioEngine.isRunning else {return}
        
        let bandwidth: Float = 0.5
        let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
   //     let multiplier = Float (.intensity / 6.0)
        
        // Left Ear 
        equalizerL1 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeL1) 
        audioEngine.attach(equalizerL1) 
        audioEngine.attach(mixerL1)
        audioEngine.connect(audioPlayerNodeL1, to: mixerL1, format: nil)
        audioEngine.connect(mixerL1, to: equalizerL1, format: nil)
        audioEngine.connect(equalizerL1, to: audioEngine.mainMixerNode, format: nil)
        
        let bandsL = equalizerL1.bands
        for i in 0...(bandsL.count - 1) {
            bandsL[i].frequency = Float(freqs[i])
            bandsL[i].bypass = false
            bandsL[i].bandwidth = bandwidth
            bandsL[i].filterType = .parametric
        }
        
        // Right Ear
        equalizerR1 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeR1) 
        audioEngine.attach(equalizerR1) 
        audioEngine.attach(mixerR1)
        audioEngine.connect(audioPlayerNodeR1, to: mixerR1, format: nil)
        audioEngine.connect(mixerR1, to: equalizerR1, format: nil)
        audioEngine.connect(equalizerR1, to: audioEngine.mainMixerNode, format: nil)
        
        let bandsR = equalizerR1.bands
        for i in 0...(bandsR.count - 1) {
            bandsR[i].frequency = Float(freqs[i])
            bandsR[i].bypass = false
            bandsR[i].bandwidth = bandwidth
            bandsR[i].filterType = .parametric
        }
    } 
    
    func setEQBandsForCurrentProfile () {
        print ("CALLED SET EQ BAND FOR CURRENT PROFILE")
        
        let multiplier = equalizerIsActive ? Float (currentUserProfile.intensity / 6.0) : 0.0
        
        // Left Ear
        let bandsL = equalizerL1.bands
        bandsL[0].gain = currentUserProfile.left60 * multiplier
        bandsL[1].gain = currentUserProfile.left100 * multiplier
        bandsL[2].gain = currentUserProfile.left230 * multiplier
        bandsL[3].gain = currentUserProfile.left500 * multiplier
        bandsL[4].gain = currentUserProfile.left1100 * multiplier
        bandsL[5].gain = currentUserProfile.left2400 * multiplier
        bandsL[6].gain = currentUserProfile.left5400 * multiplier
        bandsL[7].gain = currentUserProfile.left12000 * multiplier
        
        // Right Ear
        let bandsR = equalizerR1.bands
        bandsR[0].gain = currentUserProfile.right60 * multiplier
        bandsR[1].gain = currentUserProfile.right100 * multiplier
        bandsR[2].gain = currentUserProfile.right230 * multiplier
        bandsR[3].gain = currentUserProfile.right500 * multiplier
        bandsR[4].gain = currentUserProfile.right1100 * multiplier
        bandsR[5].gain = currentUserProfile.right2400 * multiplier
        bandsR[6].gain = currentUserProfile.right5400 * multiplier
        bandsR[7].gain = currentUserProfile.right12000 * multiplier
    }
                                
    
    func getQueueIndex (playQueue: [MPMediaItem], currentMPMediaItem: MPMediaItem) -> Int {
        for i in 0...playQueue.count - 1 {
            if playQueue[i].persistentID == currentMPMediaItem.persistentID {
                queueIndex = i
                return i
            } 
        }
        return 0
    }
    
    func setNowPlayingMetadata() {
       print ("CALLED SET NOW PLAYING METADATA")
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        // Static Metadata
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = currentMediaItem.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = currentMediaItem.mediaType.rawValue
     //   nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = currentMediaItem.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentMediaItem.title ?? "Unknown title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentMediaItem.artist ?? "Uknown artist"
        nowPlayingInfo[MPMediaItemPropertyArtwork] = currentMediaItem.artwork ?? UIImage(systemName: "photo")!
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = currentMediaItem.albumArtist ?? "Uknown artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentMediaItem.albumTitle ?? "Unknown album title"
        
        // Dynamic Metadata
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioFile.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayerNodeL1.current
        switch playState {
        case .playing: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        case .paused: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        case .stopped: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func setVolumeToZero () {
        print ("CALLED SET VOLUME TO Zero")
        audioPlayerNodeL1.volume = 0.0
        audioPlayerNodeR1.volume = 0.0
    }
    
    func playTrack () {
        print ("CALLED PLAY TRACK")
        if playQueue.isEmpty {
            playQueue = songList
        }
        currentMediaItem = playQueue[queueIndex]
        
        if playState == .playing {
            self.stopTrack()
        }
        
        prepareAudioEngine() 
        setEQBandsForCurrentProfile()
        do {
            print ("Index = \(queueIndex)")
          //  let currentMPMediaItem = playQueue[queueIndex]
         //   currentPersistentID = currentMediaItem.persistentID
            if let currentURL = currentMediaItem.assetURL {
                audioFile = try AVAudioFile(forReading: currentURL)
                
                //    Start your Engines 
//                if !audioEngine.isRunning {
//                    print ("PREPAING THE AUDIO ENGINE")
                    audioEngine.prepare()
                    try audioEngine.start()
                    print ("AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
//                }
                
               

                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                // Left Ear Play
            //    audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil) 
                audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()              
                
                // Right Ear Play
           //     audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
                
                if playState != .playing {
                    print ("PLAY STATE = \(playState)")
                    playState = .playing
                   startTimer()
                }
                
            
                setNowPlayingMetadata()
                print ("PLAY STATE 2 = \(playState)")
                print ("AUDIO IS PLAYING = \(audioPlayerNodeL1.isPlaying)")
                print ("NODE VOLUME = \(audioPlayerNodeL1.volume)")
                
            }
            
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
    
    
    func stopTrack () {
        print ("CALLED STOP TRACK")
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        playState = .stopped
        setNowPlayingMetadata()
    }
    
    
    func playPreviousTrack () {
        print ("CALLED PLAY PREVIOUS TRACK")
        cachedAudioFrame = nil
//        if isInterrupted {
//            isInterrupted.toggle()
//        }
        guard queueIndex > 0 else {return}
        queueIndex -= 1
        currentMediaItem = playQueue[queueIndex]
        if playState == .playing {
            playTrack()
        } else {
            stopTrack()
        }
        setNowPlayingMetadata()
    }
    
    func playOrPauseCurrentTrack () {
        print ("CALLED PLAY OR PAUSE CURRENT TRACK")
        if playState == .stopped {
            startFadeInTimer()
            playTrack()
            startTimer()
            
        } else if playState == .paused {
            startFadeInTimer()
            unPauseTrack()
        } else {
            pauseTrack()
        }
    }
    
    func pauseTrack () {
        print ("CALLED PAUSE TRACK")
        fadeInTimer?.invalidate()
        fadeInTimer = nil
        audioPlayerNodeL1.volume = 0
        audioPlayerNodeR1.volume = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.audioPlayerNodeL1.pause()
            self.audioPlayerNodeR1.pause()
        } 
       
        playState = .paused
        setNowPlayingMetadata()
        
    }
    
    func unPauseTrack () {
        print ("CALLED UNPAUSE TRACK")
        let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
        audioPlayerNodeL1.play(at: audioTime)
        audioPlayerNodeR1.play(at: audioTime)
        playState = .playing
        setNowPlayingMetadata()
    }
    
    
    
    func playNextTrack () {
        print ("CALLED PLAY NEXT TRACK")
        print ("PLAY NEXT TRACK PLAY STATE = \(playState)")
        cachedAudioFrame = nil
//        if isInterrupted {
//            isInterrupted.toggle()
//        }
        guard queueIndex < playQueue.count - 1 else {return}
        queueIndex += 1
        currentMediaItem = playQueue[queueIndex]
        if playState == .playing {
            playTrack()
        } else {
            stopTrack()
        }
        setNowPlayingMetadata()
    }
    
//    func playNextTrackFromCallBack (_ callBack: AVAudioPlayerNodeCompletionCallbackType) {
//        
//        DispatchQueue.main.sync {
//            print ("CALLED PLAY NEXT TRACK")
//            if self.isInterrupted {
//                self.isInterrupted.toggle()
//            }
//            guard self.queueIndex < self.playQueue.count - 1 else {return}
//            self.queueIndex += 1
//            self.currentMediaItem = self.playQueue[self.queueIndex]
//            if self.playState == .playing {
//                self.playTrack()
//            } else {
//                self.stopTrack()
//            }
//            self.setNowPlayingMetadata()
//        }
//        
//    }
    
//    func receivedTrackFinishedPlaying () {
//        print ("Received Track Finished Playing")
//        playNextTrack()
//    }
    
   
    func toggleEqualizer () {
        if equalizerIsActive {
            equalizerIsActive = false
            userDefaults.set(false, forKey: "equalizerIsActive")
            print ("Equalizer is off")
        } else {
            equalizerIsActive = true
            userDefaults.set(true, forKey: "equalizerIsActive")
            print ("Equalizer is active")
        }
        setEQBasedOnEQActive(EQIsActive: equalizerIsActive)
    }

    
    func setEQBandsGainForNewProfile () {
       // var currentLowestAudibleDecibelBands = [Double]()
        var minValue = 0.0
        var maxValue = -160.0
        for i in 0...lowestAudibleDecibelBands.count - 1 {
            if lowestAudibleDecibelBands[i] < minValue {
                minValue = lowestAudibleDecibelBands[i]
            }
            if lowestAudibleDecibelBands[i] > maxValue {
                maxValue = lowestAudibleDecibelBands[i]
            }
        }
        if abs (minValue - maxValue) < 1 {
            minValue = maxValue - 1 // Avoiding dividing by zero.
        }
        let multiplier: Double = min(6.0 / abs(minValue - maxValue), 1.0)
        
        var workingBandsGain = [Float]()
        for i in 0...lowestAudibleDecibelBands.count - 1 {
            workingBandsGain.insert(Float(multiplier * abs(minValue - lowestAudibleDecibelBands[i]) ), at: i)
        }
        currentUserProfile.left60 = workingBandsGain[0]
        currentUserProfile.left100 = workingBandsGain[1]
        currentUserProfile.left230 = workingBandsGain[2]
        currentUserProfile.left500 = workingBandsGain[3]
        currentUserProfile.left1100 = workingBandsGain[4]
        currentUserProfile.left2400 = workingBandsGain[5]
        currentUserProfile.left5400 = workingBandsGain[6]
        currentUserProfile.left12000 = workingBandsGain[7]
        currentUserProfile.right60 = workingBandsGain[8]
        currentUserProfile.right100 = workingBandsGain[9]
        currentUserProfile.right230 = workingBandsGain[10]
        currentUserProfile.right500 = workingBandsGain[11]
        currentUserProfile.right1100 = workingBandsGain[12]
        currentUserProfile.right2400 = workingBandsGain[13]
        currentUserProfile.right5400 = workingBandsGain[14]
        currentUserProfile.right12000 = workingBandsGain[15]
    }
    
    func setEQBandsGainForSlider (for currentUserProfile: UserProfile) {
        if equalizerIsActive {
            let multiplier = Float (currentUserProfile.intensity / 6.0)
            let bandsL = equalizerL1.bands
            let bandsR = equalizerR1.bands
            bandsL[0].gain = currentUserProfile.left60 * multiplier
            bandsL[1].gain = currentUserProfile.left100 * multiplier
            bandsL[2].gain = currentUserProfile.left230 * multiplier
            bandsL[3].gain = currentUserProfile.left500 * multiplier
            bandsL[4].gain = currentUserProfile.left1100 * multiplier
            bandsL[5].gain = currentUserProfile.left2400 * multiplier
            bandsL[6].gain = currentUserProfile.left5400 * multiplier
            bandsL[7].gain = currentUserProfile.left12000 * multiplier
            bandsR[0].gain = currentUserProfile.right60 * multiplier
            bandsR[1].gain = currentUserProfile.right100 * multiplier
            bandsR[2].gain = currentUserProfile.right230 * multiplier
            bandsR[3].gain = currentUserProfile.right500 * multiplier
            bandsR[4].gain = currentUserProfile.right1100 * multiplier
            bandsR[5].gain = currentUserProfile.right2400 * multiplier
            bandsR[6].gain = currentUserProfile.right5400 * multiplier
            bandsR[7].gain = currentUserProfile.right12000 * multiplier
        }
    }
    
  
    
    func setEQBasedOnEQActive (EQIsActive: Bool) {
        let multiplier = Float (currentUserProfile.intensity / 6.0)
        let bandsL = equalizerL1.bands
        let bandsR = equalizerR1.bands
        if EQIsActive {
            bandsL[0].gain = currentUserProfile.left60 * multiplier
            bandsL[1].gain = currentUserProfile.left100 * multiplier
            bandsL[2].gain = currentUserProfile.left230 * multiplier
            bandsL[3].gain = currentUserProfile.left500 * multiplier
            bandsL[4].gain = currentUserProfile.left1100 * multiplier
            bandsL[5].gain = currentUserProfile.left2400 * multiplier
            bandsL[6].gain = currentUserProfile.left5400 * multiplier
            bandsL[7].gain = currentUserProfile.left12000 * multiplier
            bandsR[0].gain = currentUserProfile.right60 * multiplier
            bandsR[1].gain = currentUserProfile.right100 * multiplier
            bandsR[2].gain = currentUserProfile.right230 * multiplier
            bandsR[3].gain = currentUserProfile.right500 * multiplier
            bandsR[4].gain = currentUserProfile.right1100 * multiplier
            bandsR[5].gain = currentUserProfile.right2400 * multiplier
            bandsR[6].gain = currentUserProfile.right5400 * multiplier
            bandsR[7].gain = currentUserProfile.right12000 * multiplier
        } else {
            bandsL[0].gain = 0.0
            bandsL[1].gain = 0.0
            bandsL[2].gain = 0.0
            bandsL[3].gain = 0.0
            bandsL[4].gain = 0.0
            bandsL[5].gain = 0.0
            bandsL[6].gain = 0.0
            bandsL[7].gain = 0.0
            bandsR[0].gain = 0.0
            bandsR[1].gain = 0.0
            bandsR[2].gain = 0.0
            bandsR[3].gain = 0.0
            bandsR[4].gain = 0.0
            bandsR[5].gain = 0.0
            bandsR[6].gain = 0.0
            bandsR[7].gain = 0.0
        }
    }
    
   
    


    
    // Hearing Test Variables
    
    let bandNames = ["L60", "L100", "L230", "L500", "L1100", "L2400", "L5400", "R60", "R100", "R230", "R500", "R1100", "R2400", "R5400", "L12000", "R12000"]
    enum TestStatus {
        case testInProgress, testCompleted, practiceInProgress, practiceCompleted, stopped
    }
   // @Published var currentBand = "Ready"
    @Published var testStatus = TestStatus.stopped
    @Published var tempURL: URL = URL(fileURLWithPath: "temp")
    @Published var initialHearingTestHasBeenCompleted = false
    var tonePlayer: AVAudioPlayer?
    var currentTone = ""
    var toneIndex = 0
    var maxUnheard: Double = -160
    var minHeard: Double = 0.0
    
    
    var lowestAudibleDecibelBand60L = 0.0
    var lowestAudibleDecibelBand100L = 0.0 
    var lowestAudibleDecibelBand230L = 0.0
    var lowestAudibleDecibelBand500L = 0.0
    var lowestAudibleDecibelBand1100L = 0.0
    var lowestAudibleDecibelBand2400L = 0.0
    var lowestAudibleDecibelBand5400L = 0.0
    var lowestAudibleDecibelBand12000L = 0.0
    var lowestAudibleDecibelBand60R = 0.0 
    var lowestAudibleDecibelBand100R = 0.0
    var lowestAudibleDecibelBand230R = 0.0
    var lowestAudibleDecibelBand500R = 0.0
    var lowestAudibleDecibelBand1100R = 0.0
    var lowestAudibleDecibelBand2400R = 0.0
    var lowestAudibleDecibelBand5400R = 0.0
    var lowestAudibleDecibelBand12000R = 0.0
    var lowestAudibleDecibelBands: [Double] { [lowestAudibleDecibelBand60L, lowestAudibleDecibelBand100L, lowestAudibleDecibelBand230L, lowestAudibleDecibelBand500L, lowestAudibleDecibelBand1100L, lowestAudibleDecibelBand2400L, lowestAudibleDecibelBand5400L, lowestAudibleDecibelBand12000L, lowestAudibleDecibelBand60R, lowestAudibleDecibelBand100R, lowestAudibleDecibelBand230R, lowestAudibleDecibelBand500R, lowestAudibleDecibelBand1100R, lowestAudibleDecibelBand2400R, lowestAudibleDecibelBand5400R, lowestAudibleDecibelBand12000R]
    }
    
    
    
    
    let toneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
    
    func getVolume (decibelReduction: Double) -> Double {
        
        return (1 / pow(10,(-decibelReduction / 20)))
        
    }
    
    func assignMinHeardDecibels () {
        switch toneIndex {
        case 0: lowestAudibleDecibelBand60L = minHeard
        case 1: lowestAudibleDecibelBand100L = minHeard
        case 2: lowestAudibleDecibelBand230L = minHeard
        case 3: lowestAudibleDecibelBand500L = minHeard
        case 4: lowestAudibleDecibelBand1100L = minHeard
        case 5: lowestAudibleDecibelBand2400L = minHeard
        case 6: lowestAudibleDecibelBand5400L = minHeard
        case 7: lowestAudibleDecibelBand12000L = minHeard
        case 8: lowestAudibleDecibelBand60R = minHeard
        case 9: lowestAudibleDecibelBand100R = minHeard
        case 10: lowestAudibleDecibelBand230R = minHeard
        case 11: lowestAudibleDecibelBand500R = minHeard
        case 12: lowestAudibleDecibelBand1100R = minHeard
        case 13: lowestAudibleDecibelBand2400R = minHeard
        case 14: lowestAudibleDecibelBand5400R = minHeard
        case 15: lowestAudibleDecibelBand12000R = minHeard
        default: break
        }
    }
    
    func setCurrentTone () {
        switch toneIndex {
        case 0: currentTone = "Band60"
        case 1: currentTone = "Band100"
        case 2: currentTone = "Band230"
        case 3: currentTone = "Band500"
        case 4: currentTone = "Band1100"
        case 5: currentTone = "Band2400"
        case 6: currentTone = "Band5400"
        case 7: currentTone = "Band12000"
        case 8: currentTone = "Band60"
        case 9: currentTone = "Band100"
        case 10: currentTone = "Band230"
        case 11: currentTone = "Band500"
        case 12: currentTone = "Band1100"
        case 13: currentTone = "Band2400"
        case 14: currentTone = "Band5400"
        case 15: currentTone = "Band12000"
        default: break
        }
    }
    
//    func setCurrentBand () {
//        switch toneIndex {
//        case 0: currentBand = "Left 60"
//        case 1: currentBand = "Left 100"
//        case 2: currentBand = "Left 230"
//        case 3: currentBand = "Left 500"
//        case 4: currentBand = "Left 1100"
//        case 5: currentBand = "Left 2400"
//        case 6: currentBand = "Left 5400"
//        case 7: currentBand = "Left 12000"
//        case 8: currentBand = "Right 60"
//        case 9: currentBand = "Right 100"
//        case 10: currentBand = "Right 230"
//        case 11: currentBand = "Right 500"
//        case 12: currentBand = "Right 1100"
//        case 13: currentBand = "Right 2400"
//        case 14: currentBand = "Right 5400"
//        case 15: currentBand = "Right 12000"
//        default: break
//        }
//    }
    
    func playTone (volume: Float){
        //  print ("Called playTone")
        setCurrentTone()
      //  setCurrentBand()
        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
        do {
            tonePlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        if let tonePlayer = tonePlayer {
            //  print ("playTone second stage")
            tonePlayer.volume = volume
            tonePlayer.numberOfLoops = -1
            if toneIndex < 8 {
                tonePlayer.pan = -1
            } else {
                tonePlayer.pan = 1
            }
            print ("playTone currentTone = \(currentTone)")
            tonePlayer.play()
        }
    }
    
//    func resumeTone () {
//        if let tonePlayer = tonePlayer {
//            tonePlayer.play()
//        }
//    }
    
    func resumeTone () {
        let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        setCurrentTone()
      //  setCurrentBand()
        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
        do {
            tonePlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        if let tonePlayer = tonePlayer {
            //  print ("playTone second stage")
            tonePlayer.volume = volume
            tonePlayer.numberOfLoops = -1
            if toneIndex < 8 {
                tonePlayer.pan = -1
            } else {
                tonePlayer.pan = 1
            }
            print ("playTone currentTone = \(currentTone)")
            tonePlayer.play()
        }
    }
    
    func stopTone () {
        if let tonePlayer = tonePlayer {
            tonePlayer.stop()
        }
    }
    
    func resetMinMaxValues () {
        maxUnheard = -160
        minHeard = 0.0
    }
    

    
    func bandComplete () {
        print ("CALLED BAND COMPLETE")
        assignMinHeardDecibels()
        resetMinMaxValues()
        if toneIndex < toneArray.count - 1 {
            toneIndex += 1
            print ("bandComplete maxUnheard = \(maxUnheard)")
            print ("bandComplete minHeard = \(minHeard)")
            playTone(volume: Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2))))
            
        } else {
            toneIndex = 0
            stopTone()
            print ("Test Complete!")
            testStatus = .testCompleted
            if !initialHearingTestHasBeenCompleted {
                initialHearingTestHasBeenCompleted = true
                userDefaults.set(true, forKey: "initialHearingTestHasBeenCompleted")
            }
        }
        
    }
    
    func tapStartTest () {
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        print ("tapStartTest volume = \(currentVolume)")
        print ("tapStartTest maxUnheard = \(maxUnheard)")
        print ("tapStartTest minHeard = \(minHeard)")
    }
    
    func tapYesHeard () {
        stopTone()
        minHeard = (maxUnheard + minHeard) / 2
        if abs (maxUnheard - minHeard) < 0.5 {
            print ("tapYesHeard bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            print ("tapYesHeard volume = \(volume)")
            print ("tapYesHeard maxUnheard = \(maxUnheard)")
            print ("tapYesHeard minHeard = \(minHeard)")
            playTone(volume: volume)
        }
        
    }
    
    func tapNoDidNotHear () {
        stopTone()
        maxUnheard = (maxUnheard + minHeard) / 2
        if abs(maxUnheard - minHeard) < 0.5 {
            print ("tapNoDidNotHear bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            print ("tapNoDidNotHear volume = \(volume)")
            print ("tapNoDidNotHear tone = \(toneArray[toneIndex])")
            print ("tapNoDidNotHear maxUnheard = \(maxUnheard)")
            print ("tapNoDidNotHear minHeard = \(minHeard)")
            playTone(volume: volume)
        }
    }
    
    init() {
        setInterruptionObserver()
        setRouteChangeObserver()
        readFromUserDefaults()
        setEnabledStatusOnRemoteCommands()
        RemoteCommandCenter.handleRemoteCommands(using: self)
    }
    
}



   
