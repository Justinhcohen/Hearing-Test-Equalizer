//
//  Model.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import Foundation
import AVKit
import MediaPlayer

class Model: ObservableObject {
    
    init () {
        prepareAudioEngine(currentProfile: currentProfile, intensity: currentIntensity)
    }
    
    let userDefaults = UserDefaults.standard
    
    let bandNames = ["L60", "R60", "L100", "R100", "L230", "R230", "L500", "R500", "L1100", "R1100", "L2400", "R2400", "L5400", "R5400", "L12000", "R12000"]
    
    @Published var currentProfile = 1 {
        willSet {
            userDefaults.set(newValue, forKey: "currentProfile")
        }
    }
    @Published var currentIntensity = 8.0 {
        willSet {
            userDefaults.set(newValue, forKey: "currentIntensity")
        }
    }
    @Published var equalizerIsActive = true {
        willSet {
            userDefaults.set(newValue, forKey: "equalizerIsActive")
        }
    }
    
    @Published var testStatus = "Hearing Test"
    @Published var currentBand = "Ready"
    @Published var testInProgress = false
    @Published var tempURL: URL = URL(fileURLWithPath: "temp")
//    @Published var bassBoost: Float = 0.0
//    @Published var reverb: Float = 0.0
    @Published var currentVolume: Float = 0.0
    
    @Published var systemVolume = AVAudioSession.sharedInstance().outputVolume
    
    var lowestAudibleDecibelBand60L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60L_1")
        }
    }
    var lowestAudibleDecibelBand60R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60R_1")
        }
    }
    var lowestAudibleDecibelBand100L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100L_1")
        }
    }
    var lowestAudibleDecibelBand100R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100R_1")
        }
    }
    var lowestAudibleDecibelBand230L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230L_1")
        }
    }
    var lowestAudibleDecibelBand230R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230R_1")
        }
    }
    var lowestAudibleDecibelBand500L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500L_1")
        }
    }
    var lowestAudibleDecibelBand500R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500R_1")
        }
    }
    var lowestAudibleDecibelBand1100L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100L_1")
        }
    }
    var lowestAudibleDecibelBand1100R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100R_1")
        }
    }
    var lowestAudibleDecibelBand2400L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400L_1")
        }
    }
    var lowestAudibleDecibelBand2400R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400R_1")
        }
    }
    var lowestAudibleDecibelBand5400L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400L_1")
        }
    }
    var lowestAudibleDecibelBand5400R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400R_1")
        }
    }
    var lowestAudibleDecibelBand12000L_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000L_1")
        }
    }
    var lowestAudibleDecibelBand12000R_1 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000R_1")
        }
    }
    var profile_1_lowestAudibleDecibelBands: [Double] { [lowestAudibleDecibelBand60L_1, lowestAudibleDecibelBand60R_1, lowestAudibleDecibelBand100L_1, lowestAudibleDecibelBand100R_1, lowestAudibleDecibelBand230L_1, lowestAudibleDecibelBand230R_1, lowestAudibleDecibelBand500L_1, lowestAudibleDecibelBand500R_1, lowestAudibleDecibelBand1100L_1, lowestAudibleDecibelBand1100R_1, lowestAudibleDecibelBand2400L_1, lowestAudibleDecibelBand2400R_1, lowestAudibleDecibelBand5400L_1, lowestAudibleDecibelBand5400R_1, lowestAudibleDecibelBand12000L_1, lowestAudibleDecibelBand12000R_1]
    }
    
    // Lowest audible decibel values for profile 2
    
    var lowestAudibleDecibelBand60L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60L_2")
        }
    }
    var lowestAudibleDecibelBand60R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60R_2")
        }
    }
    var lowestAudibleDecibelBand100L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100L_2")
        }
    }
    var lowestAudibleDecibelBand100R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100R_2")
        }
    }
    var lowestAudibleDecibelBand230L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230L_2")
        }
    }
    var lowestAudibleDecibelBand230R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230R_2")
        }
    }
    var lowestAudibleDecibelBand500L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500L_2")
        }
    }
    var lowestAudibleDecibelBand500R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500R_2")
        }
    }
    var lowestAudibleDecibelBand1100L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100L_2")
        }
    }
    var lowestAudibleDecibelBand1100R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100R_2")
        }
    }
    var lowestAudibleDecibelBand2400L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400L_2")
        }
    }
    var lowestAudibleDecibelBand2400R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400R_2")
        }
    }
    var lowestAudibleDecibelBand5400L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400L_2")
        }
    }
    var lowestAudibleDecibelBand5400R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400R_2")
        }
    }
    var lowestAudibleDecibelBand12000L_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000L_2")
        }
    }
    var lowestAudibleDecibelBand12000R_2 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000R_2")
        }
    }
    var profile_2_lowestAudibleDecibelBands: [Double] {[lowestAudibleDecibelBand60L_2, lowestAudibleDecibelBand60R_2, lowestAudibleDecibelBand100L_2, lowestAudibleDecibelBand100R_2, lowestAudibleDecibelBand230L_2, lowestAudibleDecibelBand230R_2, lowestAudibleDecibelBand500L_2, lowestAudibleDecibelBand500R_2, lowestAudibleDecibelBand1100L_2, lowestAudibleDecibelBand1100R_2, lowestAudibleDecibelBand2400L_2, lowestAudibleDecibelBand2400R_2, lowestAudibleDecibelBand5400L_2, lowestAudibleDecibelBand5400R_2, lowestAudibleDecibelBand12000L_2, lowestAudibleDecibelBand12000R_2]
    }
    
    // Lowest audible decibel values for profile 3
    
    var lowestAudibleDecibelBand60L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60L_3")
        }
    }
    var lowestAudibleDecibelBand60R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60R_3")
        }
    }
    var lowestAudibleDecibelBand100L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100L_3")
        }
    }
    var lowestAudibleDecibelBand100R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100R_3")
        }
    }
    var lowestAudibleDecibelBand230L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230L_3")
        }
    }
    var lowestAudibleDecibelBand230R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230R_3")
        }
    }
    var lowestAudibleDecibelBand500L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500L_3")
        }
    }
    var lowestAudibleDecibelBand500R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500R_3")
        }
    }
    var lowestAudibleDecibelBand1100L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100L_3")
        }
    }
    var lowestAudibleDecibelBand1100R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100R_3")
        }
    }
    var lowestAudibleDecibelBand2400L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400L_3")
        }
    }
    var lowestAudibleDecibelBand2400R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400R_3")
        }
    }
    var lowestAudibleDecibelBand5400L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400L_3")
        }
    }
    var lowestAudibleDecibelBand5400R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400R_3")
        }
    }
    var lowestAudibleDecibelBand12000L_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000L_3")
        }
    }
    var lowestAudibleDecibelBand12000R_3 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000R_3")
        }
    }
    var profile_3_lowestAudibleDecibelBands: [Double] {[lowestAudibleDecibelBand60L_3, lowestAudibleDecibelBand60R_3, lowestAudibleDecibelBand100L_3, lowestAudibleDecibelBand100R_3, lowestAudibleDecibelBand230L_3, lowestAudibleDecibelBand230R_3, lowestAudibleDecibelBand500L_3, lowestAudibleDecibelBand500R_3, lowestAudibleDecibelBand1100L_3, lowestAudibleDecibelBand1100R_3, lowestAudibleDecibelBand2400L_3, lowestAudibleDecibelBand2400R_3, lowestAudibleDecibelBand5400L_3, lowestAudibleDecibelBand5400R_3, lowestAudibleDecibelBand12000L_3, lowestAudibleDecibelBand12000R_3]
    }
    
    // Lowest audible decibel values for profile 4
    
    var lowestAudibleDecibelBand60L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60L_4")
        }
    }
    var lowestAudibleDecibelBand60R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60R_4")
        }
    }
    var lowestAudibleDecibelBand100L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100L_4")
        }
    }
    var lowestAudibleDecibelBand100R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100R_4")
        }
    }
    var lowestAudibleDecibelBand230L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230L_4")
        }
    }
    var lowestAudibleDecibelBand230R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230R_4")
        }
    }
    var lowestAudibleDecibelBand500L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500L_4")
        }
    }
    var lowestAudibleDecibelBand500R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500R_4")
        }
    }
    var lowestAudibleDecibelBand1100L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100L_4")
        }
    }
    var lowestAudibleDecibelBand1100R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100R_4")
        }
    }
    var lowestAudibleDecibelBand2400L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400L_4")
        }
    }
    var lowestAudibleDecibelBand2400R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400R_4")
        }
    }
    var lowestAudibleDecibelBand5400L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400L_4")
        }
    }
    var lowestAudibleDecibelBand5400R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400R_4")
        }
    }
    var lowestAudibleDecibelBand12000L_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000L_4")
        }
    }
    var lowestAudibleDecibelBand12000R_4 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000R_4")
        }
    }
    var profile_4_lowestAudibleDecibelBands: [Double] {[lowestAudibleDecibelBand60L_4, lowestAudibleDecibelBand60R_4, lowestAudibleDecibelBand100L_4, lowestAudibleDecibelBand100R_4, lowestAudibleDecibelBand230L_4, lowestAudibleDecibelBand230R_4, lowestAudibleDecibelBand500L_4, lowestAudibleDecibelBand500R_4, lowestAudibleDecibelBand1100L_4, lowestAudibleDecibelBand1100R_4, lowestAudibleDecibelBand2400L_4, lowestAudibleDecibelBand2400R_4, lowestAudibleDecibelBand5400L_4, lowestAudibleDecibelBand5400R_4, lowestAudibleDecibelBand12000L_4, lowestAudibleDecibelBand12000R_4]
    }
    
    // Lowest audible decibel values for profile 5
    
    var lowestAudibleDecibelBand60L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60L_5")
        }
    }
    var lowestAudibleDecibelBand60R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand60R_5")
        }
    }
    var lowestAudibleDecibelBand100L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100L_5")
        }
    }
    var lowestAudibleDecibelBand100R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand100R_5")
        }
    }
    var lowestAudibleDecibelBand230L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230L_5")
        }
    }
    var lowestAudibleDecibelBand230R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand230R_5")
        }
    }
    var lowestAudibleDecibelBand500L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500L_5")
        }
    }
    var lowestAudibleDecibelBand500R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand500R_5")
        }
    }
    var lowestAudibleDecibelBand1100L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100L_5")
        }
    }
    var lowestAudibleDecibelBand1100R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand1100R_5")
        }
    }
    var lowestAudibleDecibelBand2400L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400L_5")
        }
    }
    var lowestAudibleDecibelBand2400R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand2400R_5")
        }
    }
    var lowestAudibleDecibelBand5400L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400L_5")
        }
    }
    var lowestAudibleDecibelBand5400R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand5400R_5")
        }
    }
    var lowestAudibleDecibelBand12000L_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000L_5")
        }
    }
    var lowestAudibleDecibelBand12000R_5 = -100.0 {
        willSet {
            userDefaults.set(newValue, forKey: "lowestAudibleDecibelBand12000R_5")
        }
    }
    var profile_5_lowestAudibleDecibelBands: [Double] { [lowestAudibleDecibelBand60L_5, lowestAudibleDecibelBand60R_5, lowestAudibleDecibelBand100L_5, lowestAudibleDecibelBand100R_5, lowestAudibleDecibelBand230L_5, lowestAudibleDecibelBand230R_5, lowestAudibleDecibelBand500L_5, lowestAudibleDecibelBand500R_5, lowestAudibleDecibelBand1100L_5, lowestAudibleDecibelBand1100R_5, lowestAudibleDecibelBand2400L_5, lowestAudibleDecibelBand2400R_5, lowestAudibleDecibelBand5400L_5, lowestAudibleDecibelBand5400R_5, lowestAudibleDecibelBand12000L_5, lowestAudibleDecibelBand12000R_5]
    }
    
    
    func readFromUserDefaults () {
        print ("readFromUserDefaults CALLED")
       
        lowestAudibleDecibelBand60L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand60L_1")
        lowestAudibleDecibelBand60R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand60R_1")
        lowestAudibleDecibelBand100L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand100L_1")
        lowestAudibleDecibelBand100R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand100R_1")
        lowestAudibleDecibelBand230L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand230L_1")
        lowestAudibleDecibelBand230R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand230R_1")
        lowestAudibleDecibelBand500L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand500L_1")
        lowestAudibleDecibelBand500R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand500R_1")
        lowestAudibleDecibelBand1100L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100L_1")
        lowestAudibleDecibelBand1100R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100R_1")
        lowestAudibleDecibelBand2400L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400L_1")
        lowestAudibleDecibelBand2400R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400R_1")
        lowestAudibleDecibelBand5400L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400L_1")
        lowestAudibleDecibelBand5400R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400R_1")
        lowestAudibleDecibelBand12000L_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000L_1")
        lowestAudibleDecibelBand12000R_1 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000R_1")
        
        lowestAudibleDecibelBand60L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand60L_2")
        lowestAudibleDecibelBand60R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand60R_2")
        lowestAudibleDecibelBand100L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand100L_2")
        lowestAudibleDecibelBand100R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand100R_2")
        lowestAudibleDecibelBand230L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand230L_2")
        lowestAudibleDecibelBand230R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand230R_2")
        lowestAudibleDecibelBand500L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand500L_2")
        lowestAudibleDecibelBand500R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand500R_2")
        lowestAudibleDecibelBand1100L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100L_2")
        lowestAudibleDecibelBand1100R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100R_2")
        lowestAudibleDecibelBand2400L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400L_2")
        lowestAudibleDecibelBand2400R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400R_2")
        lowestAudibleDecibelBand5400L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400L_2")
        lowestAudibleDecibelBand5400R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400R_2")
        lowestAudibleDecibelBand12000L_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000L_2")
        lowestAudibleDecibelBand12000R_2 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000R_2")
        
        lowestAudibleDecibelBand60L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand60L_3")
        lowestAudibleDecibelBand60R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand60R_3")
        lowestAudibleDecibelBand100L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand100L_3")
        lowestAudibleDecibelBand100R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand100R_3")
        lowestAudibleDecibelBand230L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand230L_3")
        lowestAudibleDecibelBand230R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand230R_3")
        lowestAudibleDecibelBand500L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand500L_3")
        lowestAudibleDecibelBand500R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand500R_3")
        lowestAudibleDecibelBand1100L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100L_3")
        lowestAudibleDecibelBand1100R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100R_3")
        lowestAudibleDecibelBand2400L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400L_3")
        lowestAudibleDecibelBand2400R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400R_3")
        lowestAudibleDecibelBand5400L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400L_3")
        lowestAudibleDecibelBand5400R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400R_3")
        lowestAudibleDecibelBand12000L_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000L_3")
        lowestAudibleDecibelBand12000R_3 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000R_3")
        
        lowestAudibleDecibelBand60L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand60L_4")
        lowestAudibleDecibelBand60R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand60R_4")
        lowestAudibleDecibelBand100L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand100L_4")
        lowestAudibleDecibelBand100R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand100R_4")
        lowestAudibleDecibelBand230L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand230L_4")
        lowestAudibleDecibelBand230R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand230R_4")
        lowestAudibleDecibelBand500L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand500L_4")
        lowestAudibleDecibelBand500R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand500R_4")
        lowestAudibleDecibelBand1100L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100L_4")
        lowestAudibleDecibelBand1100R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100R_4")
        lowestAudibleDecibelBand2400L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400L_4")
        lowestAudibleDecibelBand2400R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400R_4")
        lowestAudibleDecibelBand5400L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400L_4")
        lowestAudibleDecibelBand5400R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400R_4")
        lowestAudibleDecibelBand12000L_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000L_4")
        lowestAudibleDecibelBand12000R_4 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000R_4")
        
        lowestAudibleDecibelBand60L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand60L_5")
        lowestAudibleDecibelBand60R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand60R_5")
        lowestAudibleDecibelBand100L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand100L_5")
        lowestAudibleDecibelBand100R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand100R_5")
        lowestAudibleDecibelBand230L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand230L_5")
        lowestAudibleDecibelBand230R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand230R_5")
        lowestAudibleDecibelBand500L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand500L_5")
        lowestAudibleDecibelBand500R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand500R_5")
        lowestAudibleDecibelBand1100L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100L_5")
        lowestAudibleDecibelBand1100R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand1100R_5")
        lowestAudibleDecibelBand2400L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400L_5")
        lowestAudibleDecibelBand2400R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand2400R_5")
        lowestAudibleDecibelBand5400L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400L_5")
        lowestAudibleDecibelBand5400R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand5400R_5")
        lowestAudibleDecibelBand12000L_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000L_5")
        lowestAudibleDecibelBand12000R_5 = userDefaults.double(forKey: "lowestAudibleDecibelBand12000R_5")
        
        currentProfile = max (userDefaults.integer(forKey: "currentProfile"), 1)
        currentIntensity = userDefaults.double(forKey: "currentIntensity")
        equalizerIsActive = userDefaults.bool(forKey: "equalizerIsActive")
    }
    
    func printUserDefaults () {
        print ("printUserDefaults CALLED")
        
        // Profile_1
        print ("lowestAudibleDecibelBand60L_1 = \(lowestAudibleDecibelBand60L_1)")
        print ("lowestAudibleDecibelBand60R_1 = \(lowestAudibleDecibelBand60R_1)")
        print ("lowestAudibleDecibelBand100L_1 = \(lowestAudibleDecibelBand100L_1)")
        print ("lowestAudibleDecibelBand100R_1 = \(lowestAudibleDecibelBand100R_1)")
        print ("lowestAudibleDecibelBand230L_1 = \(lowestAudibleDecibelBand230L_1)")
        print ("lowestAudibleDecibelBand230R_1 = \(lowestAudibleDecibelBand230R_1)")
        print ("lowestAudibleDecibelBand500L_1 = \(lowestAudibleDecibelBand500L_1)")
        print ("lowestAudibleDecibelBand500R_1 = \(lowestAudibleDecibelBand500R_1)")
        print ("lowestAudibleDecibelBand1100L_1 = \(lowestAudibleDecibelBand1100L_1)")
        print ("lowestAudibleDecibelBand1100R_1 = \(lowestAudibleDecibelBand1100R_1)")
        print ("lowestAudibleDecibelBand2400L_1 = \(lowestAudibleDecibelBand2400L_1)")
        print ("lowestAudibleDecibelBand2400R_1 = \(lowestAudibleDecibelBand2400R_1)")
        print ("lowestAudibleDecibelBand5400L_1 = \(lowestAudibleDecibelBand5400L_1)")
        print ("lowestAudibleDecibelBand5400R_1 = \(lowestAudibleDecibelBand5400R_1)")
        print ("lowestAudibleDecibelBand12000L_1 = \(lowestAudibleDecibelBand12000L_1)")
        print ("lowestAudibleDecibelBand12000R_1 = \(lowestAudibleDecibelBand12000R_1)")
        
        // Profile_2
        print ("lowestAudibleDecibelBand60L_2 = \(lowestAudibleDecibelBand60L_2)")
        print ("lowestAudibleDecibelBand60R_2 = \(lowestAudibleDecibelBand60R_2)")
        print ("lowestAudibleDecibelBand100L_2 = \(lowestAudibleDecibelBand100L_2)")
        print ("lowestAudibleDecibelBand100R_2 = \(lowestAudibleDecibelBand100R_2)")
        print ("lowestAudibleDecibelBand230L_2 = \(lowestAudibleDecibelBand230L_2)")
        print ("lowestAudibleDecibelBand230R_2 = \(lowestAudibleDecibelBand230R_2)")
        print ("lowestAudibleDecibelBand500L_2 = \(lowestAudibleDecibelBand500L_2)")
        print ("lowestAudibleDecibelBand500R_2 = \(lowestAudibleDecibelBand500R_2)")
        print ("lowestAudibleDecibelBand1100L_2 = \(lowestAudibleDecibelBand1100L_2)")
        print ("lowestAudibleDecibelBand1100R_2 = \(lowestAudibleDecibelBand1100R_2)")
        print ("lowestAudibleDecibelBand2400L_2 = \(lowestAudibleDecibelBand2400L_2)")
        print ("lowestAudibleDecibelBand2400R_2 = \(lowestAudibleDecibelBand2400R_2)")
        print ("lowestAudibleDecibelBand5400L_2 = \(lowestAudibleDecibelBand5400L_2)")
        print ("lowestAudibleDecibelBand5400R_2 = \(lowestAudibleDecibelBand5400R_2)")
        print ("lowestAudibleDecibelBand12000L_2 = \(lowestAudibleDecibelBand12000L_2)")
        print ("lowestAudibleDecibelBand12000R_2 = \(lowestAudibleDecibelBand12000R_2)")
        
        //Profile_3
        print ("lowestAudibleDecibelBand60L_3 = \(lowestAudibleDecibelBand60L_3)")
        print ("lowestAudibleDecibelBand60R_3 = \(lowestAudibleDecibelBand60R_3)")
        print ("lowestAudibleDecibelBand100L_3 = \(lowestAudibleDecibelBand100L_3)")
        print ("lowestAudibleDecibelBand100R_3 = \(lowestAudibleDecibelBand100R_3)")
        print ("lowestAudibleDecibelBand230L_3 = \(lowestAudibleDecibelBand230L_3)")
        print ("lowestAudibleDecibelBand230R_3 = \(lowestAudibleDecibelBand230R_3)")
        print ("lowestAudibleDecibelBand500L_3 = \(lowestAudibleDecibelBand500L_3)")
        print ("lowestAudibleDecibelBand500R_3 = \(lowestAudibleDecibelBand500R_3)")
        print ("lowestAudibleDecibelBand1100L_3 = \(lowestAudibleDecibelBand1100L_3)")
        print ("lowestAudibleDecibelBand1100R_3 = \(lowestAudibleDecibelBand1100R_3)")
        print ("lowestAudibleDecibelBand2400L_3 = \(lowestAudibleDecibelBand2400L_3)")
        print ("lowestAudibleDecibelBand2400R_3 = \(lowestAudibleDecibelBand2400R_3)")
        print ("lowestAudibleDecibelBand5400L_3 = \(lowestAudibleDecibelBand5400L_3)")
        print ("lowestAudibleDecibelBand5400R_3 = \(lowestAudibleDecibelBand5400R_3)")
        print ("lowestAudibleDecibelBand12000L_3 = \(lowestAudibleDecibelBand12000L_3)")
        print ("lowestAudibleDecibelBand12000R_3 = \(lowestAudibleDecibelBand12000R_3)")
        
        //Profile_4
        print ("lowestAudibleDecibelBand60L_4 = \(lowestAudibleDecibelBand60L_4)")
        print ("lowestAudibleDecibelBand60R_4 = \(lowestAudibleDecibelBand60R_4)")
        print ("lowestAudibleDecibelBand100L_4 = \(lowestAudibleDecibelBand100L_4)")
        print ("lowestAudibleDecibelBand100R_4 = \(lowestAudibleDecibelBand100R_4)")
        print ("lowestAudibleDecibelBand230L_4 = \(lowestAudibleDecibelBand230L_4)")
        print ("lowestAudibleDecibelBand230R_4 = \(lowestAudibleDecibelBand230R_4)")
        print ("lowestAudibleDecibelBand500L_4 = \(lowestAudibleDecibelBand500L_4)")
        print ("lowestAudibleDecibelBand500R_4 = \(lowestAudibleDecibelBand500R_4)")
        print ("lowestAudibleDecibelBand1100L_4 = \(lowestAudibleDecibelBand1100L_4)")
        print ("lowestAudibleDecibelBand1100R_4 = \(lowestAudibleDecibelBand1100R_4)")
        print ("lowestAudibleDecibelBand2400L_4 = \(lowestAudibleDecibelBand2400L_4)")
        print ("lowestAudibleDecibelBand2400R_4 = \(lowestAudibleDecibelBand2400R_4)")
        print ("lowestAudibleDecibelBand5400L_4 = \(lowestAudibleDecibelBand5400L_4)")
        print ("lowestAudibleDecibelBand5400R_4 = \(lowestAudibleDecibelBand5400R_4)")
        print ("lowestAudibleDecibelBand12000L_4 = \(lowestAudibleDecibelBand12000L_4)")
        print ("lowestAudibleDecibelBand12000R_4 = \(lowestAudibleDecibelBand12000R_4)")
        
        //Profile_5
        print ("lowestAudibleDecibelBand60L_5 = \(lowestAudibleDecibelBand60L_5)")
        print ("lowestAudibleDecibelBand60R_5 = \(lowestAudibleDecibelBand60R_5)")
        print ("lowestAudibleDecibelBand100L_5 = \(lowestAudibleDecibelBand100L_5)")
        print ("lowestAudibleDecibelBand100R_5 = \(lowestAudibleDecibelBand100R_5)")
        print ("lowestAudibleDecibelBand230L_5 = \(lowestAudibleDecibelBand230L_5)")
        print ("lowestAudibleDecibelBand230R_5 = \(lowestAudibleDecibelBand230R_5)")
        print ("lowestAudibleDecibelBand500L_5 = \(lowestAudibleDecibelBand500L_5)")
        print ("lowestAudibleDecibelBand500R_5 = \(lowestAudibleDecibelBand500R_5)")
        print ("lowestAudibleDecibelBand1100L_5 = \(lowestAudibleDecibelBand1100L_5)")
        print ("lowestAudibleDecibelBand1100R_5 = \(lowestAudibleDecibelBand1100R_5)")
        print ("lowestAudibleDecibelBand2400L_5 = \(lowestAudibleDecibelBand2400L_5)")
        print ("lowestAudibleDecibelBand2400R_5 = \(lowestAudibleDecibelBand2400R_5)")
        print ("lowestAudibleDecibelBand5400L_5 = \(lowestAudibleDecibelBand5400L_5)")
        print ("lowestAudibleDecibelBand5400R_5 = \(lowestAudibleDecibelBand5400R_5)")
        print ("lowestAudibleDecibelBand12000L_5 = \(lowestAudibleDecibelBand12000L_5)")
        print ("lowestAudibleDecibelBand12000R_5 = \(lowestAudibleDecibelBand12000R_5)")
        
        print ("currentProfile = \(currentProfile)")
        print ("currentInesnity = \(currentIntensity)") 
        print ("equalizerIsActive = \(equalizerIsActive)")
    }
    
    let audioEngine: AVAudioEngine = AVAudioEngine()
    var mixerL1 = AVAudioMixerNode()
//    var mixerL2 = AVAudioMixerNode()
//    var mixerL3 = AVAudioMixerNode()
//    var mixerL4 = AVAudioMixerNode()
//    var mixerL5 = AVAudioMixerNode()
    var mixerR1 = AVAudioMixerNode()
//    var mixerR2 = AVAudioMixerNode()
//    var mixerR3 = AVAudioMixerNode()
//    var mixerR4 = AVAudioMixerNode()
//    var mixerR5 = AVAudioMixerNode()
    var equalizerL1: AVAudioUnitEQ!
//    var equalizerL2: AVAudioUnitEQ!
//    var equalizerL3: AVAudioUnitEQ!
//    var equalizerL4: AVAudioUnitEQ!
//    var equalizerL5: AVAudioUnitEQ!
    var equalizerR1: AVAudioUnitEQ!
//    var equalizerR2: AVAudioUnitEQ!
//    var equalizerR3: AVAudioUnitEQ!
//    var equalizerR4: AVAudioUnitEQ!
//    var equalizerR5: AVAudioUnitEQ!
    let audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeL2: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeL3: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeL4: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeL5: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeR2: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeR3: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeR4: AVAudioPlayerNode = AVAudioPlayerNode()
//    let audioPlayerNodeR5: AVAudioPlayerNode = AVAudioPlayerNode()
    let reverbL: AVAudioUnitReverb = AVAudioUnitReverb()
    let reverbR: AVAudioUnitReverb = AVAudioUnitReverb()
    
    let audioPlayerNodeLS: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeRS: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile!
    var currentTrack = ""
    var bandsGain1 = [Float]()
//    var bandsGain2 = [Float]()
//    var bandsGain3 = [Float]()
//    var bandsGain4 = [Float]()
//    var bandsGain5 = [Float]()
    
    var EQStatusText = "" 
    
    
    // When we call this function, we'll choose the apprpriate array based on the current profile.
    
    func setEQBandsGainForSlider (currentProfile: Int, intensity: Double) {
        print ("CALLED SET EQ BANDS FOR SLIDER")
        // intensity has a value between 0.00001 and 14
        currentIntensity = intensity
        var currentLowestAudibleDecibelBands = [Double]()
        switch currentProfile {
        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
        case 3: currentLowestAudibleDecibelBands = profile_3_lowestAudibleDecibelBands
        case 4: currentLowestAudibleDecibelBands = profile_4_lowestAudibleDecibelBands
        case 5: currentLowestAudibleDecibelBands = profile_5_lowestAudibleDecibelBands
        default: break
        }
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
        let multiplier: Double = min(intensity / abs(minValue - maxValue), 1.0)
        
        var workingBandsGain = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain.insert(Float(multiplier * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
    
        bandsGain1 = workingBandsGain
        
        let bandsL = equalizerL1.bands
        let bandsR = equalizerR1.bands
        bandsL[0].gain = bandsGain1[0]
        bandsR[0].gain = bandsGain1[1]
        for i in 2...bandsGain1.count - 1 {
            if i .isMultiple(of: 2) {
                bandsL[i / 2].gain = bandsGain1[i]
            } else {
                bandsR[i / 2].gain = bandsGain1[i]
            }
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(bandNames[i]): \(workingBandsGain[i])")
        }
    }
    

    
    func stopTrack () {
        audioPlayerNodeL1.stop()
        audioPlayerNodeR1.stop()
        audioPlayerNodeLS.stop()
        audioPlayerNodeRS.stop()
    }
    
    func pauseTrack () {
        audioPlayerNodeL1.pause()
        audioPlayerNodeR1.pause()
        audioPlayerNodeLS.pause()
        audioPlayerNodeRS.pause()
    }
    
    func unPauseTrack () {
        let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
        audioPlayerNodeL1.play(at: audioTime)
        audioPlayerNodeR1.play(at: audioTime)
        audioPlayerNodeLS.play(at: audioTime)
        audioPlayerNodeRS.play(at: audioTime)
    }
    
    func setNodeVolumesBasedOnEQActive (EQIsActive: Bool) {
        if EQIsActive {
            audioPlayerNodeL1.volume = 1.0
            audioPlayerNodeR1.volume = 1.0
            audioPlayerNodeLS.volume = 0.0
            audioPlayerNodeRS.volume = 0.0
        } else {
            audioPlayerNodeL1.volume = 0.0
            audioPlayerNodeR1.volume = 0.0
            audioPlayerNodeLS.volume = 1.0
            audioPlayerNodeRS.volume = 1.0
        }
    }
    
    func toggleEqualizer () {
        if equalizerIsActive {
            equalizerIsActive = false
            userDefaults.set(false, forKey: "equalizerIsActive")
            print ("Equalizer is off")
        } else {
            equalizerIsActive = true
            userDefaults.set(true, forKey: "equalizerIsActive")
            print ("Equalizer is active")
        }
        setNodeVolumesBasedOnEQActive(EQIsActive: equalizerIsActive)
    }
    

    
   
    
    func prepareAudioEngine (currentProfile: Int, intensity: Double) {
        let bandwidth: Float = 0.5
        let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
        
        // Left Ear 
        
        equalizerL1 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeL1) 
       // audioEngine.attach(reverbL)
        audioEngine.attach(equalizerL1) 
        audioEngine.attach(mixerL1)
        audioEngine.connect(audioPlayerNodeL1, to: mixerL1, format: nil)
       // audioEngine.connect(reverbL, to: mixerL1, format: nil)
        audioEngine.connect(mixerL1, to: equalizerL1, format: nil)
       // audioEngine.connect(equalizerL1, to: reverbL, format: nil)
       audioEngine.connect(equalizerL1, to: audioEngine.mainMixerNode, format: nil)
       // audioEngine.connect(reverbL, to: audioEngine.mainMixerNode, format: nil)
        var currentLowestAudibleDecibelBands = [Double]()
        switch currentProfile {
        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
        case 3: currentLowestAudibleDecibelBands = profile_3_lowestAudibleDecibelBands
        case 4: currentLowestAudibleDecibelBands = profile_4_lowestAudibleDecibelBands
        case 5: currentLowestAudibleDecibelBands = profile_5_lowestAudibleDecibelBands
        default: break
        }
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
        let multiplier: Double = min(intensity / abs(minValue - maxValue), 1.0)
        
        var workingBandsGain = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain.insert(Float(multiplier * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
    
        bandsGain1 = workingBandsGain
        
        // Set bands for Left Ear
        
        let bandsL = equalizerL1.bands
        for i in 0...(bandsL.count - 1) {
            bandsL[i].frequency = Float(freqs[i])
            bandsL[i].bypass = false
            bandsL[i].bandwidth = bandwidth
            bandsL[i].filterType = .parametric
        }

        
        // Right Ear
        equalizerR1 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeR1) 
    //    audioEngine.attach(reverbR)
        audioEngine.attach(equalizerR1) 
        audioEngine.attach(mixerR1)
        audioEngine.connect(audioPlayerNodeR1, to: mixerR1, format: nil)
    //    audioEngine.connect(reverbR, to: mixerR1, format: nil)
        audioEngine.connect(mixerR1, to: equalizerR1, format: nil)
   //     audioEngine.connect(equalizerR1, to: reverbR, format: nil)
     //   audioEngine.connect(reverbR, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.connect(equalizerR1, to: audioEngine.mainMixerNode, format: nil)
        
        // Set bands for right ear

        let bandsR = equalizerR1.bands
        for i in 0...(bandsR.count - 1) {
            bandsR[i].frequency = Float(freqs[i])
            bandsR[i].bypass = false
            bandsR[i].bandwidth = bandwidth
            bandsR[i].filterType = .parametric
        }
        
        // Set gain for left and right ear
        
        bandsL[0].gain = bandsGain1[0]
        bandsR[0].gain = bandsGain1[1]
        for i in 2...bandsGain1.count - 1 {
            if i .isMultiple(of: 2) {
                bandsL[i / 2].gain = bandsGain1[i]
            } else {
                bandsR[i / 2].gain = bandsGain1[i]
            }
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(bandNames[i]): \(workingBandsGain[i])")
        }
    
        
        
        // Flat Stereo
        audioEngine.attach(audioPlayerNodeLS) 
        audioEngine.connect(audioPlayerNodeLS, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.attach(audioPlayerNodeRS) 
        audioEngine.connect(audioPlayerNodeRS, to: audioEngine.mainMixerNode, format: nil)
    }
    
   
    
    func playTrack (playQueue: [MPMediaItem], index: Int) {
        
        print ("Play Track, Current Proifle = \(currentProfile)")
        print ("Play Track, Current Intensity = \(currentIntensity)")
        if audioPlayerNodeL1.isPlaying {
            self.stopTrack()
        }
        prepareAudioEngine(currentProfile: currentProfile, intensity: currentIntensity)
        do {
            let currentMPMediaItem = playQueue[index]
            if let currentURL = currentMPMediaItem.assetURL {
                
                audioFile = try AVAudioFile(forReading: currentURL)
                
                //    Start your Engines 
                audioEngine.prepare()
                try audioEngine.start()
                
                setNodeVolumesBasedOnEQActive(EQIsActive: equalizerIsActive)
    
                
                let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
                
                // Left Ear EQ
                audioPlayerNodeL1.scheduleFile(audioFile, at: audioTime, completionHandler: nil) 
                audioPlayerNodeL1.pan = -1
                audioPlayerNodeL1.play()              
                
                // Right Ear EQ
                audioPlayerNodeR1.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR1.pan = 1
                audioPlayerNodeR1.play()
                
                // Left Ear Flat
                audioPlayerNodeLS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeLS.pan = -1
                audioPlayerNodeLS.play()
                
                // Right Ear Flat
                audioPlayerNodeRS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeRS.pan = 1
                audioPlayerNodeRS.play()
            }
            
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
    var tonePlayer: AVAudioPlayer?
    var currentTone = ""
    var toneIndex = 0
    
    var maxUnheard: Double = -160
    var minHeard: Double = 0.0
    
    
    let toneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
    
    func getVolume (decibelReduction: Double) -> Double {
        
        return (1 / pow(10,(-decibelReduction / 20)))
        
    }
    
    func assignMinHeardDecibels () {
        switch currentProfile {
        case 1: 
            switch toneIndex {
            case 0: lowestAudibleDecibelBand60L_1 = minHeard
            case 1: lowestAudibleDecibelBand60R_1 = minHeard
            case 2: lowestAudibleDecibelBand100L_1 = minHeard
            case 3: lowestAudibleDecibelBand100R_1 = minHeard
            case 4: lowestAudibleDecibelBand230L_1 = minHeard
            case 5: lowestAudibleDecibelBand230R_1 = minHeard
            case 6: lowestAudibleDecibelBand500L_1 = minHeard
            case 7: lowestAudibleDecibelBand500R_1 = minHeard
            case 8: lowestAudibleDecibelBand1100L_1 = minHeard
            case 9: lowestAudibleDecibelBand1100R_1 = minHeard
            case 10: lowestAudibleDecibelBand2400L_1 = minHeard
            case 11: lowestAudibleDecibelBand2400R_1 = minHeard
            case 12: lowestAudibleDecibelBand5400L_1 = minHeard
            case 13: lowestAudibleDecibelBand5400R_1 = minHeard
            case 14: lowestAudibleDecibelBand12000L_1 = minHeard
            case 15: lowestAudibleDecibelBand12000R_1 = minHeard
            default: break
            }
        case 2: 
            switch toneIndex {
            case 0: lowestAudibleDecibelBand60L_2 = minHeard
            case 1: lowestAudibleDecibelBand60R_2 = minHeard
            case 2: lowestAudibleDecibelBand100L_2 = minHeard
            case 3: lowestAudibleDecibelBand100R_2 = minHeard
            case 4: lowestAudibleDecibelBand230L_2 = minHeard
            case 5: lowestAudibleDecibelBand230R_2 = minHeard
            case 6: lowestAudibleDecibelBand500L_2 = minHeard
            case 7: lowestAudibleDecibelBand500R_2 = minHeard
            case 8: lowestAudibleDecibelBand1100L_2 = minHeard
            case 9: lowestAudibleDecibelBand1100R_2 = minHeard
            case 10: lowestAudibleDecibelBand2400L_2 = minHeard
            case 11: lowestAudibleDecibelBand2400R_2 = minHeard
            case 12: lowestAudibleDecibelBand5400L_2 = minHeard
            case 13: lowestAudibleDecibelBand5400R_2 = minHeard
            case 14: lowestAudibleDecibelBand12000L_2 = minHeard
            case 15: lowestAudibleDecibelBand12000R_2 = minHeard
            default: break
            }
        case 3: 
            switch toneIndex {
            case 0: lowestAudibleDecibelBand60L_3 = minHeard
            case 1: lowestAudibleDecibelBand60R_3 = minHeard
            case 2: lowestAudibleDecibelBand100L_3 = minHeard
            case 3: lowestAudibleDecibelBand100R_3 = minHeard
            case 4: lowestAudibleDecibelBand230L_3 = minHeard
            case 5: lowestAudibleDecibelBand230R_3 = minHeard
            case 6: lowestAudibleDecibelBand500L_3 = minHeard
            case 7: lowestAudibleDecibelBand500R_3 = minHeard
            case 8: lowestAudibleDecibelBand1100L_3 = minHeard
            case 9: lowestAudibleDecibelBand1100R_3 = minHeard
            case 10: lowestAudibleDecibelBand2400L_3 = minHeard
            case 11: lowestAudibleDecibelBand2400R_3 = minHeard
            case 12: lowestAudibleDecibelBand5400L_3 = minHeard
            case 13: lowestAudibleDecibelBand5400R_3 = minHeard
            case 14: lowestAudibleDecibelBand12000L_3 = minHeard
            case 15: lowestAudibleDecibelBand12000R_3 = minHeard
            default: break
        }
        case 4: 
            switch toneIndex {
            case 0: lowestAudibleDecibelBand60L_4 = minHeard
            case 1: lowestAudibleDecibelBand60R_4 = minHeard
            case 2: lowestAudibleDecibelBand100L_4 = minHeard
            case 3: lowestAudibleDecibelBand100R_4 = minHeard
            case 4: lowestAudibleDecibelBand230L_4 = minHeard
            case 5: lowestAudibleDecibelBand230R_4 = minHeard
            case 6: lowestAudibleDecibelBand500L_4 = minHeard
            case 7: lowestAudibleDecibelBand500R_4 = minHeard
            case 8: lowestAudibleDecibelBand1100L_4 = minHeard
            case 9: lowestAudibleDecibelBand1100R_4 = minHeard
            case 10: lowestAudibleDecibelBand2400L_4 = minHeard
            case 11: lowestAudibleDecibelBand2400R_4 = minHeard
            case 12: lowestAudibleDecibelBand5400L_4 = minHeard
            case 13: lowestAudibleDecibelBand5400R_4 = minHeard
            case 14: lowestAudibleDecibelBand12000L_4 = minHeard
            case 15: lowestAudibleDecibelBand12000R_4 = minHeard
            default: break
        }
        case 5: 
            switch toneIndex {
            case 0: lowestAudibleDecibelBand60L_5 = minHeard
            case 1: lowestAudibleDecibelBand60R_5 = minHeard
            case 2: lowestAudibleDecibelBand100L_5 = minHeard
            case 3: lowestAudibleDecibelBand100R_5 = minHeard
            case 4: lowestAudibleDecibelBand230L_5 = minHeard
            case 5: lowestAudibleDecibelBand230R_5 = minHeard
            case 6: lowestAudibleDecibelBand500L_5 = minHeard
            case 7: lowestAudibleDecibelBand500R_5 = minHeard
            case 8: lowestAudibleDecibelBand1100L_5 = minHeard
            case 9: lowestAudibleDecibelBand1100R_5 = minHeard
            case 10: lowestAudibleDecibelBand2400L_5 = minHeard
            case 11: lowestAudibleDecibelBand2400R_5 = minHeard
            case 12: lowestAudibleDecibelBand5400L_5 = minHeard
            case 13: lowestAudibleDecibelBand5400R_5 = minHeard
            case 14: lowestAudibleDecibelBand12000L_5 = minHeard
            case 15: lowestAudibleDecibelBand12000R_5 = minHeard
            default: break
        }
        default: break
        }
        
    }
    
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
    
    func setCurrentBand () {
        switch toneIndex {
        case 0: currentBand = "60L"
        case 1: currentBand = "60R"
        case 2: currentBand = "100L"
        case 3: currentBand = "100R"
        case 4: currentBand = "230L"
        case 5: currentBand = "230R"
        case 6: currentBand = "500L"
        case 7: currentBand = "500R"
        case 8: currentBand = "1100L"
        case 9: currentBand = "1100R"
        case 10: currentBand = "2400L"
        case 11: currentBand = "2400R"
        case 12: currentBand = "5400L"
        case 13: currentBand = "5400R"
        case 14: currentBand = "12000L"
        case 15: currentBand = "12000R"
        default: break
        }
    }
    
    func playTone (volume: Float){
        //  print ("Called playTone")
        setCurrentTone()
        setCurrentBand()
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
    
    func resumeTone () {
        if let tonePlayer = tonePlayer {
            tonePlayer.play()
        }
    }
    
    func stopTone () {
        if let tonePlayer = tonePlayer {
            tonePlayer.stop()
        }
    }
    
    func resetMinMaxValues () {
        maxUnheard = -160
        minHeard = 0.0
    }
    
    func printDecibelValues () {
        print ("printDecibelValues - Current Profile is \(currentProfile)")
        switch currentProfile {
        case 1:
            print ("Band60L_1 = \(lowestAudibleDecibelBand60L_1)")
            print ("Band60R_1 = \(lowestAudibleDecibelBand60R_1)")
            print ("Band100L_1 = \(lowestAudibleDecibelBand100L_1)")
            print ("Band100R_1 = \(lowestAudibleDecibelBand100R_1)")
            print ("Band230L_1 = \(lowestAudibleDecibelBand230L_1)")
            print ("Band230R_1 = \(lowestAudibleDecibelBand230R_1)")
            print ("Band500L_1 = \(lowestAudibleDecibelBand500L_1)")
            print ("Band500R_1 = \(lowestAudibleDecibelBand500R_1)")
            print ("Band1100L_1 = \(lowestAudibleDecibelBand1100L_1)")
            print ("Band1100R_1 = \(lowestAudibleDecibelBand1100R_1)")
            print ("Band2400L_1 = \(lowestAudibleDecibelBand2400L_1)")
            print ("Band2400R_1 = \(lowestAudibleDecibelBand2400R_1)")
            print ("Band5400L_1 = \(lowestAudibleDecibelBand5400L_1)")
            print ("Band5400R_1 = \(lowestAudibleDecibelBand5400R_1)")
            print ("Band12000L_1 = \(lowestAudibleDecibelBand12000L_1)")
            print ("Band12000R_1 = \(lowestAudibleDecibelBand12000R_1)")
        case 2: 
            print ("Band60L_2 = \(lowestAudibleDecibelBand60L_2)")
            print ("Band60R_2 = \(lowestAudibleDecibelBand60R_2)")
            print ("Band100L_2 = \(lowestAudibleDecibelBand100L_2)")
            print ("Band100R_2 = \(lowestAudibleDecibelBand100R_2)")
            print ("Band230L_2 = \(lowestAudibleDecibelBand230L_2)")
            print ("Band230R_2 = \(lowestAudibleDecibelBand230R_2)")
            print ("Band500L_2 = \(lowestAudibleDecibelBand500L_2)")
            print ("Band500R_2 = \(lowestAudibleDecibelBand500R_2)")
            print ("Band1100L_2 = \(lowestAudibleDecibelBand1100L_2)")
            print ("Band1100R_2 = \(lowestAudibleDecibelBand1100R_2)")
            print ("Band2400L_2 = \(lowestAudibleDecibelBand2400L_2)")
            print ("Band2400R_2 = \(lowestAudibleDecibelBand2400R_2)")
            print ("Band5400L_2 = \(lowestAudibleDecibelBand5400L_2)")
            print ("Band5400R_2 = \(lowestAudibleDecibelBand5400R_2)")
            print ("Band12000L_2 = \(lowestAudibleDecibelBand12000L_2)")
            print ("Band12000R_2 = \(lowestAudibleDecibelBand12000R_2)")
        case 3: 
            print ("Band60L_3 = \(lowestAudibleDecibelBand60L_3)")
            print ("Band60R_3 = \(lowestAudibleDecibelBand60R_3)")
            print ("Band100L_3 = \(lowestAudibleDecibelBand100L_3)")
            print ("Band100R_3 = \(lowestAudibleDecibelBand100R_3)")
            print ("Band230L_3 = \(lowestAudibleDecibelBand230L_3)")
            print ("Band230R_3 = \(lowestAudibleDecibelBand230R_3)")
            print ("Band500L_3 = \(lowestAudibleDecibelBand500L_3)")
            print ("Band500R_3 = \(lowestAudibleDecibelBand500R_3)")
            print ("Band1100L_3 = \(lowestAudibleDecibelBand1100L_3)")
            print ("Band1100R_3 = \(lowestAudibleDecibelBand1100R_3)")
            print ("Band2400L_3 = \(lowestAudibleDecibelBand2400L_3)")
            print ("Band2400R_3 = \(lowestAudibleDecibelBand2400R_3)")
            print ("Band5400L_3 = \(lowestAudibleDecibelBand5400L_3)")
            print ("Band5400R_3 = \(lowestAudibleDecibelBand5400R_3)")
            print ("Band12000L_3 = \(lowestAudibleDecibelBand12000L_3)")
            print ("Band12000R_3 = \(lowestAudibleDecibelBand12000R_3)")
        case 4: 
            print ("Band60L_4 = \(lowestAudibleDecibelBand60L_4)")
            print ("Band60R_4 = \(lowestAudibleDecibelBand60R_4)")
            print ("Band100L_4 = \(lowestAudibleDecibelBand100L_4)")
            print ("Band100R_4 = \(lowestAudibleDecibelBand100R_4)")
            print ("Band230L_4 = \(lowestAudibleDecibelBand230L_4)")
            print ("Band230R_4 = \(lowestAudibleDecibelBand230R_4)")
            print ("Band500L_4 = \(lowestAudibleDecibelBand500L_4)")
            print ("Band500R_4 = \(lowestAudibleDecibelBand500R_4)")
            print ("Band1100L_4 = \(lowestAudibleDecibelBand1100L_4)")
            print ("Band1100R_4 = \(lowestAudibleDecibelBand1100R_4)")
            print ("Band2400L_4 = \(lowestAudibleDecibelBand2400L_4)")
            print ("Band2400R_4 = \(lowestAudibleDecibelBand2400R_4)")
            print ("Band5400L_4 = \(lowestAudibleDecibelBand5400L_4)")
            print ("Band5400R_4 = \(lowestAudibleDecibelBand5400R_4)")
            print ("Band12000L_4 = \(lowestAudibleDecibelBand12000L_4)")
            print ("Band12000R_4 = \(lowestAudibleDecibelBand12000R_4)")
        case 5: 
            print ("Band60L_5 = \(lowestAudibleDecibelBand60L_5)")
            print ("Band60R_5 = \(lowestAudibleDecibelBand60R_5)")
            print ("Band100L_5 = \(lowestAudibleDecibelBand100L_5)")
            print ("Band100R_5 = \(lowestAudibleDecibelBand100R_5)")
            print ("Band230L_5 = \(lowestAudibleDecibelBand230L_5)")
            print ("Band230R_5 = \(lowestAudibleDecibelBand230R_5)")
            print ("Band500L_5 = \(lowestAudibleDecibelBand500L_5)")
            print ("Band500R_5 = \(lowestAudibleDecibelBand500R_5)")
            print ("Band1100L_5 = \(lowestAudibleDecibelBand1100L_5)")
            print ("Band1100R_5 = \(lowestAudibleDecibelBand1100R_5)")
            print ("Band2400L_5 = \(lowestAudibleDecibelBand2400L_5)")
            print ("Band2400R_5 = \(lowestAudibleDecibelBand2400R_5)")
            print ("Band5400L_5 = \(lowestAudibleDecibelBand5400L_5)")
            print ("Band5400R_5 = \(lowestAudibleDecibelBand5400R_5)")
            print ("Band12000L_5 = \(lowestAudibleDecibelBand12000L_5)")
            print ("Band12000R_5 = \(lowestAudibleDecibelBand12000R_5)")
        default: break
        }
    }
    
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
            currentBand = "All done!"
            testInProgress = false
        }
        printDecibelValues()
    }
    
    func tapStartTest () {
        currentVolume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: currentVolume)
        testStatus = "Test in Progress"
        testInProgress = true
        print ("tapStartTest volume = \(currentVolume)")
        print ("tapStartTest maxUnheard = \(maxUnheard)")
        print ("tapStartTest minHeard = \(minHeard)")
    }
    
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
    }
    
    func setProfile1 () {
        currentProfile = 1
    }
    
    func setProfile2 () {
        currentProfile = 2
    }
    
    func setProfile3 () {
        currentProfile = 3
    }
    
    func setProfile4 () {
        currentProfile = 4
    }
    
    func setProfile5 () {
        currentProfile = 5
    }
    
    var playQueue = [MPMediaItem]()
    var currentURL: URL = URL(fileURLWithPath: "")
    
}



   
