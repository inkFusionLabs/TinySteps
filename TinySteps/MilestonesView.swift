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
    @State private var animateContent = false
    @State private var showingHistory = false
    
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
                VStack(spacing: 24) {
                    // Enhanced Header
                    enhancedHeader
                    
                    // Enhanced Stats Cards
                    enhancedStatsCards
                    
                    // Enhanced Category Filter
                    enhancedCategoryFilter
                    
                    // Enhanced Milestones List
                    enhancedMilestonesList
                    
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
                HStack {
                    Button(action: { showingFilterSheet = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        showingHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.white)
                    }
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
                    dataManager.clearAllData()
                    CrashReportingManager.shared.logMessage("Milestones reset by user", level: .info)
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingHistory) {
            MilestoneHistoryView()
        }
        .onAppear {
            // Ensure default milestones are loaded
            dataManager.ensureDefaultMilestones()
            
            withAnimation(.easeInOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
    
    // MARK: - View Components
    
    private var enhancedHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "star.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
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
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.green.opacity(0.4), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                .accessibilityLabel("Add new milestone")
                .accessibilityHint("Open the form to add a new milestone.")
            }
        }
        .padding(20)
        .background(Color.clear)
        .padding(.horizontal)
    }
    
    private var enhancedStatsCards: some View {
        HStack(spacing: 16) {
            EnhancedStatCard(
                title: "Achieved",
                value: "\(dataManager.milestones.filter { $0.isAchieved }.count)",
                icon: "checkmark.circle.fill",
                color: .green,
                gradient: LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            EnhancedStatCard(
                title: "Pending",
                value: "\(dataManager.milestones.filter { !$0.isAchieved }.count)",
                icon: "clock.fill",
                color: .orange,
                gradient: LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .padding(.horizontal)
    }
    
    private var enhancedCategoryFilter: some View {
        VStack(spacing: 12) {
            Text("Filter by Category")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MilestoneCategory.allCases, id: \.self) { category in
                        EnhancedCategoryButton(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
    
    private var enhancedMilestonesList: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Development Milestones")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(filteredMilestones.count) milestones")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.clear)
            }
            
            if filteredMilestones.isEmpty {
                EnhancedEmptyState()
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(Array(filteredMilestones.enumerated()), id: \.element.id) { index, milestone in
                        EnhancedMilestoneCard(milestone: milestone)
                            .environmentObject(dataManager)
                            .offset(x: animateContent ? 0 : (index % 2 == 0 ? -50 : 50))
                            .opacity(animateContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateContent)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.clear)
        .padding(.horizontal)
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

// MARK: - Enhanced Components

struct EnhancedStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let gradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 50, height: 50)
                    .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.clear)
    }
}

struct EnhancedCategoryButton: View {
    let category: MilestoneCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(category.rawValue)
        .accessibilityHint("Filter milestones by \(category.rawValue) category.")
    }
}

struct EnhancedEmptyState: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: "star.badge")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("No milestones found")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Try adjusting your filters or tap the + button to add your first milestone")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
    }
}

struct EnhancedMilestoneCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    let milestone: Milestone
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                // Category icon with gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [milestone.category.color, milestone.category.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .shadow(color: milestone.category.color.opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: milestone.category.icon)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(milestone.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .accessibilityLabel(milestone.title)
                    
                    Text(milestone.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                        .accessibilityLabel(milestone.description)
                    
                    HStack(spacing: 12) {
                        // Age range badge
                        Text(milestone.ageRange)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                            )
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Category badge
                        Text(milestone.category.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(milestone.category.color.opacity(0.3))
                            )
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                // Enhanced status indicator
                Button(action: { toggleAchieved() }) {
                    ZStack {
                        Circle()
                            .fill(
                                milestone.isAchieved ?
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, Color.clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                            .shadow(color: milestone.isAchieved ? Color.green.opacity(0.4) : Color.clear, radius: 4, x: 0, y: 2)
                        
                        if milestone.isAchieved {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        } else {
                            Image(systemName: "circle")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    isPressed = pressing
                }, perform: {})
                .accessibilityLabel(milestone.isAchieved ? "Mark as not achieved" : "Mark as achieved")
                .accessibilityHint("Toggle achievement status for this milestone.")
            }
            
            // Achievement date if achieved
            if milestone.isAchieved, let achievedDate = milestone.achievedDate {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Achieved: \(achievedDate, style: .date)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [milestone.category.color.opacity(0.3), milestone.category.color.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: milestone.category.color.opacity(0.1), radius: 6, x: 0, y: 3)
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

// MARK: - Legacy Components (for backward compatibility)

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
        .background(Color.clear)
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
                    .background(Color.clear)
                    .foregroundColor(.white)
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
        .background(Color.clear)
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