//
//  User.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/13/22.
//

import Foundation
import SwiftUI


class StoredValues {
    
    // Singleton for StoredValues
    
    static let shared = StoredValues()
    
    // Current profile
    
    @AppStorage ("currentProfile") var currentProfile = 1
    
    // Current intensity
    
    @AppStorage ("currentIntensity") var currentIntensity = 2
    
    // Lowest audible decibel values for profile 1
    
    @AppStorage ("lowestAudibleDecibelBand60L_1") var lowestAudibleDecibelBand60L_1 = -83.75
    @AppStorage ("lowestAudibleDecibelBand60R_1") var lowestAudibleDecibelBand60R_1 = -84.375

    @AppStorage ("lowestAudibleDecibelBand100L_1") var lowestAudibleDecibelBand100L_1 = -84.6875
    @AppStorage ("lowestAudibleDecibelBand100R_1") var lowestAudibleDecibelBand100R_1 = -75.9375

    @AppStorage ("lowestAudibleDecibelBand230L_1") var lowestAudibleDecibelBand230L_1 = -89.6875
    @AppStorage ("lowestAudibleDecibelBand230R_1") var lowestAudibleDecibelBand230R_1 = -89.6875

    @AppStorage ("lowestAudibleDecibelBand500L_1") var lowestAudibleDecibelBand500L_1 = -89.6875
    @AppStorage ("lowestAudibleDecibelBand500R_1") var lowestAudibleDecibelBand500R_1 = -100.0

    @AppStorage ("lowestAudibleDecibelBand1100L_1") var lowestAudibleDecibelBand1100L_1 = -100.0
    @AppStorage ("lowestAudibleDecibelBand1100R_1") var lowestAudibleDecibelBand1100R_1 = -100.0

    @AppStorage ("lowestAudibleDecibelBand2400L_1") var lowestAudibleDecibelBand2400L_1 = -100.0
    @AppStorage ("lowestAudibleDecibelBand2400R_1") var lowestAudibleDecibelBand2400R_1 = -100.0

    @AppStorage ("lowestAudibleDecibelBand5400L_1") var lowestAudibleDecibelBand5400L_1 = -87.1875
    @AppStorage ("lowestAudibleDecibelBand5400R_1") var lowestAudibleDecibelBand5400R_1 = -89.6875

    @AppStorage ("lowestAudibleDecibelBand12000L_1") var lowestAudibleDecibelBand12000L_1 = -57.5
    @AppStorage ("lowestAudibleDecibelBand12000R_1") var lowestAudibleDecibelBand12000R_1 = -60.0
    
    // Lowest audible decibel values for profile 2
    
    @AppStorage ("lowestAudibleDecibelBand60L_2") var lowestAudibleDecibelBand60L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand60R_2") var lowestAudibleDecibelBand60R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand100L_2") var lowestAudibleDecibelBand100L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand100R_2") var lowestAudibleDecibelBand100R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand230L_2") var lowestAudibleDecibelBand230L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand230R_2") var lowestAudibleDecibelBand230R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand500L_2") var lowestAudibleDecibelBand500L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand500R_2") var lowestAudibleDecibelBand500R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand1100L_2") var lowestAudibleDecibelBand1100L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand1100R_2") var lowestAudibleDecibelBand1100R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand2400L_2") var lowestAudibleDecibelBand2400L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand2400R_2") var lowestAudibleDecibelBand2400R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand5400L_2") var lowestAudibleDecibelBand5400L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand5400R_2") var lowestAudibleDecibelBand5400R_2 = -100.0

    @AppStorage ("lowestAudibleDecibelBand12000L_2") var lowestAudibleDecibelBand12000L_2 = -100.0
    @AppStorage ("lowestAudibleDecibelBand12000R_2") var lowestAudibleDecibelBand12000R_2 = -100.0
}


