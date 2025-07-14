//
//  TinyStepsApp.swift
//  TinySteps
//
//  Created by inkFusionLabs on 13/07/2025.
//

import SwiftUI

@main
struct TinyStepsApp: App {
    @State private var selectedTab: ContentView.Tab = .home
    @StateObject private var dataManager = BabyDataManager()

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .onOpenURL { url in
                    // Example: tinysteps://category/tracking
                    guard url.scheme == "tinysteps",
                          url.host == "category",
                          let tabString = url.pathComponents.dropFirst().first,
                          let tab = ContentView.Tab(rawValue: tabString)
                    else { return }
                    selectedTab = tab
                }
        }
    }
}
