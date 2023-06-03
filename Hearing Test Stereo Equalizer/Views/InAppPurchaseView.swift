//
//  InAppPurchaseView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/24/23.
//

import SwiftUI
import StoreKit
import FirebaseAnalytics

struct InAppPurchaseView: View {
    
    @EnvironmentObject var model: Model
    @EnvironmentObject private var store: Store
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack (spacing: 30) {
            Text ("Spex Lifetime")
                .font(.largeTitle)
            HStack {
                Text ("Spex Lifetime removes the pause timer and provides you with a lifetime of full access and free upgrades. No subscription required.")
                    .font(.body)
                Spacer()
            }
           
        }
        .padding() 
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        
        VStack (spacing: 30) {
            Spacer()
            if model.spexLifetimeIsPurchased {
                HStack {
                    Text("Already purchased. Thank you for being a Spex Lifetime member!")
                        .font(.body)
                    Spacer()
                }
            }
            if !store.products.isEmpty {
                let product = store.products.first!
                Button("\(product.displayPrice) - Spex Lifetime") {
                    Task {
                        try await store.purchase(product)
                    }
                    FirebaseAnalytics.Analytics.logEvent("tap_purchase_button", parameters: [
                        "songs_played": model.songsPlayed
                    ])
                //    model.spexLifetimeIsPurchased = true
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .clipShape(Capsule())
                .onChange(of: store.hasPurchasedSpexLifetime, perform: {newValue in
                    if newValue == true {
                        if !model.spexLifetimeIsPurchased {
                            model.spexLifetimeIsPurchased = true
                        }
                    }
                }
                          
                )
                
                Button("Restore purchases") {
                    Task {
                        try await AppStore.sync()
                    }
                }
            } else {
                HStack {
                    Text ("Currently unable to connect to the App Store.")
                        .font(.body)
                    Spacer()
                }
            }
        }
        .padding()
        
    }
}

//struct InAppPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        InAppPurchaseView()
//    }
//}
