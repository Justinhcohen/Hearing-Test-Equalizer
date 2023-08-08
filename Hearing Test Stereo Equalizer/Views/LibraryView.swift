//
//  LibraryView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/3/23.
//

import SwiftUI
import MediaPlayer
import StoreKit
import FirebaseAnalytics

struct LibraryView: View {
    
    @EnvironmentObject var model: Model
    @EnvironmentObject private var store: Store
    @Environment(\.requestReview) var requestReview
    let userDefaults = UserDefaults.standard
    @Binding var tabSelection: Int
    
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State private var isShowingAlert = false
    @State var defaultUserProfileHasBeenSet = false 
    @State var shouldShowUnlockLibraryAlert = false
    
    @State var shouldShowInstructionsViewModal = false
    @State var shouldShowSettingsViewModal = false
    @State var shouldShowInAppPurchaseModal = false
    @State var libraryNavigationStep = 0 {
        didSet {
            userDefaults.set(libraryNavigationStep, forKey: "libraryNavigationStep")
        }
    }
    
    func runStartupItems () {
        
        defaultUserProfileHasBeenSet = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
        libraryNavigationStep = userDefaults.integer(forKey: "libraryNavigationStep")
        model.spexLifetimeIsPurchased = userDefaults.bool(forKey: "spexLifetimeIsPurchased")
        setCurrentProfile()
        if !model.audioEngine.isRunning {
            model.prepareAudioEngine()
        }
        model.timesLaunched += 1
        if model.timesLaunched % 20 == 0 {
            requestReview()
        }
        FirebaseAnalytics.Analytics.logEvent("run_startup", parameters: [
            "version": model.spexVersion
        ])
    }
    
    func setCurrentProfile () {
        if defaultUserProfileHasBeenSet {
            model.currentUserProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
            model.currentUserProfileName = model.currentUserProfile.name ?? "Peaches"
            model.currentIntensity = model.currentUserProfile.intensity
            model.setEQBands(for: model.currentUserProfile)
        } else {
            createDefaultProfile()
            defaultUserProfileHasBeenSet = true
            userDefaults.set(true, forKey: "defaultUserProfileHasBeenSet")
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
        model.libraryAccessIsGranted = true
        // setCurrentProfile()
        //  model.setInitialVolumeToFineTuneSoundLevel()
    }
    
    func createDefaultProfile () {
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
        
        //        for userProfile in userProfiles {
        //            userProfile.isActive = false
        //        }
        try? moc.save()
        
        FirebaseAnalytics.Analytics.logEvent("default_profile_created", parameters: nil)
    }
    
    //    func provideLibraryAccess () {
    //        spexLifetimeIsPurchased = true
    //    }
    
    func showInstructionsViewModal () {
        shouldShowInstructionsViewModal = true
        FirebaseAnalytics.Analytics.logEvent("show_instructions", parameters: nil)
    }
    
    func showSettingsViewModal () {
        shouldShowSettingsViewModal = true
        FirebaseAnalytics.Analytics.logEvent("show_settings", parameters: nil)
    }
    
    func showInAppPurchaseModal () {
        shouldShowInAppPurchaseModal = true
        FirebaseAnalytics.Analytics.logEvent("show_in_app_purchase", parameters: nil)
    }
    
    func dismiss() {
    }
    
    
    var body: some View {
        VStack {
            
            if model.libraryAccessIsGranted {
                ZStack {
                    UserProfileHeaderView()
                        .onAppear {
                            runStartupItems()
                        }
                    HStack {
                        Button (action: showSettingsViewModal) {
                            Image(systemName: "gearshape")
                        }
                        .sheet(isPresented: $shouldShowSettingsViewModal, onDismiss: dismiss) {
                            SettingsView()
                        }
                        Spacer()
                        Button (action: showInstructionsViewModal) {
                            Image(systemName: "questionmark.circle")
                        }
                        .sheet(isPresented: $shouldShowInstructionsViewModal, onDismiss: dismiss) {
                            InstructionsView()
                        }
                    }
                    .padding()
                    .onAppear {
                        
                        checkMusicLibaryAuthorization()
                        if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                        if !model.audioEngine.isRunning {
                            model.prepareAudioEngine()
                        }
                        if store.hasPurchasedSpexLifetime && !model.spexLifetimeIsPurchased {
                            model.spexLifetimeIsPurchased = true
                        }
                        if model.demoIsPlaying {
                            model.stopDemoTrack()
                        }
                    }
                }
                
                if libraryNavigationStep == 0 {
                    VStack (spacing: 30) {
                        Text ("Your Music")
                            .font(.title)
                        ScrollView {
                            VStack (spacing: 30) {
                                HStack {
                                    Text("Hopefully you were able to find the sweet spot on the Intensity slider that maximized your enjoyment of the demo songs. Now let's try with your music.")
                                    Spacer()
                                }
                                HStack {
                                    Text("Click the button below to access all of the songs you own in your music library.")
                                    Spacer()
                                }
                                HStack {
                                    Text("This free version of Spex will pause playback 2 minutes into each song. Hopefully this will give you ample opportunity to decide whether Spex is for you.")
                                    Spacer()
                                }
                                HStack {
                                    Text("If Spex improves your listening experience, you'll have the option to remove the pause timer with a one-time, in-app purchase. No subscription required.")
                                    Spacer()
                                }
                                HStack {
                                    Text("Happy listening!")
                                    Spacer()
                                }
                            }
                        }
                        Button ("Music Library") {
                            libraryNavigationStep = 10
                            FirebaseAnalytics.Analytics.logEvent("tap_to_library", parameters: nil)
                        }
                        .font(.title)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(.blue, lineWidth: 5)
                        )
                        .foregroundColor(.blue)
                    }
                    .padding()
                    
                } else if libraryNavigationStep == 10 {
                    NavigationStack {
                        
                        List {
                            
                            NavigationLink {
                                SongsView(navigationTitleText: "Songs").onAppear {
                                    model.songList = allSongs
                                    if !model.audioPlayerNodeL1.isPlaying {
                                        model.cachedAudioFrame = nil
                                        model.playQueue = [MPMediaItem]()
                                    }
                                }
                            } label: {
                                LibraryRowView(image: Image(systemName: "music.note"), text: "Songs")
                            }
                            
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
                                AlbumView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "square.stack"), text: "Albums")
                            }
                            
                            NavigationLink {
                                GenreView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "guitars"), text: "Genres")
                            }
                            
                            
                            
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Library")
                        .onChange(of: store.hasPurchasedSpexLifetime, perform: { newValue in
                            if newValue == true {
                                model.spexLifetimeIsPurchased = true
                            }
                            
                        }
                        )
                        .onAppear {
                            if !model.spexLifetimeIsPurchased {
                                if store.hasPurchasedSpexLifetimeBackup {
                                    model.spexLifetimeIsPurchased = true
                                }
                            }
                    }
                }
                    Spacer ()
                    VStack {
                        if !model.spexLifetimeIsPurchased {
                            Button("Remove Pause Timer") {
                                showInAppPurchaseModal()
                                FirebaseAnalytics.Analytics.logEvent("tap_remove_pause_timer", parameters: [
                                    "songs_played": model.songsPlayed
                                ])
                            }
                            .sheet(isPresented: $shouldShowInAppPurchaseModal, onDismiss: dismiss) {
                                InAppPurchaseView()
                            }
                            .font(.title3)
                            .padding ()
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(.blue, lineWidth: 5)
                            )
                            .foregroundColor(.blue)
                        }
                        PlayerView()
                    }
                    .padding()
                    
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
                        if !model.audioEngine.isRunning {
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
