//
//  DataPersistenceManager.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import Foundation
import SwiftUI

class DataPersistenceManager: ObservableObject {
    static let shared = DataPersistenceManager()
    
    @Published var journalEntries: [JournalEntry] = []
    @Published var progressEntries: [ProgressEntry] = []
    @Published var memoryItems: [MemoryItem] = []
    @Published var userPreferences: UserPreferences = UserPreferences()
    @Published var nurseShifts: [NurseShiftRecord] = []
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadData()
    }
    
    // MARK: - Journal Entries
    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.append(entry)
        saveJournalEntries()
    }
    
    func updateJournalEntry(_ entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index] = entry
            saveJournalEntries()
        }
    }
    
    func deleteJournalEntry(_ entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
        saveJournalEntries()
    }
    
    private func saveJournalEntries() {
        if let data = try? JSONEncoder().encode(journalEntries) {
            userDefaults.set(data, forKey: "journalEntries")
        }
    }
    
    private func loadJournalEntries() {
        if let data = userDefaults.data(forKey: "journalEntries"),
           let entries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            journalEntries = entries
        } else {
            // Load sample data if no saved data
            journalEntries = sampleJournalEntries
        }
    }
    
    // MARK: - Progress Entries
    func addProgressEntry(_ entry: ProgressEntry) {
        progressEntries.append(entry)
        saveProgressEntries()
    }
    
    func updateProgressEntry(_ entry: ProgressEntry) {
        if let index = progressEntries.firstIndex(where: { $0.id == entry.id }) {
            progressEntries[index] = entry
            saveProgressEntries()
        }
    }
    
    func deleteProgressEntry(_ entry: ProgressEntry) {
        progressEntries.removeAll { $0.id == entry.id }
        saveProgressEntries()
    }
    
    private func saveProgressEntries() {
        if let data = try? JSONEncoder().encode(progressEntries) {
            userDefaults.set(data, forKey: "progressEntries")
        }
    }
    
    private func loadProgressEntries() {
        if let data = userDefaults.data(forKey: "progressEntries"),
           let entries = try? JSONDecoder().decode([ProgressEntry].self, from: data) {
            progressEntries = entries
        } else {
            // Load sample data if no saved data
            progressEntries = sampleProgressEntries
        }
    }
    
    // MARK: - Memory Items
    func addMemoryItem(_ item: MemoryItem) {
        memoryItems.append(item)
        saveMemoryItems()
    }
    
    func updateMemoryItem(_ item: MemoryItem) {
        if let index = memoryItems.firstIndex(where: { $0.id == item.id }) {
            memoryItems[index] = item
            saveMemoryItems()
        }
    }
    
    func deleteMemoryItem(_ item: MemoryItem) {
        memoryItems.removeAll { $0.id == item.id }
        saveMemoryItems()
    }
    
    private func saveMemoryItems() {
        if let data = try? JSONEncoder().encode(memoryItems) {
            userDefaults.set(data, forKey: "memoryItems")
        }
    }
    
    private func loadMemoryItems() {
        if let data = userDefaults.data(forKey: "memoryItems"),
           let items = try? JSONDecoder().decode([MemoryItem].self, from: data) {
            memoryItems = items
        } else {
            // Load sample data if no saved data
            memoryItems = sampleMemoryItems
        }
    }
    
    // MARK: - User Preferences
    func updateUserPreferences(_ preferences: UserPreferences) {
        userPreferences = preferences
        saveUserPreferences()
    }
    
    private func saveUserPreferences() {
        if let data = try? JSONEncoder().encode(userPreferences) {
            userDefaults.set(data, forKey: "userPreferences")
        }
    }
    
    private func loadUserPreferences() {
        if let data = userDefaults.data(forKey: "userPreferences"),
           let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            userPreferences = preferences
        } else {
            userPreferences = UserPreferences()
        }
    }
    
    // MARK: - Nurse Shifts
    func addNurseShift(_ record: NurseShiftRecord) {
        nurseShifts.append(record)
        saveNurseShifts()
        objectWillChange.send()
    }
    
    func deleteNurseShift(atOffsets offsets: IndexSet) {
        nurseShifts.remove(atOffsets: offsets)
        saveNurseShifts()
        objectWillChange.send()
    }
    
    private func saveNurseShifts() {
        if let data = try? JSONEncoder().encode(nurseShifts) {
            userDefaults.set(data, forKey: "nurseShifts")
        }
    }
    
    private func loadNurseShifts() {
        if let data = userDefaults.data(forKey: "nurseShifts"),
           let shifts = try? JSONDecoder().decode([NurseShiftRecord].self, from: data) {
            nurseShifts = shifts
        }
    }
    
    // MARK: - Load All Data
    private func loadData() {
        loadJournalEntries()
        loadProgressEntries()
        loadMemoryItems()
        loadUserPreferences()
        loadNurseShifts()
    }
    
    // MARK: - Export Data
    func exportJournalEntries() -> Data? {
        return try? JSONEncoder().encode(journalEntries)
    }
    
    func exportProgressEntries() -> Data? {
        return try? JSONEncoder().encode(progressEntries)
    }
    
    func exportAllData() -> Data? {
        let exportData = ExportData(
            journalEntries: journalEntries,
            progressEntries: progressEntries,
            memoryItems: memoryItems,
            exportDate: Date()
        )
        return try? JSONEncoder().encode(exportData)
    }
}

// MARK: - Data Models
struct ProgressEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var weight: Double?
    var breathingSupport: String
    var feedingMethod: String
    var temperature: Double?
    var notes: String
    var milestones: [String]
    
    init(date: Date = Date(), weight: Double? = nil, breathingSupport: String = "Room Air", feedingMethod: String = "Tube", temperature: Double? = nil, notes: String = "", milestones: [String] = []) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.breathingSupport = breathingSupport
        self.feedingMethod = feedingMethod
        self.temperature = temperature
        self.notes = notes
        self.milestones = milestones
    }
}

struct UserPreferences: Codable {
    var babyName: String = ""
    var birthDate: Date = Date()
    var dueDate: Date = Date()
    var nicuAdmissionDate: Date = Date()
    var preferredTheme: String = "organic"
    var dailyRemindersEnabled: Bool = true
    var reminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    var notificationsEnabled: Bool = true
    var exportFormat: String = "json"
}

struct ExportData: Codable {
    let journalEntries: [JournalEntry]
    let progressEntries: [ProgressEntry]
    let memoryItems: [MemoryItem]
    let exportDate: Date
    var appVersion: String = "1.0.0"
}

// MARK: - Nurse Shift Model
struct NurseShiftRecord: Identifiable, Codable {
    var id = UUID()
    var nurseName: String
    var date: Date
    var notes: String?
    
    init(nurseName: String, date: Date = Date(), notes: String? = nil) {
        self.id = UUID()
        self.nurseName = nurseName
        self.date = date
        self.notes = notes
    }
}

// MARK: - Sample Data
private let sampleJournalEntries = [
    JournalEntry(
        title: "A Challenging Day",
        content: "Today was tough. Baby had a desat episode, and it really scared me. The nurses were amazing, but it's hard not to feel helpless.",
        date: Calendar.current.date(byAdding: .hour, value: -3, to: Date()) ?? Date(),
        mood: .worried,
        tags: [.worries, .family]
    ),
    JournalEntry(
        title: "Tiny Fingers, Big Hope",
        content: "Baby squeezed my finger today! It was just for a second, but it felt like the most incredible thing. So much love for this little fighter.",
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        mood: .hopeful,
        tags: [.milestones, .gratitude]
    )
]

private let sampleProgressEntries = [
    ProgressEntry(
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        weight: 1.2,
        breathingSupport: "Room Air",
        feedingMethod: "Tube + Bottle",
        temperature: 36.8,
        notes: "Great progress today! Baby is responding well to bottle feeding.",
        milestones: ["First bottle feed", "Weight gain"]
    ),
    ProgressEntry(
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        weight: 1.19,
        breathingSupport: "Oxygen 1L",
        feedingMethod: "Tube only",
        temperature: 36.6,
        notes: "Stable day, working on feeding tolerance.",
        milestones: ["Stable breathing"]
    )
]

private let sampleMemoryItems = [
    MemoryItem(
        title: "First Touch",
        description: "The first time you held your baby's tiny hand through the incubator opening.",
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
        icon: "hand.point.up.left.fill",
        color: .pink
    ),
    MemoryItem(
        title: "First Smile",
        description: "That moment when your baby opened their eyes and seemed to look right at you.",
        date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
        icon: "face.smiling.fill",
        color: .yellow
    )
]
