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
    @State private var intensity: Double = 11.0
    @State private var intensityIsEditing = false
    
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
    
    func saveIntensity () {
        let activeUser = userProfiles.first {
            $0.isActive
        }!
        activeUser.intensity = intensity
        try? moc.save()
    }
    
    var body: some View {
        VStack (spacing: 30) {
            ZStack {
                Text ("Switch User Profile")
                    .font(.largeTitle)
                    .foregroundColor(model.equalizerIsActive ? .green : .gray )
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
            if model.equalizerIsActive {
                Image("SpexOwl1024")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
            } else {
                Image("SpexOwl1024BW")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
            }
            Text ("Intensity: \(intensity.decimals(2))")
                .foregroundColor(intensityIsEditing ? .gray : model.equalizerIsActive ? .blue : .gray)
                .font(.title3)
            Slider (value: $intensity, in: 2.0...20.0, step: 0.25, onEditingChanged: { editing in
                // model.currentUserProfile.intensity = intensity
                model.currentIntensity = intensity
                model.setEQBands(for: model.currentUserProfile)
                saveIntensity()
                intensityIsEditing = editing
                model.intensityAdjusted += 1
                FirebaseAnalytics.Analytics.logEvent("adjust_intensity", parameters: [
                    "intensity_adjusted": model.intensityAdjusted,
                    "intensity": model.currentIntensity
                ])
            })
            .disabled (!model.equalizerIsActive)
            .padding(.leading)
            .padding (.trailing)
            .padding (.bottom)
        }
        .onAppear {
            //           
            setCurrentProfile()
            if model.testStatus != .stopped {
                model.stopAndResetTest()
            }
            intensity = model.currentIntensity
        }
    }
}

//struct SwitchUserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwitchUserProfileView()
//    }
//}
