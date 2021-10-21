//
//  Storage_Emulator_IssueApp.swift
//  Storage Emulator Issue
//
//  Created by Stewart Lynch on 2021-10-20.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage

@main
struct Storage_Emulator_IssueApp: App {
    init() {
        FirebaseApp.configure()
#if EMULATORS
        print(
        """
        ********************************
        Testing on Emulators
        ********************************
        """
        )
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        Storage.storage().useEmulator(withHost:"localhost", port:9199)
#elseif DEBUG
        print(
        """
        ********************************
        Testing on Live Server
        ********************************
        """
        )
#endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
