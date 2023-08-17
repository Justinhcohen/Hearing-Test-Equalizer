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
                            Text ("Head over to Spex Tab and move the Intensity slider to different positions while listening to the demo songs and the songs in your music library to find your ideal intensity. The default intensity level is set to 11 but your ideal intensity will likely be higher or lower so you'll want to experiment.")
                            Spacer()
                      }
                        HStack {
                            Text ("If you're still thinking the sound could be improved after you've found your ideal intensity, you can choose to show the Manual Adjustments button via a toggle in the Settings, which will give you full control over the EQ, but make sure you find your ideal intensity first.")
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

//struct TestResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestResultsView()
//    }
//}
