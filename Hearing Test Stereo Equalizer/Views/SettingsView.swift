//
//  SettingsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/7/23.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @EnvironmentObject var model: Model
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    
    var body: some View {
        VStack {
            Text ("Settings")
                .font(.largeTitle)
                .padding(20)
            ScrollView {
                VStack (spacing: 20) {
                    Toggle("Show Song Progress", isOn: $model.showPlaytimeSlider)
                    
                    Toggle("Show Song Information", isOn: $model.showSongInformation)
                    
                    Toggle("Show Spex Toggle", isOn: $model.showSpexToggle)
                    
                    Toggle("Show Subtle Volume Slider", isOn: $model.showSubtleVolumeSlider)
                    
                    Toggle("Show AirPlay Button", isOn: $model.showAirPlayButton)
                    
                    Toggle("Show Demo Song Buttons", isOn: $model.showDemoSongButtons)
                    
                    Toggle("Show Manual Adjustments Button", isOn: $model.showManualAdjustmentsButton)
                        .onChange(of: model.showManualAdjustmentsButton) { value in
                            if model.manualAdjustmentsAreActive {
                                model.manualAdjustmentsAreActive = false
                            }
                        }
                    
                    Toggle("Practice Tone Before Test", isOn: $model.practiceToneBeforeTest)
                    
                    HStack {
                        if MFMailComposeViewController.canSendMail() {
                            Button("Report Issue") {
                                self.isShowingMailView.toggle()
                            }
                        } else {
                            Text("Can't send emails from this device")
                        }
//                        if result != nil {
//                            Text("Result: \(String(describing: result))")
//                                .lineLimit(nil)
//                        }
                        Spacer()
                    }
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(isShowing: self.$isShowingMailView, result: self.$result)
                    }
                    
                    
                }
                .padding(20)
            }
            .font(.title3)
            Spacer()
            HStack {
                Text ("Spex version 1.0")
                    .font(.body)
                    .opacity(0.5)
                Spacer()
                
            }
            .padding(20)
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
