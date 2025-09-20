//
//  EnhancedNotificationsManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import UserNotifications
import SwiftUI

class EnhancedNotificationsManager: ObservableObject {
    static let shared = EnhancedNotificationsManager()
    
    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    @Published var notificationSettings = NotificationSettings()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        checkAuthorizationStatus()
        loadSettings()
    }
    
    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }
    
    func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Smart Notifications
    func scheduleSmartFeedingReminder(for baby: Baby) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Time for a Feed"
        content.body = "\(baby.name) might be getting hungry. Check for hunger cues!"
        content.sound = .default
        content.categoryIdentifier = "FEEDING_REMINDER"
        
        // Smart timing based on baby's age and feeding patterns
        let trigger = createSmartFeedingTrigger(for: baby)
        
        let request = UNNotificationRequest(
            identifier: "smart_feeding_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    func scheduleDadWellnessReminder() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Dad Check-in"
        content.body = "How are you feeling today? Take a moment for yourself."
        content.sound = .default
        content.categoryIdentifier = "DAD_WELLNESS"
        
        // Schedule for mid-morning when things might be calmer
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dad_wellness_daily",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    func scheduleMilestoneReminder(for baby: Baby) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Milestone Check"
        content.body = "\(baby.name) is growing! Check for new developmental milestones."
        content.sound = .default
        content.categoryIdentifier = "MILESTONE_CHECK"
        
        // Weekly reminder
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 * 24 * 3600, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "milestone_weekly",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    func scheduleHealthVisitorReminder() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Health Visitor Visit"
        content.body = "Don't forget your upcoming health visitor appointment!"
        content.sound = .default
        content.categoryIdentifier = "HEALTH_VISITOR"
        
        // Schedule 1 day before appointment
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 3600, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "health_visitor_reminder",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    func scheduleSelfCareReminder() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Self-Care Time"
        content.body = "Remember to take care of yourself too, Dad!"
        content.sound = .default
        content.categoryIdentifier = "SELF_CARE"
        
        // Schedule for evening when baby might be sleeping
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "self_care_evening",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    // MARK: - Contextual Notifications
    func scheduleContextualNotification(based activity: String, baby: Baby) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        
        switch activity {
        case "feeding":
            content.title = "Great Job, Dad!"
            content.body = "You're doing amazing with \(baby.name)'s feeding routine."
        case "sleep":
            content.title = "Sleep Success"
            content.body = "\(baby.name) is getting good sleep. You're creating a great routine!"
        case "nappy":
            content.title = "On Top of It"
            content.body = "Keeping up with nappy changes shows great attention to detail."
        case "milestone":
            content.title = "Milestone Achieved!"
            content.body = "\(baby.name) reached a new milestone! Your support is working."
        default:
            return
        }
        
        content.sound = .default
        content.categoryIdentifier = "ENCOURAGEMENT"
        
        // Schedule for 30 minutes later
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30 * 60, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "encouragement_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    // MARK: - Emergency Notifications
    func scheduleEmergencyContactReminder() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Emergency Contacts"
        content.body = "Make sure you have emergency contacts saved and easily accessible."
        content.sound = .default
        content.categoryIdentifier = "EMERGENCY_CONTACTS"
        
        // Weekly reminder
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 * 24 * 3600, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "emergency_contacts_weekly",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    // MARK: - Custom Reminders
    func scheduleCustomReminder(title: String, body: String, date: Date, repeats: Bool = false) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "CUSTOM_REMINDER"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let request = UNNotificationRequest(
            identifier: "custom_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        scheduleNotification(request)
    }
    
    // MARK: - Notification Categories
    func setupNotificationCategories() {
        let feedingCategory = UNNotificationCategory(
            identifier: "FEEDING_REMINDER",
            actions: [
                UNNotificationAction(identifier: "LOG_FEED", title: "Log Feed", options: [.foreground]),
                UNNotificationAction(identifier: "SNOOZE", title: "Snooze 15 min", options: [])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let wellnessCategory = UNNotificationCategory(
            identifier: "DAD_WELLNESS",
            actions: [
                UNNotificationAction(identifier: "LOG_MOOD", title: "Log Mood", options: [.foreground]),
                UNNotificationAction(identifier: "SELF_CARE", title: "Self-Care Time", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let milestoneCategory = UNNotificationCategory(
            identifier: "MILESTONE_CHECK",
            actions: [
                UNNotificationAction(identifier: "ADD_MILESTONE", title: "Add Milestone", options: [.foreground]),
                UNNotificationAction(identifier: "VIEW_MILESTONES", title: "View Milestones", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let healthVisitorCategory = UNNotificationCategory(
            identifier: "HEALTH_VISITOR",
            actions: [
                UNNotificationAction(identifier: "VIEW_APPOINTMENT", title: "View Details", options: [.foreground]),
                UNNotificationAction(identifier: "REMIND_LATER", title: "Remind Later", options: [])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let selfCareCategory = UNNotificationCategory(
            identifier: "SELF_CARE",
            actions: [
                UNNotificationAction(identifier: "TAKE_BREAK", title: "Take Break", options: [.foreground]),
                UNNotificationAction(identifier: "EXERCISE", title: "Quick Exercise", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let encouragementCategory = UNNotificationCategory(
            identifier: "ENCOURAGEMENT",
            actions: [
                UNNotificationAction(identifier: "THANKS", title: "Thanks!", options: []),
                UNNotificationAction(identifier: "SHARE", title: "Share Achievement", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let customReminderCategory = UNNotificationCategory(
            identifier: "CUSTOM_REMINDER",
            actions: [
                UNNotificationAction(identifier: "COMPLETE", title: "Mark Complete", options: []),
                UNNotificationAction(identifier: "SNOOZE", title: "Snooze", options: [])
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let emergencyCategory = UNNotificationCategory(
            identifier: "EMERGENCY_CONTACTS",
            actions: [
                UNNotificationAction(identifier: "VIEW_CONTACTS", title: "View Contacts", options: [.foreground]),
                UNNotificationAction(identifier: "ADD_CONTACT", title: "Add Contact", options: [.foreground])
            ],
            intentIdentifiers: [],
            options: []
        )

        
        notificationCenter.setNotificationCategories([
            feedingCategory,
            wellnessCategory,
            milestoneCategory,
            healthVisitorCategory,
            selfCareCategory,
            encouragementCategory,
            customReminderCategory,
            emergencyCategory
        ])
    }
    
    // MARK: - Helper Methods
    private func createSmartFeedingTrigger(for baby: Baby) -> UNNotificationTrigger {
        let ageInDays = Calendar.current.dateComponents([.day], from: baby.birthDate, to: Date()).day ?? 0
        
        // Adjust feeding intervals based on baby's age
        let interval: TimeInterval
        if ageInDays < 30 {
            interval = 2 * 3600 // 2 hours for newborns
        } else if ageInDays < 90 {
            interval = 3 * 3600 // 3 hours for 1-3 months
        } else if ageInDays < 180 {
            interval = 4 * 3600 // 4 hours for 3-6 months
        } else {
            interval = 6 * 3600 // 6 hours for 6+ months
        }
        
        return UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
    }
    
    private func scheduleNotification(_ request: UNNotificationRequest) {
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.loadPendingNotifications()
                }
            }
        }
    }
    
    func loadPendingNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.pendingNotifications = requests
            }
        }
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        loadPendingNotifications()
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        loadPendingNotifications()
    }
    
    // MARK: - Settings Management
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(notificationSettings) {
            UserDefaults.standard.set(encoded, forKey: "NotificationSettings")
        }
    }
    
    func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "NotificationSettings"),
           let settings = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            notificationSettings = settings
        }
    }
    
    // MARK: - Notification Analytics
    func trackNotificationInteraction(identifier: String, action: String) {
        // Track how users interact with notifications
        let interaction = NotificationInteraction(
            identifier: identifier,
            action: action,
            timestamp: Date()
        )
        
        // Save interaction for analytics
        saveNotificationInteraction(interaction)
    }
    
    private func saveNotificationInteraction(_ interaction: NotificationInteraction) {
        var interactions = loadNotificationInteractions()
        interactions.append(interaction)
        
        if let encoded = try? JSONEncoder().encode(interactions) {
            UserDefaults.standard.set(encoded, forKey: "NotificationInteractions")
        }
    }
    
    private func loadNotificationInteractions() -> [NotificationInteraction] {
        if let data = UserDefaults.standard.data(forKey: "NotificationInteractions"),
           let interactions = try? JSONDecoder().decode([NotificationInteraction].self, from: data) {
            return interactions
        }
        return []
    }
}

// MARK: - Supporting Models

struct NotificationSettings: Codable, Equatable {
    var feedingReminders: Bool = true
    var wellnessReminders: Bool = true
    var milestoneReminders: Bool = true
    var healthVisitorReminders: Bool = true
    var selfCareReminders: Bool = true
    var encouragementNotifications: Bool = true
    var emergencyContactReminders: Bool = true
    var customReminders: Bool = true
    
    var quietHoursEnabled: Bool = false
    var quietHoursStart: Date = Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date()
    var quietHoursEnd: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
    var badgeEnabled: Bool = true
}

struct NotificationInteraction: Codable {
    let identifier: String
    let action: String
    let timestamp: Date
}

// MARK: - Notification Settings View
struct NotificationSettingsView: View {
    @StateObject private var notificationManager = EnhancedNotificationsManager.shared
    @State private var showingAuthorizationAlert = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Authorization Status
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: notificationManager.isAuthorized ? "bell.fill" : "bell.slash.fill")
                                    .foregroundColor(notificationManager.isAuthorized ? TinyStepsDesign.NeumorphicColors.success : TinyStepsDesign.NeumorphicColors.error)
                                    .font(.title2)
                                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                                    .animation(TinyStepsDesign.Animations.bouncy.delay(0.2), value: isAnimating)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Notifications")
                                        .font(.headline)
                                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                                        .slideIn(from: .fromLeft)
                                    
                                    Text(notificationManager.isAuthorized ? "Enabled" : "Disabled")
                                        .font(.subheadline)
                                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                                        .slideIn(from: .fromLeft)
                                }
                                
                                Spacer()
                                
                                if !notificationManager.isAuthorized {
                                    TinyStepsButton(
                                        backgroundColor: TinyStepsDesign.NeumorphicColors.primary,
                                        foregroundColor: .white,
                                        cornerRadius: 8,
                                        isEnabled: true,
                                        action: {
                                            requestAuthorization()
                                        }
                                    ) {
                                        Text("Enable")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .slideIn(from: .fromRight)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(TinyStepsDesign.NeumorphicColors.base)
                                .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: 4, x: -2, y: -2)
                                .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: 4, x: 2, y: 2)
                        )
                        .padding(.horizontal)
                        
                        // Notification Types
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Notification Types")
                                .font(.headline)
                                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                                .padding(.horizontal)
                                .slideIn(from: .fromTop)
                            
                            VStack(spacing: 10) {
                                NotificationTypeToggle(
                                    title: "Feeding Reminders",
                                    description: "Smart reminders based on baby's age",
                                    isOn: $notificationManager.notificationSettings.feedingReminders,
                                    icon: "drop.fill",
                                    color: .blue
                                )
                                
                                NotificationTypeToggle(
                                    title: "Dad Wellness",
                                    description: "Mental health check-ins and support",
                                    isOn: $notificationManager.notificationSettings.wellnessReminders,
                                    icon: "heart.fill",
                                    color: .pink
                                )
                                
                                NotificationTypeToggle(
                                    title: "Milestone Checks",
                                    description: "Weekly developmental milestone reminders",
                                    isOn: $notificationManager.notificationSettings.milestoneReminders,
                                    icon: "star.fill",
                                    color: .yellow
                                )
                                
                                NotificationTypeToggle(
                                    title: "Health Visitor",
                                    description: "Appointment and visit reminders",
                                    isOn: $notificationManager.notificationSettings.healthVisitorReminders,
                                    icon: "cross.case.fill",
                                    color: .green
                                )
                                
                                NotificationTypeToggle(
                                    title: "Self-Care",
                                    description: "Reminders to take care of yourself",
                                    isOn: $notificationManager.notificationSettings.selfCareReminders,
                                    icon: "figure.walk",
                                    color: .orange
                                )
                                
                                NotificationTypeToggle(
                                    title: "Encouragement",
                                    description: "Positive reinforcement messages",
                                    isOn: $notificationManager.notificationSettings.encouragementNotifications,
                                    icon: "hand.thumbsup.fill",
                                    color: .purple
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // Quiet Hours
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Quiet Hours")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 10) {
                                Toggle("Enable Quiet Hours", isOn: $notificationManager.notificationSettings.quietHoursEnabled)
                                    .foregroundColor(.white)
                                    .tint(.blue)
                                
                                if notificationManager.notificationSettings.quietHoursEnabled {
                                    HStack {
                                        Text("Start Time")
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $notificationManager.notificationSettings.quietHoursStart, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .colorScheme(.dark)
                                    }
                                    
                                    HStack {
                                        Text("End Time")
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $notificationManager.notificationSettings.quietHoursEnd, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .colorScheme(.dark)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.clear)
                            )
                            .padding(.horizontal)
                        }
                        
                        // Pending Notifications
                        if !notificationManager.pendingNotifications.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Pending Notifications")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 8) {
                                    ForEach(notificationManager.pendingNotifications, id: \.identifier) { request in
                                        PendingNotificationRow(request: request) {
                                            notificationManager.cancelNotification(withIdentifier: request.identifier)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(TinyStepsDesign.Animations.gentle) {
                    isAnimating = true
                }
            }
            .onChange(of: notificationManager.notificationSettings) { oldValue, newValue in
                notificationManager.saveSettings()
            }
            .alert("Enable Notifications", isPresented: $showingAuthorizationAlert) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable notifications in Settings to receive reminders and updates.")
            }
        }
    }
    
    private func requestAuthorization() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            if !granted {
                await MainActor.run {
                    showingAuthorizationAlert = true
                }
            }
        }
    }
}

struct NotificationTypeToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
                .scaleEffect(isPressed ? 0.9 : 1.0)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(color)
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(TinyStepsDesign.NeumorphicColors.base)
                .shadow(
                    color: isPressed ? TinyStepsDesign.NeumorphicColors.lightShadow.opacity(0.5) : TinyStepsDesign.NeumorphicColors.lightShadow,
                    radius: isPressed ? 2 : 4,
                    x: isPressed ? -1 : -2,
                    y: isPressed ? -1 : -2
                )
                .shadow(
                    color: isPressed ? TinyStepsDesign.NeumorphicColors.darkShadow.opacity(0.5) : TinyStepsDesign.NeumorphicColors.darkShadow,
                    radius: isPressed ? 2 : 4,
                    x: isPressed ? 1 : 2,
                    y: isPressed ? 1 : 2
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(TinyStepsDesign.Animations.tap, value: isPressed)
        .onTapGesture {
            withAnimation(TinyStepsDesign.Animations.tap) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(TinyStepsDesign.Animations.tap) {
                    isPressed = false
                }
            }
        }
    }
}

struct PendingNotificationRow: View {
    let request: UNNotificationRequest
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(request.content.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(request.content.body)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button("Cancel") {
                onCancel()
            }
            .font(.caption)
            .foregroundColor(.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
    NotificationSettingsView()
} 