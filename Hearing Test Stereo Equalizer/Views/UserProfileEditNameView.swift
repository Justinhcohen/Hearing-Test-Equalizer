//
//  UserProfileEditNameView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/9/23.
//

import SwiftUI

struct UserProfileEditNameView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    var currentUserProfile: UserProfile {
        userProfiles.first {
            $0.isActive
        }!
    } 
    @State private var newProfileName = ""
    @FocusState private var focusedField: FocusedField?
    
    func saveNewProfileName (){
        currentUserProfile.name = newProfileName
        model.currentUserProfileName = newProfileName
        try? moc.save()
        dismiss()
    }
    
    enum FocusedField {
            case textField
        }
    
    var body: some View {
        VStack (spacing: 30) {
            Text ("Profile Name")
                .font(.largeTitle)
            HStack {
                Text ("If you have more than one pair of headphones, you may want to include their name so that you know which headphones go with which profile.")
                Spacer()
            }
            
            HStack {
                TextField(
                    "e.g. Sara's Silver Ultras",
                    text: $newProfileName,
                    onCommit: saveNewProfileName
                )
                .focused($focusedField, equals: .textField)
                .onAppear {
                    focusedField = .textField
                }
            }
            Spacer ()
            Button     ("Save") {
                saveNewProfileName()
            }
            .font(.title)
            .foregroundColor(.blue)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.blue, lineWidth: 5)
            )
        }
        .padding()
    }
}

struct UserProfileEditNameView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileEditNameView()
    }
}
