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
    
    func createGainRowsFor (_ userProfile: UserProfile) -> [GainRowView] {
        var workingArray = [GainRowView]()
        var workingGainRow = GainRowView(leftGain: "", hertz: "", rightGain: "")
        for i in 0...7 {
            switch i {
            case 0: 
                workingGainRow.leftGain = "Left 60 = \(userProfile.left60.decimals(2))"
                workingGainRow.rightGain = "Right 60 = \(userProfile.right60.decimals(2))"
                workingGainRow.id = UUID()
            case 1: 
                workingGainRow.leftGain = "Left 100 = \(userProfile.left100.decimals(2))"
                workingGainRow.rightGain = "Right 100 = \(userProfile.right100.decimals(2))"
                workingGainRow.id = UUID()
            case 2: 
                workingGainRow.leftGain = "Left 230 = \(userProfile.left230.decimals(2))"
                workingGainRow.rightGain = "Right 230 = \(userProfile.right230.decimals(2))"
                workingGainRow.id = UUID()
            case 3: 
                workingGainRow.leftGain = "Left 500 = \(userProfile.left500.decimals(2))"
                workingGainRow.rightGain = "Right 500 = \(userProfile.right500.decimals(2))"
                workingGainRow.id = UUID()
            case 4: 
                workingGainRow.leftGain = "Left 1100 = \(userProfile.left1100.decimals(2))"
                workingGainRow.rightGain = "Right 1100 = \(userProfile.right1100.decimals(2))"
                workingGainRow.id = UUID()
            case 5: 
                workingGainRow.leftGain = "Left 2400 = \(userProfile.left2400.decimals(2))"
                workingGainRow.rightGain = "Right 2400 = \(userProfile.right2400.decimals(2))"
                workingGainRow.id = UUID()
            case 6: 
                workingGainRow.leftGain = "Left 5400 = \(userProfile.left5400.decimals(2))"
                workingGainRow.rightGain = "Right 5400 = \(userProfile.right5400.decimals(2))"
                workingGainRow.id = UUID()
            case 7: 
                workingGainRow.leftGain = "Left 12000 = \(userProfile.left12000.decimals(2))"
                workingGainRow.rightGain = "Right 12000 = \(userProfile.right12000.decimals(2))"
                workingGainRow.id = UUID()
                
            default: break
            }
            workingArray.append(workingGainRow)
            
        }
        return workingArray
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
                            Text ("2) Go to the Spex Tab and adjust the Intensity slider while listening to the demo song to find your sweet spot.")
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
                        
                        //                HStack {
                        //                    Text ("Ready for some tunes?")
                        //                    Spacer()
                        //                }
                        HStack {
                            Text ("Now for the fun part.")
                            Spacer()
                        }
                        HStack {
                            Text ("Head over to Spex Tab and slide the Intensity slider while listening to the demo song to find your sweet spot.")
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
