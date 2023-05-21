//
//  TestView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit
import FirebaseAnalytics

struct TestView: View {
    
    @EnvironmentObject var model: Model
    @ObservedObject private var volObserver = VolumeObserver() 
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
    @State private var shouldShowVolumeChangedAlert = false
    @State private var introStep = 0 {
        willSet {
            userDefaults.setValue(newValue, forKey: "introStep")  
        }
    }
    @State private var tonesCompleted = 0
    let userDefaults = UserDefaults.standard
//    @State private var tutorialCompleted = false {
//        willSet {
//            userDefaults.setValue(newValue, forKey: "tutorialCompleted")
//        }
//    }
    
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
    
    func readFromUserDefaults () {
        introStep = userDefaults.integer(forKey: "introStep")
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
        for userProfile in userProfiles {
            userProfile.isActive = false
        }
        let newUserProfile = UserProfile (context: moc)
        var minValue = 0.0
        var maxValue = -160.0
        for i in 0...model.lowestAudibleDecibelBands.count - 1 {
            if model.lowestAudibleDecibelBands[i] == 0 {
                continue
            }
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
            let eqBoost = min (multiplier * abs(minValue - model.lowestAudibleDecibelBands[i]), 6)
            workingBandsGain.insert (Float(eqBoost), at: i)
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
        
        newUserProfile.name = "My Profile"
        newUserProfile.intensity = 11.0
        newUserProfile.isActive = true
        newUserProfile.iD = UUID()
        newUserProfile.dateCreated = Date.now
        
        model.currentUserProfile = newUserProfile
        model.currentUserProfileName = "My Profile"
        
        try? moc.save()
        
        model.profilesCreated += 1
        
        FirebaseAnalytics.Analytics.logEvent("profile_created", parameters: [
            "profiles_created": model.profilesCreated
        ])
    }
    
    var body: some View {
        VStack (spacing: 20) {
            
            switch introStep {
            case 0:
                VStack () {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                            TestResultsView() 
                        }
                        .padding()
                    ScrollView {
                        VStack (spacing: 30) {
                            
                            HStack {
                                Text ("Spex will give you a hearing test and use the results to tune your music to your ears. If you have perfect hearing, Spex won't have anything to do. It's like if you have perfect vision, eye glasses won't help you. If you have less than perfect hearing, Spex will bring your music into focus. You can think of Spex as spectacles for your ears.")
                                Spacer()
                            }
                            HStack {
                                Text ("Before we get started, please note that Spex only works with DRM-free audio files (MP3, AAC, ALAC, WAV and AIFF). It DOES NOT currently play tracks from paid subscription services such as Apple Music, Spotify and Tidal. If these services release compatible, public APIs, we will work to integrate them.")
                                Spacer()
                            }
                            HStack {
                                Text ("After the hearing test, you'll see which frequencies Spex is boosting and by how much. It will apply zero boost to the frequency you hear the best, max boost to the frequency you hear the worst, and relative boosts to all the frequencies in between. In addition to seeing the boosts, you'll hear how these boosts bring the demo songs into focus. Toggle Spex on and off while listening to determine if Spex is for you.")
                                Spacer()
                            }
                            HStack {
                                Text ("If you discover that Spex helps you, you'll have the option to make a one-time purchase that will unlock all features, including access to your owned Music Library.")
                                Spacer()
                            }
                            HStack {
                                Text ("For the hearing test, you'll need headphones, a very quiet space, and about 15-20 minutes.")
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
                        introStep = 10
                        FirebaseAnalytics.Analytics.logEvent("click_to_intro_step_10", parameters: nil)
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .onAppear {
                        readFromUserDefaults()
                    }
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .padding()
                }
            case 10:
                VStack {
                    Text("Great!")
                        .font(.largeTitle)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                            TestResultsView() 
                        }
                        .padding()
                    ScrollView {
                        VStack (spacing: 30) {
                            
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
                        toneProgress = 0
                        tonesCompleted = 0
                        model.tapStartPracticeTest()
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .onAppear {
                        if model.demoIsPlaying {
                            model.stopDemoTrack()
                        }
                    }
                    .padding()
                }
            case 20:
                VStack (spacing: 40) {
                    Text("Practice")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                            TestResultsView() 
                        }
                        .onAppear {
                            if model.testStatus != .practiceInProgress {
                                introStep = 10
                            }
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
//                            toneProgress = 0
//                            model.testStatus = .practiceCompleted
                            introStep = 30
                        }
                        yesIsTemporarilyDisabled = true
                        preventDoulbleTap (buttonToggle: yesButtonIsDisabled)
                        model.tapPracticeYesHeard()
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
//                            toneProgress = 0
//                            model.testStatus = .practiceCompleted
                            introStep = 30
                        }
                        noIsTemporarilyDisabled = true
                        preventDoulbleTap (buttonToggle: noButtonIsDisabled)
                        model.tapPracticeNoDidNotHear()
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
                            Text ("One last thing. Please don't change your phone's volume or navigate to a different tab during the test or you will need to start over.")
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
                //    tutorialCompleted = true
                    toneProgress = 0
                    tonesCompleted = 0
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
            case 40:
                VStack (spacing: 40) {
                    Text("Testing in Progress")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                            TestResultsView() 
                        }
                        .padding(.top, 20)
                        .onAppear {
                            if model.testStatus != .testInProgress {
                                introStep = 50
                            }
                        }
                        .onChange(of: volObserver.volume, perform: {value in
                            shouldShowVolumeChangedAlert = true
                        })
                        .alert("Volume change detected. Measurements will be impacted. Do you wish to restart?", isPresented: $shouldShowVolumeChangedAlert) {
                            Button ("Restart Test", role: .destructive) {
                                model.stopAndResetTest()
                                toneProgress = 0
                                tonesCompleted = 0
                                model.tapStartTest()
                            }
                            Button("Continue Test", role: .cancel) { }
                        }
                    
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
                            showTestResultsView = true
                            introStep = 50
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
                    
                    ZStack {
                        
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
                }
            case 50: 
                VStack () {
                    Text("Create Profile")
                        .font(.largeTitle)
                        .sheet(isPresented: $showTestResultsView, onDismiss: dismissToSpexView) {
                            TestResultsView() 
                        }
                        .padding()
                    ScrollView {
                        VStack (spacing: 30) {
                            
                            HStack {
                                Text ("Every new profile begins with a hearing test.")
                                Spacer()
                            }
                            HStack {
                                Text ("We're going to measure 8 tones in your left ear and 8 tones in your right ear.")
                                Spacer()
                            }
                            HStack {
                                Text ("The first tone will be deep like bass and play in your left ear. Each tone will get progressively higher in pitch and after 8 tones we'll start over with a deep tone in your right ear.")
                                Spacer()
                            }
                            HStack {
                                Text ("As a reminder, please don't change your phone's volume or navigate to a different tab during the test or you will need to start over.")
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
                        if model.practiceToneBeforeTest {
                            introStep = 10
                        } else {
                            introStep = 40
                            toneProgress = 0
                            tonesCompleted = 0
                            model.tapStartTest()
                        }
                       
                    })
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.blue, lineWidth: 5)
                    )
                    .onAppear {
                        if model.demoIsPlaying {
                            model.stopDemoTrack()
                        }
                    }
                    .padding()
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
