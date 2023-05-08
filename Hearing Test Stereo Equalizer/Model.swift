//
//  Model.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import Foundation
import AVKit
import MediaPlayer
import MusicKit
import SwiftUI

class Model: ObservableObject, RemoteCommandHandler {
    
    enum NowPlayableInterruption {
        case began, ended(Bool), failed(Error)
    }
    
    enum PlayState {
        case playing, paused, stopped
    }
    
    @Published var playState: PlayState = .stopped
    @Published var demoIsPlaying = false
    @Published var didViewMusicLibrary = false
    
    @Published var albumCover = Image(systemName: "photo")
     @Published var songName = ""
    @Published var artistName = ""
    @Published var albumName = ""
    @Published var currentSongTime: TimeInterval = 0
    @Published var currentSongTimeStatic: TimeInterval = 0
    @Published var currentSongDuration: TimeInterval = 0
    @Published var didTapSongName = false {
        didSet {
            print ("didTapSongName = \(didTapSongName)")
        }
    }
    
    // Settings
    
    @Published var showPlaytimeSlider = true {
        willSet {
            userDefaults.set(newValue, forKey: "showPlaytimeSlider")
        }
    }
    @Published var showSpexToggle = true {
        willSet {
            userDefaults.set(newValue, forKey: "showSpexToggle")
        }
    }
    @Published var showSubtleVolumeSlider = true {
        willSet {
            userDefaults.set(newValue, forKey: "showSubtleVolumeSlider")
        }
    }
    @Published var showDemoSongButtons = true {
        willSet {
            userDefaults.set(newValue, forKey: "showDemoSongButtons")
        }
    }
    @Published var showManualAdjustmentsButton = true {
        willSet {
            userDefaults.set(newValue, forKey: "showManualAdjustmentsButton")
        }
    }
    @Published var showSongInformation = true {
        willSet {
            userDefaults.set(newValue, forKey: "showSongInformation")
        }
    }
    @Published var showAirPlayButton = true {
        willSet {
            userDefaults.set(newValue, forKey: "showAirPlayButton")
        }
    }
    @Published var practiceToneBeforeTest = false {
        willSet {
            userDefaults.set(newValue, forKey: "practiceToneBeforeTest")
        }
    }
    
    
     
     func updateSongMetadata () {
         let size = CGSize(width: 1284, height: 1284)
          songName = currentMediaItem.title ?? "Unknown title"
          artistName = currentMediaItem.artist ?? "Unknown artist"
         albumName = currentMediaItem.albumTitle ?? "Unknown album"
         let mediaImage = currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
         let UIAlbumCover = mediaImage?.image(at: size)
         let defaultUIImage = UIImage(systemName: "photo")!
          albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
         currentSongTime = audioPlayerNodeL1.current + (cachedAudioTime ?? 0)
         currentSongTimeStatic = max (currentSongTime, currentSongTimeStatic)
         currentSongDuration = audioFile.duration
//         print ("On updateSongMetadata, currentSongTimeStatic = \(currentSongTimeStatic)")
//         print ("On updateSongMetaData, audioPlayNodeL1.current = \(audioPlayerNodeL1.current)")
//         print ("On updateSongMetaData, currentSongTime = \(currentSongTime)")
     }
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    let userDefaults = UserDefaults.standard
    
    // The observer of audio session interruption notifications.
    private var interruptionObserver: NSObjectProtocol!
    private var routeChangeObserver: NSObjectProtocol!
    private var headphonesConnected = false
    
    // The handler to be invoked when an interruption begins or ends.
    private var interruptionHandler: (NowPlayableInterruption) -> Void = { _ in }
    
    @Published var cachedAudioFrame: AVAudioFramePosition? {
        didSet {
            print ("CACHED AUDIO FRAME = \(cachedAudioFrame ?? 0)")
        }
    }
    
    @Published var cachedAudioTime: TimeInterval? = 0
    
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
      //  let audioSession = AVAudioSession.sharedInstance()
        
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
            playOrPauseCurrentTrack()
            
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
        print ("HANDLE AUDIO INTERRUPTION")
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
                cachedAudioTime = audioPlayerNodeL1.current
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
            cachedAudioTime = audioPlayerNodeL1.current
            //isInterrupted = true
        }
    }
    
//    func handleRouteChangeNotification(notification: Notification) {
//        guard audioPlayerNodeL1.isPlaying else {return}
//       // guard !songList.isEmpty else {return}
//        print ("HANDLE ROUTE CHANGE")
//        playState = .stopped 
//        guard let userInfo = notification.userInfo,
//               let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
//               let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
//                   return
//           }
//           
//           // Switch over the route change reason.
//           switch reason {
//
//           case .newDeviceAvailable: // New device found.
//               print ("CALLED NEW DEVICE AVAILABLE")
//               let session = AVAudioSession.sharedInstance()
//               headphonesConnected = hasHeadphones(in: session.currentRoute)
//               print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
// 
//                   if audioPlayerNodeL1.currentFrame > 0 {
//                       cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
//                       cachedAudioTime = audioPlayerNodeL1.current
//                   }
//                    playOrPauseCurrentTrack()
//                   setNowPlayingMetadata()
//                  
//                   //playTrack()
//           
//           case .oldDeviceUnavailable: // Old device removed.
//               print ("CALLED OLD DEVEICE UNAVAILABLE")
//               if let previousRoute =
//                   userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
//                   headphonesConnected = hasHeadphones(in: previousRoute)
//                   print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
//                   if headphonesConnected {
//                       if audioPlayerNodeL1.currentFrame > 0 {
//                           cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
//                           cachedAudioTime = audioPlayerNodeL1.current
//                       }
//                       print ("Headphones are connected and calling play or pause current track.")
//                       playOrPauseCurrentTrack()
//                       setNowPlayingMetadata()
//                       
//                       //playTrack()
//                   } else {
//                       if audioPlayerNodeL1.currentFrame > 0 {
//                           cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
//                           cachedAudioTime = audioPlayerNodeL1.current
//                       }
//                       print ("Headphones are not conencted and calling play or pause current track. Playstate = \(playState)")
//                    //   playOrPauseCurrentTrack()
//                       setNowPlayingMetadata()
//                   }
//               }
//           
//           default: break
//           }
//    }
    
    func handleRouteChangeNotification(notification: Notification) {
        print ("HANDLING ROUTE CHANGE NOTIFICATION")
        guard audioEngine.isRunning else {return}
        // stopTrackAfterSeek()
        if playState == .playing {
            playOrPauseCurrentTrack()
        }
//        switch playState {
//        case .paused:
//            break
//        case .stopped:
//            break
//        case .playing:
//            print ("PLAY STATE IS \(playState)")
//            guard let userInfo = notification.userInfo,
//                          let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
//                          let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
//                              return
//                      }
//            switch reason {
//
//            case .newDeviceAvailable: // New device found.
//                print ("REASON IS NEW DEVICE AVAILABLE")
////                print ("CALLED NEW DEVICE AVAILABLE")
////                let session = AVAudioSession.sharedInstance()
////                headphonesConnected = hasHeadphones(in: session.currentRoute)
////                print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
////  
////                    if audioPlayerNodeL1.currentFrame > 0 {
////                        cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
////                        cachedAudioTime = audioPlayerNodeL1.current
////                    }
//                     playTrackAfterSeek()
//                   
//                    //playTrack()
//            
//            case .oldDeviceUnavailable: // Old device removed.
//                print ("CALLED OLD DEVEICE UNAVAILABLE")
//                if let previousRoute =
//                    userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
//                    headphonesConnected = hasHeadphones(in: previousRoute)
//                    print ("HEAD PHONES CONNECTED = \(headphonesConnected)")
//                    stopTrackAfterSeek()
////                    if headphonesConnected {
////                        if audioPlayerNodeL1.currentFrame > 0 {
////                            cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
////                            cachedAudioTime = audioPlayerNodeL1.current
////                        }
////                        print ("Headphones are connected and calling play or pause current track.")
////                        playOrPauseCurrentTrack()
////                        setNowPlayingMetadata()
////                        
////                        //playTrack()
////                    } else {
////                        if audioPlayerNodeL1.currentFrame > 0 {
////                            cachedAudioFrame = (cachedAudioFrame ?? 0) + Int64(audioPlayerNodeL1.currentFrame)
////                            cachedAudioTime = audioPlayerNodeL1.current
////                        }
////                        print ("Headphones are not conencted and calling play or pause current track. Playstate = \(playState)")
////                     //   playOrPauseCurrentTrack()
////                        setNowPlayingMetadata()
////                    }
//                }
//            
//            default: break
//            }
//        }
        
           
    }
    
    func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }
    
    func printUserDefaults () {
        
     //   print ("currentProfile = \(currentProfileID)")
        print ("equalizerIsActive = \(equalizerIsActive)")
    }
    
    func registerUserDefaults () {
        userDefaults.register(
            defaults: [
                "equalizerIsActive": true,
                "manualAdjustmentsAreActive": true,
                "showPlaytimeSlider": true,
                "showSpexToggle": true,
                "showSubtleVolumeSlider": true,
                "showDemoSongButtons": true,
                "showManualAdjustmentsButton": true,
                "showSongInformation": true,
                "showAirPlayButton": true
            ]
        )
    }
    
    func readFromUserDefaults () {
        print ("CALLED READ FROM USER DEFAULTS")
        initialHearingTestHasBeenCompleted = userDefaults.bool(forKey: "initialHearingTestHasBeenCompleted")
        libraryAccessIsGranted = userDefaults.bool(forKey: "libraryAccessIsGranted")
        equalizerIsActive = userDefaults.bool(forKey: "equalizerIsActive")
        manualAdjustmentsAreActive = userDefaults.bool(forKey: "manualAdjustmentsAreActive")
        currentUserProfileName = userDefaults.string(forKey: "currentUserProfileName") ?? "There is no name"
        fineTuneSoundLevel = userDefaults.float(forKey: "fineTuneSoundLevel")
        showPlaytimeSlider = userDefaults.bool(forKey: "showPlaytimeSlider")
        showSpexToggle = userDefaults.bool(forKey: "showSpexToggle")
        showSubtleVolumeSlider = userDefaults.bool(forKey: "showSubtleVolumeSlider")
        showDemoSongButtons = userDefaults.bool(forKey: "showDemoSongButtons")
        showManualAdjustmentsButton = userDefaults.bool(forKey: "showManualAdjustmentsButton")
        showSongInformation = userDefaults.bool(forKey: "showSongInformation")
        showAirPlayButton = userDefaults.bool(forKey: "showAirPlayButton")
        practiceToneBeforeTest = userDefaults.bool(forKey: "practiceToneBeforeTest")
        print ("Equalizer is active = \(equalizerIsActive)")
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
    @Published var currentUserProfileName = "" {
        willSet {
            userDefaults.set(newValue, forKey: "currentUserProfileName")
            print ("Setting currentUserProfileName to \(newValue)")
        }
    }
    @Published var currentIntensity = 0.0
    @Published var playQueue = [MPMediaItem]()
    @Published var songList = [MPMediaItem]() {
        willSet {
            print ("songList new value count = \(newValue.count)")
        }
    }
    @Published var appleMusicTrackList = MusicItemCollection<Track>() {
        willSet {
            print ("appleMusicTrackList new value count = \(newValue.count)")
        }
    }
    
    var currentURL: URL = URL(fileURLWithPath: "")
    @Published var queueIndex: Int = 0
    @Published var appleMusicQueueIndex: Int = 0
   // @Published var isPlaying: Bool = false
   // @Published var isPaused: Bool = false
    @Published var timer: Timer?
    @Published var fadeInTimer: Timer?
    @Published var fadeOutTimer: Timer?
    @Published var fineTuneSoundLevel: Float = 0.0 {
        didSet {
            userDefaults.set(fineTuneSoundLevel, forKey: "fineTuneSoundLevel")
        }
    }
    var fadeOutSoundLevel: Float = 0.0
    @Published var currentVolume: Float = 0.0
    @Published var systemVolume = AVAudioSession.sharedInstance().outputVolume
    @Published var currentMediaItem = MPMediaItem()
   // var currentAppleMusicTrack = Track.song(<#Song#>)
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
            print ("Setting Equalizer is active to \(newValue)")
        }
    }
    @Published var manualAdjustmentsAreActive = false {
        willSet {
            userDefaults.set(newValue, forKey: "manualAdjustmentsAreActive")
        }
    }
    
    
    func playbackTimer(){
        updateSongMetadata()
        if didTapSongName {
            didTapSongName = false
        }
     
        if currentSongTime >= audioFile.duration {
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
    
    func startPlaybackTimer () {
        print ("START TIMER CALLED")
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.playbackTimer()
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
        guard !songList.isEmpty else {return}
        print ("CALLED SET NOW PLAYING METADATA, playState = \(playState)")
        if playState == .playing {
            updateSongMetadata()
        }
       print ("CALLED SET NOW PLAYING METADATA")
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
      //  var mpNowPlayingPlaybackState = MPNowPlayingPlaybackState(rawValue: 1)
        
        // Static Metadata
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = currentMediaItem.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = currentMediaItem.mediaType.rawValue
     //   nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = currentMediaItem.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentMediaItem.title ?? "Unknown title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentMediaItem.artist ?? "Unknown artist"
        let defaultImage = UIImage(systemName: "photo")!
        let defaultArtwork = MPMediaItemArtwork (boundsSize: defaultImage.size, requestHandler: { (size) -> UIImage in
            return defaultImage
        })
        nowPlayingInfo[MPMediaItemPropertyArtwork] = currentMediaItem.artwork ?? defaultArtwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = currentMediaItem.albumArtist ?? "Uknown artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentMediaItem.albumTitle ?? "Unknown album title"
        
        // Dynamic Metadata
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioFile.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayerNodeL1.current
        switch playState {
        case .playing: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
//            nowPlayingInfoCenter.playbackState = .playing
//            mpNowPlayingPlaybackState = .playing
             print ("The nowPlayingPlayback rate should now be 1.0")
        case .paused: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
//            nowPlayingInfoCenter.playbackState = .paused
//            mpNowPlayingPlaybackState = .paused
            print ("The nowPlayingPlayback rate should now be 0")

        case .stopped: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
//            nowPlayingInfoCenter.playbackState = .stopped
//            mpNowPlayingPlaybackState = .stopped
            print ("The nowPlayingPlayback rate should now be 0")
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
        currentSongTimeStatic = 0
        isPlayingDemoOne = false
        isPlayingDemoTwo = false
        if playQueue.isEmpty {
            playQueue = songList
        }
        currentMediaItem = playQueue[queueIndex]
        
        if (playState == .playing || playState == .paused)  {
            self.stopTrack()
        }
        
        if demoIsPlaying {
            demoIsPlaying = false
        }
        
        if !audioEngine.isRunning {
            prepareAudioEngine() 
            print ("PREPARE AUDIO ENGINE WAS CALLED")
            print ("AFTER PREPARING, AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
        }
        
        
        setEQBands(for: currentUserProfile)
        
      
        do {
            print ("Index = \(queueIndex)")
          //  let currentMPMediaItem = playQueue[queueIndex]
         //   currentPersistentID = currentMediaItem.persistentID
            if let currentURL = currentMediaItem.assetURL {
                audioFile = try AVAudioFile(forReading: currentURL)
                 
                //    Start your Engines 
//                if !audioEngine.isRunning {
//                    print ("PREPAING THE AUDIO ENGINE")
                if !audioEngine.isRunning {
                    audioEngine.prepare()
                    print ("I PREPARED THE AUDIO ENGINE")
                    try audioEngine.start()
                    print ("I TRIED TO START THE AUDIO ENGINE.")
                    print ("AFTER STARTING, AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
                } else {
                    print ("The audio engine is already running.")
                }
//                }
                
               

                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                guard audioEngine.isRunning else {
                    print ("THE AUDIO ENGINE WASN'T RUNNING")
                    return
                }
                
                // Left Ear Play
            //    audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil) 
//                audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
//                audioPlayerNodeL1.pan = -1
//                audioPlayerNodeL1.play()  
//                
//                
//                // Right Ear Play
//           //     audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
//                audioPlayerNodeR1.pan = 1
//                audioPlayerNodeR1.play()
                
              
               
                    stopTrack()
                    audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeL1.pan = -1
                    audioPlayerNodeL1.play()  
                    
                    
                    // Right Ear Play
               //     audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                    audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeR1.pan = 1
                    audioPlayerNodeR1.play()
                    playState = .playing
                    startPlaybackTimer()
                
                
//                if playState != .playing {
//                    print ("PLAY STATE = \(playState)")
//                    playState = .playing 
//                   startTimer()
//                }
                
            
                setNowPlayingMetadata()
                print ("PLAY STATE 2 = \(playState)")
                print ("AUDIO IS PLAYING = \(audioPlayerNodeL1.isPlaying)")
                print ("NODE VOLUME = \(audioPlayerNodeL1.volume)")
                
            }
            
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
    func playTrackAfterSeek () {
        print ("CALLED PLAY TRACK AFTER SEEK")
        isPlayingDemoOne = false
        isPlayingDemoTwo = false
        if playQueue.isEmpty {
            playQueue = songList
        }
        currentMediaItem = playQueue[queueIndex]
        
//        if (playState == .playing || playState == .paused) {
//            self.stopTrackAfterSeek()
//        }
        
        if demoIsPlaying {
            demoIsPlaying = false
        }
        
        if !audioEngine.isRunning {
            prepareAudioEngine() 
            print ("PREPARE AUDIO ENGINE WAS CALLED")
            print ("AFTER PREPARING, AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
        }
        
        
        setEQBands(for: currentUserProfile)
        
      
        do {
            print ("Index = \(queueIndex)")
          //  let currentMPMediaItem = playQueue[queueIndex]
         //   currentPersistentID = currentMediaItem.persistentID
            if let currentURL = currentMediaItem.assetURL {
                audioFile = try AVAudioFile(forReading: currentURL)
                 
                //    Start your Engines 
//                if !audioEngine.isRunning {
//                    print ("PREPAING THE AUDIO ENGINE")
                if !audioEngine.isRunning {
                    audioEngine.prepare()
                    print ("I PREPARED THE AUDIO ENGINE")
                    try audioEngine.start()
                    print ("I TRIED TO START THE AUDIO ENGINE.")
                    print ("AFTER STARTING, AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
                } else {
                    print ("The audio engine is already running.")
                }
//                }
                
               

                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                guard audioEngine.isRunning else {
                    print ("THE AUDIO ENGINE WASN'T RUNNING")
                    return
                }
                
                // Left Ear Play
            //    audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil) 
//                audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
//                audioPlayerNodeL1.pan = -1
//                audioPlayerNodeL1.play()  
//                
//                
//                // Right Ear Play
//           //     audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
//                audioPlayerNodeR1.pan = 1
//                audioPlayerNodeR1.play()
                
//                switch playState {
//                case .stopped:
//                    playState = .playing
//                    startPlaybackTimer()
//                case .paused:
//                    playState = .playing
//                case .playing: 
//                    playState = .paused
//                }
                
                switch playState {
                case .stopped:
//                    playState = .playing
//                    startPlaybackTimer()
                    break
                case .paused:
                    stopTrackAfterSeek()
                    break
                   // playState = .playing
                case .playing: 
                    stopTrackAfterSeek()
                    playState = .playing
                    startPlaybackTimer()
                    audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeL1.pan = -1
                    audioPlayerNodeL1.play()  
                    
                    
                    // Right Ear Play
               //     audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                    audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeR1.pan = 1
                    audioPlayerNodeR1.play()
                    
                   
                }
                
//                if playState != .playing {
//                    print ("PLAY STATE = \(playState)")
//                    playState = .playing 
//                   startTimer()
//                }
                
            
                setNowPlayingMetadata()
                print ("PLAY STATE 2 = \(playState)")
                print ("AUDIO IS PLAYING = \(audioPlayerNodeL1.isPlaying)")
                print ("NODE VOLUME = \(audioPlayerNodeL1.volume)")
                
            }
            
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
  
    enum DemoTrack {
        case trackOne, trackTwo, trackThree
    }
    var demoTrack = DemoTrack.trackOne
    @Published var isPlayingDemoOne = false
    @Published var isPlayingDemoTwo = false
    @Published var isPlayingDemoThree = false
    
    func playDemoTrack () {
        print ("CALLED PLAY DEMO TRACK")
        playState = .stopped
        stopTrack()
        stopDemoTrack()
        var demoTrackName = ""
        switch demoTrack {
        case .trackOne:
            demoTrackName = "twinsmusic-dancinginthesand"
            isPlayingDemoOne = true 
        case .trackTwo:
            demoTrackName = "Evert Zeevalkink - On The Roads"
            isPlayingDemoTwo = true
        case .trackThree:
            demoTrackName = "indiebox-funkhouse"
            isPlayingDemoThree = true
        }
        playQueue = [MPMediaItem]()
        songList = [MPMediaItem]()
        demoIsPlaying = true
        prepareAudioEngine() 
        setEQBands(for: currentUserProfile)
        do {
            print ("Index = \(queueIndex)")
             let currentURL = Bundle.main.url(forResource: demoTrackName, withExtension: "mp3")
           
            audioFile = try AVAudioFile(forReading: currentURL!)

                    audioEngine.prepare()
            if !audioEngine.isRunning {
                try audioEngine.start()
                print ("Tried to start audio engine for the demo song. AUDIO ENGINE IS RUNNING = \(audioEngine.isRunning)")
            } else {
                print ("The audio engine is already running for the demo song.")
            }

                
            guard audioEngine.isRunning else {
                print ("THE AUDIO ENGINE WASN'T RUNNING")
                return
            }

                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                

                audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()  
                

                audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
            
            startFadeInTimer()
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
    func stopDemoTrack () {
        print ("CALLED STOP DEMO TRACK")
        isPlayingDemoOne = false
        isPlayingDemoTwo = false
        isPlayingDemoThree = false
        playQueue = [MPMediaItem]()
        songList = [MPMediaItem]()
        demoIsPlaying = false
        fadeInComplete()
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
    }
    
    
    
    func stopTrack () {
        print ("CALLED STOP TRACK")
        currentSongTimeStatic = 0
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        playState = .stopped
        setNowPlayingMetadata()
    }
    
    func stopTrackAfterSeek () {
        print ("CALLED STOP TRACK AFTER SEEK")
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        playState = .stopped
        setNowPlayingMetadata()
    }
    
    
    
    
    func playPreviousTrack () {
        print ("CALLED PLAY PREVIOUS TRACK")
        cachedAudioFrame = nil
        cachedAudioTime = nil
        guard queueIndex > 0 else {return}
        if audioPlayerNodeL1.current < 2.0 {
            queueIndex -= 1
        }
        currentMediaItem = playQueue[queueIndex]
        if playState == .playing {
            playTrack()
        } else {
            stopTrack()
        }
        setNowPlayingMetadata()
    }
    
    func togglePlayPauseRemote () {
        let togglePlayPauseRemoteCommand = RemoteCommand.togglePlayPause
        performRemoteCommand(togglePlayPauseRemoteCommand)
    }
    
    func playOrPauseCurrentTrack () {
        print ("CALLED PLAY OR PAUSE CURRENT TRACK")
        guard !songList.isEmpty else {return}
        if playState == .stopped {
            startFadeInTimer()
            playTrack()
            startPlaybackTimer()
            
        } else if playState == .paused {
            startFadeInTimer()
            unPauseTrack()
        } else {
            pauseTrack()
        }
    }
    
    func pauseTrack () {
        guard !songList.isEmpty else {return}
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
        guard !songList.isEmpty else {return}
        print ("CALLED UNPAUSE TRACK")
        let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
        if !audioEngine.isRunning {
            audioEngine.prepare()
            do {
                try audioEngine.start()  
            } catch {
                 print ("Catching Audio Engine Error")
            }
        }
        guard audioEngine.isRunning else {return}
        audioPlayerNodeL1.play(at: audioTime)
        audioPlayerNodeR1.play(at: audioTime)
        playState = .playing
        setNowPlayingMetadata()
    } 

    
    
    
    func playNextTrack () {
        print ("CALLED PLAY NEXT TRACK")
        print ("PLAY NEXT TRACK PLAY STATE = \(playState)")
        cachedAudioFrame = nil
        cachedAudioTime = nil
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
    
    
    func setEQBands (for currentUserProfile: UserProfile) {
        let multiplier = Float (currentUserProfile.intensity / 6.0)
        if equalizerL1 == nil {
            prepareAudioEngine()
        }
        let bandsL = equalizerL1.bands
        let bandsR = equalizerR1.bands
        if equalizerIsActive && manualAdjustmentsAreActive {
            bandsL[0].gain = (currentUserProfile.left60 * multiplier) + currentUserProfile.left60M
            bandsL[1].gain = (currentUserProfile.left100 * multiplier) + currentUserProfile.left100M
            bandsL[2].gain = (currentUserProfile.left230 * multiplier) + currentUserProfile.left230M
            bandsL[3].gain = (currentUserProfile.left500 * multiplier) + currentUserProfile.left500M
            bandsL[4].gain = (currentUserProfile.left1100 * multiplier) + currentUserProfile.left1100M
            bandsL[5].gain = (currentUserProfile.left2400 * multiplier) + currentUserProfile.left2400M
            bandsL[6].gain = (currentUserProfile.left5400 * multiplier) + currentUserProfile.left5400M
            bandsL[7].gain = (currentUserProfile.left12000 * multiplier) + currentUserProfile.left12000M
            bandsR[0].gain = (currentUserProfile.right60 * multiplier) + currentUserProfile.right60M
            bandsR[1].gain = (currentUserProfile.right100 * multiplier) + currentUserProfile.right100M
            bandsR[2].gain = (currentUserProfile.right230 * multiplier) + currentUserProfile.right230M
            bandsR[3].gain = (currentUserProfile.right500 * multiplier) + currentUserProfile.right500M
            bandsR[4].gain = (currentUserProfile.right1100 * multiplier) + currentUserProfile.right1100M
            bandsR[5].gain = (currentUserProfile.right2400 * multiplier) + currentUserProfile.right2400M
            bandsR[6].gain = (currentUserProfile.right5400 * multiplier) + currentUserProfile.right5400M
            bandsR[7].gain = (currentUserProfile.right12000 * multiplier) + currentUserProfile.right12000M
        }
        else if equalizerIsActive {
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
    
//    func setEQBandsGainForSlider (for currentUserProfile: UserProfile) {
//        let multiplier = Float (currentUserProfile.intensity / 6.0)
//        let bandsL = equalizerL1.bands
//        let bandsR = equalizerR1.bands
//        if equalizerIsActive {
//            bandsL[0].gain = currentUserProfile.left60 * multiplier
//            bandsL[1].gain = currentUserProfile.left100 * multiplier
//            bandsL[2].gain = currentUserProfile.left230 * multiplier
//            bandsL[3].gain = currentUserProfile.left500 * multiplier
//            bandsL[4].gain = currentUserProfile.left1100 * multiplier
//            bandsL[5].gain = currentUserProfile.left2400 * multiplier
//            bandsL[6].gain = currentUserProfile.left5400 * multiplier
//            bandsL[7].gain = currentUserProfile.left12000 * multiplier
//            bandsR[0].gain = currentUserProfile.right60 * multiplier
//            bandsR[1].gain = currentUserProfile.right100 * multiplier
//            bandsR[2].gain = currentUserProfile.right230 * multiplier
//            bandsR[3].gain = currentUserProfile.right500 * multiplier
//            bandsR[4].gain = currentUserProfile.right1100 * multiplier
//            bandsR[5].gain = currentUserProfile.right2400 * multiplier
//            bandsR[6].gain = currentUserProfile.right5400 * multiplier
//            bandsR[7].gain = currentUserProfile.right12000 * multiplier
//        } else {
//            bandsL[0].gain = 0.0
//            bandsL[1].gain = 0.0
//            bandsL[2].gain = 0.0
//            bandsL[3].gain = 0.0
//            bandsL[4].gain = 0.0
//            bandsL[5].gain = 0.0
//            bandsL[6].gain = 0.0
//            bandsL[7].gain = 0.0
//            bandsR[0].gain = 0.0
//            bandsR[1].gain = 0.0
//            bandsR[2].gain = 0.0
//            bandsR[3].gain = 0.0
//            bandsR[4].gain = 0.0
//            bandsR[5].gain = 0.0
//            bandsR[6].gain = 0.0
//            bandsR[7].gain = 0.0
//        }
//    }
    
//    func setEQBandsGainForSliderPlusManual (for currentUserProfile: UserProfile) {
//        let multiplier = Float (currentUserProfile.intensity / 6.0)
//        let bandsL = equalizerL1.bands
//        let bandsR = equalizerR1.bands
//        if equalizerIsActive {
//            bandsL[0].gain = (currentUserProfile.left60 * multiplier) + currentUserProfile.left60M
//            bandsL[1].gain = (currentUserProfile.left100 * multiplier) + currentUserProfile.left100M
//            bandsL[2].gain = (currentUserProfile.left230 * multiplier) + currentUserProfile.left230M
//            bandsL[3].gain = (currentUserProfile.left500 * multiplier) + currentUserProfile.left500M
//            bandsL[4].gain = (currentUserProfile.left1100 * multiplier) + currentUserProfile.left1100M
//            bandsL[5].gain = (currentUserProfile.left2400 * multiplier) + currentUserProfile.left2400M
//            bandsL[6].gain = (currentUserProfile.left5400 * multiplier) + currentUserProfile.left5400M
//            bandsL[7].gain = (currentUserProfile.left12000 * multiplier) + currentUserProfile.left12000M
//            bandsR[0].gain = (currentUserProfile.right60 * multiplier) + currentUserProfile.right60M
//            bandsR[1].gain = (currentUserProfile.right100 * multiplier) + currentUserProfile.right100M
//            bandsR[2].gain = (currentUserProfile.right230 * multiplier) + currentUserProfile.right230M
//            bandsR[3].gain = (currentUserProfile.right500 * multiplier) + currentUserProfile.right500M
//            bandsR[4].gain = (currentUserProfile.right1100 * multiplier) + currentUserProfile.right1100M
//            bandsR[5].gain = (currentUserProfile.right2400 * multiplier) + currentUserProfile.right2400M
//            bandsR[6].gain = (currentUserProfile.right5400 * multiplier) + currentUserProfile.right5400M
//            bandsR[7].gain = (currentUserProfile.right12000 * multiplier) + currentUserProfile.right12000M
//        } else {
//            bandsL[0].gain = 0.0
//            bandsL[1].gain = 0.0
//            bandsL[2].gain = 0.0
//            bandsL[3].gain = 0.0
//            bandsL[4].gain = 0.0
//            bandsL[5].gain = 0.0
//            bandsL[6].gain = 0.0
//            bandsL[7].gain = 0.0
//            bandsR[0].gain = 0.0
//            bandsR[1].gain = 0.0
//            bandsR[2].gain = 0.0
//            bandsR[3].gain = 0.0
//            bandsR[4].gain = 0.0
//            bandsR[5].gain = 0.0
//            bandsR[6].gain = 0.0
//            bandsR[7].gain = 0.0
//        }
//    }
    
  
    
//    func setEQBasedOnEQActive (EQIsActive: Bool) {
//        let multiplier = Float (currentUserProfile.intensity / 6.0)
//        let bandsL = equalizerL1.bands
//        let bandsR = equalizerR1.bands
//        if EQIsActive {
//            bandsL[0].gain = currentUserProfile.left60 * multiplier
//            bandsL[1].gain = currentUserProfile.left100 * multiplier
//            bandsL[2].gain = currentUserProfile.left230 * multiplier
//            bandsL[3].gain = currentUserProfile.left500 * multiplier
//            bandsL[4].gain = currentUserProfile.left1100 * multiplier
//            bandsL[5].gain = currentUserProfile.left2400 * multiplier
//            bandsL[6].gain = currentUserProfile.left5400 * multiplier
//            bandsL[7].gain = currentUserProfile.left12000 * multiplier
//            bandsR[0].gain = currentUserProfile.right60 * multiplier
//            bandsR[1].gain = currentUserProfile.right100 * multiplier
//            bandsR[2].gain = currentUserProfile.right230 * multiplier
//            bandsR[3].gain = currentUserProfile.right500 * multiplier
//            bandsR[4].gain = currentUserProfile.right1100 * multiplier
//            bandsR[5].gain = currentUserProfile.right2400 * multiplier
//            bandsR[6].gain = currentUserProfile.right5400 * multiplier
//            bandsR[7].gain = currentUserProfile.right12000 * multiplier
//        } else {
//            bandsL[0].gain = 0.0
//            bandsL[1].gain = 0.0
//            bandsL[2].gain = 0.0
//            bandsL[3].gain = 0.0
//            bandsL[4].gain = 0.0
//            bandsL[5].gain = 0.0
//            bandsL[6].gain = 0.0
//            bandsL[7].gain = 0.0
//            bandsR[0].gain = 0.0
//            bandsR[1].gain = 0.0
//            bandsR[2].gain = 0.0
//            bandsR[3].gain = 0.0
//            bandsR[4].gain = 0.0
//            bandsR[5].gain = 0.0
//            bandsR[6].gain = 0.0
//            bandsR[7].gain = 0.0
//        }
//    }
    
   
    


    
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
    var toneIndex = 0 {
        willSet {
            print ("toneIndex new value = \(newValue)")
        }
    }
    var maxUnheard: Double = -160
    var minHeard: Double = 0.0
    
    
    var lowestAudibleDecibelBand60L = -120.0
    var lowestAudibleDecibelBand100L = -120.0
    var lowestAudibleDecibelBand230L = -120.0
    var lowestAudibleDecibelBand500L = -120.0
    var lowestAudibleDecibelBand1100L = -120.0
    var lowestAudibleDecibelBand2400L = -120.0
    var lowestAudibleDecibelBand5400L = -120.0
    var lowestAudibleDecibelBand12000L = -120.0
    var lowestAudibleDecibelBand60R = -120.0 
    var lowestAudibleDecibelBand100R = -120.0
    var lowestAudibleDecibelBand230R = -120.0
    var lowestAudibleDecibelBand500R = -120.0
    var lowestAudibleDecibelBand1100R = -120.0
    var lowestAudibleDecibelBand2400R = -120.0
    var lowestAudibleDecibelBand5400R = -120.0
    var lowestAudibleDecibelBand12000R = -120.0
    var lowestAudibleDecibelBands: [Double] { [lowestAudibleDecibelBand60L, lowestAudibleDecibelBand100L, lowestAudibleDecibelBand230L, lowestAudibleDecibelBand500L, lowestAudibleDecibelBand1100L, lowestAudibleDecibelBand2400L, lowestAudibleDecibelBand5400L, lowestAudibleDecibelBand12000L, lowestAudibleDecibelBand60R, lowestAudibleDecibelBand100R, lowestAudibleDecibelBand230R, lowestAudibleDecibelBand500R, lowestAudibleDecibelBand1100R, lowestAudibleDecibelBand2400R, lowestAudibleDecibelBand5400R, lowestAudibleDecibelBand12000R]
    }
    
    
    
    
    let toneArray = ["Band60L", "Band100L", "Band230L", "Band500L", "Band1100L", "Band2400L", "Band5400L", "Band12000L", "Band60R", "Band100R", "Band230R", "Band500R", "Band1100R", "Band2400R", "Band5400R", "Band12000R"]
    
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
        print ("CALLED BAND COMPLETE, tone index = \(toneIndex)")
        assignMinHeardDecibels()
        resetMinMaxValues()
        if toneIndex < toneArray.count - 1 {
            toneIndex += 1
            print ("bandComplete maxUnheard = \(maxUnheard)")
            print ("bandComplete minHeard = \(minHeard)")
            playTone(volume: Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2))))
            
        } else {
            stopTone()
            print ("Test Complete!")
            testStatus = .testCompleted
            if !initialHearingTestHasBeenCompleted {
                initialHearingTestHasBeenCompleted = true
                userDefaults.set(true, forKey: "initialHearingTestHasBeenCompleted")
            }
        }
        
    }
    
    func practiceBandComplete () {
        print ("CALLED PRACTICE BAND COMPLETE, tone index = \(toneIndex)")
        resetMinMaxValues()
        stopTone()
        print ("Practice Test Complete!")
        testStatus = .practiceCompleted
        }
    
    
    func tapStartPracticeTest () {
        print ("Tone Index on Tap Start Test = \(toneIndex)")
        testStatus = .practiceInProgress
        toneIndex = 3
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        print ("tapStartTest volume = \(currentVolume)")
        print ("tapStartTest maxUnheard = \(maxUnheard)")
        print ("tapStartTest minHeard = \(minHeard)")
    }
    
    func tapStartTest () {
        print ("Tone Index on Tap Start Test = \(toneIndex)")
        testStatus = .testInProgress
        toneIndex = 0
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        print ("tapStartTest volume = \(currentVolume)")
        print ("tapStartTest maxUnheard = \(maxUnheard)")
        print ("tapStartTest minHeard = \(minHeard)")
    }
    
    func stopAndResetTest () {
        testStatus = .stopped
        stopTone()
        resetMinMaxValues()
        toneIndex = 0
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
    
    func tapPracticeYesHeard () {
        stopTone()
        minHeard = (maxUnheard + minHeard) / 2
        if abs (maxUnheard - minHeard) < 0.5 {
            print ("tapYesHeard bandComplete")
           practiceBandComplete()
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
    
    func tapPracticeNoDidNotHear () {
        stopTone()
        maxUnheard = (maxUnheard + minHeard) / 2
        if abs(maxUnheard - minHeard) < 0.5 {
            print ("tapNoDidNotHear bandComplete")
            practiceBandComplete()
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
        registerUserDefaults()
        setInterruptionObserver()
        setRouteChangeObserver()
        readFromUserDefaults()
        setEnabledStatusOnRemoteCommands()
        RemoteCommandCenter.handleRemoteCommands(using: self)
    }
    
}



   
