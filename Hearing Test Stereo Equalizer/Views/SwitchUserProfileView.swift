//
//  SwitchUserProfileView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/29/23.
//

import SwiftUI
import FirebaseAnalytics

struct SwitchUserProfileView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()
    
    func setCurrentProfile () {
        model.currentUserProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
        model.currentUserProfileName = model.currentUserProfile.name ?? "Taco"
        model.currentIntensity = model.currentUserProfile.intensity
        model.setEQBands(for: model.currentUserProfile)
    }
    
    func refreshState () {
        refreshID = UUID()
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
    
   
    
    var body: some View {
        VStack (spacing: 30) {
            ZStack {
                Text ("Switch User Profile")
                    .font(.largeTitle)
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
                                FirebaseAnalytics.Analytics.logEvent("tap_switch_user_profile", parameters: [
                                    "tapped_user_profile" : model.tappedUserProfile
                                ])
                                if !model.equalizerIsActive {
                                    model.equalizerIsActive = true
                                }
                                dismiss()
                                
                            }
                            .foregroundColor(userProfile.isActive ? model.equalizerIsActive ? .green : .gray : colorScheme == .dark ? Color.white : Color.black)
                    }
                }
                .listStyle(PlainListStyle())
                .id(refreshID)
                .font(.title3)
                .onAppear {
                    refreshState()
                }
            }
        }
        .onAppear {
            //           
            setCurrentProfile()
            if model.testStatus != .stopped {
                model.stopAndResetTest()
            }
        }
    }
}

//struct SwitchUserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwitchUserProfileView()
//    }
//}
