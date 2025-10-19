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
        XCTAssertNotNil(TinyStepsDesign.Colors.cardBackground)
        XCTAssertNotNil(TinyStepsDesign.Colors.textPrimary)
        XCTAssertNotNil(TinyStepsDesign.Colors.textSecondary)
    }
    
    func testNeumorphicColors() throws {
        // Test that neumorphic colors are properly defined
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.primary)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.secondary)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.success)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.warning)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.error)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.textPrimary)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.textSecondary)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.base)
        XCTAssertNotNil(TinyStepsDesign.NeumorphicColors.backgroundSecondary)
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
    
    // MARK: - Component Tests
    
    func testTinyStepsButtonCreation() throws {
        let button = TinyStepsButton(
            backgroundColor: .blue,
            foregroundColor: .white,
            cornerRadius: 12,
            isEnabled: true,
            action: {}
        ) {
            Text("Test Button")
        }
        
        XCTAssertNotNil(button)
    }
    
    func testTinyStepsCardCreation() throws {
        let card = TinyStepsCard {
            Text("Test Card Content")
        }
        
        XCTAssertNotNil(card)
    }
    
    func testTinyStepsIconButtonCreation() throws {
        let iconButton = TinyStepsIconButton(
            icon: "heart.fill",
            color: .red,
            size: 24,
            action: {}
        )
        
        XCTAssertNotNil(iconButton)
    }
    
    func testTinyStepsSectionHeaderCreation() throws {
        let sectionHeader = TinyStepsSectionHeader(
            title: "Test Section",
            icon: "star.fill"
        )
        
        XCTAssertNotNil(sectionHeader)
    }
    
    func testTinyStepsInfoCardCreation() throws {
        let infoCard = TinyStepsInfoCard(
            title: "Test Info",
            content: "Test content",
            icon: "info.circle",
            color: .blue
        )
        
        XCTAssertNotNil(infoCard)
    }
    
    // MARK: - ResponsiveGrid Tests
    
    func testResponsiveGridCreation() throws {
        let grid = ResponsiveGrid(
            columns: 2,
            spacing: 16
        ) {
            Text("Item 1")
            Text("Item 2")
        }
        
        XCTAssertNotNil(grid)
    }
    
    // MARK: - QuickActionButton Tests
    
    func testQuickActionButtonCreation() throws {
        let quickAction = QuickActionButton(
            title: "Test Action",
            icon: "star.fill",
            color: .blue,
            action: {}
        )
        
        XCTAssertNotNil(quickAction)
    }
    
    // MARK: - Animation Modifier Tests
    
    func testSlideInAnimation() throws {
        let view = Text("Test")
            .slideIn(from: .fromTop)
        
        XCTAssertNotNil(view)
    }
    
    func testStaggeredSlideInAnimation() throws {
        let view = Text("Test")
            .staggeredSlideIn(from: .fromBottom, delay: 0.1)
        
        XCTAssertNotNil(view)
    }
    
    func testPulsateAnimation() throws {
        let view = Text("Test")
            .pulsate()
        
        XCTAssertNotNil(view)
    }
    
    func testNeumorphicPressAnimation() throws {
        let view = Text("Test")
            .neumorphicPress()
        
        XCTAssertNotNil(view)
    }
}
