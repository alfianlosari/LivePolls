//
//  LivePollsVisionApp.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
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
struct LivePollsVisionApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private var navVM = NavigationViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PollListView()
                    .environment(navVM)
            }
        }
        
        WindowGroup(id: "PollOption") {
            NavigationStack {
                PollOptionView()
                    .environment(navVM)
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.4, height: 0.6, depth: 0, in: .meters)
        
        
        WindowGroup(id: "Poll") {
            NavigationStack {
                PollView()
                    .environment(navVM)
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.4, height: 0.7, depth: 0, in: .meters)
        
    }
}

