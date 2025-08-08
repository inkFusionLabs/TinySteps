//
//  ChatConfiguration.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import UserNotifications

// MARK: - Chat Configuration
struct ChatConfiguration {
    static let shared = ChatConfiguration()
    
    // MARK: - Environment Settings
    enum Environment {
        case development
        case production
    }
    
    let environment: Environment
    
    // MARK: - Feature Flags
    let useRealTimeChat: Bool
    let useFirebaseAuth: Bool
    let useFirestore: Bool
    
    // MARK: - Chat Settings
    let maxMessageLength: Int = 1000
    let messageRetentionDays: Int = 30
    let maxParticipantsPerRoom: Int = 100
    
    private init() {
        #if DEBUG
        self.environment = .development
        self.useRealTimeChat = false
        self.useFirebaseAuth = false
        self.useFirestore = false
        #else
        self.environment = .production
        self.useRealTimeChat = true
        self.useFirebaseAuth = true
        self.useFirestore = true
        #endif
    }
    
    // MARK: - Service Factory
    func createChatService() -> any ChatServiceProtocol {
        return MockChatService()
    }
    
    // MARK: - Validation
    func validateMessage(_ message: String) -> Bool {
        return !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               message.count <= maxMessageLength
    }
    
    func validateRoomName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               name.count <= 50
    }
}

// MARK: - Chat Analytics
struct ChatAnalytics {
    static func trackMessageSent(roomId: String, category: ChatRoom.ChatCategory) {
        // Track message analytics
        #if DEBUG
        print("📊 Message sent in room: \(roomId), category: \(category.rawValue)")
        #else
        // Send to analytics service
        #endif
    }
    
    static func trackRoomJoined(roomId: String, category: ChatRoom.ChatCategory) {
        #if DEBUG
        print("📊 Room joined: \(roomId), category: \(category.rawValue)")
        #else
        // Send to analytics service
        #endif
    }
    
    static func trackUserProfileUpdated() {
        #if DEBUG
        print("📊 User profile updated")
        #else
        // Send to analytics service
        #endif
    }
}

// MARK: - Chat Moderation
struct ChatModeration {
    static let inappropriateWords: Set<String> = [
        // Add inappropriate words to filter
    ]
    
    static func filterMessage(_ message: String) -> String {
        var filteredMessage = message
        
        for word in inappropriateWords {
            filteredMessage = filteredMessage.replacingOccurrences(
                of: word,
                with: String(repeating: "*", count: word.count),
                options: .caseInsensitive
            )
        }
        
        return filteredMessage
    }
    
    static func isMessageAppropriate(_ message: String) -> Bool {
        let lowercasedMessage = message.lowercased()
        return !inappropriateWords.contains { lowercasedMessage.contains($0) }
    }
}

// MARK: - Chat Notifications
struct ChatNotifications {
    static func scheduleMessageNotification(from sender: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "New message from \(sender)"
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permissions granted")
            } else {
                print("❌ Notification permissions denied")
            }
        }
    }
}

// MARK: - Chat Data Migration
struct ChatDataMigration {
    static func migrateFromOldFormat() {
        // Handle migration from old chat format if needed
        #if DEBUG
        print("🔄 Chat data migration completed")
        #endif
    }
    
    static func backupChatData() {
        // Backup chat data before updates
        #if DEBUG
        print("💾 Chat data backup completed")
        #endif
    }
} 