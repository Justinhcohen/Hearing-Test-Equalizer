//
//  ProfileView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 12/23/22.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var model: Model
   
    var body: some View {
        
        VStack {
            Text("Select Profile")
                .font(.largeTitle)
                .padding(25)
            
            Text ("Current Profile: \(model.currentProfile)")
                .padding(25)
            
            Button("Profile 1", 
                   action: {
                model.setProfile1()
            })
            .padding(25)
            
            Button("Profile 2", 
                   action: {
                model.setProfile2()
            })
            .padding(25) 
            
            Button("Profile 3", 
                   action: {
                model.setProfile3()
            })
            .padding(25) 
            
            Button("Profile 4", 
                   action: {
                model.setProfile4()
            })
            .padding(25) 
            
            Button("Profile 5", 
                   action: {
                model.setProfile5()
            })
            .padding(25) 
        }
        
        .onAppear {
           
        }
    }
}

    

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
