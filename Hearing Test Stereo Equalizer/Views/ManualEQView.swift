//
//  ManualEQView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 4/23/23.
//

import SwiftUI

struct ManualEQView: View {
    @EnvironmentObject var model: Model	
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.managedObjectContext) var moc
    @State private var sliderIsEditing = false
    @State private var shouldShowAlert = false
    
    
    @State private var left60M = 0.0
    @State private var left100M = 0.0
    @State private var left230M = 0.0
    @State private var left500M = 0.0
    @State private var left1100M = 0.0
    @State private var left2400M = 0.0
    @State private var left5400M = 0.0
    @State private var left12000M = 0.0
    @State private var right60M = 0.0
    @State private var right100M = 0.0
    @State private var right230M = 0.0
    @State private var right500M = 0.0
    @State private var right1100M = 0.0
    @State private var right2400M = 0.0
    @State private var right5400M = 0.0
    @State private var right12000M = 0.0
    
    func saveManualAdjustments () {
        let activeUser = userProfiles.first {
            $0.isActive
        }!
        activeUser.left60M = Float(left60M)
        activeUser.left100M = Float(left100M)
        activeUser.left230M = Float(left230M)
        activeUser.left500M = Float(left500M)
        activeUser.left1100M = Float(left1100M)
        activeUser.left2400M = Float(left2400M)
        activeUser.left5400M = Float(left5400M)
        activeUser.left12000M = Float(left12000M)
        activeUser.right60M = Float(right60M)
        activeUser.right100M = Float(right100M)
        activeUser.right230M = Float(right230M)
        activeUser.right500M = Float(right500M)
        activeUser.right1100M = Float(right1100M)
        activeUser.right2400M = Float(right2400M)
        activeUser.right5400M = Float(right5400M)
        activeUser.right12000M = Float(right12000M)
        try? moc.save()
    }
    
    func populateManualAdjustmentsOnAppear() {
        left60M = Double (model.currentUserProfile.left60M)
        left100M = Double (model.currentUserProfile.left100M)
        left230M = Double (model.currentUserProfile.left230M)
        left500M = Double (model.currentUserProfile.left500M)
        left1100M = Double (model.currentUserProfile.left1100M)
        left2400M = Double (model.currentUserProfile.left2400M)
        left5400M = Double (model.currentUserProfile.left5400M)
        left12000M = Double (model.currentUserProfile.left12000M)
        right60M = Double (model.currentUserProfile.right60M)
        right100M = Double (model.currentUserProfile.right100M)
        right230M = Double (model.currentUserProfile.right230M)
        right500M = Double (model.currentUserProfile.right500M)
        right1100M = Double (model.currentUserProfile.right1100M)
        right2400M = Double (model.currentUserProfile.right2400M)
        right5400M = Double (model.currentUserProfile.right5400M)
        right12000M = Double (model.currentUserProfile.right12000M)
        
    }
    
    func resetAllToZero () {
        left60M = 0
        left100M = 0
        left230M = 0
        left500M = 0
        left1100M = 0
        left2400M = 0
        left5400M = 0
        left12000M = 0
        right60M = 0
        right100M = 0
        right230M = 0
        right500M = 0
        right1100M = 0
        right2400M = 0
        right5400M = 0
        right12000M = 0
        
        let activeUser = userProfiles.first {
            $0.isActive
        }!
        activeUser.left60M = 0
        activeUser.left100M = 0
        activeUser.left230M = 0
        activeUser.left500M = 0
        activeUser.left1100M = 0
        activeUser.left2400M = 0
        activeUser.left5400M = 0
        activeUser.left12000M = 0
        activeUser.right60M = 0
        activeUser.right100M = 0
        activeUser.right230M = 0
        activeUser.right500M = 0
        activeUser.right1100M = 0
        activeUser.right2400M = 0
        activeUser.right5400M = 0
        activeUser.right12000M = 0
        try? moc.save()
        
        model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
    }
    
    
    var body: some View {
        
        Group {
            ZStack {
                Text ("Manual EQ Adjustment")
                    .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                    .font(.title3)
                    .padding()
                Toggle("", isOn: $model.manualAdjustmentsAreActive)
                    .onChange(of: model.manualAdjustmentsAreActive) { value in
                        model.toggleManualAdjustments()
                    }
                    .padding(.trailing)
                    .padding(.leading)
            }
            HStack {
                Text ("Left")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                Text ("")
                    .frame(maxWidth: .infinity)
                Text ("Right")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
            }
            
            
            ScrollView {
                HStack {
                    VStack {
                        Text("\(left60M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left60M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left60M = Float(left60M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                        .onAppear {
                            populateManualAdjustmentsOnAppear()
                        }
                    }
                    
                    Text("60 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right60M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right60M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right60M = Float(right60M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left100M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left100M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left100M = Float(left100M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("100 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right100M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right100M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right100M = Float(right100M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left230M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left230M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left230M = Float(left230M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("230 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right230M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right230M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right230M = Float(right230M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left500M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left500M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left500M = Float(left500M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("500 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right500M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right500M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right500M = Float(right500M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left1100M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left1100M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left1100M = Float(left1100M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("1100 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right1100M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right1100M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right1100M = Float(right1100M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left2400M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left2400M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left2400M = Float(left2400M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("2400 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right2400M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right2400M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right2400M = Float(right2400M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left5400M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left5400M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left5400M = Float(left5400M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("5400 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right5400M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right5400M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right5400M = Float(right5400M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                HStack {
                    VStack {
                        Text("\(left12000M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $left12000M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.left12000M = Float(left12000M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                    
                    Text("12000 Hz")
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(right12000M.decimals(2))")
                            .foregroundColor(model.manualAdjustmentsAreActive ? .green : .gray)
                        Slider (value: $right12000M, in: -5.0...5.0, onEditingChanged: { editing in
                            model.currentUserProfile.right12000M = Float(right12000M)
                            model.setEQBandsGainForSliderPlusManual(for: model.currentUserProfile)
                            saveManualAdjustments()
                            sliderIsEditing = editing
                        })
                    }
                }
                
            }
            Button("Reset All", 
                   action: {
                //resetAllToZero()
                shouldShowAlert = true
            })
            .font(.title)
            .foregroundColor(.blue)
            .padding ()
            .overlay(
                Capsule(style: .continuous)
                    .stroke( .blue, lineWidth: 5)
            )
            .alert("Are you sure you want to reset all to zero?", isPresented: $shouldShowAlert) {
                Button ("I'm sure", role: .destructive) {
                    resetAllToZero()
                }
                        Button("Cancel", role: .cancel) { }
                    }
            //            HStack {
            //         
            //                Text("\(left100.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("100 Hz")
            //                    .frame(maxWidth: .infinity)
            //             
            //                Text("\(right100.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //           
            //                Text("\(left230.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("230 Hz")
            //                    .frame(maxWidth: .infinity)
            //               
            //                Text("\(right230.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //            
            //                Text("\(left500.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("500 Hz")
            //                    .frame(maxWidth: .infinity)
            //              
            //                Text("\(right500.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //            
            //                Text("\(left1100.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("1100 Hz")
            //                    .frame(maxWidth: .infinity)
            //             
            //                Text("\(right1100.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //             
            //                Text("\(left2400.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("2400 Hz")
            //                    .frame(maxWidth: .infinity)
            //             
            //                Text("\(right2400.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //              
            //                Text("\(left5400.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("5400 Hz")
            //                    .frame(maxWidth: .infinity)
            //            
            //                Text("\(right5400.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
            //            HStack {
            //             
            //                Text("\(left12000.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //                Text("12000 Hz")
            //                    .frame(maxWidth: .infinity)
            //           
            //                Text("\(right12000.decimals(2))")
            //                    .foregroundColor(model.equalizerIsActive ? .green : .gray)
            //                    .frame(maxWidth: .infinity)
            //            }
        }
    }
}

struct ManualEQView_Previews: PreviewProvider {
    static var previews: some View {
        ManualEQView()
    }
}
