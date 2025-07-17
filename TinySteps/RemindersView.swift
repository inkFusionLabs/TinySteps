import SwiftUI
import Foundation
#if canImport(Combine)
import Combine
#endif

struct RemindersView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddReminder = false
    @State private var searchText = ""
    @State private var selectedCategory: ReminderCategory = .all
    
    var filteredReminders: [Reminder] {
        var reminders = dataManager.reminders
        
        // Filter by category
        if selectedCategory != .all {
            reminders = reminders.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            reminders = reminders.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return reminders
    }
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Reminders")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Never miss important baby care tasks")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddReminder = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Search and Filter
                VStack(spacing: 10) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        TextField("Search reminders...", text: $searchText)
                            .foregroundColor(.white)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ReminderCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(selectedCategory == category ? category.color : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                
                // Reminders List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Your Reminders")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(filteredReminders.count) reminders")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if filteredReminders.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "bell.badge")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("No reminders found")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("Tap the + button to add your first reminder")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredReminders) { reminder in
                                    ReminderCard(reminder: reminder)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Reminders")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingAddReminder) {
            NavigationView {
                NewReminderView()
            }
        }
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(reminder.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    if !reminder.time.isEmpty {
                        Text(reminder.time)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                // Category indicator
                Text(reminder.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(reminder.category.color.opacity(0.3))
                    .foregroundColor(reminder.category.color)
                    .cornerRadius(4)
            }
            
            if let notes = reminder.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Repeat indicator
            if reminder.repeatType != .none {
                HStack {
                    Image(systemName: "repeat")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(reminder.repeatType.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationView {
        RemindersView()
            .environmentObject(BabyDataManager())
    }
} 