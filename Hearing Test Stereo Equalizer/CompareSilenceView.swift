//
//  CompareSilenceView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/11/23.
//

import SwiftUI

struct CompareSilenceView: View {
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            Spacer ()
            
            Text("This is Silence")
                .font(.largeTitle)
                .padding()
            
            Spacer ()
            
            Button("Back to Test",
                   action: {
                dismiss()
            })
            .font(.title)
            .foregroundColor(.purple)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.purple, lineWidth: 5)
            )
        }
    }
}

struct CompareSilenceView_Previews: PreviewProvider {
    static var previews: some View {
        CompareSilenceView()
    }
}
