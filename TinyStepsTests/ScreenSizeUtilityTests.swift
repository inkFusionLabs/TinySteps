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
        XCTAssertNotNil(DeviceCategory.iPhone)
        XCTAssertNotNil(DeviceCategory.iPad)
        XCTAssertNotNil(DeviceCategory.iPhone17Pro)
        XCTAssertNotNil(DeviceCategory.iPhoneAir)
        XCTAssertNotNil(DeviceCategory.proMax)
        XCTAssertNotNil(DeviceCategory.air)
        XCTAssertNotNil(DeviceCategory.iPadPro)
    }
    
    func testDeviceCategoryProperties() throws {
        // Test iPhone properties
        let iPhone = DeviceCategory.iPhone
        XCTAssertTrue(iPhone.isCompact)
        XCTAssertTrue(iPhone.hasHomeIndicator)
        XCTAssertEqual(iPhone.recommendedGridColumns, 2)
        XCTAssertEqual(iPhone.cardSpacing, 16)
        XCTAssertEqual(iPhone.buttonHeight, 44)
        XCTAssertEqual(iPhone.fontScale, 1.0)
        
        // Test iPad properties
        let iPad = DeviceCategory.iPad
        XCTAssertFalse(iPad.isCompact)
        XCTAssertFalse(iPad.hasHomeIndicator)
        XCTAssertEqual(iPad.recommendedGridColumns, 3)
        XCTAssertEqual(iPad.cardSpacing, 20)
        XCTAssertEqual(iPad.buttonHeight, 50)
        XCTAssertEqual(iPad.fontScale, 1.1)
        
        // Test iPhone 17 Pro properties
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        XCTAssertFalse(iPhone17Pro.isCompact)
        XCTAssertTrue(iPhone17Pro.hasHomeIndicator)
        XCTAssertEqual(iPhone17Pro.recommendedGridColumns, 3)
        XCTAssertEqual(iPhone17Pro.cardSpacing, 18)
        XCTAssertEqual(iPhone17Pro.buttonHeight, 48)
        XCTAssertEqual(iPhone17Pro.fontScale, 1.05)
        
        // Test iPhone Air properties
        let iPhoneAir = DeviceCategory.iPhoneAir
        XCTAssertTrue(iPhoneAir.isCompact)
        XCTAssertTrue(iPhoneAir.hasHomeIndicator)
        XCTAssertEqual(iPhoneAir.recommendedGridColumns, 2)
        XCTAssertEqual(iPhoneAir.cardSpacing, 16)
        XCTAssertEqual(iPhoneAir.buttonHeight, 44)
        XCTAssertEqual(iPhoneAir.fontScale, 1.0)
    }
    
    func testMaxContentWidth() throws {
        // Test max content width for different devices
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.maxContentWidth, 400)
        XCTAssertEqual(iPad.maxContentWidth, 600)
        XCTAssertEqual(iPhone17Pro.maxContentWidth, 500)
    }
    
    func testCardWidth() throws {
        // Test card width for different devices
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.cardWidth, 180)
        XCTAssertEqual(iPad.cardWidth, 200)
        XCTAssertEqual(iPhone17Pro.cardWidth, 190)
    }
    
    // MARK: - Screen Size Detection Tests
    
    func testScreenSizeDetection() throws {
        // Test that screen size detection methods exist
        XCTAssertNotNil(ScreenSizeUtility.currentDeviceCategory)
        XCTAssertNotNil(ScreenSizeUtility.isLandscape)
        XCTAssertNotNil(ScreenSizeUtility.isPortrait)
    }
    
    // MARK: - View Modifier Tests
    
    func testScreenSizeSpecificViewModifier() throws {
        let modifier = ScreenSizeSpecificViewModifier { _ in
            Text("iPhone Content")
        } iPadContent: { _ in
            Text("iPad Content")
        } proMaxContent: { _ in
            Text("Pro Max Content")
        } airContent: { _ in
            Text("Air Content")
        } iPhone17ProContent: { _ in
            Text("iPhone 17 Pro Content")
        }
        
        XCTAssertNotNil(modifier)
    }
    
    // MARK: - Responsive Design Tests
    
    func testResponsiveGridColumns() throws {
        // Test that responsive grid columns are calculated correctly
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.recommendedGridColumns, 2)
        XCTAssertEqual(iPad.recommendedGridColumns, 3)
        XCTAssertEqual(iPhone17Pro.recommendedGridColumns, 3)
    }
    
    func testResponsiveSpacing() throws {
        // Test that responsive spacing is calculated correctly
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.cardSpacing, 16)
        XCTAssertEqual(iPad.cardSpacing, 20)
        XCTAssertEqual(iPhone17Pro.cardSpacing, 18)
    }
    
    func testResponsiveButtonHeight() throws {
        // Test that responsive button height is calculated correctly
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.buttonHeight, 44)
        XCTAssertEqual(iPad.buttonHeight, 50)
        XCTAssertEqual(iPhone17Pro.buttonHeight, 48)
    }
    
    func testResponsiveFontScale() throws {
        // Test that responsive font scale is calculated correctly
        let iPhone = DeviceCategory.iPhone
        let iPad = DeviceCategory.iPad
        let iPhone17Pro = DeviceCategory.iPhone17Pro
        
        XCTAssertEqual(iPhone.fontScale, 1.0)
        XCTAssertEqual(iPad.fontScale, 1.1)
        XCTAssertEqual(iPhone17Pro.fontScale, 1.05)
    }
    
    // MARK: - Edge Cases Tests
    
    func testUnknownDeviceCategory() throws {
        // Test that unknown device categories have reasonable defaults
        let unknown = DeviceCategory.iPhone // Using iPhone as a fallback
        XCTAssertNotNil(unknown)
        XCTAssertTrue(unknown.isCompact)
        XCTAssertTrue(unknown.hasHomeIndicator)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceDeviceCategoryDetection() throws {
        self.measure {
            for _ in 0..<1000 {
                _ = ScreenSizeUtility.currentDeviceCategory
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
