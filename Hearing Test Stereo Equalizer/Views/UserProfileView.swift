//
//  UserProfileView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/13/23.
//

import SwiftUI
import FirebaseAnalytics

struct UserProfileView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State var currentUserName = ""
   // @State var defaultProfileIsCreated = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showUserProfileEditNameViewModal = false
    @State private var refreshID = UUID()
    @Binding var tabSelection: Int
    
    func setCurrentProfile () {
        model.currentUserProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
        model.currentUserProfileName = model.currentUserProfile.name ?? "Taco"
        model.currentIntensity = model.currentUserProfile.intensity
        model.setEQBands(for: model.currentUserProfile)
    }
    
    func refreshState () {
        refreshID = UUID()
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let profile = userProfiles[index]
            if userProfiles.count > 1 {
                moc.delete(profile)
            }
            for profile in userProfiles {
                profile.isActive = false
            }
            userProfiles[0].isActive = true
            model.currentUserProfile = userProfiles[0]
            try? moc.save()
        }
    }
    
    func setIsActiveStatus (userProfile: UserProfile) {
        userProfile.isActive = true
        let currentUUID = userProfile.iD
        for userProfile in userProfiles {
            if userProfile.iD == currentUUID {
                continue
            } else {
                userProfile.isActive = false
            }
        }
        try? moc.save()
        setCurrentProfile()
    }
    
    func addJustinXM5 () {
        let userProfile = UserProfile (context: moc)
        userProfile.name = "Justin XM5"
        userProfile.iD = UUID()
        userProfile.dateCreated = Date.now
        userProfile.intensity = 6.0
        userProfile.left60 = 4.732394
        userProfile.right60 = 4.267606
        userProfile.left100 = 2.7464788
        userProfile.right100 = 2.7887323
        userProfile.left230 = 1.4366198
        userProfile.right230 = 1.2676057
        userProfile.left500 = 0.0
        userProfile.right500 = 0.2535211
        userProfile.left1100 = 0.16901408
        userProfile.right1100 = 1.4366198
        userProfile.left2400 = 0.7183099
        userProfile.right2400 = 1.3943661
        userProfile.left5400 = 2.0704226
        userProfile.right5400 = 0.7605634
        userProfile.left12000 = 6.0
        userProfile.right12000 = 5.661972
        
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
    
//    func createDefaultProfile () {
//        let userProfile = UserProfile (context: moc)
//        userProfile.name = "Default (Flat EQ)"
//        userProfile.isActive = true
//        userProfile.iD = UUID()
//        userProfile.dateCreated = Date.now
//        userProfile.intensity = 2
//        userProfile.left60 = 0
//        userProfile.right60 = 0
//        userProfile.left100 = 0
//        userProfile.right100 = 0
//        userProfile.left230 = 0
//        userProfile.right230 = 0
//        userProfile.left500 = 0
//        userProfile.right500 = 0
//        userProfile.left1100 = 0
//        userProfile.right1100 = 0
//        userProfile.left2400 = 0
//        userProfile.right2400 = 0
//        userProfile.left5400 = 0
//        userProfile.right5400 = 0
//        userProfile.left12000 = 0
//        userProfile.right12000 = 0
//        
//        userProfile.left60M = 0
//        userProfile.right60M = 0
//        userProfile.left100M = 0
//        userProfile.right100M = 0
//        userProfile.left230M = 0
//        userProfile.right230M = 0
//        userProfile.left500M = 0
//        userProfile.right500M = 0
//        userProfile.left1100M = 0
//        userProfile.right1100M = 0
//        userProfile.left2400M = 0
//        userProfile.right2400M = 0
//        userProfile.left5400M = 0 
//        userProfile.right5400M = 0
//        userProfile.left12000M = 0
//        userProfile.right12000M = 0 
//        
//        model.currentUserProfile = userProfile
//        model.currentUserProfileName = userProfile.name!
//        model.currentIntensity = userProfile.intensity
//        for userProfile in userProfiles {
//            userProfile.isActive = false
//        }
//        try? moc.save()
//        
//   //     defaultProfileIsCreated = true
//        
//        FirebaseAnalytics.Analytics.logEvent("default_profile_created", parameters: nil)
//    }
    
    func goToTestTab () {
        self.tabSelection = 3
    }
    
    var body: some View {
        VStack (spacing: 30) {
            ZStack {
                Text ("Profiles")
                    .font(.largeTitle)
                HStack {
                    Spacer ()
                    Button ("+") {
                        goToTestTab()
                    }
                    .font(.largeTitle)
                }
                .padding()
            }
            
            if !userProfiles.isEmpty {
                List  {
                    ForEach (userProfiles, id: \.id) { userProfile in
                        UserProfileRowView(userProfile: userProfile)
                            .onTapGesture {
                                if !model.equalizerIsActive {
                                    model.equalizerIsActive = true
                                }
                                setIsActiveStatus(userProfile: userProfile)
                                refreshState()
                                FirebaseAnalytics.Analytics.logEvent("tap_user_profile", parameters: [
                                    "tapped_user_profile" : model.tappedUserProfile
                                ])
                                
                            }
                            .onLongPressGesture {
                                setIsActiveStatus(userProfile: userProfile)
                                setCurrentProfile()
                                showUserProfileEditNameViewModal = true
                            }
                            .foregroundColor(userProfile.isActive ? model.equalizerIsActive ? .green : .gray : colorScheme == .dark ? Color.white : Color.black)
                    }
                    .onDelete(perform: delete)
                }
                .sheet(isPresented: $showUserProfileEditNameViewModal, onDismiss: refreshState) {
                    UserProfileEditNameView()
                }
                .listStyle(PlainListStyle())
                .id(refreshID)
                .font(.title3)
                .onAppear {
                    refreshState()
                }
            }
            
            
            //            Button 	("Add Justin XM5") {
            //                addJustinXM5()
            //            }
            
            
        }
        .onAppear {
//           
            setCurrentProfile()
            if !model.initialHearingTestHasBeenCompleted && model.libraryAccessIsGranted {
                self.tabSelection = 3
            }
            if model.testStatus != .stopped {
                model.stopAndResetTest()
            }
        }
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}
