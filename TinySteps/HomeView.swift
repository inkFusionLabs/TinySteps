import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateCards = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Welcome Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.dad, color: TinyStepsDesign.Colors.accent)
                Text("Welcome, Dad!")
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
            VStack(spacing: 16) {
                Text("You're doing an amazing job. Remember, every small step counts!")
                    .font(.headline)
                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                    .padding(.horizontal)
                
                // Dad's Info Hub Card
                NavigationLink(destination: InformationHubView()) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dad's Info Hub")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            Text("Guidance, support & resources for NICU dads")
                                .font(.caption)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                    }
                    .padding()
                    .cornerRadius(14)
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        NavigationLink(destination: TrackingView()) {
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title)
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                Text("Tracking")
                                    .font(.caption)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                            .padding()
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: SupportView()) {
                            VStack {
                                Image(systemName: "heart.fill")
                                    .font(.title)
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                Text("Support")
                                    .font(.caption)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                            .padding()
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: MilestonesView()) {
                            VStack {
                                Image(systemName: "star.fill")
                                    .font(.title)
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                Text("Milestones")
                                    .font(.caption)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                            .padding()
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Today's Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Summary")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(dataManager.feedingRecords.filter { Calendar.current.isDateInToday($0.date) }.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            Text("Feeds")
                                .font(.caption)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text("\(dataManager.sleepRecords.filter { Calendar.current.isDateInToday($0.startTime) }.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(TinyStepsDesign.Colors.highlight)
                            Text("Sleep")
                                .font(.caption)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text("\(dataManager.nappyRecords.filter { Calendar.current.isDateInToday($0.date) }.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(TinyStepsDesign.Colors.success)
                            Text("Nappies")
                                .font(.caption)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            ScrollView {
                VStack(spacing: 20) {
                    // Example Card
                    ZStack {
                        // Card content here
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            // ... existing activity content ...
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
    
    private func formatNextFeeding() -> String {
        if let nextTime = dataManager.getNextFeedingTime() {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: nextTime)
        }
        return "Soon"
    }
    
    private func getRecentActivity() -> [ActivityItem] {
        var activities: [ActivityItem] = []
        
        // Add recent feedings
        for record in dataManager.feedingRecords.prefix(2) {
            activities.append(ActivityItem(
                icon: "drop.fill",
                title: "\(record.type.rawValue) Feed",
                description: record.amount != nil ? "\(Int(record.amount!))ml" : "\(Int(record.duration ?? 0))min",
                date: record.date,
                color: TinyStepsDesign.Colors.accent
            ))
        }
        
        // Add recent sleep records
        for record in dataManager.sleepRecords.prefix(2) {
            var description = record.location.rawValue
            if let endTime = record.endTime {
                let duration = endTime.timeIntervalSince(record.startTime) / 3600
                description = "\(formatDuration(hours: duration)) • \(record.location.rawValue)"
            }
            activities.append(ActivityItem(
                icon: "bed.double.fill",
                title: "Sleep Session",
                description: description,
                date: record.startTime,
                color: TinyStepsDesign.Colors.highlight
            ))
        }
        
        // Add recent nappy changes
        for record in dataManager.nappyRecords.prefix(2) {
            activities.append(ActivityItem(
                icon: "drop",
                title: "\(record.type.rawValue) Nappy",
                description: record.notes ?? "",
                date: record.date,
                color: TinyStepsDesign.Colors.success
            ))
        }
        
        return activities.sorted { $0.date > $1.date }.prefix(3).map { $0 }
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



#Preview {
    HomeView()
}
