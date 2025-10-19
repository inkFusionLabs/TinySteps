//
//  AccessibilityManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Accessibility Manager
class AccessibilityManager: ObservableObject {
    static let shared = AccessibilityManager()
    
    @Published var isVoiceOverEnabled = false
    @Published var isReduceMotionEnabled = false
    @Published var isReduceTransparencyEnabled = false
    @Published var isBoldTextEnabled = false
    @Published var isLargerTextEnabled = false
    @Published var preferredContentSizeCategory: ContentSizeCategory = .medium
    
    private init() {
        setupAccessibilityObservers()
        updateAccessibilitySettings()
    }
    
    // MARK: - Setup
    private func setupAccessibilityObservers() {
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAccessibilitySettings()
        }
    }
    
    private func updateAccessibilitySettings() {
        isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
        isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
        isBoldTextEnabled = UIAccessibility.isBoldTextEnabled
        isLargerTextEnabled = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory
        preferredContentSizeCategory = ContentSizeCategory(UIApplication.shared.preferredContentSizeCategory)
    }
    
    // MARK: - Accessibility Helpers
    func announce(_ message: String, priority: UIAccessibility.Notification = .announcement) {
        UIAccessibility.post(notification: priority, argument: message)
    }
    
    func focusOn(_ element: Any) {
        UIAccessibility.post(notification: .screenChanged, argument: element)
    }
    
    func isAccessibilityElement(_ element: Any) -> Bool {
        if let view = element as? UIView {
            return view.isAccessibilityElement
        }
        return false
    }
    
    // MARK: - Dynamic Type Support
    func scaledFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        if isLargerTextEnabled {
            return Font.system(style, weight: weight)
        }
        return Font.system(style, weight: weight)
    }
    
    // MARK: - Motion Support
    func shouldReduceMotion() -> Bool {
        return isReduceMotionEnabled
    }
    
    func animationForAccessibility() -> Animation? {
        return shouldReduceMotion() ? nil : .easeInOut(duration: 0.3)
    }
}

// MARK: - Accessibility View Modifiers
struct AccessibilityModifier: ViewModifier {
    let label: String?
    let hint: String?
    let value: String?
    let traits: AccessibilityTraits?
    let action: (() -> Void)?
    
    init(
        label: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        traits: AccessibilityTraits? = nil,
        action: (() -> Void)? = nil
    ) {
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label ?? "")
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
            .accessibilityAddTraits(traits ?? [])
            .accessibilityAction {
                action?()
            }
    }
}

struct AccessibilityGroupModifier: ViewModifier {
    let label: String
    let hint: String?
    
    init(label: String, hint: String? = nil) {
        self.label = label
        self.hint = hint
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}

struct AccessibilityHeadingModifier: ViewModifier {
    let level: Int
    
    init(level: Int) {
        self.level = level
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityAddTraits(.isHeader)
            .accessibilityHeading(.h1)
    }
}

struct AccessibilityButtonModifier: ViewModifier {
    let label: String
    let hint: String?
    let action: () -> Void
    
    init(label: String, hint: String? = nil, action: @escaping () -> Void) {
        self.label = label
        self.hint = hint
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
            .accessibilityAction {
                action()
            }
    }
}

struct AccessibilityImageModifier: ViewModifier {
    let label: String
    let hint: String?
    
    init(label: String, hint: String? = nil) {
        self.label = label
        self.hint = hint
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isImage)
    }
}

struct AccessibilityTextFieldModifier: ViewModifier {
    let label: String
    let hint: String?
    let value: String?
    
    init(label: String, hint: String? = nil, value: String? = nil) {
        self.label = label
        self.hint = hint
        self.value = value
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
            .accessibilityAddTraits(.isKeyboardKey)
    }
}

// MARK: - Accessibility Extensions
extension View {
    func accessibility(
        label: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        traits: AccessibilityTraits? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(AccessibilityModifier(
            label: label,
            hint: hint,
            value: value,
            traits: traits,
            action: action
        ))
    }
    
    func accessibilityGroup(label: String, hint: String? = nil) -> some View {
        modifier(AccessibilityGroupModifier(label: label, hint: hint))
    }
    
    func accessibilityHeading(level: Int = 1) -> some View {
        modifier(AccessibilityHeadingModifier(level: level))
    }
    
    func accessibilityButton(label: String, hint: String? = nil, action: @escaping () -> Void) -> some View {
        modifier(AccessibilityButtonModifier(label: label, hint: hint, action: action))
    }
    
    func accessibilityImage(label: String, hint: String? = nil) -> some View {
        modifier(AccessibilityImageModifier(label: label, hint: hint))
    }
    
    func accessibilityTextField(label: String, hint: String? = nil, value: String? = nil) -> some View {
        modifier(AccessibilityTextFieldModifier(label: label, hint: hint, value: value))
    }
}

// MARK: - Accessibility Testing
class AccessibilityTester: ObservableObject {
    @Published var testResults: [String: Bool] = [:]
    
    func testAccessibility(_ view: Any, name: String) {
        var isAccessible = false
        
        if let uiView = view as? UIView {
            isAccessible = uiView.isAccessibilityElement && (uiView.accessibilityLabel?.isEmpty == false)
        }
        
        testResults[name] = isAccessible
    }
    
    func generateAccessibilityReport() -> String {
        var report = "Accessibility Test Report\n"
        report += "========================\n\n"
        
        for (name, isAccessible) in testResults {
            report += "\(name): \(isAccessible ? "✅ PASS" : "❌ FAIL")\n"
        }
        
        let passCount = testResults.values.filter { $0 }.count
        let totalCount = testResults.count
        report += "\nOverall: \(passCount)/\(totalCount) tests passed"
        
        return report
    }
}

// MARK: - Accessibility Debug View
struct AccessibilityDebugView: View {
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    @StateObject private var tester = AccessibilityTester()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Accessibility Status")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                StatusRow(title: "VoiceOver", isEnabled: accessibilityManager.isVoiceOverEnabled)
                StatusRow(title: "Reduce Motion", isEnabled: accessibilityManager.isReduceMotionEnabled)
                StatusRow(title: "Reduce Transparency", isEnabled: accessibilityManager.isReduceTransparencyEnabled)
                StatusRow(title: "Bold Text", isEnabled: accessibilityManager.isBoldTextEnabled)
                StatusRow(title: "Larger Text", isEnabled: accessibilityManager.isLargerTextEnabled)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Content Size Category")
                    .font(.headline)
                
                Text(accessibilityManager.preferredContentSizeCategory.localizedDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Test Results")
                    .font(.headline)
                
                if tester.testResults.isEmpty {
                    Text("No tests run yet")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(tester.testResults.keys.sorted()), id: \.self) { key in
                        HStack {
                            Text(key)
                            Spacer()
                            Image(systemName: tester.testResults[key] == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(tester.testResults[key] == true ? .green : .red)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct StatusRow: View {
    let title: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isEnabled ? .green : .red)
        }
    }
}

// MARK: - Content Size Category Extension
extension ContentSizeCategory {
    init(_ category: UIContentSizeCategory) {
        switch category {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        default:
            self = .medium
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .extraSmall:
            return "Extra Small"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .extraLarge:
            return "Extra Large"
        case .extraExtraLarge:
            return "Extra Extra Large"
        case .extraExtraExtraLarge:
            return "Extra Extra Extra Large"
        case .accessibilityMedium:
            return "Accessibility Medium"
        case .accessibilityLarge:
            return "Accessibility Large"
        case .accessibilityExtraLarge:
            return "Accessibility Extra Large"
        case .accessibilityExtraExtraLarge:
            return "Accessibility Extra Extra Large"
        case .accessibilityExtraExtraExtraLarge:
            return "Accessibility Extra Extra Extra Large"
        @unknown default:
            return "Unknown"
        }
    }
}

