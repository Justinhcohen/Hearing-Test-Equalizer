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
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 25) {
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
                    
                    //                
                    //                            HStack {
                    //                                Text ("System Volume: \(volObserver.volume.decimals(2))")
                    //                                    .onChange(of: volObserver.volume, perform: {value in
                    //                                        fineTuneSoundLevel = 0.0
                    //                                        model.audioPlayerNodeL1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    //                                        model.audioPlayerNodeR1.volume = 0.7 + (fineTuneSoundLevel * 0.003)
                    //                                    })
                    //                                Spacer()
                    //                            }
                    //                            .padding(.bottom, 30)
                    //                            .font(.title3)
                    
                    HStack {
                        Text ("If you're having trouble getting the ideal volume from your phone's volume keys, go one click below too loud and then slide up and release to get it just right.")
                            .foregroundColor(shouldShowText ? colorScheme == .dark ? Color.white : Color.black : .clear)
                            .onAppear(perform: {
                                userDefaults.register(defaults: ["shouldShowText": true])
                                shouldShowText = userDefaults.bool(forKey: "shouldShowText")}
                            )
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    HStack {
                        Text ("Fine-Tune Volume Boost")
                            .foregroundColor(soundLevelIsEditing ? .gray : .blue)
                    }
                    .font(.title3)
                    .foregroundColor(.blue)
                    
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
                        Text ("Experiment with the strength slider to find the optimal listening experience. The far right is max strength, which is probably too much. Inch it back towards the left (letting go each time) until you get the best sound. Toggle Spex EQ on and off to hear how Spex EQ is shaping your music.")
                            .foregroundColor(shouldShowText ? colorScheme == .dark ? Color.white : Color.black : .clear)
                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.leading)
                    .padding(.trailing)
                    HStack {
                        Text ("Strength")
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
                        print ("Model current intensity = \(model.currentIntensity)")
                        print ("User intensity = \(model.currentUserProfile.intensity)")
                        intensity = model.currentIntensity
                        if model.equalizerL1 == nil {
                            model.prepareAudioEngine()
                        }
                        if !model.initialHearingTestHasBeenCompleted && model.libraryAccessIsGranted {
                            self.tabSelection = 3
                        }
                    }
                    Toggle("Spex EQ", isOn: $model.equalizerIsActive)
                        .onChange(of: model.equalizerIsActive) { value in
                            model.toggleEqualizer()
                        }
                        .padding(.trailing, 25)
                        .font(.title3)
                        .foregroundColor(model.equalizerIsActive ? .blue : .gray)
                }
                //            VStack (spacing: 0) {
                //                
                //                Text ("Stereo EQ Boost")
                //                    .padding()
                //                    .font(.title3)
                //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                HStack {
                //                    let left60 = model.currentUserProfile.left60 * (Float (intensity) / 6.0)
                //                    Text("\(left60.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("60 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right60 = model.currentUserProfile.right60 * (Float (intensity) / 6.0)
                //                    Text("\(right60.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left100 = model.currentUserProfile.left100 * (Float (intensity) / 6.0)
                //                    Text("\(left100.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("100 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right100 = model.currentUserProfile.right100 * (Float (intensity) / 6.0)
                //                    Text("\(right100.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left230 = model.currentUserProfile.left230 * (Float (intensity) / 6.0)
                //                    Text("\(left230.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("230 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right230 = model.currentUserProfile.right230 * (Float (intensity) / 6.0)
                //                    Text("\(right230.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left500 = model.currentUserProfile.left500 * (Float (intensity) / 6.0)
                //                    Text("\(left500.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("500 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right500 = model.currentUserProfile.right500 * (Float (intensity) / 6.0)
                //                    Text("\(right500.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left1100 = model.currentUserProfile.left1100 * (Float (intensity) / 6.0)
                //                    Text("\(left1100.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("1100 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right1100 = model.currentUserProfile.right1100 * (Float (intensity) / 6.0)
                //                    Text("\(right1100.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left2400 = model.currentUserProfile.left2400 * (Float (intensity) / 6.0)
                //                    Text("\(left2400.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("2400 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right2400 = model.currentUserProfile.right2400 * (Float (intensity) / 6.0)
                //                    Text("\(right2400.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left5400 = model.currentUserProfile.left5400 * (Float (intensity) / 6.0)
                //                    Text("\(left5400.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("5400 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right5400 = model.currentUserProfile.right5400 * (Float (intensity) / 6.0)
                //                    Text("\(right5400.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                HStack {
                //                    let left12000 = model.currentUserProfile.left12000 * (Float (intensity) / 6.0)
                //                    Text("\(left12000.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                    Text("12000 Hz")
                //                        .frame(maxWidth: .infinity)
                //                    let right12000 = model.currentUserProfile.right12000 * (Float (intensity) / 6.0)
                //                    Text("\(right12000.decimals(2))")
                //                        .foregroundColor(model.equalizerIsActive ? .green : .gray)
                //                        .frame(maxWidth: .infinity)
                //                }
                //                
                //            }
                
                // Spacer()
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
