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
    @State private var showManualControlsView = false
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
        print ("Called Save Intensity")
        let activeUser = userProfiles.first {
            $0.isActive
        }!
        activeUser.intensity = intensity
        try? moc.save()
    }
    
    func toggleShouldShowText () {
        print ("Tapped Toggle Should Show Text")
        shouldShowText = !shouldShowText
    }
    
    func setCurrentProfileV2 () {
        print ("CALLED SET CURRENT PROFILE in EQVIEW")
        model.currentUserProfile = userProfiles.first {
            $0.isActive
        }!
        model.currentUserProfileName = model.currentUserProfile.name ?? "Unknown Name"
        model.currentIntensity = model.currentUserProfile.intensity
        intensity = model.currentUserProfile.intensity
        model.setEQBands(for: model.currentUserProfile)
        
    }
    
    var body: some View {
        VStack {
            VStack {
                // User Profile Header View at the top
                UserProfileHeaderView()    
                
                // A ZStack that has the owl and the toggle
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
                
                // The intensity text above the slider and the intensity slider
                Text ("Intensity: \(intensity.decimals(2))")
                    .foregroundColor(intensityIsEditing ? .gray : model.equalizerIsActive ? .blue : .gray)
                    .font(.title3)
                
                Slider (value: $intensity, in: 2.0...20.0, step: 0.25, onEditingChanged: { editing in
                    model.currentUserProfile.intensity = intensity
                    model.currentIntensity = intensity
                    model.setEQBands(for: model.currentUserProfile)
                    saveIntensity()
                    intensityIsEditing = editing
                })
                .disabled (!model.equalizerIsActive)
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
                
                // The play demo button just below the slider
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
                .padding ()
                .overlay(
                    Capsule(style: .continuous)
                    //  .stroke(.blue, lineWidth: 5)
                        .stroke(shouldShowText ? Color.blue : Color.clear, lineWidth: 5)
                )
                .foregroundColor(shouldShowText ? Color.blue : Color.clear)
                .padding (.bottom, 20)
                .disabled(!shouldShowText)
                
                
                // The listing of EQ Boosts
                VStack {
                    Group {
                        
                            ZStack {
                                Text ("Spex Stereo EQ Boost")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .font(.title3)
                                    .padding()
                                HStack {
                                    Spacer ()
                                    Text ("+M")
                                        .foregroundColor((model.manualAdjustmentsAreActive && model.equalizerIsActive) ? .green : .gray)
                                        .font(.title3)
                                        .padding()
                                }
                            }
                        ScrollView {
                            HStack {
                                let left60 = model.currentUserProfile.left60 * Float(intensity / 6.0)
                                Text("\(left60.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("60 Hz")
                                    .frame(maxWidth: .infinity)
                                let right60 = model.currentUserProfile.right60 * Float(intensity / 6.0)
                                Text("\(right60.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left100 = model.currentUserProfile.left100 * Float(intensity / 6.0)
                                Text("\(left100.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("100 Hz")
                                    .frame(maxWidth: .infinity)
                                let right100 = model.currentUserProfile.right100 * Float(intensity / 6.0)
                                Text("\(right100.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left230 = model.currentUserProfile.left230 * Float(intensity / 6.0)
                                Text("\(left230.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("230 Hz")
                                    .frame(maxWidth: .infinity)
                                let right230 = model.currentUserProfile.right230 * Float(intensity / 6.0)
                                Text("\(right230.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left500 = model.currentUserProfile.left500 * Float(intensity / 6.0)
                                Text("\(left500.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("500 Hz")
                                    .frame(maxWidth: .infinity)
                                let right500 = model.currentUserProfile.right500 * Float(intensity / 6.0)
                                Text("\(right500.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left1100 = model.currentUserProfile.left1100 * Float(intensity / 6.0)
                                Text("\(left1100.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("1100 Hz")
                                    .frame(maxWidth: .infinity)
                                let right1100 = model.currentUserProfile.right1100 * Float(intensity / 6.0)
                                Text("\(right1100.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left2400 = model.currentUserProfile.left2400 * Float(intensity / 6.0)
                                Text("\(left2400.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("2400 Hz")
                                    .frame(maxWidth: .infinity)
                                let right2400 = model.currentUserProfile.right2400 * Float(intensity / 6.0)
                                Text("\(right2400.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left5400 = model.currentUserProfile.left5400 * Float(intensity / 6.0)
                                Text("\(left5400.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("5400 Hz")
                                    .frame(maxWidth: .infinity)
                                let right5400 = model.currentUserProfile.right5400 * Float(intensity / 6.0)
                                Text("\(right5400.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                            }
                            HStack {
                                let left12000 = model.currentUserProfile.left12000 * Float(intensity / 6.0)
                                Text("\(left12000.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                Text("12000 Hz")
                                    .frame(maxWidth: .infinity)
                                let right12000 = model.currentUserProfile.right12000 * Float(intensity / 6.0)
                                Text("\(right12000.decimals(2))")
                                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            
                            
                        }
                    }
                }
            }
            
            // The Manual Adjustments Button
            
            VStack {
                
                
                
                Button("Manual Adjustments", 
                       action: {
                    showManualControlsView = true
                })
                .font(.title)
                .foregroundColor(model.equalizerIsActive ? .blue : .gray)
                .padding ()
                .overlay(
                    Capsule(style: .continuous)
                        .stroke( model.equalizerIsActive ? .blue : .gray, lineWidth: 5)
                ) 
                .sheet(isPresented: $showManualControlsView, onDismiss: didDismiss) {
                    ManualEQView()
                }
                .disabled(!model.equalizerIsActive)
                
                // The Player
                
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
