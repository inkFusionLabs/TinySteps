//
//  NICUProgressView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

struct NICUProgressView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var selectedDate = Date()
    @State private var showAddProgress = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: isIPad ? 80 : 24) {
                    // Header
                    VStack(spacing: isIPad ? 24 : 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: isIPad ? 12 : 8) {
                                Text("Daily Progress")
                                    .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                                    .fontWeight(.bold)
                                    .themedText(style: .primary)
                                
                                Text("Track your baby's NICU journey")
                                    .font(isIPad ? .system(size: 24, weight: .medium) : .subheadline)
                                    .themedText(style: .secondary)
                            }
                            Spacer()
                            
                            Button(action: { showAddProgress = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                                    .foregroundColor(themeManager.currentTheme.colors.accent)
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.top, isIPad ? 32 : 20)
                        
                        // Date Picker
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                            .accentColor(themeManager.currentTheme.colors.primary)
                            .padding(.horizontal, isIPad ? 24 : 20)
                    }
                    
                    // Today's Summary
                    VStack(alignment: .leading, spacing: isIPad ? 20 : 16) {
                        Text("Today's Summary")
                            .font(isIPad ? .title2 : .headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal, isIPad ? 24 : 20)
                        
                            LazyVGrid(columns: isIPad ? [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ] : [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: isIPad ? 24 : 16) {
                            ProgressMetricCard(
                                title: "Weight",
                                value: "1.2 kg",
                                change: "+10g",
                                trend: .up,
                                color: themeManager.currentTheme.colors.success
                            )
                            
                            ProgressMetricCard(
                                title: "Breathing",
                                value: "Room Air",
                                change: "No oxygen",
                                trend: .up,
                                color: themeManager.currentTheme.colors.success
                            )
                            
                            ProgressMetricCard(
                                title: "Feeding",
                                value: "Tube + Bottle",
                                change: "Learning",
                                trend: .stable,
                                color: themeManager.currentTheme.colors.warning
                            )
                            
                            ProgressMetricCard(
                                title: "Temperature",
                                value: "36.8°C",
                                change: "Stable",
                                trend: .stable,
                                color: themeManager.currentTheme.colors.info
                            )
                            
                            // Additional cards for iPad 3-column layout
                            if isIPad {
                                ProgressMetricCard(
                                    title: "Heart Rate",
                                    value: "140 bpm",
                                    change: "Normal",
                                    trend: .stable,
                                    color: themeManager.currentTheme.colors.success
                                )
                                
                                ProgressMetricCard(
                                    title: "Oxygen",
                                    value: "98%",
                                    change: "Good",
                                    trend: .up,
                                    color: themeManager.currentTheme.colors.accent
                                )
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                    }
                    
                    // Progress History
                    VStack(alignment: .leading, spacing: isIPad ? 20 : 16) {
                        Text("Progress History")
                            .font(isIPad ? .title2 : .headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal, isIPad ? 24 : 20)
                        
                        VStack(spacing: isIPad ? 20 : 12) {
                            ProgressHistoryRow(
                                date: "Yesterday",
                                weight: "1.19 kg",
                                breathing: "Room Air",
                                feeding: "Tube only",
                                color: themeManager.currentTheme.colors.primary
                            )
                            
                            ProgressHistoryRow(
                                date: "2 days ago",
                                weight: "1.18 kg",
                                breathing: "Oxygen 1L",
                                feeding: "Tube only",
                                color: themeManager.currentTheme.colors.primary
                            )
                            
                            ProgressHistoryRow(
                                date: "3 days ago",
                                weight: "1.17 kg",
                                breathing: "Oxygen 2L",
                                feeding: "Tube only",
                                color: themeManager.currentTheme.colors.primary
                            )
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                    }
                    
                    // Daily Milestones
                    VStack(alignment: .leading, spacing: isIPad ? 20 : 16) {
                        Text("Today's Milestones")
                            .font(isIPad ? .title2 : .headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal, isIPad ? 24 : 20)
                        
                        VStack(spacing: isIPad ? 16 : 8) {
                            MilestoneRow(
                                title: "First bottle feed",
                                time: "2:30 PM",
                                completed: true,
                                color: themeManager.currentTheme.colors.success
                            )
                            
                            MilestoneRow(
                                title: "Skin-to-skin time",
                                time: "4:00 PM",
                                completed: false,
                                color: themeManager.currentTheme.colors.accent
                            )
                            
                            MilestoneRow(
                                title: "Weight check",
                                time: "6:00 PM",
                                completed: false,
                                color: themeManager.currentTheme.colors.info
                            )
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                    }
                    
                    // UK Support Resources
                    VStack(alignment: .leading, spacing: isIPad ? 20 : 16) {
                        HStack {
                            Text("Need Support?")
                                .font(isIPad ? .title2 : .headline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            Spacer()
                            
                            Image(systemName: "flag.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        
                        VStack(spacing: isIPad ? 12 : 8) {
                            UKSupportRow(
                                name: "Bliss Charity",
                                number: "0808 801 0322",
                                description: "Premature baby support",
                                icon: "heart.fill",
                                color: .pink
                            )
                            
                            UKSupportRow(
                                name: "NHS 111",
                                number: "111",
                                description: "Non-emergency health advice",
                                icon: "cross.case.fill",
                                color: .blue
                            )
                            
                            UKSupportRow(
                                name: "Samaritans",
                                number: "116 123",
                                description: "24/7 emotional support",
                                icon: "phone.fill",
                                color: .green
                            )
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
            }
        }
        .sheet(isPresented: $showAddProgress) {
            AddProgressView()
        }
    }
}

// MARK: - Progress Metric Card
struct ProgressMetricCard: View {
    let title: String
    let value: String
    let change: String
    let trend: ProgressTrend
    let color: Color
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum ProgressTrend {
        case up, down, stable
    }
    
        var body: some View {
            VStack(spacing: isIPad ? 20 : 12) {
                HStack {
                    Text(title)
                        .font(isIPad ? .system(size: 20, weight: .semibold) : .subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: trendIcon)
                        .font(isIPad ? .system(size: 20, weight: .bold) : .caption)
                        .foregroundColor(trendColor)
                }
                
                VStack(alignment: .leading, spacing: isIPad ? 12 : 4) {
                    Text(value)
                        .font(isIPad ? .system(size: 36, weight: .bold) : .title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(change)
                        .font(isIPad ? .system(size: 16, weight: .medium) : .caption)
                        .foregroundColor(trendColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: isIPad ? 180 : 120)
            .padding(isIPad ? 32 : 16)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                    .fill(color.opacity(0.2))
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    
    private var trendIcon: String {
        switch trend {
        case .up: return "arrow.up.circle.fill"
        case .down: return "arrow.down.circle.fill"
        case .stable: return "minus.circle.fill"
        }
    }
    
    private var trendColor: Color {
        switch trend {
        case .up: return .green
        case .down: return .red
        case .stable: return .blue
        }
    }
}

// MARK: - Progress History Row
struct ProgressHistoryRow: View {
    let date: String
    let weight: String
    let breathing: String
    let feeding: String
    let color: Color
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 24 : 16) {
            VStack(alignment: .leading, spacing: isIPad ? 8 : 4) {
                Text(date)
                    .font(isIPad ? .title3 : .subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Progress")
                    .font(isIPad ? .body : .caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: isIPad ? 120 : 80, alignment: .leading)
            
            VStack(alignment: .leading, spacing: isIPad ? 6 : 2) {
                Text("Weight: \(weight)")
                    .font(isIPad ? .body : .caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Breathing: \(breathing)")
                    .font(isIPad ? .body : .caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Feeding: \(feeding)")
                    .font(isIPad ? .body : .caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(isIPad ? 20 : 16)
        .background(
            RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Milestone Row
struct MilestoneRow: View {
    let title: String
    let time: String
    let completed: Bool
    let color: Color
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 20 : 12) {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .font(isIPad ? .title : .title3)
                .foregroundColor(completed ? .green : color)
            
            VStack(alignment: .leading, spacing: isIPad ? 6 : 2) {
                Text(title)
                    .font(isIPad ? .title3 : .subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(time)
                    .font(isIPad ? .body : .caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(isIPad ? 20 : 16)
        .background(
            RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Add Progress View
struct AddProgressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var weight = ""
    @State private var breathingSupport = "Room Air"
    @State private var feedingMethod = "Tube"
    @State private var temperature = ""
    @State private var notes = ""
    @State private var showingBreathingPicker = false
    @State private var showingFeedingPicker = false
    
    let breathingOptions = ["Room Air", "Oxygen 1L", "Oxygen 2L", "CPAP", "Ventilator"]
    let feedingOptions = ["Tube", "Tube + Bottle", "Bottle only", "Breastfeeding"]
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 24 : 24) {
                        // Header
                        VStack(spacing: isIPad ? 12 : 12) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: isIPad ? 36 : 40))
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                            
                            Text("Track Baby's Progress")
                                .font(isIPad ? .system(size: 22, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Record important measurements and milestones")
                                .font(isIPad ? .system(size: 16) : .body)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? 20 : 16)
                        .padding(.horizontal, isIPad ? 24 : 20)
                        
                        // Form Fields
                        VStack(spacing: isIPad ? 20 : 20) {
                            // Weight Section
                            ProgressFormField(
                                title: "Weight (kg)",
                                icon: "scalemass.fill",
                                color: themeManager.currentTheme.colors.primary
                            ) {
                                HStack {
                                    TextField("Enter weight", text: $weight)
                                        .font(isIPad ? .system(size: 16) : .body)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .foregroundColor(.white)
                                        .accentColor(themeManager.currentTheme.colors.primary)
                                        .overlay(
                                            // Custom placeholder with better contrast
                                            Group {
                                                if weight.isEmpty {
                                                    HStack {
                                                        Text("Enter weight")
                                                            .font(isIPad ? .system(size: 16) : .body)
                                                            .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                                        Spacer()
                                                    }
                                                    .allowsHitTesting(false)
                                                }
                                            }
                                        )
                                    
                                    if !weight.isEmpty {
                                        Text("kg")
                                            .font(isIPad ? .system(size: 16) : .body)
                                            .themedText(style: .secondary)
                                    }
                                }
                            }
                            
                            // Breathing Support Section
                            ProgressFormField(
                                title: "Breathing Support",
                                icon: "lungs.fill",
                                color: themeManager.currentTheme.colors.info
                            ) {
                                Button(action: { showingBreathingPicker = true }) {
                                    HStack {
                                        Text(breathingSupport)
                                            .font(isIPad ? .system(size: 16) : .body)
                                            .themedText(style: .primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .themedText(style: .secondary)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Feeding Method Section
                            ProgressFormField(
                                title: "Feeding Method",
                                icon: "drop.fill",
                                color: themeManager.currentTheme.colors.accent
                            ) {
                                Button(action: { showingFeedingPicker = true }) {
                                    HStack {
                                        Text(feedingMethod)
                                            .font(isIPad ? .system(size: 16) : .body)
                                            .themedText(style: .primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .themedText(style: .secondary)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Temperature Section
                            ProgressFormField(
                                title: "Temperature (°C)",
                                icon: "thermometer",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                HStack {
                                    TextField("Enter temperature", text: $temperature)
                                        .font(isIPad ? .system(size: 16) : .body)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .foregroundColor(.white)
                                        .accentColor(themeManager.currentTheme.colors.primary)
                                        .overlay(
                                            // Custom placeholder with better contrast
                                            Group {
                                                if temperature.isEmpty {
                                                    HStack {
                                                        Text("Enter temperature")
                                                            .font(isIPad ? .system(size: 16) : .body)
                                                            .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                                        Spacer()
                                                    }
                                                    .allowsHitTesting(false)
                                                }
                                            }
                                        )
                                    
                                    if !temperature.isEmpty {
                                        Text("°C")
                                            .font(isIPad ? .system(size: 16) : .body)
                                            .themedText(style: .secondary)
                                    }
                                }
                            }
                            
                            // Notes Section
                            ProgressFormField(
                                title: "Notes",
                                icon: "note.text",
                                color: themeManager.currentTheme.colors.textSecondary
                            ) {
                                TextField("Any additional notes...", text: $notes, axis: .vertical)
                                    .font(isIPad ? .system(size: 16) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .lineLimit(3...6)
                                    .overlay(
                                        // Custom placeholder with better contrast
                                        Group {
                                            if notes.isEmpty {
                                                VStack {
                                                    HStack {
                                                        Text("Any additional notes...")
                                                            .font(isIPad ? .system(size: 16) : .body)
                                                            .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                                        Spacer()
                                                    }
                                                    Spacer()
                                                }
                                                .allowsHitTesting(false)
                                            }
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themedText(style: .primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProgress()
                    }
                    .themedText(style: .primary)
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingBreathingPicker) {
            PickerSheet(
                title: "Breathing Support",
                options: breathingOptions,
                selection: $breathingSupport
            )
        }
        .sheet(isPresented: $showingFeedingPicker) {
            PickerSheet(
                title: "Feeding Method",
                options: feedingOptions,
                selection: $feedingMethod
            )
        }
    }
    
    private func saveProgress() {
        // TODO: Implement save functionality
        dismiss()
    }
}

// MARK: - Progress Form Field
struct ProgressFormField<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 12 : 12) {
            HStack(spacing: isIPad ? 10 : 8) {
                Image(systemName: icon)
                    .font(isIPad ? .system(size: 18) : .title3)
                    .foregroundColor(color)
                    .frame(width: isIPad ? 20 : 20)
                
                Text(title)
                    .font(isIPad ? .system(size: 18, weight: .semibold) : .headline)
                    .themedText(style: .primary)
            }
            
            content
                .padding(isIPad ? 16 : 16)
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 14 : 12)
                        .fill(themeManager.currentTheme.colors.backgroundSecondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 14 : 12)
                                .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Picker Sheet
struct PickerSheet: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                themeManager.currentTheme.colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    VStack(spacing: 0) {
                        // Navigation Bar
                        HStack {
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(isIPad ? .system(size: 16, weight: .medium) : .body)
                            .fontWeight(.medium)
                            .themedText(style: .primary)
                            
                            Spacer()
                            
                            Button("Done") {
                                dismiss()
                            }
                            .font(isIPad ? .system(size: 16, weight: .semibold) : .body)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.currentTheme.colors.primary)
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.top, isIPad ? 14 : 12)
                        .padding(.bottom, isIPad ? 10 : 8)
                        
                        // Title Section
                        HStack {
                            Image(systemName: getIconForTitle(title))
                                .font(.system(size: isIPad ? 24 : 28, weight: .medium))
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(title)
                                    .font(isIPad ? .system(size: 22, weight: .bold) : .title2)
                                    .fontWeight(.bold)
                                    .themedText(style: .primary)
                                
                                Text("Select an option")
                                    .font(isIPad ? .system(size: 16) : .body)
                                    .themedText(style: .secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.bottom, isIPad ? 20 : 20)
                    }
                    .background(themeManager.currentTheme.colors.background.opacity(0.95))
                    
                    // Content Area
                    ScrollView {
                        VStack(spacing: isIPad ? 16 : 12) {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selection = option
                                    dismiss()
                                }) {
                                    HStack(spacing: isIPad ? 20 : 16) {
                                        // Option Icon
                                        Image(systemName: getOptionIcon(for: option))
                                            .font(.system(size: isIPad ? 20 : 18, weight: .medium))
                                            .foregroundColor(themeManager.currentTheme.colors.primary)
                                            .frame(width: isIPad ? 32 : 28, height: isIPad ? 32 : 28)
                                        
                                        // Option Text
                                        Text(option)
                                            .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                                            .fontWeight(.medium)
                                            .themedText(style: .primary)
                                        
                                        Spacer()
                                        
                                        // Selection Indicator
                                        if selection == option {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: isIPad ? 24 : 20, weight: .semibold))
                                                .foregroundColor(themeManager.currentTheme.colors.primary)
                                        } else {
                                            Circle()
                                                .stroke(themeManager.currentTheme.colors.border, lineWidth: 2)
                                                .frame(width: isIPad ? 24 : 20, height: isIPad ? 24 : 20)
                                        }
                                    }
                                    .padding(.horizontal, isIPad ? 24 : 20)
                                    .padding(.vertical, isIPad ? 18 : 15)
                                    .themedCard()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.top, isIPad ? 20 : 16)
                        .padding(.bottom, isIPad ? 40 : 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func getIconForTitle(_ title: String) -> String {
        switch title {
        case "Breathing Support":
            return "lungs.fill"
        case "Feeding Method":
            return "drop.fill"
        default:
            return "list.bullet"
        }
    }
    
    private func getOptionIcon(for option: String) -> String {
        switch option {
        case "Room Air":
            return "wind"
        case "Oxygen 1L", "Oxygen 2L":
            return "wind.circle"
        case "CPAP":
            return "wind.circle.fill"
        case "Ventilator":
            return "lungs"
        case "Tube":
            return "drop"
        case "Tube + Bottle":
            return "drop.circle"
        case "Bottle only":
            return "drop.circle.fill"
        case "Breastfeeding":
            return "heart.fill"
        default:
            return "circle"
        }
    }
}

#Preview {
    NICUProgressView()
        .environmentObject(ThemeManager.shared)
        .environmentObject(BabyDataManager())
}
