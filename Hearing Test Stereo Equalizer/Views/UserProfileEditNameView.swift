//
//  UserProfileEditNameView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/9/23.
//

import SwiftUI

struct UserProfileEditNameView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
//    var currentUserProfile: UserProfile {
//        userProfiles.first {
//            $0.isActive
//        }!
//    } 
    @State private var newProfileName = ""
    @State private var shouldShowNamingAlert = false
    @FocusState private var focusedField: FocusedField?
    
    func saveNewProfileName (){
        if newProfileName.isEmpty {
            shouldShowNamingAlert = true
            return
        }
        userProfiles[0].name = newProfileName
        model.currentUserProfileName = newProfileName
        try? moc.save()
        dismiss()
    }
        
    
    
    enum FocusedField {
        case textField
    }
    
    var body: some View {
        VStack () {
            Text ("Profile Name")
                .font(.largeTitle)
            //            HStack {
            //                Text ("Every time you provide a fresh set of hearing measurements, you will associate them with a hearing profile.")
            //                Spacer()
            //            }
            ScrollView {
                VStack (spacing: 30) {
                    HStack {
                        Text ("If you want to create profiles for more than one set of headphones, you may want to include the name of the headphones in the profile name.")
                        Spacer()
                    }
                    HStack {
                        Text ("You can always change it later so no pressure.")
                        Spacer()
                    }
                }
            }
            
            //            HStack {
            //                Text ("You can always long-press the name in the Profile Manager to change it so no need to get hung up on it now.")
            //                Spacer()
            //            }
            
            //            HStack {
            //                Text ("You can also slide to delete unwanted profiles in the Profile Manager but you must always have at least one.")
            //                Spacer()
            //            }
            
            HStack {
                TextField(
                    "Profile name goes here",
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
            .alert("C'mon - you need at least one character.", isPresented: $shouldShowNamingAlert) {
                Button("Ok", role: .cancel) { }
            }
        }
        .padding()
    }
}

struct UserProfileEditNameView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileEditNameView()
    }
}
