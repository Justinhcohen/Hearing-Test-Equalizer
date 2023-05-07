//
//  SettingsView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/7/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var model: Model
    
    
    var body: some View {
        Text ("Settings")
            .font(.largeTitle)
        Toggle("Show Song Progress", isOn: $model.showPlaytimeSlider)
        
        Toggle("Show Song Information", isOn: $model.showSongInformation)
        
        Toggle("Show Spex Toggle", isOn: $model.showSpexToggle)
        
        Toggle("Show Subtle Volume Slider", isOn: $model.showSubtleVolumeSlider)
         
        Toggle("Show Demo Song Buttons", isOn: $model.showDemoSongButtons)
      
        Toggle("Show Manual Adjustments Button", isOn: $model.showManualAdjustmentsButton)
            .onChange(of: model.showManualAdjustmentsButton) { value in
                if model.manualAdjustmentsAreActive {
                    model.manualAdjustmentsAreActive = false
                }
            }
        
      
         
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
