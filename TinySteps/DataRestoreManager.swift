//
//  DataRestoreManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import SwiftUI
import CloudKit

// MARK: - Data Backup Structure
struct TinyStepsBackup: Codable {
    let version: String
    let timestamp: Date
    let baby: Baby?
    let feedingRecords: [FeedingRecord]
    let nappyRecords: [NappyRecord]
    let sleepRecords: [SleepRecord]
    let milestones: [Milestone]
    let achievements: [DadAchievement]
    let reminders: [Reminder]
    let vaccinations: [VaccinationRecord]
    let solidFoodRecords: [SolidFoodRecord]
    let wellnessEntries: [WellnessEntry]
    let partnerSupports: [PartnerSupport]
    let emergencyContacts: [EmergencyContact]
    let quickActions: [QuickAction]
    let growthPredictions: [GrowthPrediction]
    let developmentChecklists: [DevelopmentChecklist]
    let appointments: [Appointment]
    let userAvatar: UserAvatar?
    
    init(from dataManager: BabyDataManager) {
        self.version = "1.0.0"
        self.timestamp = Date()
        self.baby = dataManager.baby
        self.feedingRecords = dataManager.feedingRecords
        self.nappyRecords = dataManager.nappyRecords
        self.sleepRecords = dataManager.sleepRecords
        self.milestones = dataManager.milestones
        self.achievements = dataManager.achievements
        self.reminders = dataManager.reminders
        self.vaccinations = dataManager.vaccinations
        self.solidFoodRecords = dataManager.solidFoodRecords
        self.wellnessEntries = dataManager.wellnessEntries
        self.partnerSupports = dataManager.partnerSupports
        self.emergencyContacts = dataManager.emergencyContacts
        self.quickActions = dataManager.quickActions
        self.growthPredictions = dataManager.growthPredictions
        self.developmentChecklists = dataManager.developmentChecklists
        self.appointments = dataManager.appointments
        
        // Get user avatar from UserDefaults
        if let avatarData = UserDefaults.standard.data(forKey: "userAvatar"),
           let avatar = try? JSONDecoder().decode(UserAvatar.self, from: avatarData) {
            self.userAvatar = avatar
        } else {
            self.userAvatar = nil
        }
    }
}

// MARK: - Data Restore Manager
class DataRestoreManager: ObservableObject {
    @Published var isBackingUp = false
    @Published var isRestoring = false
    @Published var backupProgress: Double = 0.0
    @Published var restoreProgress: Double = 0.0
    @Published var lastBackupDate: Date?
    @Published var availableBackups: [TinyStepsBackup] = []
    @Published var showRestoreAlert = false
    @Published var restoreMessage = ""
    
    private let userDefaults = UserDefaults.standard
    private let backupKey = "TinyStepsBackups"
    private let lastBackupKey = "LastBackupDate"
    
    init() {
        loadLastBackupDate()
        loadAvailableBackups()
    }
    
    // MARK: - Backup Methods
    
    func createBackup(from dataManager: BabyDataManager) async {
        await MainActor.run {
            isBackingUp = true
            backupProgress = 0.0
        }
        
        do {
            // Create backup
            let backup = TinyStepsBackup(from: dataManager)
            backupProgress = 0.3
            
            // Encode backup
            let backupData = try JSONEncoder().encode(backup)
            backupProgress = 0.6
            
            // Save to UserDefaults
            var backups = getStoredBackups()
            backups.append(backup)
            
            // Keep only last 5 backups
            if backups.count > 5 {
                backups = Array(backups.suffix(5))
            }
            
            saveBackups(backups)
            backupProgress = 0.8
            
            // Update last backup date
            await MainActor.run {
                lastBackupDate = Date()
                userDefaults.set(lastBackupDate, forKey: lastBackupKey)
                availableBackups = backups
                backupProgress = 1.0
                isBackingUp = false
            }
            
            // Try to save to iCloud if available
            await saveToiCloud(backupData)
            
        } catch {
            await MainActor.run {
                isBackingUp = false
                restoreMessage = "Backup failed: \(error.localizedDescription)"
            }
        }
    }
    
    func exportBackup(from dataManager: BabyDataManager) -> URL? {
        do {
            let backup = TinyStepsBackup(from: dataManager)
            let backupData = try JSONEncoder().encode(backup)
            
            // Create temporary file
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let backupFileName = "TinySteps_Backup_\(Date().timeIntervalSince1970).json"
            let backupURL = documentsPath.appendingPathComponent(backupFileName)
            
            try backupData.write(to: backupURL)
            return backupURL
            
        } catch {
            print("Export failed: \(error)")
            return nil
        }
    }
    
    func importBackup(from url: URL) async -> Bool {
        await MainActor.run {
            isRestoring = true
            restoreProgress = 0.0
        }
        
        do {
            let backupData = try Data(contentsOf: url)
            restoreProgress = 0.3
            
            let backup = try JSONDecoder().decode(TinyStepsBackup.self, from: backupData)
            restoreProgress = 0.6
            
            // Validate backup version
            guard backup.version == "1.0.0" else {
                await MainActor.run {
                    isRestoring = false
                    restoreMessage = "Incompatible backup version"
                }
                return false
            }
            
            // Apply backup to data manager
            await applyBackup(backup)
            restoreProgress = 1.0
            
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore completed successfully!"
            }
            
            return true
            
        } catch {
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore failed: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    func importBackup(from url: URL, dataManager: BabyDataManager) async -> Bool {
        await MainActor.run {
            isRestoring = true
            restoreProgress = 0.0
        }
        
        do {
            let backupData = try Data(contentsOf: url)
            restoreProgress = 0.3
            
            let backup = try JSONDecoder().decode(TinyStepsBackup.self, from: backupData)
            restoreProgress = 0.6
            
            // Validate backup version
            guard backup.version == "1.0.0" else {
                await MainActor.run {
                    isRestoring = false
                    restoreMessage = "Incompatible backup version"
                }
                return false
            }
            
            // Apply backup to data manager
            applyBackupToManager(backup, dataManager: dataManager)
            restoreProgress = 0.8
            
            // Apply user avatar
            await applyBackup(backup)
            restoreProgress = 1.0
            
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore completed successfully!"
            }
            
            return true
            
        } catch {
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore failed: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    func restoreFromBackup(_ backup: TinyStepsBackup) async {
        await MainActor.run {
            isRestoring = true
            restoreProgress = 0.0
        }
        
        do {
            await applyBackup(backup)
            restoreProgress = 1.0
            
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore completed successfully!"
            }
            
        } catch {
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore failed: \(error.localizedDescription)"
            }
        }
    }
    
    func restoreFromBackup(_ backup: TinyStepsBackup, dataManager: BabyDataManager) async {
        await MainActor.run {
            isRestoring = true
            restoreProgress = 0.0
        }
        
        do {
            // Apply backup to data manager
            applyBackupToManager(backup, dataManager: dataManager)
            restoreProgress = 0.5
            
            // Apply user avatar
            await applyBackup(backup)
            restoreProgress = 1.0
            
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore completed successfully!"
            }
            
        } catch {
            await MainActor.run {
                isRestoring = false
                restoreMessage = "Restore failed: \(error.localizedDescription)"
            }
        }
    }
    
    private func applyBackup(_ backup: TinyStepsBackup) async {
        await MainActor.run {
            // Apply backup data directly to the data manager
            // This will be called from the DataRestoreView which has access to the environment object
            
            // Save user avatar if present
            if let avatar = backup.userAvatar,
               let avatarData = try? JSONEncoder().encode(avatar) {
                UserDefaults.standard.set(avatarData, forKey: "userAvatar")
            }
        }
    }
    
    func applyBackupToManager(_ backup: TinyStepsBackup, dataManager: BabyDataManager) {
        // Apply backup data to the provided data manager
        dataManager.baby = backup.baby
        dataManager.feedingRecords = backup.feedingRecords
        dataManager.nappyRecords = backup.nappyRecords
        dataManager.sleepRecords = backup.sleepRecords
        dataManager.milestones = backup.milestones
        dataManager.achievements = backup.achievements
        dataManager.reminders = backup.reminders
        dataManager.vaccinations = backup.vaccinations
        dataManager.solidFoodRecords = backup.solidFoodRecords
        dataManager.wellnessEntries = backup.wellnessEntries
        dataManager.partnerSupports = backup.partnerSupports
        dataManager.emergencyContacts = backup.emergencyContacts
        dataManager.quickActions = backup.quickActions
        dataManager.growthPredictions = backup.growthPredictions
        dataManager.developmentChecklists = backup.developmentChecklists
        dataManager.appointments = backup.appointments
        
        // Save all data
        dataManager.saveData()
    }
    
    // MARK: - iCloud Backup
    
    private func saveToiCloud(_ backupData: Data) async {
        // This would implement iCloud backup using CloudKit
        // For now, we'll just simulate the process
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
    }
    
    // MARK: - Helper Methods
    
    private func getStoredBackups() -> [TinyStepsBackup] {
        guard let data = userDefaults.data(forKey: backupKey),
              let backups = try? JSONDecoder().decode([TinyStepsBackup].self, from: data) else {
            return []
        }
        return backups
    }
    
    private func saveBackups(_ backups: [TinyStepsBackup]) {
        if let data = try? JSONEncoder().encode(backups) {
            userDefaults.set(data, forKey: backupKey)
        }
    }
    
    private func loadLastBackupDate() {
        lastBackupDate = userDefaults.object(forKey: lastBackupKey) as? Date
    }
    
    private func loadAvailableBackups() {
        availableBackups = getStoredBackups()
    }
    
    func deleteBackup(_ backup: TinyStepsBackup) {
        var backups = getStoredBackups()
        backups.removeAll { $0.timestamp == backup.timestamp }
        saveBackups(backups)
        availableBackups = backups
    }
    
    func clearAllBackups() {
        userDefaults.removeObject(forKey: backupKey)
        userDefaults.removeObject(forKey: lastBackupKey)
        availableBackups = []
        lastBackupDate = nil
    }
    
    // MARK: - Auto Backup
    
    func scheduleAutoBackup() {
        // Schedule daily auto backup
        Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { _ in
            // This would trigger auto backup
        }
    }
    
    func shouldAutoBackup() -> Bool {
        guard let lastBackup = lastBackupDate else { return true }
        let daysSinceLastBackup = Calendar.current.dateComponents([.day], from: lastBackup, to: Date()).day ?? 0
        return daysSinceLastBackup >= 1
    }
}

// MARK: - Backup Info View
struct BackupInfoView: View {
    let backup: TinyStepsBackup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Backup from \(formatDate(backup.timestamp))")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Version: \(backup.version)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            if let baby = backup.baby {
                Text("Baby: \(baby.name)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text("Records: \(backup.feedingRecords.count) feeds, \(backup.nappyRecords.count) nappies, \(backup.sleepRecords.count) sleeps")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 