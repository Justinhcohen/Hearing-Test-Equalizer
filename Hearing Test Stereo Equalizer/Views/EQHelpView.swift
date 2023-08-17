//
//  EQHelpView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 8/13/23.
//

import SwiftUI

struct EQHelpView: View {
    var body: some View {
        VStack {
            Text ("Spex EQ Insight")
                .font(.largeTitle)
                .padding(.top, 10)
            ScrollView {
                VStack (spacing: 30) {
                    HStack {
                        Text ("Spex gave you a hearing test so that it could boost the frequencies where you need it the most. The frequency that you could hear the best receives no boost. The frequencies that you heard the worst receive the most boost.")
                        Spacer()
                    }
                    HStack {
                        Text ("The intensity level sets the range of boosts. When the intensity is set to 11, the frequency you heard the worst will get boosted by 11 decibels with all other frequencies being boosted by less, with the amount being dependent upon how well you could hear them relative to the frequency you heard the worst. When the intensity is set to 15, the range of frequency boosts will run from zero decibels (the frequency you heard best) up to 15 (the frequency you heard the worst).")
                        Spacer()
                    }
                    HStack {
                        Text ("As you slide the intensity slider back and forth, you can see how the decibel boosts at each frequency in each ear are being affected. If you see higher numbers on the left side relative to the numbers on the right, that means you hear better in your right ear and needed less boost. The boosts at 60 Hz are affecting the lowest bass notes and the boosts at 12000 Hz are affecting the highest treble notes, with all the other boosts affecting the frequencies in between.")
                        Spacer()
                    }
                    HStack {
                        Text ("You will find your ideal intensity level by experimenting with the slider while listening to the demo songs and the songs in your music library. Just settle on the intensity that sounds the best. You can also toggle Spex on and off while listening to hear how Spex is shaping the sound. If you'd like to make additional adjustments to your EQ profile after you've found your ideal intensity, you can choose to show the Manual Adjustments button via a toggle in the Settings. Tapping the Manual Adjustments button will enable you to adjust each frequency within a 20 decibel range, by quarter steps.")
                        Spacer()
                    }
                    HStack {
                        Text ("If you want to use Spex with different kinds of headphones, for example ear buds and over the ear headphones, you may want to create a separate profile for each. This is because over the ear headphones tend to do a better job reproducing the ends of the audible spectrum compared to ear buds, especially bass.")
                        Spacer()
                    }
                    HStack {
                        Text ("If I can provide any additional info, please email me: Justin.H.Cohen@gmail.com. Happy listening!")
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}

struct EQHelpView_Previews: PreviewProvider {
    static var previews: some View {
        EQHelpView()
    }
}
