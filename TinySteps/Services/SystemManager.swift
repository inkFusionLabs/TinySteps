//
//  SystemManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import CoreLocation
import SwiftUI
import Security
#if os(iOS)
import UIKit
#endif

// MARK: - System Manager
class SystemManager: NSObject, ObservableObject {
    static let shared = SystemManager()
    
    // MARK: - Location Services
    @Published var locationPermissionGranted = false
    @Published var currentLocation: CLLocation?
    @Published var locationPermissionRequested = false
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Accessibility
    @Published var isVoiceOverEnabled = false
    #if os(iOS)
    @Published var preferredContentSize: UIContentSizeCategory = .medium
    #else
    @Published var preferredContentSize: String = "medium"
    #endif
    @Published var isReduceMotionEnabled = false
    
    // MARK: - System State
    @Published var isNetworkAvailable = true
    @Published var batteryLevel: Float = 1.0
    @Published var isLowPowerMode = false
    
    // MARK: - Performance
    @Published var memoryUsage: Double = 0.0
    @Published var cpuUsage: Double = 0.0
    
    override init() {
        super.init()
        setupLocationManager()
        setupAccessibilityObservers()
        setupSystemObservers()
        updateSystemState()
    }
    
    // MARK: - Location Management
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    func requestLocationPermission() {
        guard !locationPermissionRequested else { return }
        
        print("📍 Requesting location permission...")
        #if os(iOS)
        locationManager.requestWhenInUseAuthorization()
        #endif
        locationPermissionRequested = true
    }
    
    func startLocationUpdates() {
        guard locationPermissionGranted else {
            requestLocationPermission()
            return
        }
        
        locationManager.startUpdatingLocation()
        print("📍 Started location updates")
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        print("📍 Stopped location updates")
    }
    
    // MARK: - Accessibility
    private func setupAccessibilityObservers() {
        #if os(iOS)
        // Monitor VoiceOver status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessibilityStatusChanged),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
        
        // Monitor preferred content size
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeChanged),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
        
        // Monitor reduce motion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(motionPreferenceChanged),
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
        #endif
        
        updateAccessibilityStatus()
    }
    
    @objc private func accessibilityStatusChanged() {
        updateAccessibilityStatus()
    }
    
    @objc private func contentSizeChanged() {
        #if os(iOS)
        preferredContentSize = UITraitCollection.current.preferredContentSizeCategory
        #endif
    }
    
    @objc private func motionPreferenceChanged() {
        #if os(iOS)
        isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        #endif
    }
    
    private func updateAccessibilityStatus() {
        #if os(iOS)
        isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
        preferredContentSize = UITraitCollection.current.preferredContentSizeCategory
        isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        #endif
    }
    
    // MARK: - System Monitoring
    private func setupSystemObservers() {
        #if os(iOS)
        // Monitor battery state
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateChanged),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        
        // Monitor low power mode
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(lowPowerModeChanged),
            name: .NSProcessInfoPowerStateDidChange,
            object: nil
        )
        #endif
    }
    
    @objc private func batteryStateChanged() {
        #if os(iOS)
        batteryLevel = UIDevice.current.batteryLevel
        #endif
    }
    
    @objc private func lowPowerModeChanged() {
        #if os(iOS)
        isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        #endif
    }
    
    private func updateSystemState() {
        #if os(iOS)
        batteryLevel = UIDevice.current.batteryLevel
        isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        #endif
        
        // Update memory usage
        updateMemoryUsage()
    }
    
    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = Double(info.resident_size) / 1024 / 1024 // Convert to MB
            let totalMemory = Double(ProcessInfo.processInfo.physicalMemory) / 1024 / 1024
            memoryUsage = usedMemory / totalMemory
        }
    }
    
    // MARK: - Performance Optimization
    func optimizeForPerformance() {
        // Reduce animations if in low power mode
        if isLowPowerMode {
            // Disable heavy animations
            print("🔋 Low power mode detected - optimizing performance")
        }
        
        // Monitor memory usage
        if memoryUsage > 0.8 {
            print("⚠️ High memory usage detected: \(memoryUsage * 100)%")
        }
    }
    
    // MARK: - Accessibility Helpers
    func announceToVoiceOver(_ message: String) {
        #if os(iOS)
        if isVoiceOverEnabled {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
    }
    
    func shouldReduceMotion() -> Bool {
        return isReduceMotionEnabled
    }
    
    func getScaledFontSize(_ baseSize: CGFloat) -> CGFloat {
        #if os(iOS)
        switch preferredContentSize {
        case .extraSmall:
            return baseSize * 0.8
        case .small:
            return baseSize * 0.9
        case .medium:
            return baseSize
        case .large:
            return baseSize * 1.1
        case .extraLarge:
            return baseSize * 1.2
        case .extraExtraLarge:
            return baseSize * 1.3
        case .extraExtraExtraLarge:
            return baseSize * 1.4
        case .accessibilityMedium:
            return baseSize * 1.5
        case .accessibilityLarge:
            return baseSize * 1.6
        case .accessibilityExtraLarge:
            return baseSize * 1.7
        case .accessibilityExtraExtraLarge:
            return baseSize * 1.8
        case .accessibilityExtraExtraExtraLarge:
            return baseSize * 1.9
        default:
            return baseSize
        }
        #else
        return baseSize
        #endif
    }
}

// MARK: - CLLocationManagerDelegate
extension SystemManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("📍 Location updated: \(location.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationPermissionGranted = true
            startLocationUpdates()
            print("📍 Location permission granted")
        case .denied, .restricted:
            locationPermissionGranted = false
            print("📍 Location permission denied")
        case .notDetermined:
            print("📍 Location permission not determined")
        @unknown default:
            print("📍 Unknown location authorization status")
        }
    }
}