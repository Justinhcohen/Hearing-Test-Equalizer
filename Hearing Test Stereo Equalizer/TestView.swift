//
//  TestView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/22/22.
//

import SwiftUI
import AVKit

struct TestView: View {
    
    @EnvironmentObject var model: Model
    
    let labelHeight: CGFloat = 0.06
    let labelWidth: CGFloat = 0.53
    let buttonWidth: CGFloat = 0.87

    var body: some View {
        GeometryReader { proxy in 
            NavigationView {
                
                VStack {
                    
                    Text("\(model.testStatus)")
                        .font(.largeTitle)
                        .foregroundColor(model.testInProgress ? .green : .white)
                        .padding(25)
                    
                    
                    HStack {
                        Text("Current Profile: \(model.currentProfile)")
                            .padding(25)
                        
                        NavigationLink (destination: ProfileView()) {
                            Text ("Change")
                        }
                        .padding(25)
                    }
                    
                    
                    Button("Start Test", 
                           action: {
                        if !model.testInProgress {
                            model.tapStartTest()
                        }
                    })
                    .font(.title)
                    .foregroundColor(model.testInProgress ? .gray : .blue)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(model.testInProgress ? Color.gray : Color.blue, lineWidth: 5)
                        )
                            
                    .padding(45)
                    .disabled(model.testInProgress)
                    
                    Text("Do you hear the tone?")
                        .font(.title)
                        .opacity(model.testInProgress ? 1.0 : 0)
                    
                    Button("Yes, I hear it", 
                           action: {
                        if model.testInProgress {
                            model.tapYesHeard()
                        } else {
                            model.testStatus = "Congrats, All Done!"
                        }
                    })
                    .font(.title)
                    .foregroundColor(model.testInProgress ? .purple : .gray)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(model.testInProgress ? Color.purple : Color.gray, lineWidth: 5)
                        )
                    .padding(45)
                    .disabled(!model.testInProgress)
                    
                    
                    Button("No, I don't hear it", 
                           action: {
                        if model.testInProgress {
                            model.tapNoDidNotHear()
                        } else {
                            model.testStatus = "Congrats, All Done!"
                        }
                        
                    })
                    .font(.title)
                    .foregroundColor(model.testInProgress ? .purple : .gray)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(model.testInProgress ? Color.purple : Color.gray, lineWidth: 5)
                        )
                    .padding(45)
                    .disabled(!model.testInProgress)
                    
                    Text("Band: \(model.currentBand)")
                        .font(.headline)
                        .padding(25)
                }
                
            }
        }
        .onAppear {
            
            print ("TestView onAppear CALLED")
            
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
