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
    
    @ObservedObject private var volObserver = VolumeObserver() 
    
   // let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    
    @State private var intensity: Double = 6.0
    
    @State private var bassBoost: Double = 0.0
    
    @State private var reverb: Double = 0.0
    
    @State private var soundLevel: Float = 0.0 
    
    @State private var slider = RepresentedMPVolumeView()
    
    @State private var systemSoundLevel: Float = 0.2
    
    @State private var soundLevelIsEditing = false
    
    @State private var intensityIsEditing = false
    
    @State private var sliderDidEdit = false
    
    let session = AVAudioSession.sharedInstance()
    
    var volumeFineTuneMin: Float {
            return session.outputVolume - 0.03
    }
    var volumeFineTuneMax: Float {
        return session.outputVolume + 0.03
    }
    
   
    
    init() {
        soundLevel = volObserver.volume
        print(volObserver.volume)
        print ("volumeFineTuneMin = \(volumeFineTuneMin)")
        print ("volumeFineTuneMax = \(volumeFineTuneMax)")
        }
    
 
    var body: some View {
        
        VStack {
            
            Toggle("Equalizer", isOn: $model.equalizerIsActive)
                .onChange(of: model.equalizerIsActive) { value in
                    model.toggleEqualizer()
                }
                .padding(25)
                .font(.title3)
            
            Text ("System Sound Level: \(volObserver.volume)")
            
            
            Text ("Sound Level: \(soundLevel)")
                .foregroundColor(soundLevelIsEditing ? .red : .blue)
                .onReceive(volObserver.$volume) { input in
                    if !sliderDidEdit {
                        print ("Received Volume Update")
                        soundLevel = session.outputVolume
                    }
                    sliderDidEdit = false
                }
            
            
            
            Slider(value: $soundLevel, in: volumeFineTuneMin...volumeFineTuneMax, onEditingChanged: { editing in
                        MPVolumeView.setVolume(self.soundLevel)
                soundLevelIsEditing = editing
                sliderDidEdit = true
                    })
            
            Text ("Intensity: \(intensity)")
                .foregroundColor(intensityIsEditing ? .red : .blue)
            
            Slider (value: $intensity, in: 0...14.0, step: 0.5, onEditingChanged: { editing in
                model.setEQBandsGainForSlider(currentProfile: model.currentProfile, intensity: intensity)
                intensityIsEditing = editing
             //   model.changeEQOnSliderUpdate(EQL: model.equalizerL1, EQR: model.equalizerR1)
            })
            .onAppear{
                intensity = model.currentIntensity
            }
            
//            Text ("Bass Boost: \(bassBoost)")
//            Slider (value: $bassBoost, in: 0...4.0, step: 0.5, onEditingChanged: { data in
//                model.setEQBandsGainForSlider(currentProfile: 1, intensity: intensity)
//                model.changeEQOnSliderUpdate(EQL: model.equalizerL1, EQR: model.equalizerR1)
//                model.bassBoost(/*EQL: model.equalizerL1, EQR: model.equalizerR1, */bassBoost: Float(bassBoost))
//            })
           
            
//            Slider(value: $soundLevel, in: 0...1, onEditingChanged: { data in
//                MPVolumeView.setVolume(self.soundLevel)
//                    })
            
//            Text("Set Intensity:")
//                .font(.title3)
//            
//            HStack (spacing: 30) {
//                
//                Button("01", 
//                       action: {
//                    model.setIntensity1()
//                })
//                .frame(width: 35, height: 35)
//                .background(model.currentIntensity == 1 ? Color.green : Color.clear)
//                .border(Color.white)
//                //  .padding(10)    
//                
//                Button("02", 
//                       action: {
//                    model.setIntensity2()
//                })
//                .frame(width: 35, height: 35)
//                .background(model.currentIntensity == 2 ? Color.green : Color.clear)
//                .border(Color.white)
//                //  .padding(10)
//                
//                
//                Button("03", 
//                       action: {
//                    model.setIntensity3()
//                })
//                .frame(width: 35, height: 35)
//                .background(model.currentIntensity == 3 ? Color.green : Color.clear)
//                .border(Color.white)
//                //    .padding(10)
//                
//                Button("04", 
//                       action: {
//                    model.setIntensity4()
//                })
//                .frame(width: 35, height: 35)
//                .background(model.currentIntensity == 4 ? Color.green : Color.clear)
//                .border(Color.white)
//                //    .padding(10)
//                
//                Button("05", 
//                       action: {
//                    model.setIntensity5()
//                })
//                .frame(width: 35, height: 35)
//                .background(model.currentIntensity == 5 ? Color.green : Color.clear)
//                .border(Color.white)
//                //  .padding(10)
//            }
//            .font(.title3)
//            .padding()
            
            
            
//            Text ("Reverb: \(reverb)")
//                
//            Slider (value: $reverb, in: 0...50, step: 2, onEditingChanged: { data in
//                model.changeReverbOnSliderUpdate(reverb: Float (reverb))
//            })
            
        }
        
        
    }
    
        
}
    
    


//struct PlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        EQView()
//            .environmentObject(Model())
//    }
//}
