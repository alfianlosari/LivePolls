//
//  LivePollsApp.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings

        // Uncomment this settings configuration to not use Local Emulator suite
        settings.host = "127.0.0.1:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        return true
    }
    
}

@main
struct LivePollsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
