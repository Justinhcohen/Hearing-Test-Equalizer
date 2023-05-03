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
    @State var defaultUserProfileHasBeenSet = false 
    @State var shouldShowUnlockLibraryAlert = false
    @State var libraryAccessIsPurchased = false 
    
    func runStartupItems () {
        print ("CALLED RUN STARTUP ITEMS")
        let temp = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
        defaultUserProfileHasBeenSet = temp
        libraryAccessIsPurchased = userDefaults.bool(forKey: "libraryAccessIsPurchased")
        setCurrentProfile()
        model.setInitialVolumeToFineTuneSoundLevel()
//        model.songList = allSongs
//        model.playQueue = allSongs
        print ("After reading from user defaults, default user profile has been set = \(defaultUserProfileHasBeenSet)")
        print ("temp = \(temp)")
    }
    
    func setCurrentProfile () {
        print ("CALLED SET CURRENT PROFILE")
        print ("default user profile has been set = \(defaultUserProfileHasBeenSet)")
        if defaultUserProfileHasBeenSet {
            model.currentUserProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
            model.currentUserProfileName = model.currentUserProfile.name ?? "Peaches"
            model.currentIntensity = model.currentUserProfile.intensity
            model.setEQBands(for: model.currentUserProfile)
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
        let filterEncrypted: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: false, forProperty: "hasProtectedAsset")
        query.addFilterPredicate(filterOnDownloaded)
        query.addFilterPredicate(filterEncrypted)
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
        model.libraryAccessIsGranted = false
        isShowingAlert = true
    }
    
    func enableAppleMusicBasedFeatures() {
        print ("CALLED ENABLE APPLE MUSIC BASED FEATURES")
        model.libraryAccessIsGranted = true
        setCurrentProfile()
        //  setEnabledStatusOnRemoteCommands()
        //  assignRemoteCommands()
        model.setInitialVolumeToFineTuneSoundLevel()
        //        if !allSongs.isEmpty {
        //            model.songList = allSongs
        //            model.playQueue = allSongs
        //            model.currentMediaItem = model.playQueue[0]
        //        }
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
        
        userProfile.left60M = 0
        userProfile.right60M = 0
        userProfile.left100M = 0
        userProfile.right100M = 0
        userProfile.left230M = 0
        userProfile.right230M = 0
        userProfile.left500M = 0
        userProfile.right500M = 0
        userProfile.left1100M = 0
        userProfile.right1100M = 0
        userProfile.left2400M = 0
        userProfile.right2400M = 0
        userProfile.left5400M = 0 
        userProfile.right5400M = 0
        userProfile.left12000M = 0
        userProfile.right12000M = 0 
        
        
        
        model.currentUserProfile = userProfile
        model.currentUserProfileName = userProfile.name!
        model.currentIntensity = userProfile.intensity
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        try? moc.save()
    }
    
    func provideLibraryAccess () {
        libraryAccessIsPurchased = true
        userDefaults.set(true, forKey: "libraryAccessIsPurchased")
    }
    
    
    var body: some View {
        
        
        
        VStack {
            
            if model.libraryAccessIsGranted {
                
                UserProfileHeaderView()
                
                    .onAppear {
                        runStartupItems()
                    }
                
                if !libraryAccessIsPurchased {
                    VStack (spacing: 30)  {
                        Text ("Spex Lifetime")
                            .font(.title)
                        ScrollView {
                            VStack (spacing: 30) {
                                HStack {
                                    Text ("Were you able to find the sweet spot on the Intensity slider that increased your enjoyment of the demo songs?")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("If you didn't notice an improvement when toggling Spex on and off while listening to the demo songs, Spex may not be for you.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("If you did notice an improvement, Spex may still not be for you because Spex only works with DRM-free audio files (MP3, AAC, ALAC, WAV and AIFF). It DOES NOT currently play tracks from paid subscription servcies such as Apple Music, Spotify and Tidal. If these services release compatible, public APIs, we will work to integrate them.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("Spex will recognize playlists you create in the Music app on your Mac and sync to your iPhone through the Finder, subject to the restrictions mentioned above.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("If you would like to use Spex with your owned Music Library, you can make a one-time purchase of Spex Lifetime. Spex Lifetime will provide you with a lifetime of full access and free upgrades. No subscription required.")
                                    Spacer ()
                                }
                            }
                        }
                        
                        Spacer ()
                        Button("Spex Lifetime", 
                               action: {
                            //resetAllToZero()
                            shouldShowUnlockLibraryAlert = true
                        })
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke( .blue, lineWidth: 5)
                        )
                        .onAppear {
                            checkMusicLibaryAuthorization()
                            if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                                self.tabSelection = 3
                            }
                            if model.equalizerL1 == nil {
                                model.prepareAudioEngine()
                            }
                        }
                        .alert("Purchase Spex Lifetime for $9.99? (Temp text, no purchase required)", isPresented: $shouldShowUnlockLibraryAlert) {
                            Button ("Yes!") {
                                provideLibraryAccess()
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                    .padding()
                } else {
                    
                  //  UserProfileHeaderView()
                    
                    NavigationStack {
                        
                        List {
                            NavigationLink {
                                PlaylistView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "music.note.list"), text: "Playlists")
                            }
                            NavigationLink {
                                ArtistView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "music.mic"), text: "Artists")
                            }
                            NavigationLink {
                                SongsView().onAppear {
                                    model.songList = allSongs
                                }
                            } label: {
                                LibraryRowView(image: Image(systemName: "music.note"), text: "Songs")
                            }
                            //                            NavigationLink {
                            //                                AppleMusicPlaylistView().onAppear {
                            //                                    model.songList = allSongs
                            //                                }
                            //                            } label: {
                            //                                LibraryRowView(image: Image(systemName: "music.note.list"), text: "Apple Music Playlists")
                            //                            }
                            
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Library")
                        
                    }
                    .onAppear{
                        print ("LIBRARY VIEW LIST APPEARED")
                        print ("Song List Count = \(model.songList.count)")
                        model.didViewMusicLibrary = true
                        checkMusicLibaryAuthorization()
                        if model.equalizerL1 == nil {
                            model.prepareAudioEngine()
                        }
                        if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                        runStartupItems()
                        if model.testStatus != .stopped {
                            model.stopAndResetTest()
                        }
                        
                    }
//                    Button("Temp Reset", 
//                           action: {
//                        //resetAllToZero()
//                        libraryAccessIsPurchased = false
//                    })
//                    .font(.title)
//                    .foregroundColor(.blue)
//                    .padding ()
//                    .overlay(
//                        Capsule(style: .continuous)
//                            .stroke( .blue, lineWidth: 5)
//                    )
                    
                    Spacer()
                    
                    PlayerView()
                }
            } else {
                VStack (spacing: 30) {
                    Text ("Music Library access is required.")
                        .font(.title)
                        .toolbar(.hidden, for: .tabBar)
                    
                    Button ("Go to Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    .onAppear{
                        runStartupItems()
                        checkMusicLibaryAuthorization()
                        if model.equalizerL1 == nil {
                            model.prepareAudioEngine()
                        }
                        if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                        
                    }
                }
            }
            
        }
        
        .alert(isPresented: $isShowingAlert) {
            Alert (title: Text("Music Library access is required."),
                   message: Text("Go to Settings?"),
                   primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                   secondaryButton: .default(Text("Cancel")))
        }
    }
    
}


//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryView()
//    }
//}
