//
//  TestResultsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/10/23.
//

import SwiftUI

struct TestResultsView: View {
    @EnvironmentObject var model: Model
    @State private var showUserProfileEditNameViewModal = false
    @State private var didRenameProfile = false
    @Environment(\.dismiss) private var dismiss
    
    func didDismiss () {
        didRenameProfile = true
    }
    
    var body: some View {
        
        if !didRenameProfile {
            VStack {
                Text("Test Complete!")
                    .font(.largeTitle)
                ScrollView {
                    VStack (spacing: 30) {
                        HStack{       
                            Text ("Great job! Thank you for providing your hearing measurements.")
                            Spacer()
                        }
                        
                        HStack{
                            Text ("The next steps are:")
                            Spacer()
                        }
                        HStack {
                            Text ("1) Give your profile a name.")
                            Spacer()
                        }
                        HStack {
                            Text ("2) Go to the Spex Tab and adjust the Intensity slider while listening to the demo songs to find your sweet spot.")
                            Spacer()
                        }
                    }
                }
                Spacer()
                
                Button ("Name Profile") {
                    showUserProfileEditNameViewModal = true
                }
                .font(.title)
                .foregroundColor(.blue)
                .padding ()
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.blue, lineWidth: 5)
                )
                .sheet(isPresented: $showUserProfileEditNameViewModal, onDismiss: didDismiss) {
                    UserProfileEditNameView()
                }
            }
            .padding()
        } else {
            VStack {
                Text ("Excellent!")
                    .font(.largeTitle)
                ScrollView {
                    VStack (spacing: 30) {
                        HStack {
                            Text ("Now for the fun part.")
                            Spacer()
                        }
                        HStack {
                            Text ("Head over to Spex Tab and move the Intensity slider to different positions while listening to the demo songs to find your sweet spot.")
                            Spacer()
                        }
                        HStack {
                            Text ("If you can't get it just right, you'll have the option to tweak the boost of each frequency individually.")
                            Spacer()
                        }
                    }
                    
                }
                .padding()
                Spacer()
                Button ("Spex Tab") {
                    dismiss()
                }
                .font(.title)
                .foregroundColor(.blue)
                .padding ()
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.blue, lineWidth: 5)
                )
            }
             
        }
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView()
    }
}
