//
//  ResponsiveButtonStyle.swift
//  TinySteps
//
//  Created for improved touch response
//

import SwiftUI
import UIKit

// MARK: - Responsive Button Style
struct ResponsiveButtonStyle: SwiftUI.ButtonStyle {
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.1), value: isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
                if newValue {
					// Immediate haptic feedback (respects app preference)
					HapticsPreferences.impact(.light)
                }
            }
    }
}

// MARK: - Haptic Feedback Helper
struct HapticFeedback {
    static func light() {
		HapticsPreferences.impact(.light)
    }
    
    static func medium() {
		HapticsPreferences.impact(.medium)
    }
    
    static func heavy() {
		HapticsPreferences.impact(.heavy)
    }
    
    static func success() {
		HapticsPreferences.notify(.success)
    }
    
    static func error() {
		HapticsPreferences.notify(.error)
    }
}

extension View {
    func responsiveButton() -> some View {
        self.buttonStyle(ResponsiveButtonStyle())
    }
}

