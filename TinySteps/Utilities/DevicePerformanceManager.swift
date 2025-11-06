//
//  DevicePerformanceManager.swift
//  TinySteps
//
//  Created for performance optimization on older devices
//

import UIKit
import SwiftUI
import Darwin

// MARK: - Device Performance Manager
class DevicePerformanceManager: ObservableObject {
    static let shared = DevicePerformanceManager()
    
    enum PerformanceTier {
        case high      // iPhone 15 Pro and newer
        case medium    // iPhone 13-14 Pro
        case low       // iPhone 12 and older, iPhone SE
    }
    
    private var _performanceTier: PerformanceTier?
    
    var performanceTier: PerformanceTier {
        if let tier = _performanceTier {
            return tier
        }
        
        let tier = calculatePerformanceTier()
        _performanceTier = tier
        return tier
    }
    
    var isLowPerformance: Bool {
        performanceTier == .low
    }
    
    var isMediumPerformance: Bool {
        performanceTier == .medium
    }
    
    var shouldReduceAnimations: Bool {
        performanceTier != .high
    }
    
    var shouldSimplifyViews: Bool {
        performanceTier == .low
    }
    
    var maxSimultaneousAnimations: Int {
        switch performanceTier {
        case .high: return 10
        case .medium: return 5
        case .low: return 2
        }
    }
    
    var animationDurationMultiplier: Double {
        switch performanceTier {
        case .high: return 1.0
        case .medium: return 0.8
        case .low: return 0.6
        }
    }
    
    private func calculatePerformanceTier() -> PerformanceTier {
        // Get device model identifier
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        } ?? "unknown"
        
        // iPhone 15 Pro and newer (A17 and newer)
        if modelCode.contains("iPhone17") || modelCode.contains("iPhone18") || modelCode.contains("iPhone19") {
            return .high
        }
        
        // iPhone 14 Pro (A16)
        if modelCode.contains("iPhone16") {
            return .high
        }
        
        // iPhone 13 Pro (A15)
        if modelCode.contains("iPhone14") {
            return .medium
        }
        
        // iPhone 12 Pro (A14)
        if modelCode.contains("iPhone13") {
            return .medium
        }
        
        // iPhone 11 and older (A13 and older)
        if modelCode.contains("iPhone12") || modelCode.contains("iPhone11") || 
           modelCode.contains("iPhone10") || modelCode.contains("iPhone9") ||
           modelCode.contains("iPhone8") {
            return .low
        }
        
        // Fallback: check by screen size and assume older if smaller
        let screenSize = UIScreen.main.bounds.size
        let screenArea = screenSize.width * screenSize.height
        
        // Very small screens likely older devices
        if screenArea < 200000 {
            return .low
        }
        
        // Default to medium for unknown devices
        return .medium
    }
    
    func optimizedAnimation(duration: Double) -> Animation {
        let adjustedDuration = duration * animationDurationMultiplier
        if shouldReduceAnimations {
            return .easeInOut(duration: min(adjustedDuration, 0.2))
        }
        return .easeInOut(duration: adjustedDuration)
    }
    
    func shouldUseDrawingGroup() -> Bool {
        return isLowPerformance
    }
}

// MARK: - Performance Optimized View Modifier
struct PerformanceOptimizedModifier: ViewModifier {
    @StateObject private var performanceManager = DevicePerformanceManager.shared
    
    func body(content: Content) -> some View {
        if performanceManager.shouldUseDrawingGroup() {
            content
                .drawingGroup()
        } else {
            content
        }
    }
}

extension View {
    func performanceOptimized() -> some View {
        modifier(PerformanceOptimizedModifier())
    }
}

