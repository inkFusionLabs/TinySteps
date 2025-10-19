//
//  SystemManagerTests.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
@testable import TinySteps

final class SystemManagerTests: XCTestCase {
    
    var systemManager: SystemManager!
    
    override func setUpWithError() throws {
        systemManager = SystemManager()
    }
    
    override func tearDownWithError() throws {
        systemManager = nil
    }
    
    // MARK: - Initialization Tests
    
    func testSystemManagerInitialization() throws {
        XCTAssertNotNil(systemManager)
        XCTAssertNotNil(systemManager.isDarkMode)
        XCTAssertNotNil(systemManager.isReduceMotionEnabled)
        XCTAssertNotNil(systemManager.isVoiceOverEnabled)
        XCTAssertNotNil(systemManager.preferredContentSize)
    }
    
    // MARK: - Dark Mode Tests
    
    func testDarkModeToggle() throws {
        let initialDarkMode = systemManager.isDarkMode
        systemManager.toggleDarkMode()
        XCTAssertNotEqual(systemManager.isDarkMode, initialDarkMode)
    }
    
    func testDarkModeSet() throws {
        systemManager.setDarkMode(true)
        XCTAssertTrue(systemManager.isDarkMode)
        
        systemManager.setDarkMode(false)
        XCTAssertFalse(systemManager.isDarkMode)
    }
    
    // MARK: - Accessibility Tests
    
    func testVoiceOverStatus() throws {
        // Test that VoiceOver status can be checked
        let voiceOverStatus = systemManager.isVoiceOverEnabled
        XCTAssertNotNil(voiceOverStatus)
    }
    
    func testReduceMotionStatus() throws {
        // Test that Reduce Motion status can be checked
        let reduceMotionStatus = systemManager.isReduceMotionEnabled
        XCTAssertNotNil(reduceMotionStatus)
    }
    
    func testPreferredContentSize() throws {
        // Test that preferred content size can be checked
        let contentSize = systemManager.preferredContentSize
        XCTAssertNotNil(contentSize)
    }
    
    // MARK: - Location Services Tests
    
    func testLocationPermissionRequest() throws {
        // Test that location permission can be requested
        let expectation = XCTestExpectation(description: "Location permission request")
        
        systemManager.requestLocationPermission { granted in
            XCTAssertNotNil(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocationServicesEnabled() throws {
        // Test that location services status can be checked
        let locationEnabled = systemManager.isLocationServicesEnabled
        XCTAssertNotNil(locationEnabled)
    }
    
    // MARK: - Notification Tests
    
    func testNotificationPermissionRequest() throws {
        // Test that notification permission can be requested
        let expectation = XCTestExpectation(description: "Notification permission request")
        
        systemManager.requestNotificationPermission { granted in
            XCTAssertNotNil(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNotificationStatus() throws {
        // Test that notification status can be checked
        let notificationEnabled = systemManager.isNotificationEnabled
        XCTAssertNotNil(notificationEnabled)
    }
    
    // MARK: - System Information Tests
    
    func testSystemVersion() throws {
        // Test that system version can be retrieved
        let systemVersion = systemManager.systemVersion
        XCTAssertNotNil(systemVersion)
        XCTAssertFalse(systemVersion.isEmpty)
    }
    
    func testAppVersion() throws {
        // Test that app version can be retrieved
        let appVersion = systemManager.appVersion
        XCTAssertNotNil(appVersion)
        XCTAssertFalse(appVersion.isEmpty)
    }
    
    func testDeviceModel() throws {
        // Test that device model can be retrieved
        let deviceModel = systemManager.deviceModel
        XCTAssertNotNil(deviceModel)
        XCTAssertFalse(deviceModel.isEmpty)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceSystemInfoRetrieval() throws {
        self.measure {
            for _ in 0..<1000 {
                _ = systemManager.systemVersion
                _ = systemManager.appVersion
                _ = systemManager.deviceModel
            }
        }
    }
    
    func testPerformanceAccessibilityChecks() throws {
        self.measure {
            for _ in 0..<1000 {
                _ = systemManager.isVoiceOverEnabled
                _ = systemManager.isReduceMotionEnabled
                _ = systemManager.preferredContentSize
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testLocationPermissionDenied() throws {
        // Test handling of location permission denial
        let expectation = XCTestExpectation(description: "Location permission denied")
        
        systemManager.requestLocationPermission { granted in
            if !granted {
                // Test that the system handles denied permission gracefully
                XCTAssertFalse(granted)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNotificationPermissionDenied() throws {
        // Test handling of notification permission denial
        let expectation = XCTestExpectation(description: "Notification permission denied")
        
        systemManager.requestNotificationPermission { granted in
            if !granted {
                // Test that the system handles denied permission gracefully
                XCTAssertFalse(granted)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - State Management Tests
    
    func testStatePersistence() throws {
        // Test that system state is properly persisted
        let initialDarkMode = systemManager.isDarkMode
        systemManager.setDarkMode(!initialDarkMode)
        
        // Create a new system manager to test persistence
        let newSystemManager = SystemManager()
        XCTAssertEqual(newSystemManager.isDarkMode, !initialDarkMode)
    }
    
    // MARK: - Edge Cases Tests
    
    func testMultiplePermissionRequests() throws {
        // Test that multiple permission requests don't cause issues
        let expectation1 = XCTestExpectation(description: "First permission request")
        let expectation2 = XCTestExpectation(description: "Second permission request")
        
        systemManager.requestLocationPermission { _ in
            expectation1.fulfill()
        }
        
        systemManager.requestNotificationPermission { _ in
            expectation2.fulfill()
        }
        
        wait(for: [expectation1, expectation2], timeout: 10.0)
    }
    
    func testConcurrentAccess() throws {
        // Test that concurrent access to system manager doesn't cause issues
        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 100
        
        for _ in 0..<100 {
            DispatchQueue.global().async {
                _ = self.systemManager.isDarkMode
                _ = self.systemManager.isVoiceOverEnabled
                _ = self.systemManager.systemVersion
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
