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
    @State private var toneProgress = 0.0
    @State private var showTestResultsView = false
    @State private var introStep = 0
    @State private var tonesCompleted = 0
    let userDefaults = UserDefaults.standard
    @State private var tutorialCompleted = false {
        willSet {
            userDefaults.setValue(newValue, forKey: "tutorialCompleted")
        }
    }
    
    var doYouHearIsShown: Bool {
      if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var yesIHearIsShown: Bool {
        if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var noIDontHearIsShown: Bool {
       if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    
    var noButtonIsDisabled : Bool {
     if noIsTemporarilyDisabled {
            return true
        } else {
            return false
        }
    }
    var yesButtonIsDisabled : Bool {
       if yesIsTemporarilyDisabled {
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
    
    private func dismissToSpexView () {
        self.tabSelection = 2
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
        
        newUserProfile.left60M = 0
        newUserProfile.left100M = 0
        newUserProfile.left230M = 0
        newUserProfile.left500M = 0
        newUserProfile.left1100M = 0
        newUserProfile.left2400M = 0
        newUserProfile.left5400M = 0
        newUserProfile.left12000M = 0
        newUserProfile.right60M = 0
        newUserProfile.right100M = 0
        newUserProfile.right230M = 0
        newUserProfile.right500M = 0
        newUserProfile.right1100M = 0
        newUserProfile.right2400M = 0
        newUserProfile.right5400M = 0
        newUserProfile.right12000M = 0
        
        newUserProfile.name = "Name me"
        newUserProfile.intensity = 8.0
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
            VStack (spacing: 20) {
            
                switch introStep {
                case 0:
                    ScrollView {
                        VStack (spacing: 20) {
                            Text("Welcome!")
                                .font(.largeTitle)
                                .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                                    TestResultsView() 
                                }
                                .padding(.top, 20)
                            HStack {
                                Text ("Before we get started, please note that Spex currently only works with your local music files. In the future, we hope to support streaming services such as Apple Music, Spotify, and Tidal.")
                                Spacer()
                            }
                            HStack {
                                Text ("If this is not a deal-breaker, let's test your hearing so that we can shape your music to fit your ears.")
                                Spacer()
                            }
                            HStack {
                                Text ("You'll need headphones, a very quiet space, and about 15-20 minutes.")
                                Spacer()
                            }
                            HStack {
                                Text ("Are you ready to begin?")
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    Button("I'm ready!", 
                           action: {
                        if model.audioPlayerNodeL1.isPlaying {
                            model.stopTrack()
                        }
                        tutorialCompleted = userDefaults.bool(forKey: "tutorialCompleted")
                        if !tutorialCompleted {
                            introStep = 10
                        } else {
                            introStep = 40
                            model.testStatus = .testInProgress
                        }
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .padding()
                case 10:
                    ScrollView {
                        VStack (spacing: 20) {
                            Text("Great!")
                                .font(.largeTitle)
                                .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                                    TestResultsView() 
                                }
                                .padding(.top, 20)
                            HStack {
                                Text ("We're going to play a tone and ask if you can hear it.")
                                Spacer()
                            }
                            HStack {
                                Text ("If you can hear the tone, the next tone will be quieter. If you can't hear the tone, the next tone will be louder. We're trying to hone in on the softest tone that you're able to hear. Most of the time you won't hear the tone and that's okay! Be honest with your answers.")
                                Spacer()
                            }
                            HStack {
                                Text ("Let's start with a practice tone so that you'll know what to expect.")
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    Button("Let's Go!", 
                           action: {
                        introStep = 20
                        model.toneIndex = 3
                        model.testStatus = .practiceInProgress
                        model.tapStartTest()
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .padding()
                case 20:
                    VStack (spacing: 40) {
                        Text("Practice")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                                TestResultsView() 
                            }
                            .padding(.top, 20)
                        
                        ProgressView("Progress", value: toneProgress, total: 9)
                        HStack {
                            Text ("Tones completed: 0 / 1")
                            Spacer()
                        }
                        
                        Text(!isShowingCompareSilence ? "Do you hear the tone?" : "")
                            .font(.title)
                        Button("Yes, I hear it", 
                               action: {
                            toneProgress += 1
                            if toneProgress == 9 {
                                toneProgress = 0
                                model.testStatus = .practiceCompleted
                                model.toneIndex = 0
                                introStep = 30
                            }
                            yesIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: yesButtonIsDisabled)
                            model.tapYesHeard()
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
                            toneProgress += 1
                            if toneProgress == 9 {
                                toneProgress = 0
                                model.testStatus = .practiceCompleted
                                model.toneIndex = 0
                                introStep = 30
                            }
                            noIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: noButtonIsDisabled)
                            model.tapNoDidNotHear()
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
                        
                        Spacer ()
                        
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
                        .foregroundColor(.blue)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(.blue, lineWidth: 5)
                        )
                        .padding (.bottom, 20)
                    }
                    .padding()
                case 30:
                    
                            Text("Great job!")
                                .font(.largeTitle)
                                .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                                    TestResultsView() 
                                }
                                .padding(.top, 20)
                    ScrollView {
                        VStack (spacing: 20) {
                            HStack {
                                Text ("You did it!")
                                Spacer()
                            }
                            HStack {
                                Text ("We were able to measure the sensitivity of your hearing in your left ear for that tone.")
                                Spacer()
                            }
                            HStack {
                                Text ("If you're ready to move forward, we're going to do the same thing with 8 tones in your left ear and 8 tones in your right ear.")
                                Spacer()
                            }
                            HStack {
                                Text ("The first tone will be deep like bass and play in your left ear. Each tone will get progressively higher in pitch and after 8 tones we'll start over with a deep tone in your right ear.")
                                Spacer()
                            }
                            HStack {
                                Text ("As a reminder, if you can't hear a tone, it doesn't mean you have bad hearing. It's important to provide accurate responses so that we can provide you with the best experience.")
                                Spacer()
                            }
                            HStack {
                                Text ("You can repeat this process as many times as you want and save unlimited hearing profiles so just relax and do your best.")
                                Spacer()
                            }
                            HStack {
                                Text ("One last thing. Please don't change your phone's volume during the test as this will throw off the measurements.")
                                Spacer()
                            }
                            HStack {
                                Text ("Are you ready?")
                                Spacer()
                            }
                        }
                        .padding()
                    }
                    Spacer()
                    Button("Let's Go!", 
                           action: {
                        introStep = 40
                        tutorialCompleted = true
                        model.testStatus = .testInProgress
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .padding()
                case 40:
                    VStack (spacing: 40) {
                        Text("Testing in Progress")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                                TestResultsView() 
                            }
                            .padding(.top, 20)
                        
                        ProgressView("Progress", value: toneProgress, total: 9)
                        HStack {
                            Text ("Tones completed: \(tonesCompleted) / 16")
                            Spacer()
                        }
                        
                        Text(!isShowingCompareSilence ? "Do you hear the tone?" : "")
                            .font(.title)
                        Button("Yes, I hear it", 
                               action: {
                            toneProgress += 1
                            if toneProgress == 9 {
                                toneProgress = 0
                                tonesCompleted += 1
                            }
                            yesIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: yesButtonIsDisabled)
                            if model.testStatus == .testInProgress {
                                model.tapYesHeard()
                            } else {
                                return
                            }
                        })
                        .onChange(of: model.testStatus, perform: {value in
                            if model.testStatus == .testCompleted {
                                saveProfileAfterTest()
                                print ("Should Show Modal View")
                                showTestResultsView = true
                                introStep = 0
                                tonesCompleted = 0
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
                            toneProgress += 1
                            if toneProgress == 9 {
                                toneProgress = 0
                                tonesCompleted += 1
                            }
                            noIsTemporarilyDisabled = true
                            preventDoulbleTap (buttonToggle: noButtonIsDisabled)
                            if model.testStatus == .testInProgress {
                                model.tapNoDidNotHear()
                            } else {
                               return
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
                        
                        Spacer ()
                        
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
                        .foregroundColor(.blue)
                        .padding ()
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(.blue, lineWidth: 5)
                        )
                        .padding (.bottom, 20)
                    }
                default: VStack {}
                    
                }
            }
        }
        
    }
    




//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
