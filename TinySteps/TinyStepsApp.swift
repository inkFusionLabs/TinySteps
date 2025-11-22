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

@main
struct TinyStepsApp: App {
    @State private var selectedTab: ContentView.NavigationTab = .home
    @StateObject private var dataManager = BabyDataManager()
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var countryContext = CountryContext()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @AppStorage("app_passcode") private var appPasscode: String = ""
    @State private var showAuth: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .environmentObject(themeManager)
                .environmentObject(countryContext)
                .environmentObject(DataPersistenceManager.shared)
                .environment(\.sizeCategory, UIDevice.current.userInterfaceIdiom == .pad ? .extraLarge : .large)
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
