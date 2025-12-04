//
//  DesignSystemTests.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
import SwiftUI
@testable import TinySteps

final class DesignSystemTests: XCTestCase {
    
    // MARK: - Color Tests
    
    func testTinyStepsDesignColors() throws {
        // Test that all color properties are accessible
        XCTAssertNotNil(TinyStepsDesign.Colors.primary)
        XCTAssertNotNil(TinyStepsDesign.Colors.secondary)
        XCTAssertNotNil(TinyStepsDesign.Colors.accent)
        XCTAssertNotNil(TinyStepsDesign.Colors.success)
        XCTAssertNotNil(TinyStepsDesign.Colors.warning)
        XCTAssertNotNil(TinyStepsDesign.Colors.error)
        XCTAssertNotNil(TinyStepsDesign.Colors.background)
        XCTAssertNotNil(TinyStepsDesign.Colors.textPrimary)
        XCTAssertNotNil(TinyStepsDesign.Colors.textSecondary)
    }
    
    func testThemeColors() throws {
        // Test that theme colors are properly defined
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.primary)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.secondary)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.accent)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.success)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.warning)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.error)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.background)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.textPrimary)
        XCTAssertNotNil(ThemeManager.shared.currentTheme.colors.textSecondary)
    }
    
    // MARK: - Spacing Tests
    
    func testSpacingValues() throws {
        // Test that spacing values are properly defined
        XCTAssertEqual(TinyStepsDesign.Spacing.xs, 4)
        XCTAssertEqual(TinyStepsDesign.Spacing.sm, 8)
        XCTAssertEqual(TinyStepsDesign.Spacing.md, 16)
        XCTAssertEqual(TinyStepsDesign.Spacing.lg, 24)
        XCTAssertEqual(TinyStepsDesign.Spacing.xl, 32)
        XCTAssertEqual(TinyStepsDesign.Spacing.xxl, 48)
    }
    
    // MARK: - Typography Tests
    
    func testTypographySizes() throws {
        // Test that typography sizes are properly defined
        XCTAssertNotNil(TinyStepsDesign.Typography.largeTitle)
        XCTAssertNotNil(TinyStepsDesign.Typography.title)
        XCTAssertNotNil(TinyStepsDesign.Typography.headline)
        XCTAssertNotNil(TinyStepsDesign.Typography.body)
        XCTAssertNotNil(TinyStepsDesign.Typography.caption)
        XCTAssertNotNil(TinyStepsDesign.Typography.footnote)
    }
    
    // MARK: - Animation Tests
    
    func testAnimationConstants() throws {
        // Test that animation constants are properly defined
        XCTAssertNotNil(TinyStepsDesign.Animations.quick)
        XCTAssertNotNil(TinyStepsDesign.Animations.smooth)
        XCTAssertNotNil(TinyStepsDesign.Animations.gentle)
        XCTAssertNotNil(TinyStepsDesign.Animations.bouncy)
        XCTAssertNotNil(TinyStepsDesign.Animations.snappy)
        XCTAssertNotNil(TinyStepsDesign.Animations.slow)
        XCTAssertNotNil(TinyStepsDesign.Animations.tap)
        XCTAssertNotNil(TinyStepsDesign.Animations.hover)
        XCTAssertNotNil(TinyStepsDesign.Animations.focus)
    }
    
    // MARK: - Design System Component Tests

    func testDesignSystemButtonCreation() throws {
        // Test that design system buttons can be created
        let view = DesignSystem.Buttons.primary(title: "Test Button") { }
        XCTAssertNotNil(view)
    }

    func testDesignSystemCardCreation() throws {
        // Test that design system cards can be created
        let view = DesignSystem.Cards.standard {
            Text("Test Card Content")
        }
        XCTAssertNotNil(view)
    }

    func testDesignSystemInputFieldCreation() throws {
        // Test that design system input fields can be created
        let text = Binding<String>(get: { "" }, set: { _ in })
        let view = DesignSystem.InputFields.enhancedStandard(title: "Test Input", text: text)
        XCTAssertNotNil(view)
    }

    // MARK: - Theme Manager Tests

    func testThemeManagerInitialization() throws {
        let themeManager = ThemeManager.shared
        XCTAssertNotNil(themeManager)
        XCTAssertNotNil(themeManager.currentTheme)
    }

    func testThemeSwitching() throws {
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentTheme

        themeManager.setTheme(.modern)
        XCTAssertEqual(themeManager.currentTheme, .modern)

        themeManager.setTheme(.classic)
        XCTAssertEqual(themeManager.currentTheme, .classic)

        // Restore original theme
        themeManager.setTheme(originalTheme)
    }
}
