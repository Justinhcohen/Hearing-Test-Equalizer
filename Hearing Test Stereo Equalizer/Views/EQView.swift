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
    
    @ObservedObject private var volObserver = VolumeObserver() 
    
   // let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    
    @State private var intensity: Double = 6.0
    @State private var bassBoost: Double = 0.0
    @State private var reverb: Double = 0.0
    @State private var fineTuneSoundLevel: Float = 0.70 {
        didSet {
            model.fineTuneSoundLevel = fineTuneSoundLevel
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
    var body: some View {
        
        VStack {
            
            UserProfileHeaderView()
                .onTapGesture {
                    showUserProfilesModalView = true
                }
                .sheet(isPresented: $showUserProfilesModalView,
                       onDismiss: didDismiss) {
                    UserProfileView(tabSelection: $tabSelection)
                }
            
            Toggle("Equalizer", isOn: $model.equalizerIsActive)
                .onChange(of: model.equalizerIsActive) { value in
                    model.toggleEqualizer()
                }
                .padding(25)
                .font(.title3)
            
            Text ("System Sound Level: \(volObserver.volume)")
                .onChange(of: volObserver.volume, perform: {value in
                    fineTuneSoundLevel = 0.7
                    model.audioPlayerNodeL1.volume = fineTuneSoundLevel
                    model.audioPlayerNodeR1.volume = fineTuneSoundLevel
                })
            
            
            Text ("Fine Tune Sound Level: \(fineTuneSoundLevel)")
                .foregroundColor(soundLevelIsEditing ? .red : .blue)
            
            Slider(value: $fineTuneSoundLevel, in: 0.7...1.0, step: 0.01, onEditingChanged: { editing in
                model.audioPlayerNodeL1.volume = fineTuneSoundLevel
                model.audioPlayerNodeR1.volume = fineTuneSoundLevel
                soundLevelIsEditing = editing
                    })
            
            Text ("Intensity: \(intensity)")
                .foregroundColor(intensityIsEditing ? .red : .blue)
            
            Slider (value: $intensity, in: 0...12.0, step: 0.25, onEditingChanged: { editing in
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
                if !model.initialHearingTestHasBeenCompleted {
                    self.tabSelection = 3
                }
            }
            
            VStack {
                HStack {
                    var left60 = model.currentUserProfile.left60 * (Float (intensity) / 6.0)
                    Text("\(left60.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("60 Hz")
                        .frame(maxWidth: .infinity)
                    var right60 = model.currentUserProfile.right60 * (Float (intensity) / 6.0)
                    Text("\(right60.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left100 = model.currentUserProfile.left100 * (Float (intensity) / 6.0)
                    Text("\(left100.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("100 Hz")
                        .frame(maxWidth: .infinity)
                    var right100 = model.currentUserProfile.right100 * (Float (intensity) / 6.0)
                    Text("\(right100.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left230 = model.currentUserProfile.left230 * (Float (intensity) / 6.0)
                    Text("\(left230.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("230 Hz")
                        .frame(maxWidth: .infinity)
                    var right230 = model.currentUserProfile.right230 * (Float (intensity) / 6.0)
                    Text("\(right230.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left500 = model.currentUserProfile.left500 * (Float (intensity) / 6.0)
                    Text("\(left500.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("500 Hz")
                        .frame(maxWidth: .infinity)
                    var right500 = model.currentUserProfile.right500 * (Float (intensity) / 6.0)
                    Text("\(right500.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left1100 = model.currentUserProfile.left1100 * (Float (intensity) / 6.0)
                    Text("\(left1100.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("1100 Hz")
                        .frame(maxWidth: .infinity)
                    var right1100 = model.currentUserProfile.right1100 * (Float (intensity) / 6.0)
                    Text("\(right1100.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left2400 = model.currentUserProfile.left2400 * (Float (intensity) / 6.0)
                    Text("\(left2400.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("2400 Hz")
                        .frame(maxWidth: .infinity)
                    var right2400 = model.currentUserProfile.right2400 * (Float (intensity) / 6.0)
                    Text("\(right2400.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left5400 = model.currentUserProfile.left5400 * (Float (intensity) / 6.0)
                    Text("\(left5400.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("5400 Hz")
                        .frame(maxWidth: .infinity)
                    var right5400 = model.currentUserProfile.right5400 * (Float (intensity) / 6.0)
                    Text("\(right5400.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
                HStack {
                    var left12000 = model.currentUserProfile.left12000 * (Float (intensity) / 6.0)
                    Text("\(left12000.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                    Text("12000 Hz")
                        .frame(maxWidth: .infinity)
                    var right12000 = model.currentUserProfile.right12000 * (Float (intensity) / 6.0)
                    Text("\(right12000.decimals(2))")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
            PlayerView()
            

        }
        
        
    }
    
        
}
    
    


//struct PlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        EQView()
//            .environmentObject(Model())
//    }
//}
