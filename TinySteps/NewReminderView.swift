import SwiftUI

struct NewReminderView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var time = ""
    @State private var category: ReminderCategory = .feeding
    @State private var repeatOption: Reminder.RepeatType = .none
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("New Reminder")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Create a new reminder for baby care")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 15) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., Feed baby", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.white)
                        Picker("Category", selection: $category) {
                            ForEach(ReminderCategory.allCases, id: \.self) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    // Time
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., 09:00", text: $time)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Repeat
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Repeat")
                            .font(.headline)
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
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
                    .foregroundColor(.white)
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
                .foregroundColor(.white)
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
            time: time,
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