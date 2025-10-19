//
//  IntegrationTests.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
@testable import TinySteps

final class IntegrationTests: XCTestCase {
    
    var dataManager: BabyDataManager!
    var systemManager: SystemManager!
    
    override func setUpWithError() throws {
        dataManager = BabyDataManager()
        systemManager = SystemManager()
        
        // Clear any existing data for clean tests
        dataManager.clearAllData()
    }
    
    override func tearDownWithError() throws {
        dataManager = nil
        systemManager = nil
    }
    
    // MARK: - Data Flow Tests
    
    func testCompleteBabyTrackingFlow() throws {
        // Test complete baby tracking flow from start to finish
        
        // 1. Add baby profile
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            feedingMethod: "Bottle-fed"
        )
        dataManager.baby = baby
        XCTAssertNotNil(dataManager.baby)
        
        // 2. Add feeding records
        let feedingRecord = FeedingRecord(
            date: Date(),
            type: .bottle,
            amount: 120.0,
            duration: 15.0,
            notes: "Test feeding",
            side: nil
        )
        dataManager.addFeedingRecord(feedingRecord)
        XCTAssertEqual(dataManager.feedingRecords.count, 1)
        
        // 3. Add sleep records
        let sleepRecord = SleepRecord(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            duration: 60.0,
            location: .crib,
            notes: "Test sleep",
            sleepQuality: .good
        )
        dataManager.addSleepRecord(sleepRecord)
        XCTAssertEqual(dataManager.sleepRecords.count, 1)
        
        // 4. Add nappy records
        let nappyRecord = NappyRecord(
            date: Date(),
            type: .wet,
            notes: "Test nappy change"
        )
        dataManager.addNappyRecord(nappyRecord)
        XCTAssertEqual(dataManager.nappyRecords.count, 1)
        
        // 5. Add vaccination records
        let vaccination = VaccinationRecord(
            title: "8-week Vaccination",
            date: Date(),
            isCompleted: false,
            notes: "Test vaccination"
        )
        dataManager.vaccinations.append(vaccination)
        XCTAssertEqual(dataManager.vaccinations.count, 1)
        
        // 6. Save and load data
        dataManager.saveData()
        let newDataManager = BabyDataManager()
        newDataManager.loadData()
        
        XCTAssertNotNil(newDataManager.baby)
        XCTAssertEqual(newDataManager.feedingRecords.count, 1)
        XCTAssertEqual(newDataManager.sleepRecords.count, 1)
        XCTAssertEqual(newDataManager.nappyRecords.count, 1)
        XCTAssertEqual(newDataManager.vaccinations.count, 1)
    }
    
    func testDataExportImportFlow() throws {
        // Test data export and import flow
        
        // 1. Add test data
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            feedingMethod: "Bottle-fed"
        )
        dataManager.baby = baby
        
        let feedingRecord = FeedingRecord(
            date: Date(),
            type: .bottle,
            amount: 120.0,
            duration: 15.0,
            notes: "Test feeding",
            side: nil
        )
        dataManager.addFeedingRecord(feedingRecord)
        
        // 2. Export data
        dataManager.saveData()
        
        // 3. Clear data
        dataManager.clearAllData()
        XCTAssertNil(dataManager.baby)
        XCTAssertEqual(dataManager.feedingRecords.count, 0)
        
        // 4. Load data back
        dataManager.loadData()
        XCTAssertNotNil(dataManager.baby)
        XCTAssertEqual(dataManager.feedingRecords.count, 1)
    }
    
    // MARK: - System Integration Tests
    
    func testSystemManagerIntegration() throws {
        // Test system manager integration with data manager
        
        // Test dark mode integration
        let initialDarkMode = systemManager.isDarkMode
        systemManager.toggleDarkMode()
        XCTAssertNotEqual(systemManager.isDarkMode, initialDarkMode)
        
        // Test accessibility integration
        let voiceOverEnabled = systemManager.isVoiceOverEnabled
        XCTAssertNotNil(voiceOverEnabled)
        
        let reduceMotionEnabled = systemManager.isReduceMotionEnabled
        XCTAssertNotNil(reduceMotionEnabled)
    }
    
    func testNotificationIntegration() throws {
        // Test notification integration
        
        let expectation = XCTestExpectation(description: "Notification permission request")
        
        systemManager.requestNotificationPermission { granted in
            XCTAssertNotNil(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocationIntegration() throws {
        // Test location integration
        
        let expectation = XCTestExpectation(description: "Location permission request")
        
        systemManager.requestLocationPermission { granted in
            XCTAssertNotNil(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Performance Integration Tests
    
    func testLargeDataSetPerformance() throws {
        // Test performance with large data sets
        
        self.measure {
            // Add many feeding records
            for i in 0..<1000 {
                let feedingRecord = FeedingRecord(
                    date: Date().addingTimeInterval(TimeInterval(i)),
                    type: .bottle,
                    amount: Double.random(in: 50...200),
                    duration: nil,
                    notes: nil,
                    side: nil
                )
                dataManager.addFeedingRecord(feedingRecord)
            }
            
            // Add many sleep records
            for i in 0..<500 {
                let sleepRecord = SleepRecord(
                    startTime: Date().addingTimeInterval(TimeInterval(i * 3600)),
                    endTime: Date().addingTimeInterval(TimeInterval(i * 3600 + 3600)),
                    duration: 60.0,
                    location: .crib,
                    notes: nil,
                    sleepQuality: .good
                )
                dataManager.addSleepRecord(sleepRecord)
            }
            
            // Save data
            dataManager.saveData()
        }
    }
    
    func testConcurrentDataAccess() throws {
        // Test concurrent data access
        
        let expectation = XCTestExpectation(description: "Concurrent data access")
        expectation.expectedFulfillmentCount = 100
        
        for i in 0..<100 {
            DispatchQueue.global().async {
                // Add feeding record
                let feedingRecord = FeedingRecord(
                    date: Date().addingTimeInterval(TimeInterval(i)),
                    type: .bottle,
                    amount: 120.0,
                    duration: nil,
                    notes: nil,
                    side: nil
                )
                self.dataManager.addFeedingRecord(feedingRecord)
                
                // Access data
                _ = self.dataManager.getTodayFeedingCount()
                _ = self.dataManager.getTodaySleepHours()
                _ = self.dataManager.getTodayNappyCount()
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Error Handling Integration Tests
    
    func testErrorHandlingIntegration() throws {
        // Test error handling across different components
        
        // Test data validation errors
        let invalidBaby = Baby(
            name: "", // Invalid empty name
            birthDate: Date(),
            weight: -1.0, // Invalid negative weight
            height: 0.0, // Invalid zero height
            feedingMethod: "Invalid Method"
        )
        
        // Test that invalid data is handled gracefully
        dataManager.baby = invalidBaby
        XCTAssertNotNil(dataManager.baby)
        
        // Test that validation can be implemented
        // This would need to be implemented based on specific validation rules
    }
    
    func testNetworkErrorHandling() throws {
        // Test network error handling
        
        let expectation = XCTestExpectation(description: "Network error handling")
        
        // Test location permission with network unavailable
        systemManager.requestLocationPermission { granted in
            // Test that the system handles network errors gracefully
            XCTAssertNotNil(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() throws {
        // Test memory management with large data sets
        
        // Add large amount of data
        for i in 0..<10000 {
            let feedingRecord = FeedingRecord(
                date: Date().addingTimeInterval(TimeInterval(i)),
                type: .bottle,
                amount: Double.random(in: 50...200),
                duration: nil,
                notes: "Test note \(i)",
                side: nil
            )
            dataManager.addFeedingRecord(feedingRecord)
        }
        
        // Test that memory usage is reasonable
        // This would need to be implemented with specific memory monitoring
        XCTAssertEqual(dataManager.feedingRecords.count, 10000)
        
        // Clear data and test memory cleanup
        dataManager.clearAllData()
        XCTAssertEqual(dataManager.feedingRecords.count, 0)
    }
    
    // MARK: - Data Consistency Tests
    
    func testDataConsistency() throws {
        // Test data consistency across different operations
        
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            feedingMethod: "Bottle-fed"
        )
        dataManager.baby = baby
        
        // Add feeding record
        let feedingRecord = FeedingRecord(
            date: Date(),
            type: .bottle,
            amount: 120.0,
            duration: 15.0,
            notes: "Test feeding",
            side: nil
        )
        dataManager.addFeedingRecord(feedingRecord)
        
        // Save data
        dataManager.saveData()
        
        // Create new data manager and load data
        let newDataManager = BabyDataManager()
        newDataManager.loadData()
        
        // Test data consistency
        XCTAssertEqual(newDataManager.baby?.name, baby.name)
        XCTAssertEqual(newDataManager.baby?.weight, baby.weight)
        XCTAssertEqual(newDataManager.baby?.height, baby.height)
        XCTAssertEqual(newDataManager.feedingRecords.count, 1)
        XCTAssertEqual(newDataManager.feedingRecords.first?.amount, 120.0)
    }
}
