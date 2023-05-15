//
//  UserProfileHeaderView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/8/23.
//

import SwiftUI

struct UserProfileHeaderView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @State private var userProfileName = ""
    @State private var showUserProfilesModalView = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            Spacer()
            Text(model.currentUserProfileName)
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
