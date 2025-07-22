//
//  TinyStepsApp.swift
//  TinySteps
//
//  Created by inkFusionLabs on 13/07/2025.
//

import SwiftUI
import LocalAuthentication
#if canImport(UIKit)
import UIKit
#endif
import Firebase

@main
struct TinyStepsApp: App {
    @State private var selectedTab: ContentView.Tab = .home
    @StateObject private var dataManager = BabyDataManager()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("faceIDEnabled") private var faceIDEnabled: Bool = false
    @AppStorage("touchIDEnabled") private var touchIDEnabled: Bool = false
    @State private var showAuth: Bool = true
    @State private var didAppear = false

    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize crash reporting
        CrashReportingManager.shared.logMessage("TinySteps app launched", level: .info)
        CrashReportingManager.shared.logMessage("Firebase configured successfully", level: .info)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoggedIn && !showAuth {
                    ContentView(selectedTab: $selectedTab)
                        .environmentObject(dataManager)
                        .onOpenURL { url in
                            guard url.scheme == "tinysteps",
                                  url.host == "category",
                                  let tabString = url.pathComponents.dropFirst().first,
                                  let tab = ContentView.Tab(rawValue: tabString)
                            else { return }
                            selectedTab = tab
                        }
                } else {
                    LoginView()
                }
            }
            .onAppear {
                if !didAppear {
                    didAppear = true
                    authenticateIfNeeded()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                authenticateIfNeeded()
            }
        }
    }

    private func authenticateIfNeeded() {
        if isLoggedIn && (faceIDEnabled || touchIDEnabled) {
            let context = LAContext()
            var error: NSError?
            let reason = "Authenticate to access TinySteps"
            let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
            if context.canEvaluatePolicy(policy, error: &error) {
                context.evaluatePolicy(policy, localizedReason: reason) { success, _ in
                    DispatchQueue.main.async {
                        self.showAuth = !success
                    }
                }
            } else {
                // Biometrics not available, fallback to password
                self.showAuth = false
            }
        } else {
            self.showAuth = false
        }
    }
}
