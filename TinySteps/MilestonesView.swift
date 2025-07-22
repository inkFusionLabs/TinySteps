//
//  MilestonesView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI

struct MilestonesView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddMilestone = false
    @State private var selectedCategory: MilestoneCategory = .all
    @State private var selectedPeriod: String = "All"
    @State private var showingFilterSheet = false
    @State private var showAchieved: Bool = true
    @State private var showPending: Bool = true
    @State private var showingResetAlert = false
    
    var filteredMilestones: [Milestone] {
        let byCategory: [Milestone]
        if selectedCategory == .all {
            byCategory = dataManager.milestones
        } else {
            byCategory = dataManager.milestones.filter { $0.category == selectedCategory }
        }
        let byPeriod: [Milestone]
        switch selectedPeriod {
        case "Months":
            byPeriod = byCategory.filter {
                if case .months = $0.period { return true } else { return false }
            }
        case "Years":
            byPeriod = byCategory.filter {
                if case .years = $0.period { return true } else { return false }
            }
        default:
            byPeriod = byCategory
        }
        return byPeriod.filter { (showAchieved && $0.isAchieved) || (showPending && !$0.isAchieved) }
    }
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Milestones")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .accessibilityLabel("Milestones")
                                    .accessibilityAddTraits(.isHeader)
                                
                                Text("Track your baby's development progress")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .accessibilityLabel("Track your baby's development progress")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddMilestone = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.purple)
                            }
                            .accessibilityLabel("Add new milestone")
                            .accessibilityHint("Open the form to add a new milestone.")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Stats Cards
                    HStack(spacing: 12) {
                        StatCard(
                            title: "Achieved",
                            value: "\(dataManager.milestones.filter { $0.isAchieved }.count)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Pending",
                            value: "\(dataManager.milestones.filter { !$0.isAchieved }.count)",
                            icon: "clock.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Category Filter
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(MilestoneCategory.allCases, id: \.self) { category in
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
                                    .accessibilityLabel(category.rawValue)
                                    .accessibilityHint("Filter milestones by \(category.rawValue) category.")
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    
                    // Milestones List
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Development Milestones")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(filteredMilestones.count) milestones")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        if filteredMilestones.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "star.badge")
                                    .font(.largeTitle)
                                    .foregroundColor(.white.opacity(0.5))
                                Text("No milestones found")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.7))
                                Text("Tap the + button to add your first milestone")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredMilestones) { milestone in
                                    MilestoneCard(milestone: milestone)
                                        .environmentObject(dataManager)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Milestones")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showingFilterSheet = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: { showingResetAlert = true }) {
                    Label("Reset Milestones", systemImage: "arrow.counterclockwise")
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showingAddMilestone) {
            NavigationView {
                NewMilestoneView()
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            MilestoneFilterSheet(selectedCategory: $selectedCategory, selectedPeriod: $selectedPeriod, showAchieved: $showAchieved, showPending: $showPending)
        }
        .alert(isPresented: $showingResetAlert) {
            Alert(
                title: Text("Reset All Milestones?"),
                message: Text("This will restore the default milestone list and remove all your progress. Are you sure?"),
                primaryButton: .destructive(Text("Reset")) {
                    do {
                        dataManager.clearAllData()
                        CrashReportingManager.shared.logMessage("Milestones reset by user", level: .info)
                    } catch {
                        CrashReportingManager.shared.logError(error, context: "resetMilestones")
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct MilestoneFilterSheet: View {
    @Binding var selectedCategory: MilestoneCategory
    @Binding var selectedPeriod: String
    @Binding var showAchieved: Bool
    @Binding var showPending: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(MilestoneCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                }
                Section(header: Text("Period")) {
                    Picker("Period", selection: $selectedPeriod) {
                        Text("All").tag("All")
                        Text("Months").tag("Months")
                        Text("Years").tag("Years")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Status")) {
                    Toggle("Show Achieved", isOn: $showAchieved)
                    Toggle("Show Pending", isOn: $showPending)
                }
            }
            .navigationTitle("Filter Milestones")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

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
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MilestoneCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    let milestone: Milestone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(milestone.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .accessibilityLabel(milestone.title)
                    
                    Text(milestone.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                        .accessibilityLabel(milestone.description)
                }
                Spacer()
                // Status indicator with check/uncheck button
                Button(action: { toggleAchieved() }) {
                    if milestone.isAchieved {
                        ZStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                            // Badge/graphic overlay
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.yellow)
                                .offset(x: 16, y: -16)
                                .shadow(radius: 4)
                        }
                    } else {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(milestone.isAchieved ? "Mark as not achieved" : "Mark as achieved")
                .accessibilityHint("Toggle achievement status for this milestone.")
            }
            HStack {
                // Category indicator
                Text(milestone.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(milestone.category.color.opacity(0.3))
                    .foregroundColor(milestone.category.color)
                    .cornerRadius(4)
                Spacer()
                // Age range
                Text(milestone.ageRange)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            if milestone.isAchieved, let achievedDate = milestone.achievedDate {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text("Achieved: \(achievedDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
    private func toggleAchieved() {
        if let idx = dataManager.milestones.firstIndex(where: { $0.id == milestone.id }) {
            var updated = dataManager.milestones[idx]
            updated.isAchieved.toggle()
            updated.achievedDate = updated.isAchieved ? Date() : nil
            dataManager.milestones[idx] = updated
            dataManager.saveData()
        }
    }
}

#Preview {
    NavigationView {
        MilestonesView()
            .environmentObject(BabyDataManager())
    }
} 