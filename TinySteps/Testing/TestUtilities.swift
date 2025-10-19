//
//  TestUtilities.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI

// MARK: - Test Data Factory
class TestDataFactory {
    
    // MARK: - Baby Test Data
    static func createTestBaby(
        name: String = "Test Baby",
        birthDate: Date = Date(),
        weight: Double? = 3.5,
        height: Double? = 50.0,
        gender: Baby.Gender = .boy,
        isPremature: Bool = false
    ) -> Baby {
        return Baby(
            name: name,
            birthDate: birthDate,
            weight: weight,
            height: height,
            dueDate: isPremature ? Calendar.current.date(byAdding: .day, value: 30, to: birthDate) : nil,
            gender: gender,
            photoURL: nil,
            feedingMethod: "Breastfed"
        )
    }
    
    // MARK: - Milestone Test Data
    static func createTestMilestone(
        title: String = "Test Milestone",
        description: String = "Test Description",
        category: MilestoneCategory = .physical
    ) -> Milestone {
        return Milestone(
            title: title,
            description: description,
            category: category,
            achievedDate: nil,
            expectedAge: 0,
            isAchieved: false,
            notes: nil,
            ageRange: "0-12 months",
            period: .months(0)
        )
    }
    
    // MARK: - Appointment Test Data
    static func createTestAppointment(
        title: String = "Test Appointment",
        date: Date = Date(),
        location: String = "Test Location",
        notes: String? = nil
    ) -> Appointment {
        return Appointment(
            title: title,
            date: date,
            time: "10:00 AM",
            location: location,
            notes: notes,
            type: .checkup
        )
    }
    
    // MARK: - Tracking Record Test Data
    static func createTestTrackingRecord(
        type: TrackingType = .feeding,
        value: Double = 100.0,
        unit: String = "ml",
        notes: String? = nil
    ) -> TrackingRecord {
        return TrackingRecord(
            id: UUID(),
            type: type,
            value: value,
            unit: unit,
            date: Date(),
            notes: notes
        )
    }
    
    // MARK: - Emergency Contact Test Data
    static func createTestEmergencyContact(
        name: String = "Test Contact",
        phoneNumber: String = "123-456-7890",
        relationship: String = "Doctor",
        notes: String? = nil
    ) -> EmergencyContact {
        return EmergencyContact(
            name: name,
            relationship: relationship,
            phoneNumber: phoneNumber,
            isEmergency: true,
            canPickup: true,
            notes: notes
        )
    }
}

// MARK: - Mock Data Manager
class MockBabyDataManager: BabyDataManager {
    var mockBaby: Baby?
    var mockMilestones: [Milestone] = []
    var mockAppointments: [Appointment] = []
    var mockTrackingRecords: [TrackingRecord] = []
    var mockEmergencyContacts: [EmergencyContact] = []
    
    override init() {
        super.init()
        setupMockData()
    }
    
    private func setupMockData() {
        mockBaby = TestDataFactory.createTestBaby()
        mockMilestones = [
            TestDataFactory.createTestMilestone(title: "First Smile"),
            TestDataFactory.createTestMilestone(title: "First Steps")
        ]
        mockAppointments = [
            TestDataFactory.createTestAppointment(title: "Paediatrician Visit"),
            TestDataFactory.createTestAppointment(title: "Vaccination")
        ]
        mockTrackingRecords = [
            TestDataFactory.createTestTrackingRecord(type: .feeding, value: 120.0),
            TestDataFactory.createTestTrackingRecord(type: .sleep, value: 8.0, unit: "hours")
        ]
        mockEmergencyContacts = [
            TestDataFactory.createTestEmergencyContact(name: "Dr. Smith"),
            TestDataFactory.createTestEmergencyContact(name: "NICU Nurse")
        ]
    }
    
    func saveBaby(_ baby: Baby) {
        mockBaby = baby
    }
    
    override func addMilestone(_ milestone: Milestone) {
        mockMilestones.append(milestone)
    }
    
    func updateMilestone(_ milestone: Milestone) {
        if let index = mockMilestones.firstIndex(where: { $0.id == milestone.id }) {
            mockMilestones[index] = milestone
        }
    }
    
    func deleteMilestone(_ milestone: Milestone) {
        mockMilestones.removeAll { $0.id == milestone.id }
    }
    
    override func addAppointment(_ appointment: Appointment) {
        mockAppointments.append(appointment)
    }
    
    override func updateAppointment(_ appointment: Appointment) {
        if let index = mockAppointments.firstIndex(where: { $0.id == appointment.id }) {
            mockAppointments[index] = appointment
        }
    }
    
    override func deleteAppointment(_ appointment: Appointment) {
        mockAppointments.removeAll { $0.id == appointment.id }
    }
    
    func addTrackingRecord(_ record: TrackingRecord) {
        mockTrackingRecords.append(record)
    }
    
    override func addEmergencyContact(_ contact: EmergencyContact) {
        mockEmergencyContacts.append(contact)
    }
    
    func updateEmergencyContact(_ contact: EmergencyContact) {
        if let index = mockEmergencyContacts.firstIndex(where: { $0.id == contact.id }) {
            mockEmergencyContacts[index] = contact
        }
    }
    
    func deleteEmergencyContact(_ contact: EmergencyContact) {
        mockEmergencyContacts.removeAll { $0.id == contact.id }
    }
}

// MARK: - Test Configuration
struct TestConfiguration {
    static let shared = TestConfiguration()
    
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    var testTimeout: TimeInterval {
        return 5.0
    }
    
    var mockDataEnabled: Bool {
        return isRunningTests
    }
    
    private init() {}
}

// MARK: - Test Assertions
// Note: XCTest assertions moved to test target files

// MARK: - Test Performance
class TestPerformance {
    static func measureTime<T>(_ operation: () throws -> T) rethrows -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, timeElapsed)
    }
    
    static func measureAsyncTime<T>(_ operation: () async throws -> T) async rethrows -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, timeElapsed)
    }
}

// MARK: - Test Data Cleanup
class TestDataCleanup {
    static func cleanupUserDefaults() {
        let defaults = UserDefaults.standard
        let keys = [
            "baby",
            "milestones",
            "appointments",
            "trackingRecords",
            "emergencyContacts",
            "pendingChanges"
        ]
        
        for key in keys {
            defaults.removeObject(forKey: key)
        }
    }
    
    static func cleanupFileSystem() {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            for url in contents {
                if url.pathExtension == "json" || url.pathExtension == "plist" {
                    try fileManager.removeItem(at: url)
                }
            }
        } catch {
            print("Error cleaning up file system: \(error)")
        }
    }
}

// MARK: - Test Environment
class TestEnvironment {
    static let shared = TestEnvironment()
    
    private init() {}
    
    func setup() {
        TestDataCleanup.cleanupUserDefaults()
        TestDataCleanup.cleanupFileSystem()
    }
    
    func teardown() {
        TestDataCleanup.cleanupUserDefaults()
        TestDataCleanup.cleanupFileSystem()
    }
}
