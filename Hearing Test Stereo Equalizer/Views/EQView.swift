//
//  PlayView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit
import MediaPlayer


struct EQView: View {
    
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var player: Player
    @Environment(\.isPresented) private var isPresented
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @Binding var tabSelection: Int
    let userDefaults = UserDefaults.standard
    @State var shouldShowText = true {
        willSet {
            userDefaults.set(newValue, forKey: "shouldShowText")
        }
    }
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private var volObserver = VolumeObserver() 
    
    // let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    
    @State private var intensity: Double = 6.0
    @State private var bassBoost: Double = 0.0
    @State private var reverb: Double = 0.0
    @State private var fineTuneSoundLevel: Float = 0 {
        didSet {
            model.fineTuneSoundLevel =  (0.7 + (fineTuneSoundLevel * 0.003))
        }
    }
    @State private var slider = RepresentedMPVolumeView()
    @State private var systemSoundLevel: Float = 0.2
    @State private var soundLevelIsEditing = false
    @State private var intensityIsEditing = false
    @State private var sliderDidEdit = false
    @State private var showUserProfilesModalView = false
    @State private var isPlayingDemoSong = false
    
    let session = AVAudioSession.sharedInstance()
    
    var volumeFineTuneMin: Float {
        return session.outputVolume - 0.03
    }
    var volumeFineTuneMax: Float {
        return session.outputVolume + 0.03
    }
    
    func didDismiss () {
        intensity = model.currentIntensity
    }
    
    func saveIntensity () {
        let activeUser = userProfiles.first {
            $0.isActive
        }!
        activeUser.intensity = intensity
        try? moc.save()
    }
    
    func toggleShouldShowText () {
        shouldShowText = !shouldShowText
    }
    
    //    func setCurrentProfile () {
    //        print ("CALLED SET CURRENT PROFILE")
    //        print ("default user profile has been set = \(defaultUserProfileHasBeenSet)")
    //        if defaultUserProfileHasBeenSet {
    //            model.currentUserProfile = userProfiles.first {
    //                $0.isActive
    //            }!
    //            model.currentUserProfileName = model.currentUserProfile.name ?? "Unknown Name"
    //            model.currentIntensity = model.currentUserProfile.intensity
    //            model.setEQBandsForCurrentProfile()
    //        } else {
    //            print ("CREATING DEFAULT PROFILE")
    //            createDefaultProfile()
    //            defaultUserProfileHasBeenSet = true
    //            userDefaults.set(true, forKey: "defaultUserProfileHasBeenSet")
    //            let temp = userDefaults.bool(forKey: "defaultUserProfileHasBeenSet")
    //            print ("User defaults temp value = \(temp)")
    //        }
    //    }
    
    func setCurrentProfileV2 () {
        print ("CALLED SET CURRENT PROFILE in EQVIEW")
        model.currentUserProfile = userProfiles.first {
            $0.isActive
        }!
        model.currentUserProfileName = model.currentUserProfile.name ?? "Unknown Name"
        model.currentIntensity = model.currentUserProfile.intensity
        intensity = model.currentUserProfile.intensity
        model.setEQBandsForCurrentProfile()
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack  {
                    ZStack {
                        UserProfileHeaderView()
                        HStack {
                            Spacer()
                            Button (action: toggleShouldShowText) {
                                if shouldShowText {
                                    Image(systemName: "eye")
                                } else {
                                    Image (systemName: "eye.slash")
                                }
                            }
                            .padding()
                        }
                    }
                    
                    ZStack {
                        if model.equalizerIsActive {
                            Image("SpexOwl1024")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        } else {
                            Image("SpexOwl1024BW")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                        Toggle("", isOn: $model.equalizerIsActive)
                            .onChange(of: model.equalizerIsActive) { value in
                                model.toggleEqualizer()
                            }
                            .padding(.trailing)
                            .padding(.leading)
                            .font(.title3)
                            .foregroundColor(model.equalizerIsActive ? .blue : .gray)
                    }
                    
                    HStack {
                        Text ("Spextometer")
                            .foregroundColor(intensityIsEditing ? .gray : model.equalizerIsActive ? .blue : .gray)
                    }
                    .font(.title3)
                    
                    Slider (value: $intensity, in: 2.0...14.0, onEditingChanged: { editing in
                        model.currentUserProfile.intensity = intensity
                        model.setEQBandsGainForSlider(for: model.currentUserProfile)
                        saveIntensity()
                        intensityIsEditing = editing
                    })
                    .onAppear{
                        setCurrentProfileV2()
                        print ("Model current intensity = \(model.currentIntensity)")
                        print ("User intensity = \(model.currentUserProfile.intensity)")
                        if model.equalizerL1 == nil {
                            model.prepareAudioEngine()
                        }
                        if !model.initialHearingTestHasBeenCompleted && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                    }
                    HStack {
                        Text ("Min")
                        Spacer()
                        Text ("Max")
                    }
                    
                    HStack {
                        Text ("While playing the demo song (or one of your songs from the Library tab), slide and let go of the Spextometer to find your ideal setting. Toggle Spex on and off to hear how it's shaping the sound to match your unique hearing profile.")
                            .foregroundColor(shouldShowText ? colorScheme == .dark ? Color.white : Color.black : .clear)
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.leading)
                    .padding(.trailing)
                    
                }
                Button {
                    if !isPlayingDemoSong {
                        model.playDemoTrack()
                    } else {
                        model.stopDemoTrack()
                    }
                    isPlayingDemoSong.toggle()
                } label: {
                    if !isPlayingDemoSong {
                        Text("Play Demo")
                    } else {
                        Text ("Stop Demo")
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
                
                Spacer ()
                
                HStack {
                    Text ("Subtle Volume Adjustment")
                        .foregroundColor(soundLevelIsEditing ? .gray : .blue)
                }
                .font(.title3)
                .foregroundColor(.blue)
                .padding (.top, 50)
                
                Slider(value: $fineTuneSoundLevel, in: 0...100, onEditingChanged: { editing in
                    model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    soundLevelIsEditing = editing
                })
                .onChange(of: volObserver.volume, perform: {value in
                    fineTuneSoundLevel = 0.0
                    model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                })
                
                HStack {
                    Text ("Spex Version 1.0")
                    Spacer()
                }
                
                
                
            }
            VStack {
                Spacer()
                PlayerView()
            }
            
        }
    }
}







//struct PlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        EQView()
//            .environmentObject(Model())
//    }
//}
