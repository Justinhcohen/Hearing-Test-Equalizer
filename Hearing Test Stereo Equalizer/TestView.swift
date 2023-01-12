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
    
    @State private var isShowingCompareSilence = false
    @State private var noIsTemporarilyDisabled = false
    @State private var yesIsTemporarilyDisabled = false
    @State private var testProgress = 0.0
    var doYouHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var yesIHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var noIDontHearIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var bandIsShown: Bool {
        if !model.testInProgress {
            return false
        } else if isShowingCompareSilence {
            return false
        } else {
            return true
        }
    }
    var noButtonIsDisabled : Bool {
        if !model.testInProgress {
            return true
        } else if noIsTemporarilyDisabled {
            return true
        } else {
            return false
        }
    }
    var yesButtonIsDisabled : Bool {
        if !model.testInProgress {
            return true
        } else if yesIsTemporarilyDisabled {
            return true
        } else {
            return false
        }
    }
    
    private func preventDoubleTapAsync(buttonToggle: Bool) async {
            // Delay of 0.5 seconds (1 second = 1_000_000_000 nanoseconds)
            try? await Task.sleep(nanoseconds: 500_000_000)
        if buttonToggle == noIsTemporarilyDisabled {
            noIsTemporarilyDisabled = false
        } else if buttonToggle == yesIsTemporarilyDisabled {
            yesIsTemporarilyDisabled = false
        }
    }
    
    private func preventDoulbleTap (buttonToggle: Bool) {
        Task {
            await preventDoubleTapAsync(buttonToggle: buttonToggle)
        }
    }

    var body: some View {
        GeometryReader { proxy in 
            NavigationStack {
                
                VStack (spacing: 40) {
                    
                    Text("\(model.testStatus)")
                        .font(.largeTitle)
                        .foregroundColor(model.testInProgress ? .green : .white)
                  //      .padding(25)
                    
                    ProgressView("Progress...", value: testProgress, total: 144)
                        .opacity(model.testInProgress ? 1.0 : 0)
                    
                    HStack {
                        Text("Current Profile: \(model.currentProfile)")
                            .padding(25)
                        
                        NavigationLink (destination: ProfileView()) {
                            Text ("Change")
                        }
                        .padding(25)
                    }
                    .opacity(!model.testInProgress ? 1.0 : 0)
                    
                    
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

                            
                 //   .padding(45)
                    .disabled(model.testInProgress)
                    .opacity(!model.testInProgress ? 1.0 : 0)
                    
                    Text(!isShowingCompareSilence ? "Do you hear the tone?" : "This is Silence")
                        .font(.title)
                        .opacity(model.testInProgress ? 1.0 : 0)
                    
                    Button("Yes, I hear it", 
                           action: {
                        testProgress += 1
                        if testProgress == 144 {
                            testProgress = 0
                        }
                        yesIsTemporarilyDisabled = true
                        preventDoulbleTap (buttonToggle: yesButtonIsDisabled)
                        if model.testInProgress {
                            model.tapYesHeard()
                        } else {
                            model.testStatus = "Congrats, All Done!"
                        }
                    })
                    .font(.title)
                    .foregroundColor(!yesButtonIsDisabled ? .green : .gray)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(!yesButtonIsDisabled ? Color.green : Color.gray, lineWidth: 5)
                        )
                    .opacity(yesIHearIsShown ? 1.0 : 0)
            //        .padding(45)
                    .disabled(yesButtonIsDisabled)
                    
                    
                    Button("No, I don't hear it", 
                           action: {
                        testProgress += 1
                        if testProgress == 144 {
                            testProgress = 0
                        }
                        noIsTemporarilyDisabled = true
                        preventDoulbleTap (buttonToggle: noButtonIsDisabled)
                        if model.testInProgress {
                            model.tapNoDidNotHear()
                        } else {
                            model.testStatus = "Congrats, All Done!"
                        }

                    })
                    .font(.title)
                    .foregroundColor(!noButtonIsDisabled ? .red : .gray)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(!noButtonIsDisabled ? Color.red : Color.gray, lineWidth: 5)
                        )
                    .opacity(noIDontHearIsShown ? 1.0 : 0)
             //       .padding(45)
                    .disabled(noButtonIsDisabled)
                    
                    Text("Band: \(model.currentBand)")
                        .font(.headline)
                        .opacity(bandIsShown ? 1.0 : 0)
               //         .padding(25)
                    
                    Button {
                        if !isShowingCompareSilence {
                            model.stopTone()
                        } else {
                            model.resumeTone()
                        }
                        isShowingCompareSilence.toggle()
                    } label: {
                        if !isShowingCompareSilence {
                            Text("Compare Silence")
                        } else {
                            Text ("Back to Tone")
                        }
                    }
                    .font(.title)
                    .foregroundColor(model.testInProgress ? .blue : .gray)
                    .padding ()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(model.testInProgress ? Color.blue : Color.gray, lineWidth: 5)
                        )
                    .opacity(model.testInProgress ? 1.0 : 0)
             //       .padding(45)
                    .disabled(!model.testInProgress)
                    
                   
                    
                           
//                    Button("Compare Silence",
//                           action: {
//                        model.stopTone()
//                        print ("CALLED MODEL.STOPTONE")
//                        isShowingCompareSilence.toggle()
//                        
//                    })
//                    .font(.title)
//                    .foregroundColor(model.testInProgress ? .purple : .gray)
//                    .padding ()
//                    .overlay(
//                        Capsule(style: .continuous)
//                            .stroke(model.testInProgress ? Color.purple : Color.gray, lineWidth: 5)
//                        )
//                    .opacity(model.testInProgress ? 1.0 : 0)
//             //       .padding(45)
//                    .disabled(!model.testInProgress)
                    
                   
                }
     
                
                
//                .sheet(isPresented: $isShowingCompareSilence, onDismiss: {
//                    model.resumeTone()
//                    print ("CALLED MODEL.PLAYTONE")
//                }) {
//                    CompareSilenceView()
//                }
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
