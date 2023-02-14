//
//  GainRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 2/10/23.
//

import SwiftUI

struct GainRowView: View {
    
    var leftGain: String
    var hertz: String
    var rightGain: String
    
    var id = UUID()
    
    var body: some View {
        
        HStack (spacing: 0) {
            Text(leftGain)
            Text (hertz)
            Text(rightGain)
            
        }
    }
}

struct GainRowView_Previews: PreviewProvider {
    static var previews: some View {
        GainRowView(leftGain: "", hertz: "", rightGain: "")
    }
}
