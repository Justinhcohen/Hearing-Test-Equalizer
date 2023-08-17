//
//  SettingsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/7/23.
//

import SwiftUI
import MessageUI
import FirebaseAnalytics

struct SettingsView: View {
    
    @EnvironmentObject var model: Model
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var shouldShowInAppPurchaseModal = false
    
    func showInAppPurchaseModal () {
        shouldShowInAppPurchaseModal = true
        FirebaseAnalytics.Analytics.logEvent("show_in_app_purchase", parameters: nil)
    }
    func dismiss() {
    }
    
    
    var body: some View {
        VStack {
            Text ("Settings")
                .font(.largeTitle)
                .padding(20)
            ScrollView {
                VStack (spacing: 20) {
                    Group {
                        Toggle("Show Song Progress", isOn: $model.showPlaytimeSlider)
                            .onChange(of: model.showPlaytimeSlider) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_playtime_slider", parameters: [
                                    "playtime_slider_is_showing": "\(model.showPlaytimeSlider)"
                                ])
                            }
                        
                        Toggle("Show Song Information", isOn: $model.showSongInformation)
                            .onChange(of: model.showSongInformation) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_song_information", parameters: [
                                    "song_information_is_showing": "\(model.showSongInformation)"
                                ])
                            }
                        
                        Toggle("Show Repeat Button", isOn: $model.showRepeatButton)
                            .onChange(of: model.showRepeatButton) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_repeat_button", parameters: [
                                    "repeat_button_is_showing": "\(model.showRepeatButton)"
                                ])
                            }
                        
                        Toggle("Show Spex On Player", isOn: $model.showSpexOnPlayer)
                            .onChange(of: model.showSpexOnPlayer) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_spex_on_player", parameters: [
                                    "spex_on_player_is_showing": "\(model.showSpexOnPlayer)"
                                ])
                            }
                        
                        Toggle("Show Intensity with Profile Name", isOn: $model.showIntensityWithProfile)
                            .onChange(of: model.showIntensityWithProfile) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_intensity_with_profile", parameters: [
                                    "show_intensity_with_profile": "\(model.showIntensityWithProfile)"
                                ])
                            }
                        
                        Toggle("Show Subtle Volume Slider", isOn: $model.showSubtleVolumeSlider)
                            .onChange(of: model.showSubtleVolumeSlider) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_subtle_volume_slider", parameters: [
                                    "subtle_volume_slider_is_showing": "\(model.showSubtleVolumeSlider)"
                                ])
                            }
                        
                        Toggle("Show AirPlay Button", isOn: $model.showAirPlayButton)
                            .onChange(of: model.showAirPlayButton) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_airplay_button", parameters: [
                                    "airplay_button_is_showing": "\(model.showAirPlayButton)"
                                ])
                            }
                        
                        Toggle("Show Demo Song Buttons", isOn: $model.showDemoSongButtons)
                            .onChange(of: model.showDemoSongButtons) { value in
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_demo_song_buttons", parameters: [
                                    "demo_song_buttons_are_showing": "\(model.showDemoSongButtons)"
                                ])
                            }
                        
                        Toggle("Show Manual EQ Button", isOn: $model.showManualAdjustmentsButton)
                            .onChange(of: model.showManualAdjustmentsButton) { value in
                                if model.manualAdjustmentsAreActive {
                                    model.manualAdjustmentsAreActive = false
                                }
                                FirebaseAnalytics.Analytics.logEvent("toggle_show_manual_adjustments_button", parameters: [
                                    "manual_adjustment_button_is_showing": "\(model.showManualAdjustmentsButton)"
                                ])
                                
                            }
                    }
                    Toggle("Practice Tone Before Test", isOn: $model.practiceToneBeforeTest)
                        .onChange(of: model.practiceToneBeforeTest) { value in
                            FirebaseAnalytics.Analytics.logEvent("toggle_practice_tone_before_test", parameters: [
                                "practice_tone_before_test": "\(model.practiceToneBeforeTest)"
                            ])
                        }
                    
                    HStack {
                        if MFMailComposeViewController.canSendMail() {
                            Button("Report Issue") {
                                self.isShowingMailView = true
                                FirebaseAnalytics.Analytics.logEvent("report_issue", parameters: nil)
                            }
                        } else {
                            Text("")
                        }
                        Spacer()
                    }
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(isShowing: self.$isShowingMailView, result: self.$result)
                    }
                    HStack {
                        Button("In-App Purchases") {
                            showInAppPurchaseModal()
                        }
                        .sheet(isPresented: $shouldShowInAppPurchaseModal, onDismiss: dismiss) {
                            InAppPurchaseView()
                        }
                        Spacer()
                    }
                    
                }
                .padding(20)
            }
            .font(.title3)
            Spacer()
            HStack {
                Text ("Spex version 1.11")
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
