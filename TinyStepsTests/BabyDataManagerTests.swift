//
//  BabyDataManagerTests.swift
//  TinyStepsTests
//
//  Created by inkFusionLabs on 20/09/2025.
//

import XCTest
@testable import TinySteps

final class BabyDataManagerTests: XCTestCase {
    
    var dataManager: BabyDataManager!
    
    override func setUpWithError() throws {
        dataManager = BabyDataManager()
        // Clear any existing data for clean tests
        dataManager.clearAllData()
    }
    
    override func tearDownWithError() throws {
        dataManager = nil
    }
    
    // MARK: - Baby Data Tests
    
    func testAddBaby() throws {
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            gender: .boy,
            feedingMethod: "Bottle-fed"
        )
        
        dataManager.baby = baby
        
        XCTAssertNotNil(dataManager.baby)
        XCTAssertEqual(dataManager.baby?.name, "Test Baby")
        XCTAssertEqual(dataManager.baby?.weight, 3.5)
        XCTAssertEqual(dataManager.baby?.height, 50.0)
    }
    
    func testUpdateBaby() throws {
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            gender: .boy,
            feedingMethod: "Bottle-fed"
        )
        
        dataManager.baby = baby
        
        var updatedBaby = baby
        updatedBaby.weight = 4.0
        updatedBaby.height = 55.0
        
        dataManager.baby = updatedBaby
        
        XCTAssertEqual(dataManager.baby?.weight, 4.0)
        XCTAssertEqual(dataManager.baby?.height, 55.0)
    }
    
    // MARK: - Feeding Records Tests
    
    func testAddFeedingRecord() throws {
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
        XCTAssertEqual(dataManager.feedingRecords.first?.type, .bottle)
        XCTAssertEqual(dataManager.feedingRecords.first?.amount, 120.0)
    }
    
    func testGetTodayFeedingCount() throws {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        // Add feeding records for today and yesterday
        let todayFeeding = FeedingRecord(
            date: today,
            type: .bottle,
            amount: 120.0,
            duration: nil,
            notes: nil,
            side: nil
        )
        
        let yesterdayFeeding = FeedingRecord(
            date: yesterday,
            type: .bottle,
            amount: 100.0,
            duration: nil,
            notes: nil,
            side: nil
        )
        
        dataManager.addFeedingRecord(todayFeeding)
        dataManager.addFeedingRecord(yesterdayFeeding)
        
        let todayCount = dataManager.getTodayFeedingCount()
        XCTAssertEqual(todayCount, 1)
    }
    
    // MARK: - Sleep Records Tests
    
    func testAddSleepRecord() throws {
        let sleepRecord = SleepRecord(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600), // 1 hour later
            duration: 60.0,
            location: .crib,
            notes: "Test sleep",
            sleepQuality: .good
        )
        
        dataManager.addSleepRecord(sleepRecord)
        
        XCTAssertEqual(dataManager.sleepRecords.count, 1)
        XCTAssertEqual(dataManager.sleepRecords.first?.location, .crib)
        XCTAssertEqual(dataManager.sleepRecords.first?.sleepQuality, .good)
    }
    
    func testGetTodaySleepHours() throws {
        let today = Date()
        let startTime = today
        let endTime = today.addingTimeInterval(3600) // 1 hour later
        
        let sleepRecord = SleepRecord(
            startTime: startTime,
            endTime: endTime,
            duration: 60.0,
            location: .crib,
            notes: nil,
            sleepQuality: .good
        )
        
        dataManager.addSleepRecord(sleepRecord)
        
        let todaySleepHours = dataManager.getTodaySleepHours()
        XCTAssertEqual(todaySleepHours, 1.0, accuracy: 0.1)
    }
    
    // MARK: - Nappy Records Tests
    
    func testAddNappyRecord() throws {
        let nappyRecord = NappyRecord(
            date: Date(),
            type: .wet,
            notes: "Test nappy change"
        )
        
        dataManager.addNappyRecord(nappyRecord)
        
        XCTAssertEqual(dataManager.nappyRecords.count, 1)
        XCTAssertEqual(dataManager.nappyRecords.first?.type, .wet)
    }
    
    func testGetTodayNappyCount() throws {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        // Add nappy records for today and yesterday
        let todayNappy = NappyRecord(
            date: today,
            type: .wet,
            notes: nil
        )
        
        let yesterdayNappy = NappyRecord(
            date: yesterday,
            type: .dirty,
            notes: nil
        )
        
        dataManager.addNappyRecord(todayNappy)
        dataManager.addNappyRecord(yesterdayNappy)
        
        let todayCount = dataManager.getTodayNappyCount()
        XCTAssertEqual(todayCount, 1)
    }
    
    // MARK: - Vaccination Records Tests
    
    func testAddVaccinationRecord() throws {
        let vaccination = VaccinationRecord(
            title: "8-week Vaccination",
            date: Date(),
            isCompleted: false,
            notes: "Test vaccination"
        )
        
        dataManager.vaccinations.append(vaccination)
        
        XCTAssertEqual(dataManager.vaccinations.count, 1)
        XCTAssertEqual(dataManager.vaccinations.first?.title, "8-week Vaccination")
        XCTAssertFalse(dataManager.vaccinations.first?.isCompleted ?? true)
    }
    
    // MARK: - Data Persistence Tests
    
    func testSaveAndLoadData() throws {
        let baby = Baby(
            name: "Test Baby",
            birthDate: Date(),
            weight: 3.5,
            height: 50.0,
            gender: .boy,
            feedingMethod: "Bottle-fed"
        )
        
        dataManager.baby = baby
        dataManager.saveData()
        
        // Create a new data manager to test loading (loadData is called automatically in init)
        let newDataManager = BabyDataManager()
        
        XCTAssertNotNil(newDataManager.baby)
        XCTAssertEqual(newDataManager.baby?.name, "Test Baby")
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceAddManyFeedingRecords() throws {
        self.measure {
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
        }
    }
    
    func testPerformanceGetTodayFeedingCount() throws {
        // Add many feeding records
        for i in 0..<1000 {
            let feedingRecord = FeedingRecord(
                date: Date().addingTimeInterval(TimeInterval(i)),
                type: .bottle,
                amount: 120.0,
                duration: nil,
                notes: nil,
                side: nil
            )
            dataManager.addFeedingRecord(feedingRecord)
        }
        
        self.measure {
            _ = dataManager.getTodayFeedingCount()
        }
    }
}
