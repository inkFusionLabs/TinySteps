//
//  TinyStepsApp.swift
//  TinySteps
//
//  Created by inkFusionLabs on 13/07/2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
// import Firebase

@main
struct TinyStepsApp: App {
    @State private var selectedTab: ContentView.NavigationTab = .home
    @StateObject private var dataManager = BabyDataManager()
    @StateObject private var notificationManager = EnhancedNotificationsManager.shared
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @AppStorage("app_passcode") private var appPasscode: String = ""
    @State private var showAuth: Bool = false

    init() {
        // Configure Firebase
        // FirebaseApp.configure()
        
        // Setup enhanced notifications
        EnhancedNotificationsManager.shared.setupNotificationCategories()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .environmentObject(notificationManager)
                .onOpenURL { url in
                    guard url.scheme == "tinysteps",
                          url.host == "category",
                          let tabString = url.pathComponents.dropFirst().first,
                          let tab = ContentView.NavigationTab(rawValue: tabString)
                    else { return }
                    selectedTab = tab
                }
        }
    }
}
