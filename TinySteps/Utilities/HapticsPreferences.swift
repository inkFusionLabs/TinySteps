//
//  HapticsPreferences.swift
//  TinySteps
//
//  Centralized toggle for enabling/disabling haptics app-wide
//

import Foundation
import UIKit

enum HapticsPreferences {
	static var isEnabled: Bool {
		if UserDefaults.standard.object(forKey: "enable_haptics") == nil {
			// Default to true if not set
			return true
		}
		return UserDefaults.standard.bool(forKey: "enable_haptics")
	}
	
	static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		guard isEnabled else { return }
		let generator = UIImpactFeedbackGenerator(style: style)
		generator.impactOccurred()
	}
	
	static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
		guard isEnabled else { return }
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(type)
	}
}





