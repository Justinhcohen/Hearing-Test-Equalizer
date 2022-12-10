//
//  ContentView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/4/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
//    @State var audioPlayerL: AVAudioPlayer!
//    @State var audioPlayerR: AVAudioPlayer!
    var audioEngine: AVAudioEngine = AVAudioEngine()
    @State var mixerL = AVAudioMixerNode()
    @State var mixerR = AVAudioMixerNode()
    @State var audioFileBuffer = AVAudioPCMBuffer()
    @State var equalizerL: AVAudioUnitEQ!
    @State var equalizerR: AVAudioUnitEQ!
    var audioPlayerNodeL: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioPlayerNodeR: AVAudioPlayerNode = AVAudioPlayerNode()
    @State var audioFile: AVAudioFile!
    let audioTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.3))
    var body: some View {
        VStack {
            Button("Play", 
                action: {
//                let playTime = audioPlayerL.deviceCurrentTime + 0.01
//                self.audioPlayerL.pan = -1.0
//                    self.audioPlayerL.play(atTime: playTime)
//                self.audioPlayerR.pan = 1.0
//                    self.audioPlayerR.play(atTime: playTime)
                }
            ) 
        }
        .onAppear {
            
            // Left Ear
            equalizerL = AVAudioUnitEQ(numberOfBands: 8)
            audioEngine.attach(audioPlayerNodeL) 
            audioEngine.attach(equalizerL) 
            audioEngine.attach(mixerL)
            audioEngine.connect(audioPlayerNodeL, to: mixerL, format: nil)
            audioEngine.connect(mixerL, to: equalizerL, format: nil)
            audioEngine.connect(equalizerL, to: audioEngine.mainMixerNode, format: nil)
            let bandsL = equalizerL.bands
            let freqs = [60, 100, 230, 500, 1100, 2400, 5400, 12000]
            for i in 0...(bandsL.count - 1) {
                bandsL[i].frequency = Float(freqs[i])
                bandsL[i].bypass = false
                bandsL[i].filterType = .parametric
            }
            bandsL[0].gain = -50.0
            bandsL[1].gain = -50.0
            bandsL[2].gain = -50.0
            bandsL[3].gain = 10.0
            bandsL[4].gain = 10.0
            
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
                bandsR[i].filterType = .parametric
            }
            bandsR[0].gain = 10.0
            bandsR[1].gain = 10.0
            bandsR[2].gain = 10.0
            bandsR[3].gain = -50.0
            bandsR[4].gain = -50.0
            
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
                    
                    
                    // Right Audio Engine
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

