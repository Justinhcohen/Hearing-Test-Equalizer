//
//  TestView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit

struct TestView: View {
    
    @EnvironmentObject var model: Model
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @Binding var tabSelection: Int
    
    let labelHeight: CGFloat = 0.06
    let labelWidth: CGFloat = 0.53
    let buttonWidth: CGFloat = 0.87
    
    @State private var isShowingCompareSilence = false
    @State private var noIsTemporarilyDisabled = false
    @State private var yesIsTemporarilyDisabled = false
    @State private var testProgress = 0.0
    @State private var showTestResultsView = false
    var doYouHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var yesIHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var noIDontHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var bandIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var noButtonIsDisabled : Bool {
        if !model.testInProgress {
            return true
        } else if noIsTemporarilyDisabled {
            return true
        } else {
            return false
        }
    }
    var yesButtonIsDisabled : Bool {
        if !model.testInProgress {
            return true
        } else if yesIsTemporarilyDisabled {
            return true
        } else {
            return false
        }
    }
    
    private func preventDoubleTapAsync(buttonToggle: Bool) async {
        // Delay of 0.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 500_000_000)
        if buttonToggle == noIsTemporarilyDisabled {
            noIsTemporarilyDisabled = false
        } else if buttonToggle == yesIsTemporarilyDisabled {
            yesIsTemporarilyDisabled = false
        }
    }
    
    private func preventDoulbleTap (buttonToggle: Bool) {
        Task {
            await preventDoubleTapAsync(buttonToggle: buttonToggle)
        }
    }
    
    private func dismissToLibraryView () {
        self.tabSelection = 1
    }
    
    private func saveProfileAfterTest () {
        print ("CALLED SAVE PROFILE AFTER TEST")
        let newUserProfile = UserProfile (context: moc)
        var minValue = 0.0
        var maxValue = -160.0
        for i in 0...model.lowestAudibleDecibelBands.count - 1 {
            if model.lowestAudibleDecibelBands[i] < minValue {
                minValue = model.lowestAudibleDecibelBands[i]
            }
            if model.lowestAudibleDecibelBands[i] > maxValue {
                maxValue = model.lowestAudibleDecibelBands[i]
            }
        }
        if abs (minValue - maxValue) < 1 {
            minValue = maxValue - 1 // Avoiding dividing by zero.
        }
        let multiplier: Double = min(6.0 / abs(minValue - maxValue), 1.0)
        
        var workingBandsGain = [Float]()
        for i in 0...model.lowestAudibleDecibelBands.count - 1 {
            workingBandsGain.insert(Float(multiplier * abs(minValue - model.lowestAudibleDecibelBands[i]) ), at: i)
        }
        newUserProfile.left60 = workingBandsGain[0]
        newUserProfile.left100 = workingBandsGain[1]
        newUserProfile.left230 = workingBandsGain[2]
        newUserProfile.left500 = workingBandsGain[3]
        newUserProfile.left1100 = workingBandsGain[4]
        newUserProfile.left2400 = workingBandsGain[5]
        newUserProfile.left5400 = workingBandsGain[6]
        newUserProfile.left12000 = workingBandsGain[7]
        newUserProfile.right60 = workingBandsGain[8]
        newUserProfile.right100 = workingBandsGain[9]
        newUserProfile.right230 = workingBandsGain[10]
        newUserProfile.right500 = workingBandsGain[11]
        newUserProfile.right1100 = workingBandsGain[12]
        newUserProfile.right2400 = workingBandsGain[13]
        newUserProfile.right5400 = workingBandsGain[14]
        newUserProfile.right12000 = workingBandsGain[15]
        
        newUserProfile.name = "Name me"
        newUserProfile.intensity = 6.0
        newUserProfile.isActive = true
        newUserProfile.iD = UUID()
        newUserProfile.dateCreated = Date.now
        
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        
        model.currentUserProfile = newUserProfile
        
        try? moc.save()
    }
    
    var body: some View {
       // GeometryReader { proxy in 
            NavigationStack {
                
                if !model.testInProgress {
                    VStack (spacing: 20) {
                        Text("\(model.testStatus)")
                            .font(.largeTitle)
                            .foregroundColor(model.testInProgress ? .green : .white)
                            .sheet(isPresented: $showTestResultsView, onDismiss: dismissToLibraryView) {
                                TestResultsView() 
                            }
                            .padding(.top, 20)
                        VStack (spacing: 20) {
                            HStack {
                                Text ("Let's test your hearing to build an EQ tuned to your ears.")
                                Spacer()
                            }
                            HStack {
                                Text ("You'll need headphones, a very quiet space, and about 10 - 15 minutes.")
                                Spacer()
                            }
                            HStack {
                                Text ("We're trying to find the softest tones that you can hear so much of the time you won't hear the tone or you'll barely be able to hear it.")
                                Spacer()
                            }
                            HStack {
                                Text ("Are you ready to begin?")
                                Spacer()
                            }
                        }
                        .padding()
                        Spacer()
                        Button("Start Test", 
                               action: {
                            if !model.testInProgress {
                                model.tapStartTest()
                            }
                        })
                        .font(.title)
                        .foregroundColor(model.testInProgress ? .gray : .blue)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(model.testInProgress ? Color.gray : Color.blue, lineWidth: 5)
                        )
                        .padding()
                    }
                    
                } else {
                    
                    Text("\(model.testStatus)")
                        .font(.largeTitle)
                        .foregroundColor(model.testInProgress ? .green : .white)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToLibraryView) {
                            TestResultsView() 
                        }
                        .padding(.top, 20)
                    
                    ProgressView("Progress", value: testProgress, total: 144)
                        .opacity(model.testInProgress ? 1.0 : 0)
                    
                    Spacer()
                    
                    VStack (spacing: 40) {
                        Text(!isShowingCompareSilence ? "Do you hear the tone?" : "")
                            .font(.title)
                            .opacity(model.testInProgress ? 1.0 : 0)
                        Button("Yes, I hear it", 
                               action: {
                            testProgress += 1
                            if testProgress == 144 {
                                testProgress = 0
                            }
                            yesIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: yesButtonIsDisabled)
                            if model.testInProgress {
                                model.tapYesHeard()
                            } else {
                                model.testStatus = "Congrats, All Done!"
                            }
                        })
                        .onChange(of: model.testInProgress, perform: {value in
                            if !model.testInProgress {
                                saveProfileAfterTest()
                                print ("Should Show Modal View")
                                showTestResultsView = true
                            } else {
                                return
                            }
                        })
                        .font(.title)
                        .foregroundColor(!yesButtonIsDisabled ? .green : .gray)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(!yesButtonIsDisabled ? Color.green : Color.gray, lineWidth: 5)
                        )
                        .opacity(yesIHearIsShown ? 1.0 : 0)
                        .disabled(yesButtonIsDisabled)
                        Button("No, I don't hear it", 
                               action: {
                            testProgress += 1
                            if testProgress == 144 {
                                testProgress = 0
                            }
                            noIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: noButtonIsDisabled)
                            if model.testInProgress {
                                model.tapNoDidNotHear()
                            } else {
                                model.testStatus = "Congrats, All Done!"
                            }
                        })
                        .font(.title)
                        .foregroundColor(!noButtonIsDisabled ? .red : .gray)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(!noButtonIsDisabled ? Color.red : Color.gray, lineWidth: 5)
                        )
                        .opacity(noIDontHearIsShown ? 1.0 : 0)
                        //       .padding(45)
                        .disabled(noButtonIsDisabled)
                        
                        Text("\(model.currentBand)")
                            .font(.headline)
                            .opacity(bandIsShown ? 1.0 : 0)
                        
                        Button {
                            if !isShowingCompareSilence {
                                model.stopTone()
                            } else {
                                model.resumeTone()
                            }
                            isShowingCompareSilence.toggle()
                        } label: {
                            if !isShowingCompareSilence {
                                Text("Compare Silence")
                            } else {
                                Text ("Back to Tone")
                            }
                        }
                        .font(.title)
                        .foregroundColor(model.testInProgress ? .blue : .gray)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(model.testInProgress ? Color.blue : Color.gray, lineWidth: 5)
                        )
                        .opacity(model.testInProgress ? 1.0 : 0)
                        .disabled(!model.testInProgress)
                        .padding (.bottom, 20)
                    }
                    .onAppear {
                        print ("TestView onAppear CALLED")
                    }
                }
    //        }
           
        }
        .onChange(of: model.testInProgress, perform: {value in
            if !model.testInProgress {
                saveProfileAfterTest()
                print ("Should Show Modal View")
                showTestResultsView = true
            } else {
                return
            }
        })
    }
}


//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
