//
//  TestView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit

struct TestView: View {
    
 //   @EnvironmentObject var model: Model
    
    let storedValues = StoredValues.shared
    
    @State var tonePlayer: AVAudioPlayer?
    @State var currentTone = ""
    @State var toneIndex = 0
    
    @State var maxUnheard: Double = -160
    @State var minHeard: Double = 0.0
    
    @State var currentProfile = 1
   // @State var currentLowestAudibleDecibelBands = [Double]()
    @State var profile_1_lowestAudibleDecibelBands = [Double]()
    @State var profile_2_lowestAudibleDecibelBands = [Double]()
    
    @State var testStatus = "Hearing Test"
    
    // We use the toneArray to go in order through the bands during the test.
    
    let toneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
    
    // On startup, Set the model's current profile.
    
    func setCurrentProfile () {
        currentProfile = storedValues.currentProfile
    }
    
    // On startup, populate the lowest audible bands for each profile so that the band gains can be set on the EQ for each profile.
    
    func populateLowestAudibleDecibelBandsArrays () {
        profile_1_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_1, storedValues.lowestAudibleDecibelBand60R_1, storedValues.lowestAudibleDecibelBand100L_1, storedValues.lowestAudibleDecibelBand100R_1, storedValues.lowestAudibleDecibelBand230L_1, storedValues.lowestAudibleDecibelBand230R_1, storedValues.lowestAudibleDecibelBand500L_1, storedValues.lowestAudibleDecibelBand500R_1, storedValues.lowestAudibleDecibelBand1100L_1, storedValues.lowestAudibleDecibelBand1100R_1, storedValues.lowestAudibleDecibelBand2400L_1, storedValues.lowestAudibleDecibelBand2400R_1, storedValues.lowestAudibleDecibelBand5400L_1, storedValues.lowestAudibleDecibelBand5400R_1, storedValues.lowestAudibleDecibelBand12000L_1, storedValues.lowestAudibleDecibelBand12000R_1]
        profile_2_lowestAudibleDecibelBands = [storedValues.lowestAudibleDecibelBand60L_2, storedValues.lowestAudibleDecibelBand60R_2, storedValues.lowestAudibleDecibelBand100L_2, storedValues.lowestAudibleDecibelBand100R_2, storedValues.lowestAudibleDecibelBand230L_2, storedValues.lowestAudibleDecibelBand230R_2, storedValues.lowestAudibleDecibelBand500L_2, storedValues.lowestAudibleDecibelBand500R_2, storedValues.lowestAudibleDecibelBand1100L_2, storedValues.lowestAudibleDecibelBand1100R_2, storedValues.lowestAudibleDecibelBand2400L_2, storedValues.lowestAudibleDecibelBand2400R_2, storedValues.lowestAudibleDecibelBand5400L_2, storedValues.lowestAudibleDecibelBand5400R_2, storedValues.lowestAudibleDecibelBand12000L_2, storedValues.lowestAudibleDecibelBand12000R_2]
    }
    
     // This won't work but at least we have enough elements in the array.
    
//    func populateCurrentLowestAudibleDecibelBandsArrays () {
//        switch currentProfile {
//        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
//        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
//        default: break
//        }
//    }
    
    // Get the volume at which to play the tone for a given decibel reduction.
    
    func getVolume (decibelReduction: Double) -> Double {
        
        return (1 / pow(10,(-decibelReduction / 20)))
        
    }
    
    // After a tone gets within .5 decibels of heard and unheard, we assign the lowest audible decibel level for that band, for the appropriate profile.
    
    func assignMinHeardDecibels () {
        currentProfile = storedValues.currentProfile
        switch currentProfile {
        case 1: 
            switch toneIndex {
            case 0: storedValues.lowestAudibleDecibelBand60L_1 = minHeard
            case 1: storedValues.lowestAudibleDecibelBand60R_1 = minHeard
            case 2: storedValues.lowestAudibleDecibelBand100L_1 = minHeard
            case 3: storedValues.lowestAudibleDecibelBand100R_1 = minHeard
            case 4: storedValues.lowestAudibleDecibelBand230L_1 = minHeard
            case 5: storedValues.lowestAudibleDecibelBand230R_1 = minHeard
            case 6: storedValues.lowestAudibleDecibelBand500L_1 = minHeard
            case 7: storedValues.lowestAudibleDecibelBand500R_1 = minHeard
            case 8: storedValues.lowestAudibleDecibelBand1100L_1 = minHeard
            case 9: storedValues.lowestAudibleDecibelBand1100R_1 = minHeard
            case 10: storedValues.lowestAudibleDecibelBand2400L_1 = minHeard
            case 11: storedValues.lowestAudibleDecibelBand2400R_1 = minHeard
            case 12: storedValues.lowestAudibleDecibelBand5400L_1 = minHeard
            case 13: storedValues.lowestAudibleDecibelBand5400R_1 = minHeard
            case 14: storedValues.lowestAudibleDecibelBand12000L_1 = minHeard
            case 15: storedValues.lowestAudibleDecibelBand12000R_1 = minHeard
            default: break
            }
        case 2: 
            switch toneIndex {
            case 0: storedValues.lowestAudibleDecibelBand60L_2 = minHeard
            case 1: storedValues.lowestAudibleDecibelBand60R_2 = minHeard
            case 2: storedValues.lowestAudibleDecibelBand100L_2 = minHeard
            case 3: storedValues.lowestAudibleDecibelBand100R_2 = minHeard
            case 4: storedValues.lowestAudibleDecibelBand230L_2 = minHeard
            case 5: storedValues.lowestAudibleDecibelBand230R_2 = minHeard
            case 6: storedValues.lowestAudibleDecibelBand500L_2 = minHeard
            case 7: storedValues.lowestAudibleDecibelBand500R_2 = minHeard
            case 8: storedValues.lowestAudibleDecibelBand1100L_2 = minHeard
            case 9: storedValues.lowestAudibleDecibelBand1100R_2 = minHeard
            case 10: storedValues.lowestAudibleDecibelBand2400L_2 = minHeard
            case 11: storedValues.lowestAudibleDecibelBand2400R_2 = minHeard
            case 12: storedValues.lowestAudibleDecibelBand5400L_2 = minHeard
            case 13: storedValues.lowestAudibleDecibelBand5400R_2 = minHeard
            case 14: storedValues.lowestAudibleDecibelBand12000L_2 = minHeard
            case 15: storedValues.lowestAudibleDecibelBand12000R_2 = minHeard
            default: break
            }
        default: break
        }
        
    }
    
    // For the hearing test, we set the currentTone string equal to the name of the tone's mp3 file.
    
    func setCurrentTone () {
        switch toneIndex {
        case 0: currentTone = "Band60"
        case 1: currentTone = "Band60"
        case 2: currentTone = "Band100"
        case 3: currentTone = "Band100"
        case 4: currentTone = "Band230"
        case 5: currentTone = "Band230"
        case 6: currentTone = "Band500"
        case 7: currentTone = "Band500"
        case 8: currentTone = "Band1100"
        case 9: currentTone = "Band1100"
        case 10: currentTone = "Band2400"
        case 11: currentTone = "Band2400"
        case 12: currentTone = "Band5400"
        case 13: currentTone = "Band5400"
        case 14: currentTone = "Band12000"
        case 15: currentTone = "Band12000"
        default: break
        }
    }
    
    // For the hearing test, plays the tone on repeat at the volume needed for the desired decibel level. The tone is currently based on the index because we're going through the tones in order from lowest to highest. 
    
    func playTone (volume: Float){
        //  print ("Called playTone")
        setCurrentTone()
        guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
        do {
            tonePlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
        if let tonePlayer = tonePlayer {
            //  print ("playTone second stage")
            tonePlayer.volume = volume
            tonePlayer.numberOfLoops = -1
            if toneIndex % 2 == 0 {
                tonePlayer.pan = -1
            } else {
                tonePlayer.pan = 1
            }
            print ("playTone currentTone = \(currentTone)")
            tonePlayer.play()
        }
    }
    
    // For the hearing test, stops the tone after a user has pressed either the heard or did not hear button.
    
    func stopTone () {
        if let tonePlayer = tonePlayer {
            tonePlayer.stop()
        }
    }
    
    
    // For the hearing test, after a tone is set (difference between heard and unheard is less than .5 decibels), we reset the maxUnheard and minHeard values for the next tone.
    
    func resetMinMaxValues () {
        maxUnheard = -160
        minHeard = 0.0
    }
    
    // A QC check to see the assigned lowest audible decibel values for each band of the current profile.
    
    func printDecibelValues () {
        currentProfile = storedValues.currentProfile
        print ("printDecibelValues - Current Profile is \(currentProfile)")
        switch currentProfile {
        case 1:
            print ("Band60L_1 = \(storedValues.lowestAudibleDecibelBand60L_1)")
            print ("Band60R_1 = \(storedValues.lowestAudibleDecibelBand60R_1)")
            print ("Band100L_1 = \(storedValues.lowestAudibleDecibelBand100L_1)")
            print ("Band100R_1 = \(storedValues.lowestAudibleDecibelBand100R_1)")
            print ("Band230L_1 = \(storedValues.lowestAudibleDecibelBand230L_1)")
            print ("Band230R_1 = \(storedValues.lowestAudibleDecibelBand230R_1)")
            print ("Band500L_1 = \(storedValues.lowestAudibleDecibelBand500L_1)")
            print ("Band500R_1 = \(storedValues.lowestAudibleDecibelBand500R_1)")
            print ("Band1100L_1 = \(storedValues.lowestAudibleDecibelBand1100L_1)")
            print ("Band1100R_1 = \(storedValues.lowestAudibleDecibelBand1100R_1)")
            print ("Band2400L_1 = \(storedValues.lowestAudibleDecibelBand2400L_1)")
            print ("Band2400R_1 = \(storedValues.lowestAudibleDecibelBand2400R_1)")
            print ("Band5400L_1 = \(storedValues.lowestAudibleDecibelBand5400L_1)")
            print ("Band5400R_1 = \(storedValues.lowestAudibleDecibelBand5400R_1)")
            print ("Band12000L_1 = \(storedValues.lowestAudibleDecibelBand12000L_1)")
            print ("Band12000R_1 = \(storedValues.lowestAudibleDecibelBand12000R_1)")
        case 2: 
            print ("Band60L_2 = \(storedValues.lowestAudibleDecibelBand60L_2)")
            print ("Band60R_2 = \(storedValues.lowestAudibleDecibelBand60R_2)")
            print ("Band100L_2 = \(storedValues.lowestAudibleDecibelBand100L_2)")
            print ("Band100R_2 = \(storedValues.lowestAudibleDecibelBand100R_2)")
            print ("Band230L_2 = \(storedValues.lowestAudibleDecibelBand230L_2)")
            print ("Band230R_2 = \(storedValues.lowestAudibleDecibelBand230R_2)")
            print ("Band500L_2 = \(storedValues.lowestAudibleDecibelBand500L_2)")
            print ("Band500R_2 = \(storedValues.lowestAudibleDecibelBand500R_2)")
            print ("Band1100L_2 = \(storedValues.lowestAudibleDecibelBand1100L_2)")
            print ("Band1100R_2 = \(storedValues.lowestAudibleDecibelBand1100R_2)")
            print ("Band2400L_2 = \(storedValues.lowestAudibleDecibelBand2400L_2)")
            print ("Band2400R_2 = \(storedValues.lowestAudibleDecibelBand2400R_2)")
            print ("Band5400L_2 = \(storedValues.lowestAudibleDecibelBand5400L_2)")
            print ("Band5400R_2 = \(storedValues.lowestAudibleDecibelBand5400R_2)")
            print ("Band12000L_2 = \(storedValues.lowestAudibleDecibelBand12000L_2)")
            print ("Band12000R_2 = \(storedValues.lowestAudibleDecibelBand12000R_2)")
        default: break
        }
    }
    
    // For the hearing test, assigns the min heard decibel value for the appropriate band associated with the appropriate profile after the user has reached a .5 decibel difference between the heard and unheard tones. If we have more tones to go, it will queue up the next tone, otherwise it will switch the status view to "Test Complete!"
    
//    func populateStoredValueLowestAudibleDecibelBands () {
//        currentProfile = storedValues.currentProfile
//        switch currentProfile {
//        case 1: 
//            storedValues.lowestAudibleDecibelBand60L_1 = currentLowestAudibleDecibelBands[0]
//            storedValues.lowestAudibleDecibelBand60R_1 = currentLowestAudibleDecibelBands[1]
//            storedValues.lowestAudibleDecibelBand100L_1 = currentLowestAudibleDecibelBands[2]
//            storedValues.lowestAudibleDecibelBand100R_1 = currentLowestAudibleDecibelBands[3]
//            storedValues.lowestAudibleDecibelBand230L_1 = currentLowestAudibleDecibelBands[4]
//            storedValues.lowestAudibleDecibelBand230R_1 = currentLowestAudibleDecibelBands[5]
//            storedValues.lowestAudibleDecibelBand500L_1 = currentLowestAudibleDecibelBands[6]
//            storedValues.lowestAudibleDecibelBand500R_1 = currentLowestAudibleDecibelBands[7]
//            storedValues.lowestAudibleDecibelBand1100L_1 = currentLowestAudibleDecibelBands[8]
//            storedValues.lowestAudibleDecibelBand1100R_1 = currentLowestAudibleDecibelBands[9]
//            storedValues.lowestAudibleDecibelBand2400L_1 = currentLowestAudibleDecibelBands[10]
//            storedValues.lowestAudibleDecibelBand2400R_1 = currentLowestAudibleDecibelBands[11]
//            storedValues.lowestAudibleDecibelBand5400L_1 = currentLowestAudibleDecibelBands[12]
//            storedValues.lowestAudibleDecibelBand5400R_1 = currentLowestAudibleDecibelBands[13]
//            storedValues.lowestAudibleDecibelBand12000L_1 = currentLowestAudibleDecibelBands[14]
//            storedValues.lowestAudibleDecibelBand12000R_1 = currentLowestAudibleDecibelBands[15]
//        case 2: 
//            storedValues.lowestAudibleDecibelBand60L_2 = currentLowestAudibleDecibelBands[0]
//            storedValues.lowestAudibleDecibelBand60R_2 = currentLowestAudibleDecibelBands[1]
//            storedValues.lowestAudibleDecibelBand100L_2 = currentLowestAudibleDecibelBands[2]
//            storedValues.lowestAudibleDecibelBand100R_2 = currentLowestAudibleDecibelBands[3]
//            storedValues.lowestAudibleDecibelBand230L_2 = currentLowestAudibleDecibelBands[4]
//            storedValues.lowestAudibleDecibelBand230R_2 = currentLowestAudibleDecibelBands[5]
//            storedValues.lowestAudibleDecibelBand500L_2 = currentLowestAudibleDecibelBands[6]
//            storedValues.lowestAudibleDecibelBand500R_2 = currentLowestAudibleDecibelBands[7]
//            storedValues.lowestAudibleDecibelBand1100L_2 = currentLowestAudibleDecibelBands[8]
//            storedValues.lowestAudibleDecibelBand1100R_2 = currentLowestAudibleDecibelBands[9]
//            storedValues.lowestAudibleDecibelBand2400L_2 = currentLowestAudibleDecibelBands[10]
//            storedValues.lowestAudibleDecibelBand2400R_2 = currentLowestAudibleDecibelBands[11]
//            storedValues.lowestAudibleDecibelBand5400L_2 = currentLowestAudibleDecibelBands[12]
//            storedValues.lowestAudibleDecibelBand5400R_2 = currentLowestAudibleDecibelBands[13]
//            storedValues.lowestAudibleDecibelBand12000L_2 = currentLowestAudibleDecibelBands[14]
//            storedValues.lowestAudibleDecibelBand12000R_2 = currentLowestAudibleDecibelBands[15]
//        default: break
//        }
//    }
    
    func bandComplete () {
        assignMinHeardDecibels()
        resetMinMaxValues()
        if toneIndex < toneArray.count - 1 {
            toneIndex += 1
            print ("bandComplete maxUnheard = \(maxUnheard)")
            print ("bandComplete minHeard = \(minHeard)")
            playTone(volume: Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2))))
            
        } else {
            toneIndex = 0
            stopTone()
            print ("Test Complete!")
            testStatus = "Test Complete"
        }
      //  populateStoredValueLowestAudibleDecibelBands()
        printDecibelValues()
    }
    
    // The hearing test begins and plays the current tone, which should be at toneIndex = 0. The prints show the minHeard and maxUnheard getting closer together after each button press.
    
    func tapStartTest () {
        let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: volume)
        testStatus = "Test in Progress"
        print ("tapStartTest volume = \(volume)")
        print ("tapStartTest maxUnheard = \(maxUnheard)")
        print ("tapStartTest minHeard = \(minHeard)")
    }
    
    // During the hearing test, the user taps yes when they hear the tone. This updates the minimum audible decibel value for that band. If the min heard and max unheard are within .5 decibels, the band is complete and on to the next one. If not complete, we play the tone again louder if they didn't hear it and softer if they did.
    
    func tapYesHeard () {
        stopTone()
        minHeard = (maxUnheard + minHeard) / 2
        if abs (maxUnheard - minHeard) < 0.5 {
            print ("tapYesHeard bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            print ("tapYesHeard volume = \(volume)")
            print ("tapYesHeard maxUnheard = \(maxUnheard)")
            print ("tapYesHeard minHeard = \(minHeard)")
            playTone(volume: volume)
        }
        
        // During the hearing test, the user taps if they don't hear the tone. This sets the new maxUnheard value for that band. If the min heard and max unheard are within .5 decibels, we move on to the next band. If not, we play the tone again louder if they didn't hear it and softer if they did.
    }
    
    func tapNoDidNotHear () {
        stopTone()
        maxUnheard = (maxUnheard + minHeard) / 2
        if abs(maxUnheard - minHeard) < 0.5 {
            print ("tapNoDidNotHear bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
            print ("tapNoDidNotHear volume = \(volume)")
            print ("tapNoDidNotHear tone = \(toneArray[toneIndex])")
            print ("tapNoDidNotHear maxUnheard = \(maxUnheard)")
            print ("tapNoDidNotHear minHeard = \(minHeard)")
            playTone(volume: volume)
        }
        
        // While playing a track, it toggles the EQ effect off by settign the EQ nodes to 0 and the flat node to 1.
        
    }
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
            
                Text("\(testStatus)")
                .font(.largeTitle)
                .padding(25)
            
           
                HStack {
                    Text("Current Profile: \(storedValues.currentProfile)")
                        .padding(25)
                    
                    NavigationLink (destination: ProfileView()) {
                        Text ("Change")
                    }
                    .padding(25)
                }
                
                Button("Start Test", 
                       action: {
                    tapStartTest()
                })
                .padding(25)
                
                Button("Yes, I hear it", 
                       action: {
                    tapYesHeard()
                })
                .padding(25)
                
                
                Button("No, I don't hear it", 
                       action: {
                    tapNoDidNotHear()
                })
                .padding(25)
            }
            
        }
        .onAppear {
            
            print ("TestView Appeared")
            
            printDecibelValues()
            
            // On startup, we set the last used profile to be the current profile before we populated the current lowest audible band array.
            
           setCurrentProfile()
            
            // On startup, we populate arrays from stored values that are used to set the gain on the EQ bands.
            
            populateLowestAudibleDecibelBandsArrays()
            
     //    populateCurrentLowestAudibleDecibelBandsArrays()
            
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
