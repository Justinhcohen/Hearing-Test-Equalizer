//
//  UserProfileHeaderView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/8/23.
//

import SwiftUI

struct UserProfileHeaderView: View {
    @EnvironmentObject var model: Model
  //  @State private var userProfile = UserProfile()
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @State private var userProfileName = ""
    @State private var showUserProfilesModalView = false
    @Environment(\.dismiss) private var dismiss
//    var defaultUserProfileHasBeenSet = true
//    @State var showUserProfilesModalView = false
    
//    func setCurrentProfile () {
//        if defaultUserProfileHasBeenSet {
//            model.currentUserProfile = userProfiles.first {
//                $0.isActive
//            }!
//        } else {
//            showUserProfilesModalView = true
//        }
//    }
    
    
    
    var body: some View {
        HStack {
            Spacer()
            Text(model.currentUserProfileName)
            Spacer()
        }
        .foregroundColor(model.equalizerIsActive ? .green : .gray)
        .font(.callout)
//        .onTapGesture {
//            showUserProfilesModalView = true
//        }
//        .sheet(isPresented: $showUserProfilesModalView) {
//            UserProfileView() 
//        }
    }
    
        
}

struct UserProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileHeaderView()
    }
}
