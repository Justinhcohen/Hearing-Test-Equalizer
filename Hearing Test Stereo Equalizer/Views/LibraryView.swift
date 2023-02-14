//
//  LibraryView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/3/23.
//

import SwiftUI
import MediaPlayer
import StoreKit



struct LibraryView: View {
    
    @EnvironmentObject var model: Model
    @State private var path = NavigationPath()
    let userDefaults = UserDefaults.standard
    @Binding var tabSelection: Int
    
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State var showUserProfilesModalView = false
    @State private var isShowingAlert = false
    @State private var libraryAccessIsGranted = true
    @State var defaultUserProfileHasBeenSet = false 
    
    func readFromUserDefaults () {
        let temp = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
        defaultUserProfileHasBeenSet = temp
        print ("After reading from user defaults, default user profile has been set = \(defaultUserProfileHasBeenSet)")
        print ("temp = \(temp)")
    }
    
    func setCurrentProfile () {
        print ("CALLED SET CURRENT PROFILE")
        print ("default user profile has been set = \(defaultUserProfileHasBeenSet)")
        if defaultUserProfileHasBeenSet {
            model.currentUserProfile = userProfiles.first {
                $0.isActive
            }!
            model.currentUserProfileName = model.currentUserProfile.name ?? "Unknown Name"
            model.currentIntensity = model.currentUserProfile.intensity
            model.setEQBandsForCurrentProfile()
        } else {
            print ("CREATING DEFAULT PROFILE")
            createDefaultProfile()
            defaultUserProfileHasBeenSet = true
            userDefaults.set(true, forKey: "defaultUserProfileHasBeenSet")
            let temp = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
            print ("User defaults temp value = \(temp)")
        }
    }
    
    var allSongs: [MPMediaItem] {
        let query = MPMediaQuery.songs()
        let filterOnDownloaded: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: false, forProperty: "isCloudItem")
        query.addFilterPredicate(filterOnDownloaded)
        return query.items!
    }
    
    func checkMusicLibaryAuthorization () {
        //  guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        SKCloudServiceController.requestAuthorization {(status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .denied, .restricted, .notDetermined: disableAppleMusicBasedFeatures()
            case .authorized: enableAppleMusicBasedFeatures()
            default: break
            }
        }
    }
    
    func disableAppleMusicBasedFeatures() {
        libraryAccessIsGranted = false
        isShowingAlert = true
        
        
    }
    
    func enableAppleMusicBasedFeatures() {
        model.songList = allSongs
        setCurrentProfile()
        setEnabledStatusOnRemoteCommands()
        assignRemoteCommands()
        model.setInitialVolumeToFineTuneSoundLevel()
    }
    
    func createDefaultProfile () {
        print ("CALLED CREATE DEFAULT PROFILE")
        let userProfile = UserProfile (context: moc)
        userProfile.name = "Default (Flat EQ)"
        userProfile.isActive = true
        userProfile.iD = UUID()
        userProfile.dateCreated = Date.now
        userProfile.intensity = 0
        userProfile.left60 = 0
        userProfile.right60 = 0
        userProfile.left100 = 0
        userProfile.right100 = 0
        userProfile.left230 = 0
        userProfile.right230 = 0
        userProfile.left500 = 0
        userProfile.right500 = 0
        userProfile.left1100 = 0
        userProfile.right1100 = 0
        userProfile.left2400 = 0
        userProfile.right2400 = 0
        userProfile.left5400 = 0
        userProfile.right5400 = 0
        userProfile.left12000 = 0
        userProfile.right12000 = 0
        
        model.currentUserProfile = userProfile
        model.currentUserProfileName = userProfile.name!
        model.currentIntensity = userProfile.intensity
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        try? moc.save()
    }
    
    func setEnabledStatusOnRemoteCommands () {
        let rmc = MPRemoteCommandCenter.shared()
        rmc.pauseCommand.isEnabled = false
        rmc.playCommand.isEnabled = true
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
    
    func assignRemoteCommands() {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        remoteCommandCenter.playCommand.addTarget{ _ -> MPRemoteCommandHandlerStatus in 
            
            model.playOrPauseCurrentTrack()
            return.success
        }
        
        remoteCommandCenter.togglePlayPauseCommand.addTarget{ _ -> MPRemoteCommandHandlerStatus in 
            model.playOrPauseCurrentTrack()
            return.success
        }
        remoteCommandCenter.nextTrackCommand.addTarget{ _ -> MPRemoteCommandHandlerStatus in 
            model.playNextTrack()
            return.success
        }
        remoteCommandCenter.previousTrackCommand.addTarget{ _ -> MPRemoteCommandHandlerStatus in 
            model.playPreviousTrack()
            return.success
        }
    }
    
    var body: some View {
        
        
        VStack {
            
            if libraryAccessIsGranted {
                
                UserProfileHeaderView()
                    .onTapGesture {
                        showUserProfilesModalView = true
                        print ("TAPPED LIBRARY HEADER VIEW")
                    }
                    .sheet(isPresented: $showUserProfilesModalView) {
                        UserProfileView(tabSelection: $tabSelection)
                    }
                
                NavigationStack {
                    
                    List {
                        NavigationLink {
                            PlaylistView()
                        } label: {
                            LibraryRowView(image: Image(systemName: "music.note.list"), text: "Playlists")
                        }
                        NavigationLink {
                            SongsView().onAppear {
                                model.songList = allSongs
                            }
                        } label: {
                            LibraryRowView(image: Image(systemName: "music.note"), text: "Songs")
                        }
             	           
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Library")
                    
                }
                .onAppear{
                    readFromUserDefaults()
                    checkMusicLibaryAuthorization()
                    if model.equalizerL1 == nil {
                        model.prepareAudioEngine()
                    }
                    if !model.initialHearingTestHasBeenCompleted {
                        self.tabSelection = 3
                    }
                    
                }
                
                Spacer()
                
                PlayerView()
            } else {
                VStack (spacing: 30) {
                    Text ("Music Library access is required.")
                        .font(.title)
                        .toolbar(.hidden, for: .tabBar)
                    
                    Button ("Go to Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
            
        }
        //        .sheet(isPresented: $showUserProfilesModalView) {
        //          UserProfileView() 
        
        .alert(isPresented: $isShowingAlert) {
            Alert (title: Text("Music Library access is required."),
                   message: Text("Go to Settings?"),
                   primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                   secondaryButton: .default(Text("Cancel")))
        }
    }
//    init () {
//        readFromUserDefaults()
//        print ("CALLED LIBRARY VIEW INIT")
//        print ("default user profile has been set = \(defaultUserProfileHasBeenSet)")
//    }
}


//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryView()
//    }
//}
