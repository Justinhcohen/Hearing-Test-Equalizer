//
//  ProfileView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import SwiftUI

struct ProfileView: View {

   // @EnvironmentObject var model: Model
    
    let storedValues = StoredValues.shared

    
    @State var currentProfile = 1
    
    func updateCurrentProfile () {
        currentProfile = storedValues.currentProfile
    }
    
    func setProfile1 () {
        currentProfile = 1
        storedValues.currentProfile = 1
       
    }
    
    func setProfile2 () {
        currentProfile = 2
        storedValues.currentProfile = 2
    }
    
    var body: some View {
        
        VStack {
            Text("Select Profile")
                .font(.largeTitle)
                .padding(25)
            
            Text ("Current Profile: \(currentProfile)")
                .padding(25)
            
            Button("Profile 1", 
                   action: {
                setProfile1()
            })
            .padding(25)
            
            Button("Profile 2", 
                   action: {
                setProfile2()
            })
            .padding(25) 
        }
        
        .onAppear {
            updateCurrentProfile()
        }
    }
}

    

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
