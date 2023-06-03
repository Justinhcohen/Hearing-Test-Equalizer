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
    @State private var newProfileName = ""
    @State private var shouldShowNamingAlert = false
    @FocusState private var focusedField: FocusedField?
    enum FocusedField {
        case textField
    }
    
    func saveNewProfileName (){
        if newProfileName.isEmpty {
            shouldShowNamingAlert = true
            return
        }
        let activeProfile = userProfiles.first {$0.isActive} ?? userProfiles.first!
        activeProfile.name = newProfileName
        model.currentUserProfileName = newProfileName
        try? moc.save()
        dismiss()
    }

    var body: some View {
        VStack (spacing: 30) {
            Text ("Update Name")
                .font(.largeTitle)
            HStack {
                Text ("Current Name: \(model.currentUserProfileName)")
                Spacer()
            }
            HStack {
                TextField(
                    "New name",
                    text: $newProfileName,
                    onCommit: saveNewProfileName
                )
                .focused($focusedField, equals: .textField)
                .disableAutocorrection(true)
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
            .alert("C'mon - you need at least one character. : )", isPresented: $shouldShowNamingAlert) {
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
