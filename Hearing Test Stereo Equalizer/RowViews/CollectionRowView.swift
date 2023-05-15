//
//  CollectionRowView.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/15/23.
//

import SwiftUI

struct CollectionRowView: View {
    var collectionImage: Image
    var collectionName: String
    
    var body: some View {
        HStack {
            collectionImage
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(collectionName)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

//struct CollectionRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionRowView()
//    }
//}
