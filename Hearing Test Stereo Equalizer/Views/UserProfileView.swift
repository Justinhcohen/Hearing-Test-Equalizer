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
    
//    func delete(at offsets: IndexSet) {
//        for index in offsets {
//            let profile = userProfiles[index]
//            if userProfiles.count > 1 {
//                moc.delete(profile)
//            }
//            for profile in userProfiles {
//                profile.isActive = false
//            }
//            userProfiles[0].isActive = true
//            model.currentUserProfile = userProfiles[0]
//            try? moc.save()
//        }
//    }
    
    func delete(at offsets: IndexSet) {
        var activeFlag = false
        for index in offsets {
            let profile = userProfiles[index]
            if userProfiles.count > 1 {
                moc.delete(profile)
                try? moc.save()
            }
            for profile in userProfiles {
                if profile.isActive == true {
                    activeFlag = true
                    print ("ACTIVE FLAG IS SET")
                }
            }
        }
        if !activeFlag {
            userProfiles[0].isActive = true
            model.currentUserProfile = userProfiles[0]
            print ("ACTIVE FLAG NOT SET")
        }
        try? moc.save()
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
    
    func duplicate(activeProfile: UserProfile) {
        let userProfile = UserProfile (context: moc)
        userProfile.name = "\(activeProfile.name ?? "Unknown Name") - Dupe"
        userProfile.iD = UUID()
        userProfile.dateCreated = Date.now
        userProfile.intensity = activeProfile.intensity
        userProfile.left60 = activeProfile.left60
        userProfile.right60 = activeProfile.right60
        userProfile.left100 = activeProfile.left100
        userProfile.right100 = activeProfile.right100
        userProfile.left230 = activeProfile.left230
        userProfile.right230 = activeProfile.right230
        userProfile.left500 = activeProfile.left500
        userProfile.right500 = activeProfile.right500
        userProfile.left1100 = activeProfile.left1100
        userProfile.right1100 = activeProfile.right1100
        userProfile.left2400 = activeProfile.left2400
        userProfile.right2400 = activeProfile.right2400
        userProfile.left5400 = activeProfile.left5400
        userProfile.right5400 = activeProfile.right5400
        userProfile.left12000 = activeProfile.left12000
        userProfile.right12000 = activeProfile.right12000
        
        userProfile.left60M = activeProfile.left60M
        userProfile.right60M = activeProfile.right60M
        userProfile.left100M = activeProfile.left100M
        userProfile.right100M = activeProfile.right100M
        userProfile.left230M = activeProfile.left230M
        userProfile.right230M = activeProfile.right230M
        userProfile.left500M = activeProfile.left500M
        userProfile.right500M = activeProfile.right500M
        userProfile.left1100M = activeProfile.left1100M
        userProfile.right1100M = activeProfile.right1100M
        userProfile.left2400M = activeProfile.left2400M
        userProfile.right2400M = activeProfile.right2400M
        userProfile.left5400M = activeProfile.left5400M
        userProfile.right5400M = activeProfile.right5400M
        userProfile.left12000M = activeProfile.left12000M
        userProfile.right12000M = activeProfile.right12000M
        
        model.currentUserProfile = userProfile
        model.currentUserProfileName = userProfile.name!
        model.currentIntensity = userProfile.intensity
        userProfile.isActive = true
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        
        try? moc.save()
    }
    
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
                        UserProfileRowView(userProfile: userProfile, intensity: userProfile.intensity)
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
            
            
            //                        Button 	("Add Justin XM5") {
            //                            addJustinXM5()
            //                        }
            
            Spacer()
            
            Button     ("Duplicate Active Profile") {
                let activeProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
                duplicate(activeProfile: activeProfile)
            }
            .font(.title3)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.blue, lineWidth: 5)
            )
            .foregroundColor(Color.blue)
            .padding (.bottom, 20)
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
