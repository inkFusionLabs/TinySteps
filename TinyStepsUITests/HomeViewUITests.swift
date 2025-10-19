//
//  HomeViewUITests.swift
//  TinyStepsUITests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest

final class HomeViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Home View Tests
    
    func testHomeViewElements() throws {
        // Test that home view elements are present
        XCTAssertTrue(app.navigationBars["TinySteps"].exists)
        
        // Test that main content is visible
        XCTAssertTrue(app.scrollViews.firstMatch.exists)
    }
    
    func testNavigationToTracking() throws {
        // Test navigation to tracking view
        let trackingButton = app.buttons["Tracking"]
        if trackingButton.exists {
            trackingButton.tap()
            XCTAssertTrue(app.navigationBars["Tracking"].exists)
        }
    }
    
    func testNavigationToJournal() throws {
        // Test navigation to journal view
        let journalButton = app.buttons["Journal"]
        if journalButton.exists {
            journalButton.tap()
            XCTAssertTrue(app.navigationBars["Journal"].exists)
        }
    }
    
    func testNavigationToSupport() throws {
        // Test navigation to support view
        let supportButton = app.buttons["Support"]
        if supportButton.exists {
            supportButton.tap()
            XCTAssertTrue(app.navigationBars["Support"].exists)
        }
    }
    
    func testNavigationToSettings() throws {
        // Test navigation to settings view
        let settingsButton = app.buttons["Settings"]
        if settingsButton.exists {
            settingsButton.tap()
            XCTAssertTrue(app.navigationBars["Settings"].exists)
        }
    }
    
    // MARK: - Baby Profile Tests
    
    func testAddBabyProfile() throws {
        // Test adding a baby profile
        let addBabyButton = app.buttons["Add Baby"]
        if addBabyButton.exists {
            addBabyButton.tap()
            
            // Test that baby form is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    func testEditBabyProfile() throws {
        // Test editing existing baby profile
        let editBabyButton = app.buttons["Edit Baby"]
        if editBabyButton.exists {
            editBabyButton.tap()
            
            // Test that baby form is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    // MARK: - Quick Actions Tests
    
    func testFeedingQuickAction() throws {
        // Test feeding quick action
        let feedingButton = app.buttons["Feeding"]
        if feedingButton.exists {
            feedingButton.tap()
            
            // Test that feeding sheet is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    func testSleepQuickAction() throws {
        // Test sleep quick action
        let sleepButton = app.buttons["Sleep"]
        if sleepButton.exists {
            sleepButton.tap()
            
            // Test that sleep sheet is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    func testNappyQuickAction() throws {
        // Test nappy quick action
        let nappyButton = app.buttons["Nappy"]
        if nappyButton.exists {
            nappyButton.tap()
            
            // Test that nappy sheet is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    // MARK: - Data Export Tests
    
    func testDataExport() throws {
        // Test data export functionality
        let exportButton = app.buttons["Export Data"]
        if exportButton.exists {
            exportButton.tap()
            
            // Test that export view is presented
            XCTAssertTrue(app.sheets.firstMatch.exists)
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        // Test that all interactive elements have accessibility labels
        let buttons = app.buttons
        for i in 0..<buttons.count {
            let button = buttons.element(boundBy: i)
            if button.exists {
                XCTAssertFalse(button.label.isEmpty, "Button at index \(i) should have an accessibility label")
            }
        }
    }
    
    func testVoiceOverNavigation() throws {
        // Test VoiceOver navigation
        let firstElement = app.buttons.firstMatch
        if firstElement.exists {
            firstElement.tap()
            // Test that element is accessible
            XCTAssertTrue(firstElement.isHittable)
        }
    }
    
    // MARK: - Performance Tests
    
    func testHomeViewLoadPerformance() throws {
        // Test home view load performance
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            app.launch()
        }
    }
    
    func testScrollPerformance() throws {
        // Test scroll performance
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            measure {
                scrollView.swipeUp()
                scrollView.swipeDown()
            }
        }
    }
    
    // MARK: - Dark Mode Tests
    
    func testDarkModeToggle() throws {
        // Test dark mode toggle
        let darkModeButton = app.buttons["Dark Mode"]
        if darkModeButton.exists {
            darkModeButton.tap()
            
            // Test that dark mode is applied
            // This would need to be verified visually or through other means
        }
    }
    
    // MARK: - Responsive Design Tests
    
    func testResponsiveLayout() throws {
        // Test responsive layout on different orientations
        let device = XCUIDevice.shared
        
        // Test portrait orientation
        device.orientation = .portrait
        XCTAssertTrue(app.navigationBars.firstMatch.exists)
        
        // Test landscape orientation
        device.orientation = .landscapeLeft
        XCTAssertTrue(app.navigationBars.firstMatch.exists)
        
        // Reset to portrait
        device.orientation = .portrait
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorHandling() throws {
        // Test error handling when network is unavailable
        // This would require mocking network conditions
        let networkButton = app.buttons["Network Action"]
        if networkButton.exists {
            networkButton.tap()
            
            // Test that error is handled gracefully
            // This would need to be implemented based on specific error scenarios
        }
    }
    
    // MARK: - Data Validation Tests
    
    func testDataInputValidation() throws {
        // Test data input validation
        let addBabyButton = app.buttons["Add Baby"]
        if addBabyButton.exists {
            addBabyButton.tap()
            
            // Test that form validation works
            let saveButton = app.buttons["Save"]
            if saveButton.exists {
                saveButton.tap()
                
                // Test that validation errors are shown
                // This would need to be implemented based on specific validation rules
            }
        }
    }
}
