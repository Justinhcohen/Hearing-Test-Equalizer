//
//  UserProfileRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/14/23.
//

import SwiftUI

struct UserProfileRowView: View {
    
    var userProfile: UserProfile
    
    var body: some View {
        HStack {
            Text(userProfile.name ?? "Unknown Name")
            Spacer()
            Text (userProfile.dateCreated ??  Date(), style: .date)
            
        }
        .contentShape(Rectangle())
    }
}

struct UserProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileRowView(userProfile: UserProfile())
    }
}
