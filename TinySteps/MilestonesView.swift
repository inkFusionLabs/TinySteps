//
//  MilestonesView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI

struct MilestonesView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateContent = false
    @State private var selectedCategory: Milestone.MilestoneCategory?
    @State private var showingAddMilestone = false
    @State private var newMilestoneTitle = ""
    @State private var newMilestoneDescription = ""
    @State private var newMilestoneCategory: Milestone.MilestoneCategory = .physical
    @State private var newMilestoneExpectedAge = 12
    @State private var newMilestoneNotes = ""
    
    var filteredMilestones: [Milestone] {
        if let category = selectedCategory {
            return dataManager.milestones.filter { $0.category == category }
        }
        return dataManager.milestones
    }
    
    var achievedMilestones: [Milestone] {
        filteredMilestones.filter { $0.isAchieved }
    }
    
    var pendingMilestones: [Milestone] {
        filteredMilestones.filter { !$0.isAchieved }
    }
    
    var progressPercentage: Double {
        guard !dataManager.milestones.isEmpty else { return 0 }
        return Double(achievedMilestones.count) / Double(dataManager.milestones.count) * 100
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Milestones Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.sports, color: TinyStepsDesign.Colors.success)
                Text("Dad's Milestones")
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
                            Text("Upcoming Milestones")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            // ... existing milestones content ...
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
    
    private func toggleMilestone(_ milestone: Milestone) {
        var updated = milestone
        updated.isAchieved.toggle()
        updated.achievedDate = updated.isAchieved ? Date() : nil
        if let idx = dataManager.milestones.firstIndex(where: { $0.id == milestone.id }) {
            dataManager.milestones[idx] = updated
            dataManager.saveData()
        }
    }
    
    private func addNewMilestone() {
        guard !newMilestoneTitle.isEmpty else { return }
        
        let newMilestone = Milestone(
            title: newMilestoneTitle,
            description: newMilestoneDescription,
            category: newMilestoneCategory,
            achievedDate: nil,
            expectedAge: newMilestoneExpectedAge,
            isAchieved: false,
            notes: newMilestoneNotes.isEmpty ? nil : newMilestoneNotes
        )
        
        dataManager.milestones.append(newMilestone)
        dataManager.saveData()
        
        // Reset form
        newMilestoneTitle = ""
        newMilestoneDescription = ""
        newMilestoneCategory = .physical
        newMilestoneExpectedAge = 12
        newMilestoneNotes = ""
        
        showingAddMilestone = false
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(TinyStepsDesign.Colors.cardBackground)
        )
    }
}

struct MilestoneCategoryFilterView: View {
    @Binding var selectedCategory: Milestone.MilestoneCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                MilestoneCategoryButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: .blue
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        selectedCategory = nil
                    }
                }
                
                ForEach(Milestone.MilestoneCategory.allCases, id: \.self) { category in
                    MilestoneCategoryButton(
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

struct MilestoneCategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : TinyStepsDesign.Colors.cardBackground)
                )
                .foregroundColor(isSelected ? .white : .white)
        }
    }
}

struct AchievedMilestoneCard: View {
    let milestone: Milestone
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Achievement Badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(milestone.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                if let achievedDate = milestone.achievedDate {
                    Text("Achieved: \(achievedDate, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
                
                HStack {
                    Text(milestone.category.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(milestone.category.color.opacity(0.3))
                        .foregroundColor(milestone.category.color)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: onToggle) {
                        Text("Undo")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(TinyStepsDesign.Colors.accent.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PendingMilestoneCard: View {
    let milestone: Milestone
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Pending Badge
            ZStack {
                Circle()
                    .fill(TinyStepsDesign.Colors.cardBackground)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(milestone.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Expected around \(milestone.expectedAge) weeks")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                HStack {
                    Text(milestone.category.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(milestone.category.color.opacity(0.3))
                        .foregroundColor(milestone.category.color)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: onToggle) {
                        Text("Achieved!")
                            .font(.caption)
                            .foregroundColor(TinyStepsDesign.Colors.success)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
        )
    }
}

struct AddMilestoneView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @Binding var description: String
    @Binding var category: Milestone.MilestoneCategory
    @Binding var expectedAge: Int
    @Binding var notes: String
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Milestone Details") {
                    TextField("Title", text: $title)
                    TextField("Description (optional)", text: $description)
                }
                
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(Milestone.MilestoneCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section("Timeline") {
                    Stepper("Expected Age: \(expectedAge) weeks", value: $expectedAge, in: 1...52)
                }
                
                Section("Notes (optional)") {
                    TextField("Add notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Milestone")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - Extensions

// Note: Milestone.MilestoneCategory extensions are already defined in BabyData.swift

#Preview {
    MilestonesView()
        .environmentObject(BabyDataManager())
} 