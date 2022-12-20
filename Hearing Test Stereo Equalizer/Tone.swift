//
//  Tone.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/13/22.
//

import Foundation

enum Tone {
    case Band60L (String)
    case Band60R (String)
    case Band100L (String)
    case Band100R (String)
    case Band230L (String)
    case Band230R (String)
    case Band500L (String)
    case Band500R (String)
    case Band1100L (String)
    case Band1100R (String)
    case Band2400L (String)
    case Band2400R (String)
    case Band5400L (String)
    case Band5400R (String)
    case Band12000L (String)
    case Band12000R (String)
}

let toneArray = [Tone.Band60L("Band60")]
