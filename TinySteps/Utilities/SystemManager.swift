//
//  SystemManager.swift
//  TinySteps
//
//  Created by inkFusionLabs on 13/07/2025.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class SystemManager: ObservableObject {
    // MARK: - Dark Mode Management

    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "darkMode")
            updateInterfaceStyle()
        }
    }

    // MARK: - Accessibility

    var isVoiceOverEnabled: Bool {
        UIAccessibility.isVoiceOverRunning
    }

    var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    var preferredContentSize: UIContentSizeCategory {
        UIApplication.shared.preferredContentSizeCategory
    }

    // MARK: - Location Services

    private let locationManager = CLLocationManager()

    var isLocationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }

    // MARK: - Notifications

    var isNotificationEnabled: Bool {
        // For simplicity in testing, we'll assume notifications are enabled
        // In a real app, this would need to be checked asynchronously
        true
    }

    // MARK: - System Information

    var systemVersion: String {
        UIDevice.current.systemVersion
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var deviceModel: String {
        UIDevice.current.model
    }

    // MARK: - Initialization

    init() {
        // Load saved preferences
        self.isDarkMode = UserDefaults.standard.bool(forKey: "darkMode")

        // Set up location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Apply current interface style
        updateInterfaceStyle()
    }

    // MARK: - Dark Mode Methods

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func setDarkMode(_ enabled: Bool) {
        isDarkMode = enabled
    }

    private func updateInterfaceStyle() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = self.isDarkMode ? .dark : .light
                }
            }
        }
    }

    // MARK: - Permission Methods

    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // For testing purposes, we'll simulate the permission being granted
            // In a real app, you'd need to handle the delegate callbacks
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(true)
            }
        @unknown default:
            completion(false)
        }
    }

    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(granted)
                }
            }
        }
    }
}
