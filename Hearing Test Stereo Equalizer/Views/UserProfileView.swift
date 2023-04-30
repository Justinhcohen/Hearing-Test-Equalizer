//
//  UserProfileView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/13/23.
//

import SwiftUI

struct UserProfileView: View {
    
    struct GainRow {
        var leftGain = ""
        var rightGain = ""
    }
    
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State var currentUserName = ""
    @State var defaultProfileIsCreated = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showUserProfileEditNameViewModal = false
    @State private var refreshID = UUID()
    @Binding var tabSelection: Int
    
    
    
    
    func setCurrentProfile () {
        print ("CALLED SET CURRENT PROFILE IN USER PROFILE VIEW")
        model.currentUserProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
        model.currentUserProfileName = model.currentUserProfile.name ?? "Taco"
        model.currentIntensity = model.currentUserProfile.intensity
        model.setEQBands(for: model.currentUserProfile)
    }
    
    func refreshState () {
        refreshID = UUID()
        print ("CALLED DID DISMISS ON USER PROFILE VIEW")
    }
    
    func createDefaultProfileIfNone () {
        if userProfiles.isEmpty {
            createDefaultProfile()
        }
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
        print ("setIsActiveStatus CALLED")
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
        
        try? moc.save()
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
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        try? moc.save()
    }
    
    var body: some View {
        
        
        VStack (spacing: 30) {
            
            Text ("Profiles")
                .font(.largeTitle)
            
            if defaultProfileIsCreated {
               
                    List  {
                        ForEach (userProfiles, id: \.id) { userProfile in
                            UserProfileRowView(userProfile: userProfile)
                                .onTapGesture {
                                    if !model.equalizerIsActive {
                                        model.equalizerIsActive = true
                                    }
                                    setIsActiveStatus(userProfile: userProfile)
                               //     setCurrentProfile()
                                    refreshState()
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
                
                VStack (spacing: 10) {
                    HStack {
                        Text ("Take a hearing test to create a new profile.")
                        Spacer ()
                    }
                    HStack {
                        Text ("Create a new profile for each set of earphones you use and tap the name to switch between them.")
                        Spacer ()
                    }
                    HStack {
                        Text ("Longpress to rename.")
                        Spacer ()
                    }
                    HStack {
                        Text ("Swipe left to delete.")
                        Spacer ()
                    }
               
                }
                .padding()
                
//                VStack {
//                    Text ("Boost at 6.0 Intensity")
//                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                        .font(.title3)
//                        .padding()
//                    HStack {
//                        Text("\(model.currentUserProfile.left60.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("60 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right60.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left100.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("100 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right100.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left230.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("230 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right230.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left500.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("500 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right500.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left1100.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("1100 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right1100.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left2400.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("2400 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right2400.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left5400.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("5400 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right5400.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    HStack {
//                        Text("\(model.currentUserProfile.left12000.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                        Text("12000 Hz")
//                            .frame(maxWidth: .infinity)
//                        Text("\(model.currentUserProfile.right12000.decimals(2))")
//                            .foregroundColor(model.equalizerIsActive ? .green : .gray)
//                            .frame(maxWidth: .infinity)
//                    }
//                    
//                }
            }
            
            
//            Button 	("Add Justin XM5") {
//                addJustinXM5()
//            }
//            .sheet(isPresented: $showUserProfileEditNameViewModal, onDismiss: refreshState) {
//                UserProfileEditNameView()
//            }
            
        }
        .onAppear {
            createDefaultProfileIfNone()
            setCurrentProfile()
            defaultProfileIsCreated = true
            if !model.initialHearingTestHasBeenCompleted && model.libraryAccessIsGranted {
                self.tabSelection = 3
            }
        }
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}
