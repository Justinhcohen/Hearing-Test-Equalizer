//
//  ManualEQView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 4/23/23.
//

import SwiftUI

struct ManualEQView: View {
    @EnvironmentObject var model: Model	
    var body: some View {
        Group {
            Text ("Spex Stereo EQ Boost")
                .foregroundColor(model.equalizerIsActive ? .green : .gray)
                .font(.title3)
                .padding()
            HStack {
                let left60 = model.currentUserProfile.left60 * Float(intensity / 6.0)
                Text("\(left60.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("60 Hz")
                    .frame(maxWidth: .infinity)
                let right60 = model.currentUserProfile.right60 * Float(intensity / 6.0)
                Text("\(right60.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left100 = model.currentUserProfile.left100 * Float(intensity / 6.0)
                Text("\(left100.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("100 Hz")
                    .frame(maxWidth: .infinity)
                let right100 = model.currentUserProfile.right100 * Float(intensity / 6.0)
                Text("\(right100.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left230 = model.currentUserProfile.left230 * Float(intensity / 6.0)
                Text("\(left230.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("230 Hz")
                    .frame(maxWidth: .infinity)
                let right230 = model.currentUserProfile.right230 * Float(intensity / 6.0)
                Text("\(right230.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left500 = model.currentUserProfile.left500 * Float(intensity / 6.0)
                Text("\(left500.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("500 Hz")
                    .frame(maxWidth: .infinity)
                let right500 = model.currentUserProfile.right500 * Float(intensity / 6.0)
                Text("\(right500.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left1100 = model.currentUserProfile.left1100 * Float(intensity / 6.0)
                Text("\(left1100.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("1100 Hz")
                    .frame(maxWidth: .infinity)
                let right1100 = model.currentUserProfile.right1100 * Float(intensity / 6.0)
                Text("\(right1100.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left2400 = model.currentUserProfile.left2400 * Float(intensity / 6.0)
                Text("\(left2400.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("2400 Hz")
                    .frame(maxWidth: .infinity)
                let right2400 = model.currentUserProfile.right2400 * Float(intensity / 6.0)
                Text("\(right2400.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left5400 = model.currentUserProfile.left5400 * Float(intensity / 6.0)
                Text("\(left5400.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("5400 Hz")
                    .frame(maxWidth: .infinity)
                let right5400 = model.currentUserProfile.right5400 * Float(intensity / 6.0)
                Text("\(right5400.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
            HStack {
                let left12000 = model.currentUserProfile.left12000 * Float(intensity / 6.0)
                Text("\(left12000.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
                Text("12000 Hz")
                    .frame(maxWidth: .infinity)
                let right12000 = model.currentUserProfile.right12000 * Float(intensity / 6.0)
                Text("\(right12000.decimals(2))")
                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ManualEQView_Previews: PreviewProvider {
    static var previews: some View {
        ManualEQView()
    }
}
