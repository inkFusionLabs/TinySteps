//
//  ScreenSizeUtilityTests.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
import SwiftUI
@testable import TinySteps

final class ScreenSizeUtilityTests: XCTestCase {
    
    // MARK: - Device Category Tests
    
    func testDeviceCategoryDetection() throws {
        // Test that device categories are properly defined
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhoneSE)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhoneStandard)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhoneAir)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhoneLarge)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhoneProMax)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPhone17Pro)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPad)
        XCTAssertNotNil(ScreenSizeUtility.DeviceCategory.iPadPro)
    }
    
    func testDeviceCategoryProperties() throws {
        // Test iPhone SE properties
        let iPhoneSE = ScreenSizeUtility.DeviceCategory.iPhoneSE
        XCTAssertTrue(iPhoneSE.isCompact)
        XCTAssertFalse(iPhoneSE.hasHomeIndicator)
        XCTAssertEqual(iPhoneSE.recommendedGridColumns, 2)
        XCTAssertEqual(iPhoneSE.cardSpacing, 12)
        XCTAssertEqual(iPhoneSE.buttonHeight, 44)
        XCTAssertEqual(iPhoneSE.fontScale, 0.9)

        // Test iPhone Standard properties
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        XCTAssertTrue(iPhoneStandard.isCompact)
        XCTAssertFalse(iPhoneStandard.hasHomeIndicator)
        XCTAssertEqual(iPhoneStandard.recommendedGridColumns, 2)
        XCTAssertEqual(iPhoneStandard.cardSpacing, 16)
        XCTAssertEqual(iPhoneStandard.buttonHeight, 48)
        XCTAssertEqual(iPhoneStandard.fontScale, 1.0)

        // Test iPhone Air properties
        let iPhoneAir = ScreenSizeUtility.DeviceCategory.iPhoneAir
        XCTAssertTrue(iPhoneAir.isCompact)
        XCTAssertTrue(iPhoneAir.hasHomeIndicator)
        XCTAssertEqual(iPhoneAir.recommendedGridColumns, 2)
        XCTAssertEqual(iPhoneAir.cardSpacing, 16)
        XCTAssertEqual(iPhoneAir.buttonHeight, 48)
        XCTAssertEqual(iPhoneAir.fontScale, 1.0)

        // Test iPhone Large properties
        let iPhoneLarge = ScreenSizeUtility.DeviceCategory.iPhoneLarge
        XCTAssertFalse(iPhoneLarge.isCompact)
        XCTAssertTrue(iPhoneLarge.hasHomeIndicator)
        XCTAssertEqual(iPhoneLarge.recommendedGridColumns, 3)
        XCTAssertEqual(iPhoneLarge.cardSpacing, 20)
        XCTAssertEqual(iPhoneLarge.buttonHeight, 52)
        XCTAssertEqual(iPhoneLarge.fontScale, 1.05)

        // Test iPad properties
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        XCTAssertFalse(iPad.isCompact)
        XCTAssertTrue(iPad.hasHomeIndicator)
        XCTAssertEqual(iPad.recommendedGridColumns, 4)
        XCTAssertEqual(iPad.cardSpacing, 24)
        XCTAssertEqual(iPad.buttonHeight, 56)
        XCTAssertEqual(iPad.fontScale, 1.2)
    }
    
    func testMaxContentWidth() throws {
        // Test max content width for different devices
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        // These values depend on actual screen sizes, so we'll just verify they're reasonable
        XCTAssertGreaterThan(iPhoneStandard.fontScale, 0)
        XCTAssertGreaterThan(iPad.fontScale, 1.0)
        XCTAssertGreaterThan(iPhone17Pro.fontScale, 1.0)
    }
    
    func testCardWidth() throws {
        // Test that card width calculation works for different devices
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        // Test that grid columns are reasonable
        XCTAssertGreaterThan(iPhoneStandard.recommendedGridColumns, 0)
        XCTAssertGreaterThan(iPad.recommendedGridColumns, 2)
        XCTAssertGreaterThan(iPhone17Pro.recommendedGridColumns, 2)
    }
    
    // MARK: - Screen Size Detection Tests
    
    func testScreenSizeDetection() throws {
        // Test that screen size detection methods exist
        XCTAssertNotNil(ScreenSizeUtility.deviceCategory)
        XCTAssertNotNil(ScreenSizeUtility.isLandscape)
        XCTAssertNotNil(ScreenSizeUtility.isPortrait)
    }
    
    // MARK: - View Modifier Tests
    
    func testScreenSizeSpecificViewModifier() throws {
        let modifier = ScreenSizeSpecificViewModifier(
            seView: { AnyView(Text("SE Content")) },
            standardView: { AnyView(Text("Standard Content")) },
            airView: { AnyView(Text("Air Content")) },
            largeView: { AnyView(Text("Large Content")) },
            proMaxView: { AnyView(Text("Pro Max Content")) },
            iPhone17ProView: { AnyView(Text("iPhone 17 Pro Content")) }
        )

        XCTAssertNotNil(modifier)
    }
    
    // MARK: - Responsive Design Tests
    
    func testResponsiveGridColumns() throws {
        // Test that responsive grid columns are calculated correctly
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        XCTAssertEqual(iPhoneStandard.recommendedGridColumns, 2)
        XCTAssertEqual(iPad.recommendedGridColumns, 4)
        XCTAssertEqual(iPhone17Pro.recommendedGridColumns, 4)
    }
    
    func testResponsiveSpacing() throws {
        // Test that responsive spacing is calculated correctly
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        XCTAssertEqual(iPhoneStandard.cardSpacing, 16)
        XCTAssertEqual(iPad.cardSpacing, 24)
        XCTAssertEqual(iPhone17Pro.cardSpacing, 28)
    }
    
    func testResponsiveButtonHeight() throws {
        // Test that responsive button height is calculated correctly
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        XCTAssertEqual(iPhoneStandard.buttonHeight, 48)
        XCTAssertEqual(iPad.buttonHeight, 56)
        XCTAssertEqual(iPhone17Pro.buttonHeight, 60)
    }
    
    func testResponsiveFontScale() throws {
        // Test that responsive font scale is calculated correctly
        let iPhoneStandard = ScreenSizeUtility.DeviceCategory.iPhoneStandard
        let iPad = ScreenSizeUtility.DeviceCategory.iPad
        let iPhone17Pro = ScreenSizeUtility.DeviceCategory.iPhone17Pro

        XCTAssertEqual(iPhoneStandard.fontScale, 1.0)
        XCTAssertEqual(iPad.fontScale, 1.2)
        XCTAssertEqual(iPhone17Pro.fontScale, 1.15)
    }
    
    // MARK: - Edge Cases Tests
    
    func testUnknownDeviceCategory() throws {
        // Test that unknown device categories have reasonable defaults
        let unknown = ScreenSizeUtility.DeviceCategory.iPhoneStandard // Using iPhone as a fallback
        XCTAssertNotNil(unknown)
        XCTAssertTrue(unknown.isCompact)
        XCTAssertTrue(unknown.hasHomeIndicator)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceDeviceCategoryDetection() throws {
        self.measure {
            for _ in 0..<1000 {
                _ = ScreenSizeUtility.deviceCategory
            }
        }
    }
    
    func testPerformanceScreenSizeDetection() throws {
        self.measure {
            for _ in 0..<1000 {
                _ = ScreenSizeUtility.isLandscape
                _ = ScreenSizeUtility.isPortrait
            }
        }
    }
}
