//
//  PlayView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit

struct PlayView: View {
    
    // @EnvironmentObject var model: Model
    
    let storedValues = StoredValues.shared
    
    let audioEngine: AVAudioEngine = AVAudioEngine()
    @State var mixerL1 = AVAudioMixerNode()
    @State var mixerL2 = AVAudioMixerNode()
    @State var mixerL3 = AVAudioMixerNode()
    @State var mixerR1 = AVAudioMixerNode()
    @State var mixerR2 = AVAudioMixerNode()
    @State var mixerR3 = AVAudioMixerNode()
    @State var equalizerL1: AVAudioUnitEQ!
    @State var equalizerL2: AVAudioUnitEQ!
    @State var equalizerL3: AVAudioUnitEQ!
    @State var equalizerR1: AVAudioUnitEQ!
    @State var equalizerR2: AVAudioUnitEQ!
    @State var equalizerR3: AVAudioUnitEQ!
    let audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL2: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL3: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR2: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR3: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeS: AVAudioPlayerNode = AVAudioPlayerNode()
    @State var audioFile: AVAudioFile!
    @State var currentTrack = "edamame"
    @State var equalizerIsActive = true
    
    // Change the range of gain applied to the EQ min = 6, med = 8, max = 10.
    
    @State var currentIntensity = 2
    @State var currentProfile = 1
    @State var currentLowestAudibleDecibelBands = [Double]()
    
    @State var bandsGain1 = [Float]()
    @State var bandsGain2 = [Float]()
    @State var bandsGain3 = [Float]()
    
    // Populate all of these arrays on startup prior to setting any EQ bands gain.
    
    @State var profile_1_lowestAudibleDecibelBands = [Double]()
    @State var profile_2_lowestAudibleDecibelBands = [Double]()
    
    @State var EQStatusText = "" 
    
    // This function gives us the values we need to populate the EQ bands.
    
    func populateLowestAudibleDecibelBandsArrays () {
        profile_1_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_1, storedValues.lowestAudibleDecibelBand60R_1, storedValues.lowestAudibleDecibelBand100L_1, storedValues.lowestAudibleDecibelBand100R_1, storedValues.lowestAudibleDecibelBand230L_1, storedValues.lowestAudibleDecibelBand230R_1, storedValues.lowestAudibleDecibelBand500L_1, storedValues.lowestAudibleDecibelBand500R_1, storedValues.lowestAudibleDecibelBand1100L_1, storedValues.lowestAudibleDecibelBand1100R_1, storedValues.lowestAudibleDecibelBand2400L_1, storedValues.lowestAudibleDecibelBand2400R_1, storedValues.lowestAudibleDecibelBand5400L_1, storedValues.lowestAudibleDecibelBand5400R_1, storedValues.lowestAudibleDecibelBand12000L_1, storedValues.lowestAudibleDecibelBand12000R_1]
        profile_2_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_2, storedValues.lowestAudibleDecibelBand60R_2, storedValues.lowestAudibleDecibelBand100L_2, storedValues.lowestAudibleDecibelBand100R_2, storedValues.lowestAudibleDecibelBand230L_2, storedValues.lowestAudibleDecibelBand230R_2, storedValues.lowestAudibleDecibelBand500L_2, storedValues.lowestAudibleDecibelBand500R_2, storedValues.lowestAudibleDecibelBand1100L_2, storedValues.lowestAudibleDecibelBand1100R_2, storedValues.lowestAudibleDecibelBand2400L_2, storedValues.lowestAudibleDecibelBand2400R_2, storedValues.lowestAudibleDecibelBand5400L_2, storedValues.lowestAudibleDecibelBand5400R_2, storedValues.lowestAudibleDecibelBand12000L_2, storedValues.lowestAudibleDecibelBand12000R_2]
    }
    
    // Call this on startup to set the current profile:
    
    func setCurrentProfile () {
        currentProfile = storedValues.currentProfile
        print ("setCurrentProfile: \(currentProfile)")
    }
    
    func setCurrentIntensity () {
        currentIntensity = storedValues.currentIntensity
        print ("setCurrentIntensity: \(currentIntensity)")
    }
    
    // Sets the EQ gain based on the profile and intensity after the hearing test. Gets called on startup and when the profile is set.
    
    func updateCurrentLowestAudibleDecibelBandValues () {
        currentProfile = storedValues.currentProfile
        switch currentProfile {
        case 1: 
            currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
            currentLowestAudibleDecibelBands[0] = storedValues.lowestAudibleDecibelBand60L_1
            currentLowestAudibleDecibelBands[1] = storedValues.lowestAudibleDecibelBand60R_1
            currentLowestAudibleDecibelBands[2] = storedValues.lowestAudibleDecibelBand100L_1
            currentLowestAudibleDecibelBands[3] = storedValues.lowestAudibleDecibelBand100R_1
            currentLowestAudibleDecibelBands[4] = storedValues.lowestAudibleDecibelBand230L_1
            currentLowestAudibleDecibelBands[5] = storedValues.lowestAudibleDecibelBand230R_1
            currentLowestAudibleDecibelBands[6] = storedValues.lowestAudibleDecibelBand500L_1
            currentLowestAudibleDecibelBands[7] = storedValues.lowestAudibleDecibelBand500R_1
            currentLowestAudibleDecibelBands[8] = storedValues.lowestAudibleDecibelBand1100L_1
            currentLowestAudibleDecibelBands[9] = storedValues.lowestAudibleDecibelBand1100R_1
            currentLowestAudibleDecibelBands[10] = storedValues.lowestAudibleDecibelBand2400L_1
            currentLowestAudibleDecibelBands[11] = storedValues.lowestAudibleDecibelBand2400R_1
            currentLowestAudibleDecibelBands[12] = storedValues.lowestAudibleDecibelBand5400L_1
            currentLowestAudibleDecibelBands[13] = storedValues.lowestAudibleDecibelBand5400R_1
            currentLowestAudibleDecibelBands[14] = storedValues.lowestAudibleDecibelBand12000L_1
            currentLowestAudibleDecibelBands[15] = storedValues.lowestAudibleDecibelBand12000R_1
        case 2: 
            currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
            currentLowestAudibleDecibelBands[0] = storedValues.lowestAudibleDecibelBand60L_2
            currentLowestAudibleDecibelBands[1] = storedValues.lowestAudibleDecibelBand60R_2
            currentLowestAudibleDecibelBands[2] = storedValues.lowestAudibleDecibelBand100L_2
            currentLowestAudibleDecibelBands[3] = storedValues.lowestAudibleDecibelBand100R_2
            currentLowestAudibleDecibelBands[4] = storedValues.lowestAudibleDecibelBand230L_2
            currentLowestAudibleDecibelBands[5] = storedValues.lowestAudibleDecibelBand230R_2
            currentLowestAudibleDecibelBands[6] = storedValues.lowestAudibleDecibelBand500L_2
            currentLowestAudibleDecibelBands[7] = storedValues.lowestAudibleDecibelBand500R_2
            currentLowestAudibleDecibelBands[8] = storedValues.lowestAudibleDecibelBand1100L_2
            currentLowestAudibleDecibelBands[9] = storedValues.lowestAudibleDecibelBand1100R_2
            currentLowestAudibleDecibelBands[10] = storedValues.lowestAudibleDecibelBand2400L_2
            currentLowestAudibleDecibelBands[11] = storedValues.lowestAudibleDecibelBand2400R_2
            currentLowestAudibleDecibelBands[12] = storedValues.lowestAudibleDecibelBand5400L_2
            currentLowestAudibleDecibelBands[13] = storedValues.lowestAudibleDecibelBand5400R_2
            currentLowestAudibleDecibelBands[14] = storedValues.lowestAudibleDecibelBand12000L_2
            currentLowestAudibleDecibelBands[15] = storedValues.lowestAudibleDecibelBand12000R_2
        default: break
        }
    }
    
    // After we set the model's lowest decibels, we should be able to copy them to a new array.
    
    func setEQBandsGain () {
        currentProfile = storedValues.currentProfile
        print ("Setting EQ Bands")
        updateCurrentLowestAudibleDecibelBandValues()
        var minValue = 0.0
        var maxValue = -160.0
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            if currentLowestAudibleDecibelBands[i] < minValue {
                minValue = currentLowestAudibleDecibelBands[i]
            }
            if currentLowestAudibleDecibelBands[i] > maxValue {
                maxValue = currentLowestAudibleDecibelBands[i]
            }
        }
        if minValue == maxValue {
            minValue += 1
        }
        let multiplyer1: Double = min(6 / abs(minValue - maxValue), 1.0)
        let multiplyer2: Double = min(8 / abs(minValue - maxValue), 1.0)
        let multiplyer3: Double = min(10 / abs(minValue - maxValue), 1.0)
        
        // Intensity 1 band gain
        
        var workingBandsGain1 = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain1.insert(Float(multiplyer1 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(workingBandsGain1[i])")
        }
        bandsGain1 = workingBandsGain1
        
        // Intensity 2 band gain
        
        var workingBandsGain2 = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain2.insert(Float(multiplyer2 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(workingBandsGain2[i])")
        }
        bandsGain2 = workingBandsGain2
        
        // Intensity 3 band gain
        
        var workingBandsGain3 = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain3.insert(Float(multiplyer3 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(workingBandsGain3[i])")
        }
        bandsGain3 = workingBandsGain3
    }
    
    
    
    func stopTrack () {
        audioPlayerNodeL1.stop()
        audioPlayerNodeL2.stop()
        audioPlayerNodeL3.stop()
        audioPlayerNodeR1.stop()
        audioPlayerNodeR2.stop()
        audioPlayerNodeR3.stop()
        audioPlayerNodeS.stop()
    }
    
    
    func toggleEqualizer () {
        if equalizerIsActive {
            equalizerIsActive = false
            print ("Equalizer is off")
        } else {
            equalizerIsActive = true
            print ("Equalizer is active")
        }
        setEqualizerVolume()
    }
    
    func setEqualizerVolume () {
        currentIntensity = storedValues.currentIntensity
        currentProfile = storedValues.currentProfile
        setEQBandsGain()
        if equalizerIsActive {
            switch currentIntensity {
            case 1: 
                audioPlayerNodeL1.volume = 1
                print("IntensityL-1")
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeR1.volume = 1
                print ("IntensityR-1")
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeS.volume = 0
            case 2:
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 1
                print("IntensityL-2")
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 1
                print("IntensityR-2")
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeS.volume = 0
            case 3: 
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 1
                print("IntensityL-3")
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 1
                print("IntensityR-3")
                audioPlayerNodeS.volume = 0
            default: break
            }
        } else {
            audioPlayerNodeL1.volume = 0
            audioPlayerNodeL2.volume = 0
            audioPlayerNodeL3.volume = 0
            audioPlayerNodeR1.volume = 0
            audioPlayerNodeR2.volume = 0
            audioPlayerNodeR3.volume = 0
            audioPlayerNodeS.volume = 1
            print("Flat Stereo")
        }
    }
    
//    func setVolumeEqualizerIsOff () {
//        audioPlayerNodeL1.volume = 0
//        audioPlayerNodeL2.volume = 0
//        audioPlayerNodeL3.volume = 0
//        audioPlayerNodeR1.volume = 0
//        audioPlayerNodeR2.volume = 0
//        audioPlayerNodeR3.volume = 0
//        audioPlayerNodeS.volume = 1
//        print("Flat Stereo")
//    }
    
    // Apparent duplicate of above function
    
//    func setIntensityNodeVolumes () {
//        if equalizerIsActive {
//            switch currentIntensity {
//            case 1: 
//                audioPlayerNodeL1.volume = 1
//                audioPlayerNodeL2.volume = 0
//                audioPlayerNodeL3.volume = 0
//                audioPlayerNodeR1.volume = 1
//                audioPlayerNodeR2.volume = 0
//                audioPlayerNodeR3.volume = 0
//                audioPlayerNodeS.volume = 0
//               
//            case 2:
//                audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL2.volume = 1
//                audioPlayerNodeL3.volume = 0
//                audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR2.volume = 1
//                audioPlayerNodeR3.volume = 0
//                audioPlayerNodeS.volume = 0
//           
//            case 3: 
//                audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL2.volume = 0
//                audioPlayerNodeL3.volume = 1
//                audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR2.volume = 0
//                audioPlayerNodeR3.volume = 1
//                audioPlayerNodeS.volume = 0
//  
//            default: break
//            }
//        } else {
//            audioPlayerNodeL1.volume = 0
//            audioPlayerNodeL2.volume = 0
//            audioPlayerNodeL3.volume = 0
//            audioPlayerNodeR1.volume = 0
//            audioPlayerNodeR2.volume = 0
//            audioPlayerNodeR3.volume = 0
//            audioPlayerNodeS.volume = 1
//  
//        }
//        
//    }
    
    func playEdamame () {
        stopTrack()
        currentTrack = "edamame"
        setEQBandsGain()
        do {
            if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
                let filepathURL = NSURL.fileURL(withPath: filepath)
                audioFile = try AVAudioFile(forReading: filepathURL)
                
             //    Start your Engines 
                audioEngine.prepare()
                try audioEngine.start()
                
                
               setEqualizerVolume()
             
                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                
                
                // Left Ear 
                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()
                
                audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL2.pan = -1
                audioPlayerNodeL2.play()
                
                audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL3.pan = -1
                audioPlayerNodeL3.play()
                
                
                // Right Ear
                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
                
                audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR2.pan = 1
                audioPlayerNodeR2.play()
                
                audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR3.pan = 1
                audioPlayerNodeR3.play()
                
                // Flat Stereo
                audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeS.pan = 0
                audioPlayerNodeS.play()
            }
        } catch _ {print ("Catching Audio Engine Error")}
        
    }
    
    func playLevitating () {
        stopTrack()
        currentTrack = "levitating"
        setEQBandsGain()
        do {
            if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
                let filepathURL = NSURL.fileURL(withPath: filepath)
                audioFile = try AVAudioFile(forReading: filepathURL)
                
             //     Start your Engines 
                audioEngine.prepare()
                try audioEngine.start()
                
                setEqualizerVolume()
             
                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                // Left Ear 
                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()
                
                audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL2.pan = -1
                audioPlayerNodeL2.play()
                
                audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL3.pan = -1
                audioPlayerNodeL3.play()
                
                
                // Right Ear
                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
                
                audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR2.pan = 1
                audioPlayerNodeR2.play()
                
                audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR3.pan = 1
                audioPlayerNodeR3.play()
                
                // Flat Stereo
                audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeS.pan = 0
                audioPlayerNodeS.play()
            }
        } catch _ {}
        
    }
    

    
    func setIntensity1 () {
        currentIntensity = 1
        storedValues.currentIntensity = 1
        setEqualizerVolume()
        print ("Intesnity to: \(currentIntensity)")
    }
    
    func setIntensity2() {
        currentIntensity = 2
        storedValues.currentIntensity = 2
        setEqualizerVolume()
        print ("Intesnity to: \(currentIntensity)")
    }
    
    func setIntensity3() {
        currentIntensity = 3
        storedValues.currentIntensity = 3
        setEqualizerVolume()
        print ("Intesnity to: \(currentIntensity)")
    }
    
    func printLowestAudibleDecibelValuesProfile_2 (){
        print ("Band60L = \(storedValues.lowestAudibleDecibelBand60L_1)")
//        print ("Band60R = \(currentLowestAudibleDecibelBands[1])")
//        print ("Band100L = \(currentLowestAudibleDecibelBands[2])")
//        print ("Band100R = \(currentLowestAudibleDecibelBands[3])")
//        print ("Band230L = \(currentLowestAudibleDecibelBands[4])")
//        print ("Band230R = \(currentLowestAudibleDecibelBands[5])")
//        print ("Band500L = \(currentLowestAudibleDecibelBands[6])")
//        print ("Band500R = \(currentLowestAudibleDecibelBands[7])")
//        print ("Band1100L = \(currentLowestAudibleDecibelBands[8])")
//        print ("Band1100R = \(currentLowestAudibleDecibelBands[9])")
//        print ("Band2400L = \(currentLowestAudibleDecibelBands[10])")
//        print ("Band2400R = \(currentLowestAudibleDecibelBands[11])")
//        print ("Band5400L = \(currentLowestAudibleDecibelBands[12])")
//        print ("Band5400R = \(currentLowestAudibleDecibelBands[13])")
//        print ("Band12000L = \(currentLowestAudibleDecibelBands[14])")
//        print ("Band12000R = \(currentLowestAudibleDecibelBands[15])")
    }
    
    func updateBand60LForProfile1 () {
        storedValues.lowestAudibleDecibelBand60L_1 = -83.75
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
//                Text("Play a Song!")
//                    .font(.largeTitle)
//                    .padding(25)
                
                HStack {
                    Text("Current Profile: \(currentProfile)")
                        .padding(25)
                    
                    NavigationLink (destination: ProfileView()) {
                        Text ("Change")
                    }
                }
                    .padding(25)
                    
                Text("Intensity: \(currentIntensity)")
                        .padding(25)
                    
                Toggle("Equalizer", isOn: $equalizerIsActive)
                    .onChange(of: equalizerIsActive) { value in
                            toggleEqualizer()
                        }
                        .padding(25)
                    
                
                Button("Test Band 60L", 
                       action: {
                    updateBand60LForProfile1()
                })
                .padding(25)
                    
                    Button("Play Edamame", 
                           action: {
                        playEdamame()
                    })
                    .padding(25)
                    
                    
                    Button("Play Levitating", 
                           action: {
                        playLevitating()
                    })
                    .padding(25)
                
                    
                    Button("Stop Track", 
                           action: {
                        stopTrack()
                    })
                    .padding(25)
                    
                    
                    Button("Intensity 1", 
                           action: {
                        setIntensity1()
                    })
                    .padding(25)
                    
                    
                    Button("Intensity 2", 
                           action: {
                        setIntensity2()
                    })
                    .padding(25)
                    
                    
                    Button("Intensity 3", 
                           action: {
                        setIntensity3()
                    })
                    .padding(25)
            }
        }
        
    
        
        .onAppear {
            
            print ("PlayView On Appear Called")
            
            
          //   On startup, we set the last used profile to be the current profile.
            
            setCurrentProfile()
            
        //     On startup, we set the last used intensity to be the current intensity.
            
            setCurrentIntensity()
            
           
         //    On startup, we populate arrays from stored values that are used to set the gain on the EQ bands.
            
            
            
            populateLowestAudibleDecibelBandsArrays()
            
            
            
            
        //    updateCurrentLowestAudibleDecibelBandValues()
         
            
            // On startup, we set the gain on the EQ bands based on the current profile.
            
            setEQBandsGain()
            
            // Setup the 7 audio nodes: 3 on each channel at 3 intensities and 1 flat stereo.
            
            printLowestAudibleDecibelValuesProfile_2()
            
            let bandwidth: Float = 0.5
            let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
            
            // Left Ear 
            
            equalizerL1 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeL1) 
            audioEngine.attach(equalizerL1) 
            audioEngine.attach(mixerL1)
            audioEngine.connect(audioPlayerNodeL1, to: mixerL1, format: nil)
            audioEngine.connect(mixerL1, to: equalizerL1, format: nil)
            audioEngine.connect(equalizerL1, to: audioEngine.mainMixerNode, format: nil)
            let bandsL1 = equalizerL1.bands
            for i in 0...(bandsL1.count - 1) {
                bandsL1[i].frequency = Float(freqs[i])
                bandsL1[i].bypass = false
                bandsL1[i].bandwidth = bandwidth
                bandsL1[i].filterType = .parametric
                bandsL1[i].gain = bandsGain1[i]
            }
            
            equalizerL2 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeL2) 
            audioEngine.attach(equalizerL2) 
            audioEngine.attach(mixerL2)
            audioEngine.connect(audioPlayerNodeL2, to: mixerL2, format: nil)
            audioEngine.connect(mixerL2, to: equalizerL2, format: nil)
            audioEngine.connect(equalizerL2, to: audioEngine.mainMixerNode, format: nil)
            let bandsL2 = equalizerL2.bands
            for i in 0...(bandsL2.count - 1) {
                bandsL2[i].frequency = Float(freqs[i])
                bandsL2[i].bypass = false
                bandsL2[i].bandwidth = bandwidth
                bandsL2[i].filterType = .parametric
                bandsL2[i].gain = bandsGain2[i]
            }
            
            equalizerL3 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeL3) 
            audioEngine.attach(equalizerL3) 
            audioEngine.attach(mixerL3)
            audioEngine.connect(audioPlayerNodeL3, to: mixerL3, format: nil)
            audioEngine.connect(mixerL3, to: equalizerL3, format: nil)
            audioEngine.connect(equalizerL3, to: audioEngine.mainMixerNode, format: nil)
            let bandsL3 = equalizerL3.bands
            for i in 0...(bandsL3.count - 1) {
                bandsL3[i].frequency = Float(freqs[i])
                bandsL3[i].bypass = false
                bandsL3[i].bandwidth = bandwidth
                bandsL3[i].filterType = .parametric
                bandsL3[i].gain = bandsGain3[i]
            }
         
          
            
            // Right Ear
            equalizerR1 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeR1) 
            audioEngine.attach(equalizerR1) 
            audioEngine.attach(mixerR1)
            audioEngine.connect(audioPlayerNodeR1, to: mixerR1, format: nil)
            audioEngine.connect(mixerR1, to: equalizerR1, format: nil)
            audioEngine.connect(equalizerR1, to: audioEngine.mainMixerNode, format: nil)
            let bandsR1 = equalizerR1.bands
            for i in 0...(bandsR1.count - 1) {
                bandsR1[i].frequency = Float(freqs[i])
                bandsR1[i].bypass = false
                bandsR1[i].bandwidth = bandwidth
                bandsR1[i].filterType = .parametric
                bandsR1[i].gain = bandsGain1[i + bandsR1.count]
            }
            
            equalizerR2 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeR2) 
            audioEngine.attach(equalizerR2) 
            audioEngine.attach(mixerR2)
            audioEngine.connect(audioPlayerNodeR2, to: mixerR2, format: nil)
            audioEngine.connect(mixerR2, to: equalizerR2, format: nil)
            audioEngine.connect(equalizerR2, to: audioEngine.mainMixerNode, format: nil)
            let bandsR2 = equalizerR2.bands
            for i in 0...(bandsR2.count - 1) {
                bandsR2[i].frequency = Float(freqs[i])
                bandsR2[i].bypass = false
                bandsR2[i].bandwidth = bandwidth
                bandsR2[i].filterType = .parametric
                bandsR2[i].gain = bandsGain2[i + bandsR2.count]
            }
            
            equalizerR3 = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeR3) 
            audioEngine.attach(equalizerR3) 
            audioEngine.attach(mixerR3)
            audioEngine.connect(audioPlayerNodeR3, to: mixerR3, format: nil)
            audioEngine.connect(mixerR3, to: equalizerR3, format: nil)
            audioEngine.connect(equalizerR3, to: audioEngine.mainMixerNode, format: nil)
            let bandsR3 = equalizerR3.bands
            for i in 0...(bandsR3.count - 1) {
                bandsR3[i].frequency = Float(freqs[i])
                bandsR3[i].bypass = false
                bandsR3[i].bandwidth = bandwidth
                bandsR3[i].filterType = .parametric
                bandsR3[i].gain = bandsGain3[i + bandsR3.count]
            }

            
            // Flat Stereo
            audioEngine.attach(audioPlayerNodeS) 
            audioEngine.connect(audioPlayerNodeS, to: audioEngine.mainMixerNode, format: nil)
            
            
           
          
            
//            do {
//                if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
//                    let filepathURL = NSURL.fileURL(withPath: filepath)
//                    audioFile = try AVAudioFile(forReading: filepathURL)
//                    
//                    // Start your Engines 
//                    audioEngine.prepare()
//                    try audioEngine.start()
//                    print ("Tried to start audio engine")
                 
//                    let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
//                    
//                    // Left Ear 
//                    audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeL1.pan = -1
//                    audioPlayerNodeL1.volume = 0
//                    audioPlayerNodeL1.play()
//                    
//                    audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeL2.pan = -1
//                    audioPlayerNodeL2.volume = 1
//                    audioPlayerNodeL2.play()
//                    
//                    audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeL3.pan = -1
//                    audioPlayerNodeL3.volume = 0
//                    audioPlayerNodeL3.play()
//                    
//                    
//                    // Right Ear
//                    audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeR1.pan = 1
//                    audioPlayerNodeR1.volume = 0
//                    audioPlayerNodeR1.play()
//                    
//                    audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeR2.pan = 1
//                    audioPlayerNodeR2.volume = 1
//                    audioPlayerNodeR2.play()
//                    
//                    audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeR3.pan = 1
//                    audioPlayerNodeR3.volume = 0
//                    audioPlayerNodeR3.play()
//                    
//                    // Flat Stereo
//                    audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                    audioPlayerNodeS.pan = 0
//                    audioPlayerNodeS.volume = 0
//                    audioPlayerNodeS.play()
//                }
//            } catch _ {}
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
            .environmentObject(Model())
    }
}
