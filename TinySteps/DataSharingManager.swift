//
//  DataSharingManager.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

class DataSharingManager: ObservableObject {
    static let shared = DataSharingManager()
    private let appGroupID = "group.com.inkLabs.TinySteps"
    private let sharedDefaults: UserDefaults?
    
    private init() {
        sharedDefaults = UserDefaults(suiteName: appGroupID)
    }
    
    // MARK: - User Data
    func saveUserName(_ name: String) {
        sharedDefaults?.set(name, forKey: "userName")
    }
    
    func getUserName() -> String? {
        return sharedDefaults?.string(forKey: "userName")
    }
    
    // MARK: - Baby Data
    func saveBabyName(_ name: String) {
        sharedDefaults?.set(name, forKey: "babyName")
    }
    
    func getBabyName() -> String? {
        return sharedDefaults?.string(forKey: "babyName")
    }
    
    func saveBabyBirthDate(_ date: Date) {
        sharedDefaults?.set(date, forKey: "babyBirthDate")
    }
    
    func getBabyBirthDate() -> Date? {
        return sharedDefaults?.object(forKey: "babyBirthDate") as? Date
    }
    
    func saveBabyWeight(_ weight: Double) {
        sharedDefaults?.set(weight, forKey: "babyWeight")
    }
    
    func getBabyWeight() -> Double? {
        let weight = sharedDefaults?.double(forKey: "babyWeight") ?? 0
        return weight > 0 ? weight : nil
    }
    
    // MARK: - Daily Stats
    func saveFeedingCount(_ count: Int) {
        sharedDefaults?.set(count, forKey: "feedingCount")
    }
    
    func getFeedingCount() -> Int {
        return sharedDefaults?.integer(forKey: "feedingCount") ?? 0
    }
    
    func saveDiaperCount(_ count: Int) {
        sharedDefaults?.set(count, forKey: "diaperCount")
    }
    
    func getDiaperCount() -> Int {
        return sharedDefaults?.integer(forKey: "diaperCount") ?? 0
    }
    
    func saveSleepHours(_ hours: Double) {
        sharedDefaults?.set(hours, forKey: "sleepHours")
    }
    
    func getSleepHours() -> Double {
        return sharedDefaults?.double(forKey: "sleepHours") ?? 0
    }
    
    // MARK: - Widget Refresh
    func refreshWidget() {
        // Trigger widget refresh by updating a timestamp
        sharedDefaults?.set(Date(), forKey: "lastUpdate")
        
        // Request widget refresh
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        let keys = [
            "userName", "babyName", "babyBirthDate", "babyWeight",
            "feedingCount", "diaperCount", "sleepHours", "lastUpdate"
        ]
        
        for key in keys {
            sharedDefaults?.removeObject(forKey: key)
        }
    }
} 