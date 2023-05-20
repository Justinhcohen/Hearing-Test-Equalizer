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
    @EnvironmentObject private var purchaseManager: PurchaseManager
    //    let productIds = ["Spex_Lifetime_01"]
    //    private func loadProducts() async throws {
    //            self.products = try await Product.products(for: productIds)
    //        }
    //    private func purchase(_ product: Product) async throws {
    //        let result = try await product.purchase()
    //
    //        switch result {
    //        case let .success(.verified(transaction)):
    //            // Successful purhcase
    //            await transaction.finish()
    //        case let .success(.unverified(_, error)):
    //            // Successful purchase but transaction/receipt can't be verified
    //            // Could be a jailbroken phone
    //            break
    //        case .pending:
    //            // Transaction waiting on SCA (Strong Customer Authentication) or
    //            // approval from Ask to Buy
    //            break
    //        case .userCancelled:
    //            // ^^^
    //            break
    //        @unknown default:
    //            break
    //        }
    //    }
    //   
    //    @State private var products: [Product] = []
    @Environment(\.requestReview) var requestReview
    //   @State private var path = NavigationPath()
    let userDefaults = UserDefaults.standard
    @Binding var tabSelection: Int
    
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State private var isShowingAlert = false
    @State var defaultUserProfileHasBeenSet = false 
    @State var shouldShowUnlockLibraryAlert = false
    @State var spexLifetimeIsPurchased = false {
        didSet {
            userDefaults.set(spexLifetimeIsPurchased, forKey: "spexLifetimeIsPurchased")
        }
    }
    @State var shouldShowInstructionsViewModal = false
    @State var shouldShowSettingsViewModal = false
    
    func runStartupItems () {
        defaultUserProfileHasBeenSet = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
        spexLifetimeIsPurchased = userDefaults.bool(forKey: "spexLifetimeIsPurchased")
        setCurrentProfile()
        if !model.audioEngine.isRunning {
            model.prepareAudioEngine()
        }
        model.timesLaunched += 1
        if model.timesLaunched % 20 == 0 {
            requestReview()
        }
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
    
    func provideLibraryAccess () {
        spexLifetimeIsPurchased = true
    }
    
    func showInstructionsViewModal () {
        shouldShowInstructionsViewModal = true
        FirebaseAnalytics.Analytics.logEvent("show_instructions", parameters: nil)
    }
    
    func showSettingsViewModal () {
        shouldShowSettingsViewModal = true
        FirebaseAnalytics.Analytics.logEvent("show_settings", parameters: nil)
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
                }
                if !purchaseManager.hasPurchasedSpexLifetime && !spexLifetimeIsPurchased {
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
                                    Text ("If you didn't notice an improvement when toggling Spex on and off while listening to the demo songs at various intensities, and manually tweaking the boosts didn't help, Spex may not be for you.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("If you did notice an improvement, Spex may still not be for you because Spex only works with DRM-free audio files (MP3, AAC, ALAC, WAV and AIFF). It DOES NOT currently play tracks from paid subscription servcies such as Apple Music, Spotify and Tidal. If these services release compatible, public APIs, we will work to integrate them.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("Spex will recognize compatible songs and playlists you create in Apple's Music app and sync to your iPhone, subject to the restrictions mentioned above.")
                                    Spacer ()
                                }
                                HStack {
                                    Text ("If you would like to use Spex with your owned Music Library, you can make a one-time purchase of Spex Lifetime. Spex Lifetime will provide you with a lifetime of full access and free upgrades. No subscription required.")
                                    Spacer ()
                                }
                            }
                        }
                        Spacer ()
                        ForEach(purchaseManager.products) { product in
                            Button {
                                Task {
                                    do {
                                        try await purchaseManager.purchase(product)
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Text("\(product.displayPrice) - \(product.displayName)")
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(.blue)
//                                    .clipShape(Capsule())
                                    .font(.title)
                                    .foregroundColor(.blue)
                                    .padding ()
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .stroke( .blue, lineWidth: 5)
                                    )
                            }
                        }
                        Button {
                            Task {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                        }
                        
//                        Button("Spex Lifetime", 
//                               action: {
//                            shouldShowUnlockLibraryAlert = true
//                            model.tappedSpexLifetime += 1
//                            FirebaseAnalytics.Analytics.logEvent("spex_lifetime", parameters: [
//                                "tapped_spex_lifetime" : model.tappedSpexLifetime
//                            ])
//                        })
//                        .font(.title)
//                        .foregroundColor(.blue)
//                        .padding ()
//                        .overlay(
//                            Capsule(style: .continuous)
//                                .stroke( .blue, lineWidth: 5)
//                        )
                        .onAppear {
                         //   spexLifetimeIsPurchased = false
                            checkMusicLibaryAuthorization()
                            if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                                self.tabSelection = 3
                            }
                            if !model.audioEngine.isRunning {
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
                    .task {
                                Task {
                                    do {
                                        try await purchaseManager.loadProducts()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }

                } else {
                    
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
                                AlbumView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "square.stack"), text: "Albums")
                            }
                            NavigationLink {
                                GenreView()
                            } label: {
                                LibraryRowView(image: Image(systemName: "guitars"), text: "Genres")
                            }
                            NavigationLink {
                                SongsView(navigationTitleText: "Songs").onAppear {
                                    model.songList = allSongs
                                }
                            } label: {
                                LibraryRowView(image: Image(systemName: "music.note"), text: "Songs")
                            }
                            
                            
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Library")
                        .onAppear {
                            if !spexLifetimeIsPurchased {
                                spexLifetimeIsPurchased = true
                                print ("SET SPEX LIFETIME IS PURCHASED TO: \(spexLifetimeIsPurchased)")
                            }
                          //  spexLifetimeIsPurchased = false
                        }
                    }
                    
                    .onAppear{
                        //    model.didViewMusicLibrary = true
                        //    checkMusicLibaryAuthorization()
                        if !model.audioEngine.isRunning {
                            model.prepareAudioEngine()
                        }
                        if !model.initialHearingTestHasBeenCompleted  && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                        //   runStartupItems()
                        if model.testStatus != .stopped {
                            model.stopAndResetTest()
                        }
                        if model.demoIsPlaying {
                            model.stopDemoTrack()
                        }
                        
                    }
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
