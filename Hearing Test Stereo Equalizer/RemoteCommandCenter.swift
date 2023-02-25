//
//  RemoteCommandCenter.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/21/23.
//

import MediaPlayer

enum RemoteCommand {
    case pause, play, nextTrack, previousTrack, togglePlayPause
}

/// The behavior of an object that handles remote commands.
protocol RemoteCommandHandler: AnyObject {
    func performRemoteCommand(_: RemoteCommand)
}

class RemoteCommandCenter {
    
    /// Registers callbacks for various remote commands.
    static func handleRemoteCommands(using handler: RemoteCommandHandler) {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.pauseCommand.addTarget { [weak handler] _ in
            guard let handler = handler else { return .noActionableNowPlayingItem }
            handler.performRemoteCommand(.pause)
            return .success
        }
        
        commandCenter.playCommand.addTarget { [weak handler] _ in
            guard let handler = handler else { return .noActionableNowPlayingItem }
            handler.performRemoteCommand(.play)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak handler] _ in
            guard let handler = handler else { return .noActionableNowPlayingItem }
            handler.performRemoteCommand(.togglePlayPause)
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak handler] _ in
            guard let handler = handler else { return .noActionableNowPlayingItem }
            handler.performRemoteCommand(.nextTrack)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak handler] _ in
            guard let handler = handler else { return .noActionableNowPlayingItem }
            handler.performRemoteCommand(.previousTrack)
            return .success
        }
    }
}
