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
                    // Immediate haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
    }
}

// MARK: - Haptic Feedback Helper
struct HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

extension View {
    func responsiveButton() -> some View {
        self.buttonStyle(ResponsiveButtonStyle())
    }
}

