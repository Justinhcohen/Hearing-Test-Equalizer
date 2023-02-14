//
//  DataController.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 1/13/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HearingTest")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
