//
//  NewReminderViewNeumorphic.swift
//  TinySteps
//
//  Created by Neumorphic Theme Implementation
//

import SwiftUI

// Date formatter for time display - using global timeFormatter from BabyData.swift

struct NewReminderViewNeumorphic: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    
    @State private var title = ""
    @State private var notes = ""
    @State private var category: ReminderCategory = .feeding
    @State private var date = Date()
    @State private var isRecurring = false
    @State private var recurrenceInterval: RecurrenceInterval = .daily
    
    enum RecurrenceInterval: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    

    
    var body: some View {
        NavigationView {
            ZStack {
                // Neumorphic background
                NeumorphicThemeManager.NeumorphicColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(NeumorphicThemeManager.NeumorphicColors.cardBackground)
                                    .frame(width: 80, height: 80)
                                    .neumorphicCard()
                                
                                Image(systemName: "bell.badge.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(TinyStepsDesign.Colors.primary)
                            }
                            
                            Text("New Reminder")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                            
                            Text("Set a reminder for your baby's care")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textSecondary)
                        }
                        .padding(.top, 20)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // Basic Information
                            NeumorphicCard {
                                VStack(spacing: 20) {
                                    Text("Reminder Details")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    NeumorphicTextField(
                                        title: "Title",
                                        text: $title,
                                        icon: "textformat",
                                        placeholder: "e.g., Feed baby, Change diaper"
                                    )
                                    
                                    NeumorphicTextField(
                                        title: "Notes",
                                        text: $notes,
                                        icon: "note.text",
                                        placeholder: "Additional details (optional)"
                                    )
                                    
                                    NeumorphicPicker(
                                        title: "Category",
                                        selection: $category,
                                        options: ReminderCategory.allCases,
                                        icon: "folder.fill"
                                    )
                                }
                                .padding(20)
                            }
                            
                            // Schedule
                            NeumorphicCard {
                                VStack(spacing: 20) {
                                    Text("Schedule")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    NeumorphicDatePicker(
                                        title: "Date & Time",
                                        date: $date,
                                        icon: "clock.fill"
                                    )
                                    
                                    HStack {
                                        Image(systemName: "repeat")
                                            .foregroundColor(TinyStepsDesign.Colors.primary)
                                            .frame(width: 20)
                                        
                                        Toggle("Recurring Reminder", isOn: $isRecurring)
                                            .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                                    }
                                    
                                    if isRecurring {
                                        NeumorphicPicker(
                                            title: "Repeat Every",
                                            selection: $recurrenceInterval,
                                            options: RecurrenceInterval.allCases,
                                            icon: "calendar.badge.clock"
                                        )
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            NeumorphicButton(action: saveReminder) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Create Reminder")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(TinyStepsDesign.Colors.primary)
                            )
                            .disabled(title.isEmpty)
                            
                            NeumorphicButton(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveReminder() {
        guard !title.isEmpty else { return }
        
        let reminder = Reminder(
            title: title,
            description: notes.isEmpty ? nil : notes,
            date: date,
            isCompleted: false,
            category: category,
            repeatType: isRecurring ? Reminder.RepeatType(rawValue: recurrenceInterval.rawValue) ?? .none : .none,
            time: timeFormatter.string(from: date),
            notes: notes.isEmpty ? nil : notes
        )
        
        dataManager.addReminder(reminder)
        dismiss()
    }
}

// MARK: - Neumorphic Form Components
// These are now defined in NeumorphicFormComponents.swift
