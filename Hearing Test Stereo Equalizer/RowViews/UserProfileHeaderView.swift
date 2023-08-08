//
//  UserProfileHeaderView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/8/23.
//

import SwiftUI

struct UserProfileHeaderView: View {
    @EnvironmentObject var model: Model
//    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
//    @State private var userProfileName = ""
    @State private var showSwitchUserProfileModalView = false
    @Environment(\.dismiss) private var dismiss
    
    

    var body: some View {
        HStack {
            Spacer()
            Button(model.showIntensityWithProfile ? "\(model.currentUserProfileName) - \(model.currentIntensity.decimals(2))" : "\(model.currentUserProfileName)") {
                showSwitchUserProfileModalView = true
            }
                .sheet(isPresented: $showSwitchUserProfileModalView) {
                    SwitchUserProfileView()
                }
            Spacer()
        }
        .foregroundColor(model.equalizerIsActive ? .green : .gray)
        .font(.callout)
    }
    
        
}

struct UserProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileHeaderView()
    }
}
