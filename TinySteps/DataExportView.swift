//
//  DataExportView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

struct DataExportView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedExportType: ExportType = .summary
    @State private var showingShareSheet = false
    @State private var exportData: String = ""
    @State private var isExporting = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    let timeFormatter: DateFormatter = {
        let tf = DateFormatter()
        tf.timeStyle = .short
        return tf
    }()
    
    enum ExportType: String, CaseIterable {
        case summary = "Summary Report"
        case detailed = "Detailed Report"
        case feeding = "Feeding Data"
        case growth = "Growth Data"
        case all = "All Data"
        
        var icon: String {
            switch self {
            case .summary: return "doc.text"
            case .detailed: return "doc.text.fill"
            case .feeding: return "drop.fill"
            case .growth: return "chart.line.uptrend.xyaxis"
            case .all: return "archivebox.fill"
            }
        }
        
        var description: String {
            switch self {
            case .summary: return "Basic overview of baby's progress"
            case .detailed: return "Comprehensive report with all details"
            case .feeding: return "Feeding records and patterns"
            case .growth: return "Weight, height, and head circumference data"
            case .all: return "Complete data export including photos"
            }
        }
    }
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Spacer()
                    Text("Data Export")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") {
                        print("Done button tapped")
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .slideIn(from: .fromTop)
                
                // Main Content
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .animation(TinyStepsDesign.Animations.bouncy.delay(0.2), value: isAnimating)
                        
                        Text("Export Baby Data")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .slideIn(from: .fromBottom)
                        
                        Text("Export your baby's data for backup or sharing with healthcare providers")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .slideIn(from: .fromBottom)
                    }
                    .padding(.top)
                    .onAppear {
                        withAnimation(TinyStepsDesign.Animations.gentle) {
                            isAnimating = true
                        }
                    }
                    
                    // Export type selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Export Type")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .slideIn(from: .fromLeft)
                        
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(ExportType.allCases.enumerated()), id: \.element) { index, type in
                                    ExportTypeCard(
                                        type: type,
                                        isSelected: selectedExportType == type
                                    ) {
                                        withAnimation(TinyStepsDesign.Animations.bouncy) {
                                            selectedExportType = type
                                        }
                                    }
                                    .slideIn(from: .fromRight)
                                    .animation(TinyStepsDesign.Animations.slideIn.delay(Double(index) * 0.1), value: isAnimating)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                    // Export button
                    TinyStepsButton(
                        backgroundColor: TinyStepsDesign.NeumorphicColors.primary,
                        foregroundColor: .white,
                        cornerRadius: 12,
                        isEnabled: !isExporting,
                        action: {
                            withAnimation(TinyStepsDesign.Animations.tap) {
                                isExporting = true
                            }
                            exportData = generateExportData()
                            showingShareSheet = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(TinyStepsDesign.Animations.tap) {
                                    isExporting = false
                                }
                            }
                        }
                    ) {
                        HStack {
                            if isExporting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "square.and.arrow.up")
                            }
                            Text(isExporting ? "Preparing Export..." : "Export Data")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                    }
                    .slideIn(from: .fromBottom)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [exportData])
        }
    }
    
    private func generateExportData() -> String {
        isExporting = true
        
        var report = ""
        
        // Header
        report += "TinySteps Baby Data Export\n"
        report += "Generated: \(dateFormatter.string(from: Date()))\n"
        report += "=====================================\n\n"
        
        // Baby Information
        if let baby = dataManager.baby {
            report += "BABY INFORMATION\n"
            report += "Name: \(baby.name)\n"
            report += "Birth Date: \(dateFormatter.string(from: baby.birthDate))\n"
            report += "Gender: \(baby.gender.rawValue)\n"
            if let weight = baby.weight {
                report += "Current Weight: \(String(format: "%.2f", weight)) kg\n"
            }
            if let height = baby.height {
                report += "Current Height: \(String(format: "%.1f", height)) cm\n"
            }
            if let dueDate = baby.dueDate {
                report += "Due Date: \(dateFormatter.string(from: dueDate))\n"
                report += "Premature: \(baby.isPremature ? "Yes" : "No")\n"
            }
            report += "Age: \(baby.ageInDays) days (\(baby.ageInWeeks) weeks)\n\n"
        }
        
        switch selectedExportType {
        case .summary:
            report += generateSummaryReport()
        case .detailed:
            report += generateDetailedReport()
        case .feeding:
            report += generateFeedingReport()
        case .growth:
            report += generateGrowthReport()
        case .all:
            report += generateCompleteReport()
        }
        
        isExporting = false
        return report
    }
    
    private func generateSummaryReport() -> String {
        var report = "SUMMARY REPORT\n"
        report += "=====================================\n\n"
        
        // Today's summary
        let todayFeeds = dataManager.getTodayFeedingCount()
        let todayNappies = dataManager.getTodayNappyCount()
        let todaySleep = dataManager.getTodaySleepHours()
        
        report += "TODAY'S SUMMARY\n"
        report += "Feeding Sessions: \(todayFeeds)\n"
        report += "Nappy Changes: \(todayNappies)\n"
        report += "Sleep Duration: \(formatDuration(hours: todaySleep))\n\n"
        
        // Milestones
        let achievedMilestones = dataManager.milestones.filter { $0.isAchieved }
        let pendingMilestones = dataManager.milestones.filter { !$0.isAchieved }
        
        report += "MILESTONES\n"
        report += "Achieved: \(achievedMilestones.count)\n"
        report += "Pending: \(pendingMilestones.count)\n\n"
        
        // Recent achievements
        if !achievedMilestones.isEmpty {
            report += "RECENT ACHIEVEMENTS\n"
            for milestone in achievedMilestones.sorted(by: { $0.achievedDate ?? Date() > $1.achievedDate ?? Date() }).prefix(5) {
                if let achievedDate = milestone.achievedDate {
                    report += "• \(milestone.title) - \(dateFormatter.string(from: achievedDate))\n"
                }
            }
            report += "\n"
        }
        
        return report
    }
    
    private func generateDetailedReport() -> String {
        var report = "DETAILED REPORT\n"
        report += "=====================================\n\n"
        
        // Feeding records
        report += "FEEDING RECORDS (Last 30 days)\n"
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentFeedings = dataManager.feedingRecords.filter { $0.date >= thirtyDaysAgo }
        
        for feeding in recentFeedings.sorted(by: { $0.date > $1.date }) {
            report += "\(dateFormatter.string(from: feeding.date)) - \(feeding.type.rawValue)"
            if let amount = feeding.amount {
                report += " (\(Int(amount))ml)"
            }
            if let duration = feeding.duration {
                report += " (\(Int(duration/60))min)"
            }
            if let notes = feeding.notes {
                report += " - \(notes)"
            }
            report += "\n"
        }
        report += "\n"
        
        // Sleep records
        report += "SLEEP RECORDS (Last 30 days)\n"
        let recentSleeps = dataManager.sleepRecords.filter { $0.startTime >= thirtyDaysAgo }
        
        for sleep in recentSleeps.sorted(by: { $0.startTime > $1.startTime }) {
            report += "\(dateFormatter.string(from: sleep.startTime)) \(timeFormatter.string(from: sleep.startTime))"
            if let endTime = sleep.endTime {
                let duration = endTime.timeIntervalSince(sleep.startTime) / 3600
                report += " - \(timeFormatter.string(from: endTime)) (\(formatDuration(hours: duration)))"
            } else {
                report += " - Ongoing"
            }
            report += " • \(sleep.location.rawValue)"
            if let quality = sleep.sleepQuality {
                report += " • \(quality.rawValue)"
            }
            if let notes = sleep.notes {
                report += " - \(notes)"
            }
            report += "\n"
        }
        report += "\n"
        
        // Growth data
        if let baby = dataManager.baby {
            report += "GROWTH DATA\n"
            if !baby.weightHistory.isEmpty {
                report += "Weight History:\n"
                for entry in baby.weightHistory.sorted(by: { $0.date < $1.date }) {
                    report += "  \(dateFormatter.string(from: entry.date)): \(String(format: "%.2f", entry.weight)) kg\n"
                }
                report += "\n"
            }
            
            if !baby.heightHistory.isEmpty {
                report += "Height History:\n"
                for entry in baby.heightHistory.sorted(by: { $0.date < $1.date }) {
                    report += "  \(dateFormatter.string(from: entry.date)): \(String(format: "%.1f", entry.value)) cm\n"
                }
                report += "\n"
            }
        }
        
        return report
    }
    
    private func generateFeedingReport() -> String {
        var report = "FEEDING DATA REPORT\n"
        report += "=====================================\n\n"
        
        // Feeding statistics
        let totalFeedings = dataManager.feedingRecords.count
        let breastFeedings = dataManager.feedingRecords.filter { $0.type == .breast }.count
        let bottleFeedings = dataManager.feedingRecords.filter { $0.type == .bottle }.count
        let mixedFeedings = dataManager.feedingRecords.filter { $0.type == .mixed }.count
        
        report += "FEEDING STATISTICS\n"
        report += "Total Feedings: \(totalFeedings)\n"
        report += "Breast Feedings: \(breastFeedings)\n"
        report += "Bottle Feedings: \(bottleFeedings)\n"
        report += "Mixed Feedings: \(mixedFeedings)\n\n"
        
        // Recent feeding records
        report += "RECENT FEEDING RECORDS\n"
        for feeding in dataManager.feedingRecords.sorted(by: { $0.date > $1.date }).prefix(20) {
            report += "\(dateFormatter.string(from: feeding.date)) \(timeFormatter.string(from: feeding.date)) - \(feeding.type.rawValue)"
            if let amount = feeding.amount {
                report += " (\(Int(amount))ml)"
            }
            if let duration = feeding.duration {
                report += " (\(Int(duration/60))min)"
            }
            if let notes = feeding.notes {
                report += " - \(notes)"
            }
            report += "\n"
        }
        
        return report
    }
    
    private func generateGrowthReport() -> String {
        var report = "GROWTH DATA REPORT\n"
        report += "=====================================\n\n"
        
        guard let baby = dataManager.baby else {
            return report + "No baby data available\n"
        }
        
        // Weight data
        if !baby.weightHistory.isEmpty {
            report += "WEIGHT DATA\n"
            report += "Current Weight: \(String(format: "%.2f", baby.weightHistory.last?.weight ?? 0)) kg\n"
            report += "Birth Weight: \(String(format: "%.2f", baby.weightHistory.first?.weight ?? 0)) kg\n"
            report += "Weight Gain: \(String(format: "%.2f", (baby.weightHistory.last?.weight ?? 0) - (baby.weightHistory.first?.weight ?? 0))) kg\n\n"
            
            report += "Weight History:\n"
            for entry in baby.weightHistory.sorted(by: { $0.date < $1.date }) {
                report += "  \(dateFormatter.string(from: entry.date)): \(String(format: "%.2f", entry.weight)) kg"
                if let notes = entry.notes {
                    report += " (\(notes))"
                }
                report += "\n"
            }
            report += "\n"
        }
        
        // Height data
        if !baby.heightHistory.isEmpty {
            report += "HEIGHT DATA\n"
            report += "Current Height: \(String(format: "%.1f", baby.heightHistory.last?.value ?? 0)) cm\n"
            report += "Birth Height: \(String(format: "%.1f", baby.heightHistory.first?.value ?? 0)) cm\n"
            report += "Height Growth: \(String(format: "%.1f", (baby.heightHistory.last?.value ?? 0) - (baby.heightHistory.first?.value ?? 0))) cm\n\n"
            
            report += "Height History:\n"
            for entry in baby.heightHistory.sorted(by: { $0.date < $1.date }) {
                report += "  \(dateFormatter.string(from: entry.date)): \(String(format: "%.1f", entry.value)) cm\n"
            }
            report += "\n"
        }
        
        // Head circumference data
        if !baby.headCircumferenceHistory.isEmpty {
            report += "HEAD CIRCUMFERENCE DATA\n"
            report += "Current Head Circumference: \(String(format: "%.1f", baby.headCircumferenceHistory.last?.value ?? 0)) cm\n\n"
            
            report += "Head Circumference History:\n"
            for entry in baby.headCircumferenceHistory.sorted(by: { $0.date < $1.date }) {
                report += "  \(dateFormatter.string(from: entry.date)): \(String(format: "%.1f", entry.value)) cm\n"
            }
            report += "\n"
        }
        
        return report
    }
    
    private func generateCompleteReport() -> String {
        var report = "COMPLETE DATA EXPORT\n"
        report += "=====================================\n\n"
        
        report += generateDetailedReport()
        report += generateFeedingReport()
        report += generateGrowthReport()
        
        // Additional data
        report += "ADDITIONAL DATA\n"
        report += "=====================================\n\n"
        
        // Sleep summary
        let totalSleepHours = dataManager.sleepRecords.reduce(0.0) { total, sleep in
            if let endTime = sleep.endTime {
                return total + endTime.timeIntervalSince(sleep.startTime) / 3600
            }
            return total
        }
        report += "SLEEP SUMMARY\n"
        report += "Total Sleep Sessions: \(dataManager.sleepRecords.count)\n"
        report += "Total Sleep Duration: \(formatDuration(hours: totalSleepHours))\n"
        report += "Average Sleep Duration: \(formatDuration(hours: totalSleepHours / Double(max(1, dataManager.sleepRecords.count))))\n\n"
        
        // Vaccinations
        if !dataManager.vaccinations.isEmpty {
            report += "VACCINATION RECORDS\n"
            for vaccination in dataManager.vaccinations.sorted(by: { $0.date < $1.date }) {
                report += "\(dateFormatter.string(from: vaccination.date)) - \(vaccination.title)"
                if vaccination.isCompleted {
                    report += " (Completed)"
                }
                if let notes = vaccination.notes {
                    report += " - \(notes)"
                }
                report += "\n"
            }
            report += "\n"
        }
        
        // Solid food records
        if !dataManager.solidFoodRecords.isEmpty {
            report += "SOLID FOOD RECORDS\n"
            for food in dataManager.solidFoodRecords.sorted(by: { $0.date > $1.date }) {
                report += "\(dateFormatter.string(from: food.date)) - \(food.foodName) (\(food.reaction.rawValue))"
                if let notes = food.notes {
                    report += " - \(notes)"
                }
                report += "\n"
            }
            report += "\n"
        }
        
        return report
    }
    
    // Helper to format duration as hours and minutes
    private func formatDuration(hours: Double) -> String {
        let totalMinutes = Int(hours * 60)
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        if h > 0 && m > 0 {
            return "\(h)h \(m)m"
        } else if h > 0 {
            return "\(h)h"
        } else {
            return "\(m)m"
        }
    }
}

struct ExportTypeCard: View {
    let type: DataExportView.ExportType
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : TinyStepsDesign.NeumorphicColors.primary)
                    .frame(width: 30)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.rawValue)
                        .font(.headline)
                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                    
                    Text(type.description)
                        .font(.caption)
                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(TinyStepsDesign.NeumorphicColors.success)
                        .font(.title3)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? TinyStepsDesign.NeumorphicColors.primary : TinyStepsDesign.NeumorphicColors.base)
                    .shadow(
                        color: isSelected ? TinyStepsDesign.NeumorphicColors.primary.opacity(0.3) : TinyStepsDesign.NeumorphicColors.lightShadow,
                        radius: isPressed ? 2 : 4,
                        x: isPressed ? -1 : -2,
                        y: isPressed ? -1 : -2
                    )
                    .shadow(
                        color: isSelected ? TinyStepsDesign.NeumorphicColors.primary.opacity(0.3) : TinyStepsDesign.NeumorphicColors.darkShadow,
                        radius: isPressed ? 2 : 4,
                        x: isPressed ? 1 : 2,
                        y: isPressed ? 1 : 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? TinyStepsDesign.NeumorphicColors.primary : TinyStepsDesign.NeumorphicColors.lightShadow.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
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

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 