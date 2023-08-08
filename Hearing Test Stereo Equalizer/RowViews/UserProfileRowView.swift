//
//  UserProfileRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/14/23.
//

import SwiftUI

struct UserProfileRowView: View {
    @EnvironmentObject var model: Model
    var userProfile: UserProfile
    var intensity: Double
    
    var body: some View {
        HStack {
            Text(model.showIntensityWithProfile ? "\(userProfile.name ?? "Trees") - \(intensity.decimals(2))" : "\(userProfile.name ?? "Trees")")
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Spacer()
            Text (userProfile.dateCreated ??  Date(), style: .date)
            
        }
        .contentShape(Rectangle())
    }
}

//struct UserProfileRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileRowView(userProfile: UserProfile())
//    }
//}
