//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
//    @EnvironmentObject var model: Model
    
//    // The  player variables.
//    
//    var audioEngine: AVAudioEngine = AVAudioEngine()
//    @State var mixerL1 = AVAudioMixerNode()
//    @State var mixerL2 = AVAudioMixerNode()
//    @State var mixerL3 = AVAudioMixerNode()
//    @State var mixerR1 = AVAudioMixerNode()
//    @State var mixerR2 = AVAudioMixerNode()
//    @State var mixerR3 = AVAudioMixerNode()
//    @State var equalizerL1: AVAudioUnitEQ!
//    @State var equalizerL2: AVAudioUnitEQ!
//    @State var equalizerL3: AVAudioUnitEQ!
//    @State var equalizerR1: AVAudioUnitEQ!
//    @State var equalizerR2: AVAudioUnitEQ!
//    @State var equalizerR3: AVAudioUnitEQ!
//    var audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeL2: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeL3: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeR2: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeR3: AVAudioPlayerNode = AVAudioPlayerNode()
//    var audioPlayerNodeS: AVAudioPlayerNode = AVAudioPlayerNode()
//    @State var audioFile: AVAudioFile!
//    @State var currentTrack = ""
//    @State var equalizerIsActive = true
//    
//    // Change the range of gain applied to the EQ min = 6, med = 8, max = 10.
//    
//    @State var currentIntensity = 2
//    @State var currentProfile = 1
//    @State var currentLowestAudibleDecibelBands = [Double]()
//    
//    // Populate all of these arrays on startup prior to setting any EQ bands gain.
//    
//    @State var profile_1_lowestAudibleDecibelBands = [Double]()
//    @State var profile_2_lowestAudibleDecibelBands = [Double]()
//    
//    @State var EQStatusText = ""
//    
//    
//    
//    // The test variables 
//    @State var tonePlayer: AVAudioPlayer?
//    @State var currentTone = ""
//    @State var toneIndex = 0
//    
//    // The tone array will likely be used when the hearing test plays bands out of order.
//    
////    let toneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
//    
//    // Hearing test variables used to set the EQ gain.
//    
//    @State var maxUnheard: Double = -160
//    @State var minHeard: Double = 0.0
//    
//    
//    @State var bandsGain1 = [Float]()
//    @State var bandsGain2 = [Float]()
//    @State var bandsGain3 = [Float]()
//    
//    // Toggle the EQ on and off
//    
//    
//    
//    // Call this on startup to populated the lowest audible decibel band arrays from stored values.
//    
//    func populateLowestAudibleDecibelBandsArrays () {
//        profile_1_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_1, storedValues.lowestAudibleDecibelBand60R_1, storedValues.lowestAudibleDecibelBand100L_1, storedValues.lowestAudibleDecibelBand100R_1, storedValues.lowestAudibleDecibelBand230L_1, storedValues.lowestAudibleDecibelBand230R_1, storedValues.lowestAudibleDecibelBand500L_1, storedValues.lowestAudibleDecibelBand500R_1, storedValues.lowestAudibleDecibelBand1100L_1, storedValues.lowestAudibleDecibelBand1100R_1, storedValues.lowestAudibleDecibelBand2400L_1, storedValues.lowestAudibleDecibelBand2400R_1, storedValues.lowestAudibleDecibelBand5400L_1, storedValues.lowestAudibleDecibelBand5400R_1, storedValues.lowestAudibleDecibelBand12000L_1, storedValues.lowestAudibleDecibelBand12000R_1]
//        profile_2_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_2, storedValues.lowestAudibleDecibelBand60R_2, storedValues.lowestAudibleDecibelBand100L_2, storedValues.lowestAudibleDecibelBand100R_2, storedValues.lowestAudibleDecibelBand230L_2, storedValues.lowestAudibleDecibelBand230R_2, storedValues.lowestAudibleDecibelBand500L_2, storedValues.lowestAudibleDecibelBand500R_2, storedValues.lowestAudibleDecibelBand1100L_2, storedValues.lowestAudibleDecibelBand1100R_2, storedValues.lowestAudibleDecibelBand2400L_2, storedValues.lowestAudibleDecibelBand2400R_2, storedValues.lowestAudibleDecibelBand5400L_2, storedValues.lowestAudibleDecibelBand5400R_2, storedValues.lowestAudibleDecibelBand12000L_2, storedValues.lowestAudibleDecibelBand12000R_2]
//    }
//    
//    // Call this on startup to set the current profile:
//    
//    func setCurrentProfile () {
//        currentProfile = storedValues.currentProfile
//    }
//    
//    func setCurrentIntensity () {
//        currentIntensity = storedValues.currentIntensity
//    }
//    
//    // Sets the EQ gain based on the profile and intensity after the hearing test. Gets called on startup and when the profile is set.
//    
//    func setEQBandsGain () {
//        switch currentProfile {
//        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
//        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
//        default: break
//        }
//        var minValue = 0.0
//        var maxValue = -160.0
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            if currentLowestAudibleDecibelBands[i] < minValue {
//                minValue = currentLowestAudibleDecibelBands[i]
//            }
//            if currentLowestAudibleDecibelBands[i] > maxValue {
//                maxValue = currentLowestAudibleDecibelBands[i]
//            }
//        }
//        let multiplyer1: Double = (6 / abs(minValue - maxValue))
//        let multiplyer2: Double = (8 / abs(minValue - maxValue))
//        let multiplyer3: Double = (10 / abs(minValue - maxValue))
//        
//        // Intensity 1 band gain
//        
//        var workingBandsGain1 = [Float]()
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            workingBandsGain1.insert(Float(multiplyer1 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
//        }
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            print ("\(workingBandsGain1[i])")
//        }
//        bandsGain1 = workingBandsGain1
//        
//        // Intensity 2 band gain
//        
//        var workingBandsGain2 = [Float]()
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            workingBandsGain2.insert(Float(multiplyer2 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
//        }
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            print ("\(workingBandsGain2[i])")
//        }
//        bandsGain2 = workingBandsGain2
//        
//        // Intensity 3 band gain
//        
//        var workingBandsGain3 = [Float]()
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            workingBandsGain3.insert(Float(multiplyer3 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
//        }
//        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
//            print ("\(workingBandsGain3[i])")
//        }
//        bandsGain3 = workingBandsGain3
//    }
//    
//    // For the hearing test, returns the volume of the tone for a target decibel level.
//    
//    func getVolume (decibelReduction: Double) -> Double {
//        
//        return (1 / pow(10,(-decibelReduction / 20)))
//        
//    }
//    
//    // For the hearing test, when the decibel difference between a heard and unheard tone is less than .5 decibels, we assign the decibel level of the minimum heard tone of the associated band to the stored value of the appropriate profile.
//    
//    func assignMinHeardDecibels () {
//        switch currentProfile {
//        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
//        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
//        default: break
//        }
//        switch toneIndex {
//        case 0: currentLowestAudibleDecibelBands[0] = minHeard
//        case 1: currentLowestAudibleDecibelBands[1] = minHeard
//        case 2: currentLowestAudibleDecibelBands[2] = minHeard
//        case 3: currentLowestAudibleDecibelBands[3] = minHeard
//        case 4: currentLowestAudibleDecibelBands[4] = minHeard
//        case 5: currentLowestAudibleDecibelBands[5] = minHeard
//        case 6: currentLowestAudibleDecibelBands[6] = minHeard
//        case 7: currentLowestAudibleDecibelBands[7] = minHeard
//        case 8: currentLowestAudibleDecibelBands[8] = minHeard
//        case 9: currentLowestAudibleDecibelBands[9] = minHeard
//        case 10: currentLowestAudibleDecibelBands[10] = minHeard
//        case 11: currentLowestAudibleDecibelBands[11] = minHeard
//        case 12: currentLowestAudibleDecibelBands[12] = minHeard
//        case 13: currentLowestAudibleDecibelBands[13] = minHeard
//        case 14: currentLowestAudibleDecibelBands[14] = minHeard
//        case 15: currentLowestAudibleDecibelBands[15] = minHeard
//        default: break
//        }
//    }
//    
//    // For the hearing test, we set the currentTone string equal to the name of the tone's mp3 file.
//    
//    func setCurrentTone () {
//        switch toneIndex {
//        case 0: currentTone = "Band60"
//        case 1: currentTone = "Band60"
//        case 2: currentTone = "Band100"
//        case 3: currentTone = "Band100"
//        case 4: currentTone = "Band230"
//        case 5: currentTone = "Band230"
//        case 6: currentTone = "Band500"
//        case 7: currentTone = "Band500"
//        case 8: currentTone = "Band1100"
//        case 9: currentTone = "Band1100"
//        case 10: currentTone = "Band2400"
//        case 11: currentTone = "Band2400"
//        case 12: currentTone = "Band5400"
//        case 13: currentTone = "Band5400"
//        case 14: currentTone = "Band12000"
//        case 15: currentTone = "Band12000"
//        default: break
//        }
//    }
//    
//    // For the hearing test, plays the tone on repeat at the volume needed for the desired decibel level. The tone is currently based on the index because we're going through the tones in order from lowest to highest. 
//    
//    func playTone (volume: Float){
//        //  print ("Called playTone")
//        setCurrentTone()
//        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
//        do {
//            tonePlayer = try AVAudioPlayer(contentsOf: url)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        if let tonePlayer = tonePlayer {
//            //  print ("playTone second stage")
//            tonePlayer.volume = volume
//            tonePlayer.numberOfLoops = -1
//            if toneIndex % 2 == 0 {
//                tonePlayer.pan = -1
//            } else {
//                tonePlayer.pan = 1
//            }
//            print ("playTone currentTone = \(currentTone)")
//            tonePlayer.play()
//        }
//    }
//    
//    // For the hearing test, stops the tone after a user has pressed either the heard or did not hear button.
//    
//    func stopTone () {
//        if let tonePlayer = tonePlayer {
//            tonePlayer.stop()
//        }
//    }
//    
//    func stopTrack () {
//        audioPlayerNodeL1.stop()
//        audioPlayerNodeL2.stop()
//        audioPlayerNodeL3.stop()
//        audioPlayerNodeR1.stop()
//        audioPlayerNodeR2.stop()
//        audioPlayerNodeR3.stop()
//        audioPlayerNodeS.stop()
//    }
//    
//    // For the hearing test, after a tone is set (difference between heard and unheard is less than .5 decibels), we reset the maxUnheard and minHeard values for the next tone.
//    
//    func resetMinMaxValues () {
//        maxUnheard = -160
//        minHeard = 0.0
//    }
//    
//    // Prints the lowest audible decibel levels for each band associated with the current profile.
//    
//    func printDecibelValues () {
//        print ("Band60L = \(currentLowestAudibleDecibelBands[0])")
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
//    }
//    
//    // For the hearing test, assigns the min heard decibel value for the appropriate band associated with the appropriate profile after the user has reached a .5 decibel difference between the heard and unheard tones. If we have more tones to go, it will queue up the next tone, otherwise it will switch the status view to "Test Complete!"
//    
//    func bandComplete () {
//        assignMinHeardDecibels()
//        resetMinMaxValues()
//        if toneIndex < toneArray.count - 1 {
//            toneIndex += 1
//            print ("bandComplete maxUnheard = \(maxUnheard)")
//            print ("bandComplete minHeard = \(minHeard)")
//            playTone(volume: Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2))))
//        } else {
//            toneIndex = 0
//            print ("Test Complete!")
//        }
//        printDecibelValues()
//    }
//    
//    // The hearing test begins and plays the current tone, which should be at toneIndex = 0. The prints show the minHeard and maxUnheard getting closer together after each button press.
//    
//    func tapStartTest () {
//        let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
//        playTone(volume: volume)
//        print ("tapStartTest volume = \(volume)")
//        print ("tapStartTest maxUnheard = \(maxUnheard)")
//        print ("tapStartTest minHeard = \(minHeard)")
//    }
//    
//    // During the hearing test, the user taps yes when they hear the tone. This updates the minimum audible decibel value for that band. If the min heard and max unheard are within .5 decibels, the band is complete and on to the next one. If not complete, we play the tone again louder if they didn't hear it and softer if they did.
//    
//    func tapYesHeard () {
//        stopTone()
//        minHeard = (maxUnheard + minHeard) / 2
//        if abs (maxUnheard - minHeard) < 0.5 {
//            print ("tapYesHeard bandComplete")
//            bandComplete()
//        } else {
//            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
//            print ("tapYesHeard volume = \(volume)")
//            print ("tapYesHeard maxUnheard = \(maxUnheard)")
//            print ("tapYesHeard minHeard = \(minHeard)")
//            playTone(volume: volume)
//        }
//        
//        // During the hearing test, the user taps if they don't hear the tone. This sets the new maxUnheard value for that band. If the min heard and max unheard are within .5 decibels, we move on to the next band. If not, we play the tone again louder if they didn't hear it and softer if they did.
//    }
//    
//    func tapNoDidNotHear () {
//        stopTone()
//        maxUnheard = (maxUnheard + minHeard) / 2
//        if abs(maxUnheard - minHeard) < 0.5 {
//            print ("tapNoDidNotHear bandComplete")
//            bandComplete()
//        } else {
//            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
//            print ("tapNoDidNotHear volume = \(volume)")
//            print ("tapNoDidNotHear tone = \(toneArray[toneIndex])")
//            print ("tapNoDidNotHear maxUnheard = \(maxUnheard)")
//            print ("tapNoDidNotHear minHeard = \(minHeard)")
//            playTone(volume: volume)
//        }
//        
//        // While playing a track, it toggles the EQ effect off by settign the EQ nodes to 0 and the flat node to 1.
//        
//    }
//    
//    func toggleEqualizer () {
//        if equalizerIsActive {
//            setVolumeEqualizerIsOff()
//            equalizerIsActive = false
//        } else {
//            setVolumeEqualizerIsActive()
//            equalizerIsActive = true
//        }
//    }
//    
//    func setVolumeEqualizerIsActive () {
//        switch currentIntensity {
//        case 1: 
//            audioPlayerNodeL1.volume = 1
//            audioPlayerNodeL2.volume = 0
//            audioPlayerNodeL3.volume = 0
//            audioPlayerNodeR1.volume = 1
//            audioPlayerNodeR2.volume = 0
//            audioPlayerNodeR3.volume = 0
//            audioPlayerNodeS.volume = 0
//            EQStatusText = "Intensity 1"
//        case 2:
//            audioPlayerNodeL1.volume = 0
//            audioPlayerNodeL2.volume = 1
//            audioPlayerNodeL3.volume = 0
//            audioPlayerNodeR1.volume = 0
//            audioPlayerNodeR2.volume = 1
//            audioPlayerNodeR3.volume = 0
//            audioPlayerNodeS.volume = 0
//            EQStatusText = "Intensity 2"
//        case 3: 
//            audioPlayerNodeL1.volume = 0
//            audioPlayerNodeL2.volume = 0
//            audioPlayerNodeL3.volume = 1
//            audioPlayerNodeR1.volume = 0
//            audioPlayerNodeR2.volume = 0
//            audioPlayerNodeR3.volume = 1
//            audioPlayerNodeS.volume = 0
//            EQStatusText = "Intensity 3"
//        default: break
//        }
//    }
//    
//    func setVolumeEqualizerIsOff () {
//        audioPlayerNodeL1.volume = 0
//        audioPlayerNodeL2.volume = 0
//        audioPlayerNodeL3.volume = 0
//        audioPlayerNodeR1.volume = 0
//        audioPlayerNodeR2.volume = 0
//        audioPlayerNodeR3.volume = 0
//        audioPlayerNodeS.volume = 1
//        EQStatusText = "EQ is Off"
//    }
//    
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
//                EQStatusText = "Intensity 1"
//            case 2:
//                audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL2.volume = 1
//                audioPlayerNodeL3.volume = 0
//                audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR2.volume = 1
//                audioPlayerNodeR3.volume = 0
//                audioPlayerNodeS.volume = 0
//                EQStatusText = "Intensity 2"
//            case 3: 
//                audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL2.volume = 0
//                audioPlayerNodeL3.volume = 1
//                audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR2.volume = 0
//                audioPlayerNodeR3.volume = 1
//                audioPlayerNodeS.volume = 0
//                EQStatusText = "Intensity 3"
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
//            EQStatusText = "EQ is Off"
//        }
//        
//    }
//    
//    func playEdamame () {
//        stopTrack()
//        currentTrack = "edamame"
//        do {
//            if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
//                let filepathURL = NSURL.fileURL(withPath: filepath)
//                audioFile = try AVAudioFile(forReading: filepathURL)
//                
//                // Start your Engines 
//                audioEngine.prepare()
//                try audioEngine.start()
//                
//                setIntensityNodeVolumes()
//             
//                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
//                
//                
//                
//                // Left Ear 
//                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL1.pan = -1
//               // audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL1.play()
//                
//                audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL2.pan = -1
//              //  audioPlayerNodeL2.volume = 1
//                audioPlayerNodeL2.play()
//                
//                audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL3.pan = -1
//             //   audioPlayerNodeL3.volume = 0
//                audioPlayerNodeL3.play()
//                
//                
//                // Right Ear
//                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR1.pan = 1
//           //     audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR1.play()
//                
//                audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR2.pan = 1
//         //       audioPlayerNodeR2.volume = 1
//                audioPlayerNodeR2.play()
//                
//                audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR3.pan = 1
//            //    audioPlayerNodeR3.volume = 0
//                audioPlayerNodeR3.play()
//                
//                // Flat Stereo
//                audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeS.pan = 0
//            //    audioPlayerNodeS.volume = 0
//                audioPlayerNodeS.play()
//            }
//        } catch _ {}
//        
//    }
//    
//    func playLevitating () {
//        stopTrack()
//        currentTrack = "levitating"
//        do {
//            if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
//                let filepathURL = NSURL.fileURL(withPath: filepath)
//                audioFile = try AVAudioFile(forReading: filepathURL)
//                
//                // Start your Engines 
//                audioEngine.prepare()
//                try audioEngine.start()
//                
//                setIntensityNodeVolumes()
//             
//                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
//                
//                // Left Ear 
//                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL1.pan = -1
//              //  audioPlayerNodeL1.volume = 0
//                audioPlayerNodeL1.play()
//                
//                audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL2.pan = -1
//            //    audioPlayerNodeL2.volume = 1
//                audioPlayerNodeL2.play()
//                
//                audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeL3.pan = -1
//             //   audioPlayerNodeL3.volume = 0
//                audioPlayerNodeL3.play()
//                
//                
//                // Right Ear
//                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR1.pan = 1
//            //    audioPlayerNodeR1.volume = 0
//                audioPlayerNodeR1.play()
//                
//                audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR2.pan = 1
//            //    audioPlayerNodeR2.volume = 1
//                audioPlayerNodeR2.play()
//                
//                audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeR3.pan = 1
//             //   audioPlayerNodeR3.volume = 0
//                audioPlayerNodeR3.play()
//                
//                // Flat Stereo
//                audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
//                audioPlayerNodeS.pan = 0
//             //   audioPlayerNodeS.volume = 0
//                audioPlayerNodeS.play()
//            }
//        } catch _ {}
//        
//    }
//    
//    func setIntensity1 () {
//        currentIntensity = 1
//        setIntensityNodeVolumes()
//    }
//    
//    func setIntensity2() {
//        currentIntensity = 2
//        setIntensityNodeVolumes()
//    }
//    
//    func setIntensity3() {
//        currentIntensity = 3
//        setIntensityNodeVolumes()
//    }
    
    
    // The UI of the app's initial screen. If a hearing test has never been completed, it should be the hearing test. If a hearing test has been completed, it should be the user's music.
    
    var body: some View {
        
        TabView { 
            PlayView() 
                .tabItem({ Label("Play", systemImage: "book.circle") }) 
            TestView() 
                .tabItem({ Label("Test", systemImage: "gear") }) }
        
   //         VStack {
                
//                Text(EQStatusText)
//                    .padding(25)
//                
//                Toggle("Equalizer", isOn: $equalizerIsActive)
//                    .onChange(of: equalizerIsActive) { value in
//                        toggleEqualizer()
//                }
//                .padding(25)
//                
//            
//                Button("Play Edamame", 
//                       action: {
//                    playEdamame()
//                })
//                .padding(25)
//                
//                
//                Button("Play Levitating", 
//                       action: {
//                    playLevitating()
//                })
//                .padding(25)
//                
//                
//                Button("Stop Track", 
//                       action: {
//                    stopTrack()
//                })
//                .padding(25)
//                
//                
//                Button("Intensity 1", 
//                       action: {
//                    setIntensity1()
//                })
//                .padding(25)
//                
//                
//                Button("Intensity 2", 
//                       action: {
//                    setIntensity2()
//                })
//                .padding(25)
//                
//                
//                Button("Intensity 3", 
//                       action: {
//                    setIntensity3()
//                })
//                .padding(25)
                
                
//                Button("Yes, I hear it", 
//                       action: {
//                    tapYesHeard()
//                })
//                .padding(25)
//                
//                
//                Button("No, I don't hear it", 
//                       action: {
//                    tapNoDidNotHear()
//                })
//                .padding(25)
                
                
  //      }
        .onAppear {
            
            print ("Content View on Appear Called")
            
//            currentProfile = storedValues.currentProfile
//            currentIntensity = storedValues.currentProfile
            
//            print ("Model currentProfile = \(currentProfile)")
            
            
         
//            print ("\(AVAudioSession.sharedInstance().outputVolume)")
//            guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)            
//                try AVAudioSession.sharedInstance().setActive(true)
//                tonePlayer = try AVAudioPlayer(contentsOf: url)
//            } catch let error {
//                print(error.localizedDescription)
//            }
 //           tapStartTest()
            
            // On startup, we populate arrays from stored values that are used to set the gain on the EQ bands.
            
//            populateLowestAudibleDecibelBandsArrays()
//            
//            // On startup, we set the last used profile to be the current profile.
//            
//            setCurrentProfile()
//            
//            // On startup, we set the last used intensity to be the current intensity.
//            
//            setCurrentIntensity()
//            
//            // On startup, we set the gain on the EQ bands based on the current profile.
//            
//            setEQBandsGain()
//            
//            // Setup the 7 audio nodes: 3 on each channel at 3 intensities and 1 flat stereo.
//            
//            let bandwidth: Float = 0.5
//            let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
//            
//            // Left Ear 
//            
//            equalizerL1 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeL1) 
//            audioEngine.attach(equalizerL1) 
//            audioEngine.attach(mixerL1)
//            audioEngine.connect(audioPlayerNodeL1, to: mixerL1, format: nil)
//            audioEngine.connect(mixerL1, to: equalizerL1, format: nil)
//            audioEngine.connect(equalizerL1, to: audioEngine.mainMixerNode, format: nil)
//            let bandsL1 = equalizerL1.bands
//            for i in 0...(bandsL1.count - 1) {
//                bandsL1[i].frequency = Float(freqs[i])
//                bandsL1[i].bypass = false
//                bandsL1[i].bandwidth = bandwidth
//                bandsL1[i].filterType = .parametric
//                bandsL1[i].gain = bandsGain1[i]
//            }
//            
//            equalizerL2 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeL2) 
//            audioEngine.attach(equalizerL2) 
//            audioEngine.attach(mixerL2)
//            audioEngine.connect(audioPlayerNodeL2, to: mixerL2, format: nil)
//            audioEngine.connect(mixerL2, to: equalizerL2, format: nil)
//            audioEngine.connect(equalizerL2, to: audioEngine.mainMixerNode, format: nil)
//            let bandsL2 = equalizerL2.bands
//            for i in 0...(bandsL2.count - 1) {
//                bandsL2[i].frequency = Float(freqs[i])
//                bandsL2[i].bypass = false
//                bandsL2[i].bandwidth = bandwidth
//                bandsL2[i].filterType = .parametric
//                bandsL2[i].gain = bandsGain2[i]
//            }
//            
//            equalizerL3 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeL3) 
//            audioEngine.attach(equalizerL3) 
//            audioEngine.attach(mixerL3)
//            audioEngine.connect(audioPlayerNodeL3, to: mixerL3, format: nil)
//            audioEngine.connect(mixerL3, to: equalizerL3, format: nil)
//            audioEngine.connect(equalizerL3, to: audioEngine.mainMixerNode, format: nil)
//            let bandsL3 = equalizerL3.bands
//            for i in 0...(bandsL3.count - 1) {
//                bandsL3[i].frequency = Float(freqs[i])
//                bandsL3[i].bypass = false
//                bandsL3[i].bandwidth = bandwidth
//                bandsL3[i].filterType = .parametric
//                bandsL3[i].gain = bandsGain3[i]
//            }
//         
//          
//            
//            // Right Ear
//            equalizerR1 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeR1) 
//            audioEngine.attach(equalizerR1) 
//            audioEngine.attach(mixerR1)
//            audioEngine.connect(audioPlayerNodeR1, to: mixerR1, format: nil)
//            audioEngine.connect(mixerR1, to: equalizerR1, format: nil)
//            audioEngine.connect(equalizerR1, to: audioEngine.mainMixerNode, format: nil)
//            let bandsR1 = equalizerR1.bands
//            for i in 0...(bandsR1.count - 1) {
//                bandsR1[i].frequency = Float(freqs[i])
//                bandsR1[i].bypass = false
//                bandsR1[i].bandwidth = bandwidth
//                bandsR1[i].filterType = .parametric
//                bandsR1[i].gain = bandsGain1[i + bandsR1.count]
//            }
//            
//            equalizerR2 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeR2) 
//            audioEngine.attach(equalizerR2) 
//            audioEngine.attach(mixerR2)
//            audioEngine.connect(audioPlayerNodeR2, to: mixerR2, format: nil)
//            audioEngine.connect(mixerR2, to: equalizerR2, format: nil)
//            audioEngine.connect(equalizerR2, to: audioEngine.mainMixerNode, format: nil)
//            let bandsR2 = equalizerR2.bands
//            for i in 0...(bandsR2.count - 1) {
//                bandsR2[i].frequency = Float(freqs[i])
//                bandsR2[i].bypass = false
//                bandsR2[i].bandwidth = bandwidth
//                bandsR2[i].filterType = .parametric
//                bandsR2[i].gain = bandsGain2[i + bandsR2.count]
//            }
//            
//            equalizerR3 = AVAudioUnitEQ(numberOfBands: 8)
//            audioEngine.attach(audioPlayerNodeR3) 
//            audioEngine.attach(equalizerR3) 
//            audioEngine.attach(mixerR3)
//            audioEngine.connect(audioPlayerNodeR3, to: mixerR3, format: nil)
//            audioEngine.connect(mixerR3, to: equalizerR3, format: nil)
//            audioEngine.connect(equalizerR3, to: audioEngine.mainMixerNode, format: nil)
//            let bandsR3 = equalizerR3.bands
//            for i in 0...(bandsR3.count - 1) {
//                bandsR3[i].frequency = Float(freqs[i])
//                bandsR3[i].bypass = false
//                bandsR3[i].bandwidth = bandwidth
//                bandsR3[i].filterType = .parametric
//                bandsR3[i].gain = bandsGain3[i + bandsR3.count]
//            }
//
//            
//            // Flat Stereo
//            audioEngine.attach(audioPlayerNodeS) 
//            audioEngine.connect(audioPlayerNodeS, to: audioEngine.mainMixerNode, format: nil)
//           
//          
//            
//            do {
//                if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
//                    let filepathURL = NSURL.fileURL(withPath: filepath)
//                    audioFile = try AVAudioFile(forReading: filepathURL)
//                    
//                    // Start your Engines 
//                    audioEngine.prepare()
//                    try audioEngine.start()
//                 
////                    let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
////                    
////                    // Left Ear 
////                    audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeL1.pan = -1
////                    audioPlayerNodeL1.volume = 0
////                    audioPlayerNodeL1.play()
////                    
////                    audioPlayerNodeL2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeL2.pan = -1
////                    audioPlayerNodeL2.volume = 1
////                    audioPlayerNodeL2.play()
////                    
////                    audioPlayerNodeL3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeL3.pan = -1
////                    audioPlayerNodeL3.volume = 0
////                    audioPlayerNodeL3.play()
////                    
////                    
////                    // Right Ear
////                    audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeR1.pan = 1
////                    audioPlayerNodeR1.volume = 0
////                    audioPlayerNodeR1.play()
////                    
////                    audioPlayerNodeR2.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeR2.pan = 1
////                    audioPlayerNodeR2.volume = 1
////                    audioPlayerNodeR2.play()
////                    
////                    audioPlayerNodeR3.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeR3.pan = 1
////                    audioPlayerNodeR3.volume = 0
////                    audioPlayerNodeR3.play()
////                    
////                    // Flat Stereo
////                    audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
////                    audioPlayerNodeS.pan = 0
////                    audioPlayerNodeS.volume = 0
////                    audioPlayerNodeS.play()
//                }
//            } catch _ {}
        }
    }
        
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

