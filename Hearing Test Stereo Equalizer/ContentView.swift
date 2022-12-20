//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit
import MediaPlayer

struct ContentView: View {

    @AppStorage ("lowestAudibleDecibelBand60L") var lowestAudibleDecibelBand60L = 0.0
    @AppStorage ("lowestAudibleDecibelBand60R") var lowestAudibleDecibelBand60R = 0.0

    @AppStorage ("lowestAudibleDecibelBand100L") var lowestAudibleDecibelBand100L = 0.0
    @AppStorage ("lowestAudibleDecibelBand100R") var lowestAudibleDecibelBand100R = 0.0

    @AppStorage ("lowestAudibleDecibelBand230L") var lowestAudibleDecibelBand230L = 0.0
    @AppStorage ("lowestAudibleDecibelBand230R") var lowestAudibleDecibelBand230R = 0.0

    @AppStorage ("lowestAudibleDecibelBand500L") var lowestAudibleDecibelBand500L = 0.0
    @AppStorage ("lowestAudibleDecibelBand500R") var lowestAudibleDecibelBand500R = 0.0

    @AppStorage ("lowestAudibleDecibelBand1100L") var lowestAudibleDecibelBand1100L = 0.0
    @AppStorage ("lowestAudibleDecibelBand1100R") var lowestAudibleDecibelBand1100R = 0.0

    @AppStorage ("lowestAudibleDecibelBand2400L") var lowestAudibleDecibelBand2400L = 0.0
    @AppStorage ("lowestAudibleDecibelBand2400R") var lowestAudibleDecibelBand2400R = 0.0

    @AppStorage ("lowestAudibleDecibelBand5400L") var lowestAudibleDecibelBand5400L = 0.0
    @AppStorage ("lowestAudibleDecibelBand5400R") var lowestAudibleDecibelBand5400R = 0.0

    @AppStorage ("lowestAudibleDecibelBand12000L") var lowestAudibleDecibelBand12000L = 0.0
    @AppStorage ("lowestAudibleDecibelBand12000R") var lowestAudibleDecibelBand12000R = 0.0
    
    var audioEngine: AVAudioEngine = AVAudioEngine()
    @State var mixerL = AVAudioMixerNode()
    @State var mixerR = AVAudioMixerNode()
    @State var audioFileBuffer = AVAudioPCMBuffer()
    @State var equalizerL: AVAudioUnitEQ!
    @State var equalizerR: AVAudioUnitEQ!
    var audioPlayerNodeL: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioPlayerNodeR: AVAudioPlayerNode = AVAudioPlayerNode()
    @State var audioFile: AVAudioFile!
    let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(1.0))
    let toneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
    var workingToneArray = ["Band60L", "Band60R", "Band100L", "Band100R", "Band230L", "Band230R", "Band500L", "Band500R", "Band1100L", "Band1100R", "Band2400L", "Band2400R", "Band5400L", "Band5400R", "Band12000L", "Band12000R"]
    @State var maxSilence: Double = -160
    @State var minHeard: Double = 0.0
    @State var index = 0
    @State var currentTone = ""
    @State var tonePlayer: AVAudioPlayer?
    @State var isPlaying = false
    @State var bandsGain8 = [Float]()
    let volume: Float = 1.0
    
    func setEQBandsRange8 () {
        let lowestAudibleDecibelBandsAll = [lowestAudibleDecibelBand60L, lowestAudibleDecibelBand100L, lowestAudibleDecibelBand230L, lowestAudibleDecibelBand500L, lowestAudibleDecibelBand1100L, lowestAudibleDecibelBand2400L, lowestAudibleDecibelBand5400L, lowestAudibleDecibelBand12000L, lowestAudibleDecibelBand60R, lowestAudibleDecibelBand100R, lowestAudibleDecibelBand230R, lowestAudibleDecibelBand500R, lowestAudibleDecibelBand1100R, lowestAudibleDecibelBand2400R, lowestAudibleDecibelBand5400R, lowestAudibleDecibelBand12000R]
        var minValue = 0.0
        var maxValue = -160.0
        for i in 0...lowestAudibleDecibelBandsAll.count - 1 {
            if lowestAudibleDecibelBandsAll[i] < minValue {
                minValue = lowestAudibleDecibelBandsAll[i]
            }
            if lowestAudibleDecibelBandsAll[i] > maxValue {
                maxValue = lowestAudibleDecibelBandsAll[i]
            }
        }
        let multiplyer = 8 / abs(minValue - maxValue)
        var gainArray = [Float]()
        for i in 0...lowestAudibleDecibelBandsAll.count - 1 {
            gainArray.insert(Float(multiplyer * abs(minValue - lowestAudibleDecibelBandsAll[i]) ), at: i)
        }
        for i in 0...lowestAudibleDecibelBandsAll.count - 1 {
            print ("\(gainArray[i])")
        }
        bandsGain8 = gainArray
    }
    
    
    func getVolume (decibelReduction: Double) -> Double {
        
        return (1 / pow(10,(-decibelReduction / 20)))
        
    }
    
    func assignMaxHeardDecibels () {
        switch index {
        case 0: lowestAudibleDecibelBand60L = minHeard
        case 1: lowestAudibleDecibelBand60R = minHeard
        case 2: lowestAudibleDecibelBand100L = minHeard
        case 3: lowestAudibleDecibelBand100R = minHeard
        case 4: lowestAudibleDecibelBand230L = minHeard
        case 5: lowestAudibleDecibelBand230R = minHeard
        case 6: lowestAudibleDecibelBand500L = minHeard
        case 7: lowestAudibleDecibelBand500R = minHeard
        case 8: lowestAudibleDecibelBand1100L = minHeard
        case 9: lowestAudibleDecibelBand1100R = minHeard
        case 10: lowestAudibleDecibelBand2400L = minHeard
        case 11: lowestAudibleDecibelBand2400R = minHeard
        case 12: lowestAudibleDecibelBand5400L = minHeard
        case 13: lowestAudibleDecibelBand5400R = minHeard
        case 14: lowestAudibleDecibelBand12000L = minHeard
        case 15: lowestAudibleDecibelBand12000R = minHeard
        default: break
        }
    }
    
    func setCurrentTone () {
        switch index {
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
            if index % 2 == 0 {
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
        maxSilence = -160
        minHeard = 0.0
    }
    
    func printDecibelValues () {
        print ("Band60L = \(lowestAudibleDecibelBand60L)")
        print ("Band60R = \(lowestAudibleDecibelBand60R)")
        print ("Band100L = \(lowestAudibleDecibelBand100L)")
        print ("Band100R = \(lowestAudibleDecibelBand100R)")
        print ("Band230L = \(lowestAudibleDecibelBand230L)")
        print ("Band230R = \(lowestAudibleDecibelBand230R)")
        print ("Band500L = \(lowestAudibleDecibelBand500L)")
        print ("Band500R = \(lowestAudibleDecibelBand500R)")
        print ("Band1100L = \(lowestAudibleDecibelBand1100L)")
        print ("Band1100R = \(lowestAudibleDecibelBand1100R)")
        print ("Band2400L = \(lowestAudibleDecibelBand2400L)")
        print ("Band2400R = \(lowestAudibleDecibelBand2400R)")
        print ("Band5400L = \(lowestAudibleDecibelBand5400L)")
        print ("Band5400R = \(lowestAudibleDecibelBand5400R)")
        print ("Band12000L = \(lowestAudibleDecibelBand12000L)")
        print ("Band12000R = \(lowestAudibleDecibelBand12000R)")
    }
    
    func bandComplete () {
        assignMaxHeardDecibels()
        resetMinMaxValues()
        if index < toneArray.count - 1 {
            index += 1
            print ("bandComplete volume = \(volume)")
            print ("bandComplete maxSilence = \(maxSilence)")
            print ("bandComplete minHeard = \(minHeard)")
            printDecibelValues()
            playTone(volume: Float(getVolume(decibelReduction: ((maxSilence + minHeard) / 2))))
        } else {
            stopTone()
            printDecibelValues()
        }
    }
    
    func tapStartTest () {
        let volume = Float(getVolume(decibelReduction: ((maxSilence + minHeard) / 2)))
        playTone(volume: volume)
        print ("tapStartTest volume = \(volume)")
        print ("tapStartTest maxSilence = \(maxSilence)")
        print ("tapStartTest minHeard = \(minHeard)")
        
    }
    
    func tapYesHeard () {
        stopTone()
        minHeard = (maxSilence + minHeard) / 2
        if abs (maxSilence - minHeard) < 0.5 {
            print ("tapYesHeard bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxSilence + minHeard) / 2)))
            print ("tapYesHeard volume = \(volume)")
            print ("tapYesHeard maxSilence = \(maxSilence)")
            print ("tapYesHeard minHeard = \(minHeard)")
            playTone(volume: volume)
        }
        
        
    }
    
    func tapNoDidNotHear () {
        stopTone()
        maxSilence = (maxSilence + minHeard) / 2
        if abs(maxSilence - minHeard) < 0.5 {
            print ("tapNoDidNotHear bandComplete")
            bandComplete()
        } else {
            let volume = Float(getVolume(decibelReduction: ((maxSilence + minHeard) / 2)))
            print ("tapNoDidNotHear volume = \(volume)")
            print ("tapNoDidNotHear tone = \(toneArray[index])")
            print ("tapNoDidNotHear maxSilence = \(maxSilence)")
            print ("tapNoDidNotHear minHeard = \(minHeard)")
            playTone(volume: volume)
        }
       
    }


    var body: some View {
        VStack {
            
            Button("Yes, I hear it", 
                   action: {
                tapYesHeard()
            })
            Button("No, I don't hear it", 
                   action: {
                tapNoDidNotHear()
            })
            .padding (25)
//            Button("Play", 
//                action: {
//                if !isPlaying {
//                    if let tonePlayer = tonePlayer {
//                       
//                        tonePlayer.volume = volume
//                 
//                        tonePlayer.play()
//                        isPlaying = true
//                
//                        }
//                } else {
//                    if let tonePlayer = tonePlayer {
//                        tonePlayer.stop()
//                        isPlaying = false
//                    }
//                }
//                }
//            )
            
            
        }
        .onAppear {
            
         
//            print ("\(AVAudioSession.sharedInstance().outputVolume)")
//            guard let url = Bundle.main.url(forResource: currentTone, withExtension: "mp3") else { return }
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)            
//                try AVAudioSession.sharedInstance().setActive(true)
//                tonePlayer = try AVAudioPlayer(contentsOf: url)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//            tapStartTest()
          
            setEQBandsRange8()
            // Left Ear
            equalizerL = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeL) 
            audioEngine.attach(equalizerL) 
            audioEngine.attach(mixerL)
            audioEngine.connect(audioPlayerNodeL, to: mixerL, format: nil)
            audioEngine.connect(mixerL, to: equalizerL, format: nil)
            audioEngine.connect(equalizerL, to: audioEngine.mainMixerNode, format: nil)
            let bandsL = equalizerL.bands
            let bandwidth: Float = 0.5
            let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
            for i in 0...(bandsL.count - 1) {
                bandsL[i].frequency = Float(freqs[i])
                bandsL[i].bypass = false
                bandsL[i].bandwidth = bandwidth
                bandsL[i].filterType = .parametric
                bandsL[i].gain = bandsGain8[i]
            }
            // My Bands limited to 8
//            bandsL[0].gain = 2.9884
//            bandsL[1].gain = 2.816
//            bandsL[2].gain = 1.8965
//            bandsL[3].gain = 1.8965
//            bandsL[4].gain = 0
//            bandsL[5].gain = 0
//            bandsL[6].gain = 2.3562
//            bandsL[7].gain = 7.8158
////            
          
            
            // Right Ear
            equalizerR = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeR) 
            audioEngine.attach(equalizerR) 
            audioEngine.attach(mixerR)
            audioEngine.connect(audioPlayerNodeR, to: mixerR, format: nil)
            audioEngine.connect(mixerR, to: equalizerR, format: nil)
            audioEngine.connect(equalizerR, to: audioEngine.mainMixerNode, format: nil)
            let bandsR = equalizerR.bands
            for i in 0...(bandsR.count - 1) {
                bandsR[i].frequency = Float(freqs[i])
                bandsR[i].bypass = false
                bandsL[i].bandwidth = bandwidth
                bandsR[i].filterType = .parametric
                bandsR[i].gain = bandsGain8[i + 8]
            }
            // My Bands limited to 8
//            bandsR[0].gain = 2.8734
//            bandsR[1].gain = 4.4521
//            bandsR[2].gain = 1.8965
//            bandsR[3].gain = 0
//            bandsR[4].gain = 0
//            bandsR[5].gain = 0
//            bandsR[6].gain = 1.8965
//            bandsR[7].gain = 7.356
//            
          
            
            do {
                if let filepath = Bundle.main.path(forResource: "edamame", ofType: "mp3") {
                    let filepathURL = NSURL.fileURL(withPath: filepath)
                    audioFile = try AVAudioFile(forReading: filepathURL)
                    
                    // Start your Engines 
                    audioEngine.prepare()
                    try audioEngine.start()
                 
                    
                    // Left Mixer
                    audioPlayerNodeL.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                    audioPlayerNodeL.pan = -1
                    audioPlayerNodeL.play()
                    
                    
                    // Right Mixer
                    audioPlayerNodeR.scheduleFile(audioFile, at: audioTime, completionHandler: nil)
                    audioPlayerNodeR.pan = 1
                    audioPlayerNodeR.play()
                }
            } catch _ {}
        }
    }
        
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

