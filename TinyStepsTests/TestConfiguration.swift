//
//  TestConfiguration.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
@testable import TinySteps

class TestConfiguration {
    
    // MARK: - Test Data Factory
    
    static func createTestBaby() -> Baby {
        return Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            gender: .boy,
            feedingMethod: "Bottle-fed"
        )
    }
    
    static func createTestFeedingRecord() -> FeedingRecord {
        return FeedingRecord(
            date: Date(),
            type: .bottle,
            amount: 120.0,
            duration: 15.0,
            notes: "Test feeding",
            side: nil
        )
    }
    
    static func createTestSleepRecord() -> SleepRecord {
        return SleepRecord(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            duration: 60.0,
            location: .crib,
            notes: "Test sleep",
            sleepQuality: .good
        )
    }
    
    static func createTestNappyRecord() -> NappyRecord {
        return NappyRecord(
            date: Date(),
            type: .wet,
            notes: "Test nappy change"
        )
    }
    
    static func createTestVaccinationRecord() -> VaccinationRecord {
        return VaccinationRecord(
            title: "8-week Vaccination",
            date: Date(),
            isCompleted: false,
            notes: "Test vaccination"
        )
    }
    
    // MARK: - Test Setup Helpers
    
    static func setupTestDataManager() -> BabyDataManager {
        let dataManager = BabyDataManager()
        dataManager.clearAllData()
        return dataManager
    }
    
    static func setupTestSystemManager() -> SystemManager {
        return SystemManager()
    }
    
    // MARK: - Test Assertions
    
    static func assertBabyData(_ baby: Baby?, expectedName: String, expectedWeight: Double, expectedHeight: Double) {
        XCTAssertNotNil(baby)
        XCTAssertEqual(baby?.name, expectedName)
        XCTAssertEqual(baby?.weight, expectedWeight)
        XCTAssertEqual(baby?.height, expectedHeight)
    }
    
    static func assertFeedingRecord(_ record: FeedingRecord?, expectedType: FeedingRecord.FeedingType, expectedAmount: Double) {
        XCTAssertNotNil(record)
        XCTAssertEqual(record?.type, expectedType)
        XCTAssertEqual(record?.amount, expectedAmount)
    }
    
    static func assertSleepRecord(_ record: SleepRecord?, expectedLocation: SleepRecord.SleepLocation, expectedQuality: SleepRecord.SleepQuality) {
        XCTAssertNotNil(record)
        XCTAssertEqual(record?.location, expectedLocation)
        XCTAssertEqual(record?.sleepQuality, expectedQuality)
    }
    
    // MARK: - Performance Test Helpers
    
    static func measurePerformance<T>(_ operation: () throws -> T) -> T {
        var result: T!
        let startTime = Date()
        do {
            result = try operation()
        } catch {
            fatalError("Performance test failed: \(error)")
        }
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        print("Performance test took \(duration) seconds")
        return result
    }
    
    // MARK: - Mock Data Helpers
    
    static func createMockFeedingRecords(count: Int) -> [FeedingRecord] {
        var records: [FeedingRecord] = []
        for i in 0..<count {
            let record = FeedingRecord(
                date: Date().addingTimeInterval(TimeInterval(i * 3600)),
                type: .bottle,
                amount: Double.random(in: 50...200),
                duration: Double.random(in: 10...30),
                notes: "Mock feeding \(i)",
                side: nil
            )
            records.append(record)
        }
        return records
    }
    
    static func createMockSleepRecords(count: Int) -> [SleepRecord] {
        var records: [SleepRecord] = []
        for i in 0..<count {
            let startTime = Date().addingTimeInterval(TimeInterval(i * 3600))
            let endTime = startTime.addingTimeInterval(3600) // 1 hour later
            let record = SleepRecord(
                startTime: startTime,
                endTime: endTime,
                duration: 60.0,
                location: .crib,
                notes: "Mock sleep \(i)",
                sleepQuality: .good
            )
            records.append(record)
        }
        return records
    }
    
    static func createMockNappyRecords(count: Int) -> [NappyRecord] {
        var records: [NappyRecord] = []
        for i in 0..<count {
            let record = NappyRecord(
                date: Date().addingTimeInterval(TimeInterval(i * 1800)), // Every 30 minutes
                type: i % 2 == 0 ? .wet : .dirty,
                notes: "Mock nappy \(i)"
            )
            records.append(record)
        }
        return records
    }
    
    // MARK: - Test Environment Helpers
    
    static func setupTestEnvironment() {
        // Set up test environment variables
        UserDefaults.standard.set(true, forKey: "isTestEnvironment")
    }
    
    static func cleanupTestEnvironment() {
        // Clean up test environment
        UserDefaults.standard.removeObject(forKey: "isTestEnvironment")
    }
    
    // MARK: - Test Validation Helpers
    
    static func validateDataIntegrity(_ dataManager: BabyDataManager) {
        // Validate that data manager has consistent state
        XCTAssertNotNil(dataManager.baby)
        XCTAssertGreaterThanOrEqual(dataManager.feedingRecords.count, 0)
        XCTAssertGreaterThanOrEqual(dataManager.sleepRecords.count, 0)
        XCTAssertGreaterThanOrEqual(dataManager.nappyRecords.count, 0)
        XCTAssertGreaterThanOrEqual(dataManager.vaccinations.count, 0)
    }
    
    static func validateSystemManagerState(_ systemManager: SystemManager) {
        // Validate that system manager has consistent state
        XCTAssertNotNil(systemManager.isDarkMode)
        XCTAssertNotNil(systemManager.isVoiceOverEnabled)
        XCTAssertNotNil(systemManager.isReduceMotionEnabled)
        XCTAssertNotNil(systemManager.preferredContentSize)
        XCTAssertNotNil(systemManager.systemVersion)
        XCTAssertNotNil(systemManager.appVersion)
        XCTAssertNotNil(systemManager.deviceModel)
    }
}
