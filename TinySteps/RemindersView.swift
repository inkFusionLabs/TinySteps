import SwiftUI
import Foundation
import Combine

struct RemindersView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingAddReminder = false
    @State private var animateContent = false
    @State private var selectedCategory: Reminder.ReminderCategory?
    @State private var searchText = ""
    
    var filteredReminders: [Reminder] {
        let upcoming = dataManager.getUpcomingReminders()
        let filtered = selectedCategory == nil ? upcoming : upcoming.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { reminder in
                reminder.title.localizedCaseInsensitiveContains(searchText) ||
                (reminder.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Reminders Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.tools, color: TinyStepsDesign.Colors.highlight)
                Text("Dad's Reminders")
                    .font(TinyStepsDesign.Typography.header)
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                Spacer()
            }
            .padding()
            .background(TinyStepsDesign.Colors.primary)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top, 12)
            // Main Content
            ScrollView {
                VStack(spacing: 20) {
                    // Example Card
                    ZStack {
                        // Card content here
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upcoming Reminders")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            // ... existing reminders content ...
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    // ... repeat for other cards/buttons ...
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))
                .font(.title3)
            
            TextField("Search reminders...", text: $text)
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.title3)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: Reminder.ReminderCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: .blue
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        selectedCategory = nil
                    }
                }
                
                ForEach(Reminder.ReminderCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color.opacity(0.3) : Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? color : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    let onComplete: () -> Void
    @State private var isHovered = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon and Category
            VStack(spacing: 8) {
                Image(systemName: reminder.category.icon)
                    .foregroundColor(reminder.category.color)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(reminder.category.color.opacity(0.2))
                    )
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isHovered)
                
                Text(reminder.category.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(reminder.category.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(reminder.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if let description = reminder.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption)
                    
                    Text(reminder.date, style: .time)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption)
                    
                    Text(reminder.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if reminder.repeatType != .none {
                        Spacer()
                        Text(reminder.repeatType.rawValue)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(reminder.category.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(reminder.category.color.opacity(0.2))
                            )
                    }
                }
            }
            
            Spacer()
            
            // Complete Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onComplete()
                    isPressed = false
                }
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                    .scaleEffect(isPressed ? 0.8 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(reminder.category.color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(color: reminder.category.color.opacity(0.2), radius: isHovered ? 10 : 5, x: 0, y: 3)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct EmptyRemindersView: View {
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.6))
                .scaleEffect(animateIcon ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
            
            VStack(spacing: 8) {
                Text("No reminders yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Add your first reminder to stay organized")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .onAppear {
            animateIcon = true
        }
    }
}

struct AddReminderView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var category: Reminder.ReminderCategory = .feeding
    @State private var repeatType: Reminder.RepeatType = .none
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.4),
                        Color(red: 0.2, green: 0.3, blue: 0.6),
                        Color(red: 0.3, green: 0.4, blue: 0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Title Input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reminder Title")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("e.g., Feed baby", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8), value: animateContent)
                        
                        // Description Input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description (Optional)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("Add details...", text: $description)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.2), value: animateContent)
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(Reminder.ReminderCategory.allCases, id: \.self) { cat in
                                    CategorySelectionButton(
                                        category: cat,
                                        isSelected: category == cat
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            category = cat
                                        }
                                    }
                                }
                            }
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.4), value: animateContent)
                        
                        // Date and Time
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date & Time")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .colorScheme(.dark)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.6), value: animateContent)
                        
                        // Repeat Options
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Repeat")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Picker("Repeat", selection: $repeatType) {
                                ForEach(Reminder.RepeatType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.8), value: animateContent)
                        
                        // Save Button
                        Button(action: saveReminder) {
                            HStack(spacing: 10) {
                                Image(systemName: "bell.fill")
                                    .font(.headline)
                                Text("Create Reminder")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(title.isEmpty)
                        .opacity(title.isEmpty ? 0.6 : 1.0)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.0), value: animateContent)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Reminder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .onAppear {
                withAnimation {
                    animateContent = true
                }
            }
        }
    }
    
    private func saveReminder() {
        let reminder = Reminder(
            title: title,
            description: description.isEmpty ? nil : description,
            date: date,
            isCompleted: false,
            category: category,
            repeatType: repeatType
        )
        
        dataManager.addReminder(reminder)
        dismiss()
    }
}

struct CategorySelectionButton: View {
    let category: Reminder.ReminderCategory
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .foregroundColor(isSelected ? .white : category.color)
                    .font(.title2)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? category.color : Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    RemindersView()
        .environmentObject(BabyDataManager())
} 