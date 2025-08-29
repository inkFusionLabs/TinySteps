import SwiftUI

struct NewReminderView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var category: ReminderCategory = .feeding
    @State private var repeatOption: Reminder.RepeatType = .none
    
    // Using global timeFormatter from BabyData.swift
    
    var body: some View {
        ZStack {
            NeumorphicThemeManager.NeumorphicColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("New Reminder")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)

                            Text("Create a new reminder for baby care")
                                .font(.subheadline)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .neumorphicCard()
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 15) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        TextField("e.g., Feed baby", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        Menu {
                            ForEach(ReminderCategory.allCases, id: \.self) { cat in
                                Button(cat.rawValue) {
                                    category = cat
                                }
                            }
                        } label: {
                            HStack {
                                Text(category.rawValue)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                            .padding()
                            .neumorphicButton()
                        }
                    }
                    
                    // Date and Time
                    HStack(spacing: 15) {
                        // Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.headline)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                        }
                        
                        // Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.headline)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                        }
                    }
                    
                    // Repeat
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Repeat")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        Picker("Repeat", selection: $repeatOption) {
                            ForEach(Reminder.RepeatType.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding()
                .background(TinyStepsDesign.Colors.cardBackground.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                Button(action: saveReminder) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Reminder")
                    }
                    .font(.headline)
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.orange)
                    .cornerRadius(12)
                }
                .disabled(title.isEmpty)
                .padding(.horizontal)
            }
        }
        .navigationTitle("New Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
            }
        }
    }
    
    private func saveReminder() {
        let reminder = Reminder(
            title: title,
            description: notes.isEmpty ? nil : notes,
            date: date,
            isCompleted: false,
            category: category,
            repeatType: repeatOption,
            time: timeFormatter.string(from: date),
            notes: notes.isEmpty ? nil : notes
        )
        
        dataManager.addReminder(reminder)
        dismiss()
    }
}

#Preview {
    NavigationView {
        NewReminderView()
            .environmentObject(BabyDataManager())
    }
} 