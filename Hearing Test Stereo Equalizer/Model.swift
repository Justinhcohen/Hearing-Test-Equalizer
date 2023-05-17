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
import FirebaseAnalytics

class Model: ObservableObject, RemoteCommandHandler {
    
    // MARK: Launch Items
    
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
                "showAirPlayButton": true,
                "fineTuneSoundLevel": 0.0
            ]
        )
    }
    
    func readFromUserDefaults () {
        initialHearingTestHasBeenCompleted = userDefaults.bool(forKey: "initialHearingTestHasBeenCompleted")
        libraryAccessIsGranted = userDefaults.bool(forKey: "libraryAccessIsGranted")
        equalizerIsActive = userDefaults.bool(forKey: "equalizerIsActive")
        manualAdjustmentsAreActive = userDefaults.bool(forKey: "manualAdjustmentsAreActive")
        currentUserProfileName = userDefaults.string(forKey: "currentUserProfileName") ?? "There is no name"
        fineTuneSoundLevel = userDefaults.float(forKey: "fineTuneSoundLevel")
        
        // Settings
        showPlaytimeSlider = userDefaults.bool(forKey: "showPlaytimeSlider")
        showSpexToggle = userDefaults.bool(forKey: "showSpexToggle")
        showSubtleVolumeSlider = userDefaults.bool(forKey: "showSubtleVolumeSlider")
        showDemoSongButtons = userDefaults.bool(forKey: "showDemoSongButtons")
        showManualAdjustmentsButton = userDefaults.bool(forKey: "showManualAdjustmentsButton")
        showSongInformation = userDefaults.bool(forKey: "showSongInformation")
        showAirPlayButton = userDefaults.bool(forKey: "showAirPlayButton")
        practiceToneBeforeTest = userDefaults.bool(forKey: "practiceToneBeforeTest")
        
        // Analytics
        timesLaunched = userDefaults.integer(forKey: "timesLaunched")
        songsPlayed = userDefaults.integer(forKey: "songsPlayed")
        hearingTestsStarted = userDefaults.integer(forKey: "hearingTestsStarted")
        demoOnePlayed = userDefaults.integer(forKey: "demoOnePlayed")
        demoTwoPlayed = userDefaults.integer(forKey: "demoTwoPlayed")
        demoThreePlayed = userDefaults.integer(forKey: "demoThreePlayed")
        profilesCreated = userDefaults.integer(forKey: "profilesCreated")
        intensityAdjusted = userDefaults.integer(forKey: "intensityAdjusted")
        spexToggled = userDefaults.integer(forKey: "spexToggled")
        manualAdjustmentsToggled = userDefaults.integer(forKey: "manualAdjustmentsToggled")
    }
    
    
    // MARK: Analytics
    var timesLaunched = 0 {
        didSet {
            userDefaults.set(timesLaunched, forKey: "timesLaunched")
        }
    }
    var songsPlayed = 0 {
        didSet {
            userDefaults.set(songsPlayed, forKey: "songsPlayed")
        }
    }
    var hearingTestsStarted = 0 {
        didSet {
            userDefaults.set(hearingTestsStarted, forKey: "hearingTestsStarted")
        }
    }
    var demoOnePlayed = 0 {
        didSet {
            userDefaults.set(demoOnePlayed, forKey: "demoOnePlayed")
        }
    }
    var demoTwoPlayed = 0 {
        didSet {
            userDefaults.set(demoTwoPlayed, forKey: "demoTwoPlayed")
        }
    }
    var demoThreePlayed = 0 {
        didSet {
            userDefaults.set(demoThreePlayed, forKey: "demoThreePlayed")
        }
    }
    var profilesCreated = 0 {
        didSet {
            userDefaults.set(profilesCreated, forKey: "profilesCreated")
        }
    }
    var intensityAdjusted = 0 {
        didSet {
            userDefaults.set(intensityAdjusted, forKey: "intensityAdjusted")
        }
    }
    var spexToggled = 0 {
        didSet {
            userDefaults.set(spexToggled, forKey: "spexToggled")
        }
    }
    var manualAdjustmentsToggled = 0 {
        didSet {
            userDefaults.set(manualAdjustmentsToggled, forKey: "manualAdjustmentsToggled")
        }
    }
    
    // MARK: State
    let userDefaults = UserDefaults.standard
    @Published var demoIsPlaying = false
    //  @Published var didViewMusicLibrary = false
    @Published var didTapSongName = false 
    var initialSoundLevelSet = false
    @Published var libraryAccessIsGranted = false {
        willSet {
            userDefaults.set(newValue, forKey: "libraryAccessIsGranted")
        }
    }
    @Published var currentUserProfile: UserProfile! 
    @Published var currentUserProfileName = "" {
        willSet {
            userDefaults.set(newValue, forKey: "currentUserProfileName")
        }
    }
    @Published var currentIntensity = 0.0
    @Published var playQueue = [MPMediaItem]()
    @Published var currentMediaItem = MPMediaItem()
    @Published var queueIndex: Int = 0 {
        didSet {
            //   updateWhenTheQueueIndexIsSet()
        }
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
    enum PlayState {
        case playing, paused, stopped
    }
    @Published var playState: PlayState = .stopped 
    @Published var songList = [MPMediaItem]() 
    var currentURL: URL = URL(fileURLWithPath: "")
    @Published var timer: Timer?
    @Published var fadeInTimer: Timer?
  //  @Published var fadeOutTimer: Timer?
    @Published var fineTuneSoundLevel: Float = 0.0 {
        didSet {
            userDefaults.set(fineTuneSoundLevel, forKey: "fineTuneSoundLevel")
        }
    }
 //   var fadeOutSoundLevel: Float = 0.0
    @Published var currentVolume: Float = 0.0
    @Published var systemVolume = AVAudioSession.sharedInstance().outputVolume
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
    @Published var manualAdjustmentsAreActive = false {
        willSet {
            userDefaults.set(newValue, forKey: "manualAdjustmentsAreActive")
        }
    }
    enum DemoTrack {
        case trackOne, trackTwo, trackThree
    }
    var demoTrack = DemoTrack.trackOne
    @Published var isPlayingDemoOne = false
    @Published var isPlayingDemoTwo = false
    @Published var isPlayingDemoThree = false
    
    // MARK: Playback Controls
    
    
    // MARK: Song Metadata
    @Published var albumCover = Image(systemName: "photo")
    @Published var songName = "" {
        didSet {
            //  updateWhenTheQueueIndexIsSet()
        }
    }
    @Published var artistName = ""
    @Published var albumName = ""
    var currentSongTime: TimeInterval {
        TimeInterval((cachedAudioFrame ?? 0) + audioPlayerNodeL1.currentFrame) / audioFile.processingFormat.sampleRate
    }
    //  @Published var currentSongTimeStatic: TimeInterval = 0
    @Published var currentSongDuration: TimeInterval = 0
    @Published var cachedAudioFrame: AVAudioFramePosition?
    @Published var lastAudioFrame: AVAudioFramePosition? 
    @Published var runningAudioFrame: AVAudioFramePosition?
    
    
    // MARK: User Settings
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
    
    // MARK: Handlers
    enum NowPlayableInterruption {
        case began, ended(Bool), failed(Error)
    }
    private var interruptionHandler: (NowPlayableInterruption) -> Void = { _ in }
    private var interruptionObserver: NSObjectProtocol!
    private var routeChangeObserver: NSObjectProtocol!
    private var headphonesConnected = false
    func setInterruptionObserver () {
        let audioSession = AVAudioSession.sharedInstance()
        // Observe interruptions to the audio session.
        interruptionObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: .main) {
            [unowned self] notification in
            self.handleAudioSessionInterruption(notification: notification)
        }
    }    
    
    func setRouteChangeObserver() {
        // Observe route change interruptions
        routeChangeObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) {
            [unowned self] notification in
            self.handleRouteChangeNotification(notification: notification)
        }
    }
    
    func handleAudioSessionInterruption(notification: Notification) {
 
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            cachedAudioFrame = runningAudioFrame
            switch playState {
            case .stopped, .paused:
                break
            case .playing:
                playState = .paused
            }
         
         
        case .ended:
            // An interruption ended. Resume playback, if appropriate.
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                if !audioEngine.isRunning {
                    prepareAudioEngine()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        switch self.playState {
                        case .paused, .playing: 
                            self.playTrack()
                        case .stopped:
                            break
                        }
                    } 
                }
            } 
        default: break
        }
    }
    
    func handleRouteChangeNotification(notification: Notification) {
        if !audioEngine.isRunning {
            prepareAudioEngine()
        }
        cachedAudioFrame = runningAudioFrame
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        switch reason {
            
        case .newDeviceAvailable: // New device found.
            let session = AVAudioSession.sharedInstance()
            headphonesConnected = hasHeadphones(in: session.currentRoute)
            switch playState {
            case .paused, .stopped:
                pauseTrack()
            case.playing:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.startFadeInTimer()
                    self.playTrack()
                } 
            }
            
            
        case .oldDeviceUnavailable: // Old device removed.
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                headphonesConnected = hasHeadphones(in: previousRoute)
            }
            cachedAudioFrame = runningAudioFrame
            stopTrack()
            
        default:
            break
        }
        
        
        //        guard audioEngine.isRunning else {return}
        //        if playState == .playing {
        //            playOrPauseCurrentTrack()
        //        }
        //        if demoIsPlaying {
        //            stopDemoTrack()
        //        }
    }
    
    func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }
    
    // MARK: Remote Commands
    
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
            pauseTrack()
        case .play:
            playOrPauseCurrentTrack()
        case .nextTrack:
            playNextTrack()
        case .previousTrack:
            playPreviousTrack()
        case .togglePlayPause:
            playOrPauseCurrentTrack()
        }
    }
    
    // MARK: Player Methods
    func playbackTimer(){
        updateEverySecondInPlaybackTimer()
        if didTapSongName {
            didTapSongName = false
        }
        if audioPlayerNodeL1.currentFrame + (cachedAudioFrame ?? 0) >= audioFile.length {
            updateOnNewSong()
            playNextTrack()
        }
    }
    
    func fadeInAudio () {
        if audioPlayerNodeL1.volume < 0.7 + (fineTuneSoundLevel * 0.003) {
            audioPlayerNodeL1.volume = min (audioPlayerNodeL1.volume + 0.05, 0.7 + (fineTuneSoundLevel * 0.003))
            audioPlayerNodeR1.volume = min (audioPlayerNodeR1.volume + 0.05, 0.7 + (fineTuneSoundLevel * 0.003))
        } else {
            fadeInComplete()
        }
    }
    
//    func fadeOutAudio () {
//        audioPlayerNodeL1.volume = 0
//        audioPlayerNodeR1.volume = 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.pauseTrack()
//        }        
//    }
    
    func startFadeInTimer () {
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
    
    func fadeInComplete () {
        fadeInTimer?.invalidate()
        fadeInTimer = nil
    }
    
//    func fadeOutComplete () {
//        pauseTrack()
//        playState = .paused
//        fadeOutTimer?.invalidate()
//        fadeOutTimer = nil
//    }
    
    func startPlaybackTimer () {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
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
        
        let bandwidth: Float = 0.5
        let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
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
        
        do {
            try audioEngine.start()
        } catch {}
    } 
    
    func updateEverySecondInPlaybackTimer() {
        setNowPlayingMetadataEverySecond()
        runningAudioFrame = (cachedAudioFrame ?? 0) + audioPlayerNodeL1.currentFrame
    }
    
    func updateOnNewSong() {
        updateSongMetadataOnNewSong()
    }
    
    func updateSongMetadataOnNewSong () {
        let size = CGSize(width: 1284, height: 1284)
        songName = currentMediaItem.title ?? "Unknown title"
        artistName = currentMediaItem.artist ?? "Unknown artist"
        albumName = currentMediaItem.albumTitle ?? "Unknown album"
        let mediaImage = currentMediaItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        let UIAlbumCover = mediaImage?.image(at: size)
        let defaultUIImage = UIImage(systemName: "photo")!
        albumCover = Image(uiImage: UIAlbumCover ?? defaultUIImage)
        currentSongDuration = audioFile.duration
    }
    
    // Call in the timer (every second)
    func setNowPlayingMetadataEverySecond() {
        guard !songList.isEmpty else {return}
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentSongTime
        
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = currentMediaItem.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = currentMediaItem.mediaType.rawValue
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentMediaItem.title ?? "Unknown title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentMediaItem.artist ?? "Unknown artist"
        let defaultImage = UIImage(systemName: "photo")!
        let defaultArtwork = MPMediaItemArtwork (boundsSize: defaultImage.size, requestHandler: { (size) -> UIImage in
            return defaultImage
        })
        nowPlayingInfo[MPMediaItemPropertyArtwork] = currentMediaItem.artwork ?? defaultArtwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = currentMediaItem.albumArtist ?? "Uknown artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = currentMediaItem.albumTitle ?? "Unknown album title"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioFile.duration
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        
        switch playState {
        case .playing: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        case .paused: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        case .stopped: nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        }
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func setVolumeToZero () {
        audioPlayerNodeL1.volume = 0.0
        audioPlayerNodeR1.volume = 0.0
    }
    
    func tapSongToPlay (searchResults: [MPMediaItem], queueIndex: Int, showModalView: ()->Void) {
        didTapSongName = true
        cachedAudioFrame = nil
        playQueue = searchResults
        self.queueIndex = queueIndex
        startFadeInTimer()
        playTrack()
        showModalView()
        updateOnNewSong()
        FirebaseAnalytics.Analytics.logEvent("tap_song_to_play", parameters: nil)
    }
    
    func tapShufflePlay (searchResults: [MPMediaItem], showModalView: ()->Void) {
        cachedAudioFrame = nil
        playQueue = searchResults.shuffled()
        queueIndex = 0
        startFadeInTimer()
        playTrack()
        showModalView()
        updateOnNewSong()
        FirebaseAnalytics.Analytics.logEvent("tap_shuffle_play", parameters: nil)
    }
    
    func playTrack () {
        guard !songList.isEmpty else {return} 
        songsPlayed += 1
        FirebaseAnalytics.Analytics.logEvent("play_track", parameters: [
          "songs_played": songsPlayed,
          "intensity": currentIntensity
        ])
        isPlayingDemoOne = false
        isPlayingDemoTwo = false
        isPlayingDemoThree = false
        if playQueue.isEmpty {
            playQueue = songList
        }
        currentMediaItem = playQueue[queueIndex]
        switch playState {
        case .stopped, .paused:
            startFadeInTimer()
        case .playing:
            stopTrack()
        }
        if demoIsPlaying {
            demoIsPlaying = false
        }
        if !audioEngine.isRunning {
            prepareAudioEngine() 
        }
        setEQBands(for: currentUserProfile)
        do {
            if let currentURL = currentMediaItem.assetURL {
                audioFile = try AVAudioFile(forReading: currentURL)
                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                guard audioEngine.isRunning else {
                    print ("THE AUDIO ENGINE WASN'T RUNNING")
                    return
                }
                if !(playState == .playing) {
                    playState = .playing
                }
                startPlaybackTimer()
                // Left Ear Play
                audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()  
                
                // Right Ear Play
                audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
                
            }
        } catch {print ("ERROR ERROR ERROR")}
    }
    
    func playTrackAfterSeek () {
        isPlayingDemoOne = false
        isPlayingDemoTwo = false
        if playQueue.isEmpty {
            playQueue = songList
        }
        currentMediaItem = playQueue[queueIndex]
        if demoIsPlaying {
            demoIsPlaying = false
        }
        if !audioEngine.isRunning {
            prepareAudioEngine() 
        }
        setEQBands(for: currentUserProfile)
        do {
            if let currentURL = currentMediaItem.assetURL {
                audioFile = try AVAudioFile(forReading: currentURL)
                if !audioEngine.isRunning {
                    prepareAudioEngine()
                } 
                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                guard audioEngine.isRunning else {return}
                switch playState {
                case .stopped:
                    break
                case .paused:
                    stopTrackAfterSeek()
                case .playing: 
                    stopTrackAfterSeek()
                    playState = .playing
                    startPlaybackTimer()
                    // Left Ear Play
                    audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeL1.pan = -1
                    audioPlayerNodeL1.play()  
                    // Right Ear Play
                    audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
                    audioPlayerNodeR1.pan = 1
                    audioPlayerNodeR1.play()
                }
            }
            
        } catch {}
    }
    
    func stopTrack () {
        //    currentSongTimeStatic = 0
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        playState = .stopped
        //  setNowPlayingMetadata()
    }
    
    func stopTrackAfterSeek () {
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        playState = .stopped
        //  setNowPlayingMetadata()
    }
    
    func playPreviousTrack () {
        if (Double((cachedAudioFrame ?? 0) + audioPlayerNodeL1.currentFrame) / audioFile.processingFormat.sampleRate) < 2.0 && queueIndex > 0 {
            queueIndex -= 1
        }
        cachedAudioFrame = nil
        currentMediaItem = playQueue[queueIndex]
        playTrack()
        
        updateOnNewSong()
    }
    
    func playNextTrack () {
        cachedAudioFrame = nil
        guard queueIndex < playQueue.count - 1 else {return}
        queueIndex += 1
        currentMediaItem = playQueue[queueIndex]
        playTrack()
        updateOnNewSong()
    }
    
    func togglePlayPauseRemote () {
        let togglePlayPauseRemoteCommand = RemoteCommand.togglePlayPause
        performRemoteCommand(togglePlayPauseRemoteCommand)
    }
    
    func playOrPauseCurrentTrack () {
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
        lastAudioFrame = audioPlayerNodeL1.currentFrame
        guard !songList.isEmpty else {return}
        fadeInTimer?.invalidate()
        fadeInTimer = nil
        audioPlayerNodeL1.volume = 0
        audioPlayerNodeR1.volume = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.audioPlayerNodeL1.stop()
            self.audioPlayerNodeR1.stop()
            self.cachedAudioFrame = (self.cachedAudioFrame ?? 0) + (self.lastAudioFrame ?? 0)
        } 
        playState = .paused
    }
    
    func unPauseTrack () {
        playState = .playing
        playTrack()
    } 
    
    
    
    
    func playDemoTrack () {
        playState = .stopped
        stopTrack()
        stopDemoTrack()
        var demoTrackName = ""
        switch demoTrack {
        case .trackOne:
            demoTrackName = "twinsmusic-dancinginthesand"
            isPlayingDemoOne = true 
            demoOnePlayed += 1
            FirebaseAnalytics.Analytics.logEvent("play_demo_one", parameters: [
                "demo_one_played": demoOnePlayed
            ])
        case .trackTwo:
            demoTrackName = "Evert Zeevalkink - On The Roads"
            isPlayingDemoTwo = true
            demoTwoPlayed += 1
            FirebaseAnalytics.Analytics.logEvent("play_demo_two", parameters: [
                "demo_two_played": demoTwoPlayed
            ])
        case .trackThree:
            demoTrackName = "indiebox-funkhouse"
            isPlayingDemoThree = true
            demoThreePlayed += 1
            FirebaseAnalytics.Analytics.logEvent("play_demo_three", parameters: [
                "demo_three_played": demoThreePlayed
            ])
        }
        playQueue = [MPMediaItem]()
        songList = [MPMediaItem]()
        demoIsPlaying = true
        prepareAudioEngine() 
        
        if currentUserProfile != nil {
            setEQBands(for: currentUserProfile)
        }
        
        do {
            let currentURL = Bundle.main.url(forResource: demoTrackName, withExtension: "mp3")
            audioFile = try AVAudioFile(forReading: currentURL!)
            audioEngine.prepare()
            if !audioEngine.isRunning {
                prepareAudioEngine()
            } 
            
            guard audioEngine.isRunning else {return}
            
            let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
            audioPlayerNodeL1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
            audioPlayerNodeL1.pan = -1
            audioPlayerNodeL1.play()  
            
            
            audioPlayerNodeR1.scheduleSegment(audioFile, startingFrame: cachedAudioFrame ?? 0, frameCount: UInt32(audioFile.length), at: audioTime, completionCallbackType: .dataPlayedBack, completionHandler: nil)
            audioPlayerNodeR1.pan = 1
            audioPlayerNodeR1.play()
            
            startFadeInTimer()
        } catch _ {}
    }
    
    func stopDemoTrack () {
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
    
    // MARK: Hearing Test 
    
    let bandNames = ["L60", "L100", "L230", "L500", "L1100", "L2400", "L5400", "R60", "R100", "R230", "R500", "R1100", "R2400", "R5400", "L12000", "R12000"]
    enum TestStatus {
        case testInProgress, testCompleted, practiceInProgress, practiceCompleted, stopped
    }
    
    @Published var testStatus = TestStatus.stopped
    @Published var tempURL: URL = URL(fileURLWithPath: "temp")
    @Published var initialHearingTestHasBeenCompleted = false
    var tonePlayer: AVAudioPlayer?
    var currentTone = ""
    var toneIndex = 0 
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
    
    
    func playTone (volume: Float){
        setCurrentTone()
        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
        do {
            tonePlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        if let tonePlayer = tonePlayer {
            tonePlayer.volume = volume
            tonePlayer.numberOfLoops = -1
            if toneIndex < 8 {
                tonePlayer.pan = -1
            } else {
                tonePlayer.pan = 1
            }
            tonePlayer.play()
        }
    }
    
    func resumeTone () {
        let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        setCurrentTone()
        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
        do {
            tonePlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        if let tonePlayer = tonePlayer {
            tonePlayer.volume = volume
            tonePlayer.numberOfLoops = -1
            if toneIndex < 8 {
                tonePlayer.pan = -1
            } else {
                tonePlayer.pan = 1
            }
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
        assignMinHeardDecibels()
        resetMinMaxValues()
        if toneIndex < toneArray.count - 1 {
            toneIndex += 1
            playTone(volume: Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2))))
            
        } else {
            stopTone()
            testStatus = .testCompleted
            if !initialHearingTestHasBeenCompleted {
                initialHearingTestHasBeenCompleted = true
                userDefaults.set(true, forKey: "initialHearingTestHasBeenCompleted")
            }
        }
    }
    
    func practiceBandComplete () {
        resetMinMaxValues()
        stopTone()
        testStatus = .practiceCompleted
    }
    
    func tapStartPracticeTest () {
        testStatus = .practiceInProgress
        toneIndex = 3
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        FirebaseAnalytics.Analytics.logEvent("start_practice_test", parameters: nil)
    }
    
    func tapStartTest () {
        testStatus = .testInProgress
        toneIndex = 0
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        hearingTestsStarted += 1
        FirebaseAnalytics.Analytics.logEvent("start_hearing_test", parameters: [
            "hearing_tests_started": hearingTestsStarted
        ])
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
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            playTone(volume: volume)
        }
    }
    
    func tapPracticeYesHeard () {
        stopTone()
        minHeard = (maxUnheard + minHeard) / 2
        if abs (maxUnheard - minHeard) < 0.5 {
            practiceBandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            playTone(volume: volume)
        }
    }
    
    func tapNoDidNotHear () {
        stopTone()
        maxUnheard = (maxUnheard + minHeard) / 2
        if abs(maxUnheard - minHeard) < 0.5 {
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            playTone(volume: volume)
        }
    }
    
    func tapPracticeNoDidNotHear () {
        stopTone()
        maxUnheard = (maxUnheard + minHeard) / 2
        if abs(maxUnheard - minHeard) < 0.5 {
            practiceBandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
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




