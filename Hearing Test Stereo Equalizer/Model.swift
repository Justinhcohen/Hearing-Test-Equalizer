//
//  Model.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import Foundation
import AVKit

class Model: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    
    @Published var currentProfile = 1 {
        willSet {
            userDefaults.set(newValue, forKey: "currentProfile")
        }
    }
    @Published var currentIntensity = 2 {
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
        
        currentProfile = userDefaults.integer(forKey: "currentProfile")
        currentIntensity = userDefaults.integer(forKey: "currentIntensity")
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
    var mixerL2 = AVAudioMixerNode()
    var mixerL3 = AVAudioMixerNode()
    var mixerL4 = AVAudioMixerNode()
    var mixerL5 = AVAudioMixerNode()
    var mixerR1 = AVAudioMixerNode()
    var mixerR2 = AVAudioMixerNode()
    var mixerR3 = AVAudioMixerNode()
    var mixerR4 = AVAudioMixerNode()
    var mixerR5 = AVAudioMixerNode()
    var equalizerL1: AVAudioUnitEQ!
    var equalizerL2: AVAudioUnitEQ!
    var equalizerL3: AVAudioUnitEQ!
    var equalizerL4: AVAudioUnitEQ!
    var equalizerL5: AVAudioUnitEQ!
    var equalizerR1: AVAudioUnitEQ!
    var equalizerR2: AVAudioUnitEQ!
    var equalizerR3: AVAudioUnitEQ!
    var equalizerR4: AVAudioUnitEQ!
    var equalizerR5: AVAudioUnitEQ!
    let audioPlayerNodeL1: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL2: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL3: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL4: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeL5: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR1: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR2: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR3: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR4: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeR5: AVAudioPlayerNode = AVAudioPlayerNode()
    let audioPlayerNodeS: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile!
    var currentTrack = ""
    var bandsGain1 = [Float]()
    var bandsGain2 = [Float]()
    var bandsGain3 = [Float]()
    var bandsGain4 = [Float]()
    var bandsGain5 = [Float]()
    
    var EQStatusText = "" 
    
    
    // When we call this function, we'll choose the apprpriate array based on the current profile.
    
    func setEQBandsGain (currentProfile: Int) {
        var currentLowestAudibleDecibelBands = [Double]()
        switch currentProfile {
        case 1: currentLowestAudibleDecibelBands = profile_1_lowestAudibleDecibelBands
        case 2: currentLowestAudibleDecibelBands = profile_2_lowestAudibleDecibelBands
        case 3: currentLowestAudibleDecibelBands = profile_3_lowestAudibleDecibelBands
        case 4: currentLowestAudibleDecibelBands = profile_4_lowestAudibleDecibelBands
        case 5: currentLowestAudibleDecibelBands = profile_5_lowestAudibleDecibelBands
        default: break
        }
        print ("Setting EQ Bands")
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
        let multiplyer4: Double = min(12 / abs(minValue - maxValue), 1.0)
        let multiplyer5: Double = min(14 / abs(minValue - maxValue), 1.0)
        
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
        
        // Intensity 4 band gain 
        var workingBandsGain4 = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain4.insert(Float(multiplyer4 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(workingBandsGain4[i])")
        }
        bandsGain4 = workingBandsGain4
        
        // Intensity 5 band gain
        
        var workingBandsGain5 = [Float]()
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            workingBandsGain5.insert(Float(multiplyer5 * abs(minValue - currentLowestAudibleDecibelBands[i]) ), at: i)
        }
        for i in 0...currentLowestAudibleDecibelBands.count - 1 {
            print ("\(workingBandsGain5[i])")
        }
        bandsGain5 = workingBandsGain5
    }
    
    func stopTrack () {
        audioPlayerNodeL1.stop()
        audioPlayerNodeL2.stop()
        audioPlayerNodeL3.stop()
        audioPlayerNodeL4.stop()
        audioPlayerNodeL5.stop()
        audioPlayerNodeR1.stop()
        audioPlayerNodeR2.stop()
        audioPlayerNodeR3.stop()
        audioPlayerNodeR4.stop()
        audioPlayerNodeR5.stop()
        audioPlayerNodeS.stop()
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
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
    }
    
    func setEqualizerVolume (currentIntensity: Int, currentProfile: Int) {
        setEQBandsGain(currentProfile: currentProfile)
        if equalizerIsActive {
            switch currentIntensity {
            case 1: 
                audioPlayerNodeL1.volume = 1
                print("IntensityL-1")
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeL4.volume = 0
                audioPlayerNodeL5.volume = 0
                audioPlayerNodeR1.volume = 1
                print ("IntensityR-1")
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeR4.volume = 0
                audioPlayerNodeR5.volume = 0
                audioPlayerNodeS.volume = 0
            case 2:
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 1
                print("IntensityL-2")
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeL4.volume = 0
                audioPlayerNodeL5.volume = 0
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 1
                print("IntensityR-2")
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeR4.volume = 0
                audioPlayerNodeR5.volume = 0
                audioPlayerNodeS.volume = 0
            case 3: 
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 1
                print("IntensityL-3")
                audioPlayerNodeL4.volume = 0
                audioPlayerNodeL5.volume = 0
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 1
                print("IntensityR-3")
                audioPlayerNodeR4.volume = 0
                audioPlayerNodeR5.volume = 0
                audioPlayerNodeS.volume = 0
                
            case 4: 
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeL4.volume = 1
                print("IntensityL-4")
                audioPlayerNodeL5.volume = 0
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeR4.volume = 1
                print("IntensityR-4")
                audioPlayerNodeR5.volume = 0
                audioPlayerNodeS.volume = 0
            case 5: 
                audioPlayerNodeL1.volume = 0
                audioPlayerNodeL2.volume = 0
                audioPlayerNodeL3.volume = 0
                audioPlayerNodeL4.volume = 0
                audioPlayerNodeL5.volume = 1
                print("IntensityL-5")
                audioPlayerNodeR1.volume = 0
                audioPlayerNodeR2.volume = 0
                audioPlayerNodeR3.volume = 0
                audioPlayerNodeR4.volume = 0
                audioPlayerNodeR5.volume = 1
                print("IntensityR-5")
                audioPlayerNodeS.volume = 0
            default: break
            }
        } else {
            audioPlayerNodeL1.volume = 0
            audioPlayerNodeL2.volume = 0
            audioPlayerNodeL3.volume = 0
            audioPlayerNodeL4.volume = 0
            audioPlayerNodeL5.volume = 0
            audioPlayerNodeR1.volume = 0
            audioPlayerNodeR2.volume = 0
            audioPlayerNodeR3.volume = 0
            audioPlayerNodeR4.volume = 0
            audioPlayerNodeR5.volume = 0
            audioPlayerNodeS.volume = 1
            print("Flat Stereo")
        }
    }
    
    func prepareAudioEngine () {
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
        
        equalizerL4 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeL4) 
        audioEngine.attach(equalizerL4) 
        audioEngine.attach(mixerL4)
        audioEngine.connect(audioPlayerNodeL4, to: mixerL3, format: nil)
        audioEngine.connect(mixerL4, to: equalizerL4, format: nil)
        audioEngine.connect(equalizerL4, to: audioEngine.mainMixerNode, format: nil)
        let bandsL4 = equalizerL4.bands
        for i in 0...(bandsL4.count - 1) {
            bandsL4[i].frequency = Float(freqs[i])
            bandsL4[i].bypass = false
            bandsL4[i].bandwidth = bandwidth
            bandsL4[i].filterType = .parametric
            bandsL4[i].gain = bandsGain4[i]
        }
        
        equalizerL5 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeL5) 
        audioEngine.attach(equalizerL5) 
        audioEngine.attach(mixerL5)
        audioEngine.connect(audioPlayerNodeL5, to: mixerL3, format: nil)
        audioEngine.connect(mixerL5, to: equalizerL5, format: nil)
        audioEngine.connect(equalizerL5, to: audioEngine.mainMixerNode, format: nil)
        let bandsL5 = equalizerL5.bands
        for i in 0...(bandsL5.count - 1) {
            bandsL5[i].frequency = Float(freqs[i])
            bandsL5[i].bypass = false
            bandsL5[i].bandwidth = bandwidth
            bandsL5[i].filterType = .parametric
            bandsL5[i].gain = bandsGain5[i]
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
        
        equalizerR4 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeR4) 
        audioEngine.attach(equalizerR4) 
        audioEngine.attach(mixerR4)
        audioEngine.connect(audioPlayerNodeR4, to: mixerR4, format: nil)
        audioEngine.connect(mixerR4, to: equalizerR4, format: nil)
        audioEngine.connect(equalizerR4, to: audioEngine.mainMixerNode, format: nil)
        let bandsR4 = equalizerR4.bands
        for i in 0...(bandsR4.count - 1) {
            bandsR4[i].frequency = Float(freqs[i])
            bandsR4[i].bypass = false
            bandsR4[i].bandwidth = bandwidth
            bandsR4[i].filterType = .parametric
            bandsR4[i].gain = bandsGain4[i + bandsR4.count]
        }
        
        equalizerR5 = AVAudioUnitEQ(numberOfBands: 8)
        audioEngine.attach(audioPlayerNodeR5) 
        audioEngine.attach(equalizerR5) 
        audioEngine.attach(mixerR5)
        audioEngine.connect(audioPlayerNodeR5, to: mixerR5, format: nil)
        audioEngine.connect(mixerR5, to: equalizerR5, format: nil)
        audioEngine.connect(equalizerR5, to: audioEngine.mainMixerNode, format: nil)
        let bandsR5 = equalizerR5.bands
        for i in 0...(bandsR5.count - 1) {
            bandsR5[i].frequency = Float(freqs[i])
            bandsR5[i].bypass = false
            bandsR5[i].bandwidth = bandwidth
            bandsR5[i].filterType = .parametric
            bandsR5[i].gain = bandsGain5[i + bandsR5.count]
        }
        
        
        // Flat Stereo
        audioEngine.attach(audioPlayerNodeS) 
        audioEngine.connect(audioPlayerNodeS, to: audioEngine.mainMixerNode, format: nil)
    }
    
    func playTrack (currentTrack: String) {
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        prepareAudioEngine()
        do {
            if let filepath = Bundle.main.path(forResource: currentTrack, ofType: "mp3") {
                let filepathURL = NSURL.fileURL(withPath: filepath)
                audioFile = try AVAudioFile(forReading: filepathURL)
                
                //    Start your Engines 
                audioEngine.prepare()
                try audioEngine.start()
                
                
                setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
                
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
                
                audioPlayerNodeL4.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL4.pan = -1
                audioPlayerNodeL4.play()
                
                audioPlayerNodeL5.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeL5.pan = -1
                audioPlayerNodeL5.play()
                
                
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
                
                audioPlayerNodeR4.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR4.pan = 1
                audioPlayerNodeR4.play()
                
                audioPlayerNodeR5.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeR5.pan = 1
                audioPlayerNodeR5.play()
                
                // Flat Stereo
                audioPlayerNodeS.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                audioPlayerNodeS.pan = 0
                audioPlayerNodeS.play()
            }
        } catch _ {print ("Catching Audio Engine Error")}
    }
    
    func setIntensity1 () {
        currentIntensity = 1
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        print ("Intesnity set to: \(currentIntensity)")
    }
    
    func setIntensity2 () {
        currentIntensity = 2
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        print ("Intesnity set to: \(currentIntensity)")
    }
    
    func setIntensity3 () {
        currentIntensity = 3
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        print ("Intesnity set to: \(currentIntensity)")
    }
    
    func setIntensity4 () {
        currentIntensity = 4
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        print ("Intesnity set to: \(currentIntensity)")
    }
    
    func setIntensity5 () {
        currentIntensity = 5
        setEqualizerVolume(currentIntensity: currentIntensity, currentProfile: currentProfile)
        print ("Intesnity set to: \(currentIntensity)")
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
        let volume = Float(getVolume(decibelReduction: ((maxUnheard + minHeard) / 2)))
        playTone(volume: volume)
        testStatus = "Test in Progress"
        testInProgress = true
        print ("tapStartTest volume = \(volume)")
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
    
}



   
