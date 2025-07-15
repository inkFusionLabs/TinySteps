import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateCards = false
    @AppStorage("userAvatar") private var userAvatarData: Data = Data()
    @State private var userAvatar: UserAvatar = UserAvatar()
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Dad Welcome Banner
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Welcome, Dad!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { showProfile = true }) {
                            SimpleAvatarView(avatar: userAvatar)
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 2, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Text("Your dashboard for baby's journey.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)
                .padding(.top)
                // Main Content
                VStack(spacing: 16) {
                    Text("You're doing an amazing job. Remember, every small step counts!")
                        .font(.headline)
                        .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        .padding(.horizontal)
                    
                    // Dad's Info Hub Card
                    NavigationLink(destination: InformationHubView()) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Dad's Info Hub")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Text("Guidance, support & resources for NICU dads")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
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
                                        .font(.title2)
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
                                        .font(.title2)
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
                                        .font(.title2)
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
                                Text("\(dataManager.getTodayFeedingCount())")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                Text("Feeds")
                                    .font(.caption)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                            
                            VStack {
                                Text("\(dataManager.getTodaySleepCount())")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                Text("Sleep")
                                    .font(.caption)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                            
                            VStack {
                                Text("\(dataManager.getTodayNappyCount())")
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
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            // ... existing activity content ...
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                        // ... repeat for other cards/buttons ...
                    }
                    .padding()
                }
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .onAppear {
            if let loaded = try? JSONDecoder().decode(UserAvatar.self, from: userAvatarData), userAvatarData.count > 0 {
                userAvatar = loaded
            }
        }
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
        let recentRecords = dataManager.getRecentRecords(limit: 6)
        var activities: [ActivityItem] = []
        
        for record in recentRecords {
            if let feeding = record as? FeedingRecord {
                activities.append(ActivityItem(
                    icon: "drop.fill",
                    title: "\(feeding.type.rawValue) Feed",
                    description: feeding.amount != nil ? "\(Int(feeding.amount!))ml" : "\(Int(feeding.duration ?? 0))min",
                    date: feeding.date,
                    color: TinyStepsDesign.Colors.accent
                ))
            } else if let sleep = record as? SleepRecord {
                var description = sleep.location.rawValue
                if let endTime = sleep.endTime {
                    let duration = endTime.timeIntervalSince(sleep.startTime) / 3600
                    description = "\(formatDuration(hours: duration)) • \(sleep.location.rawValue)"
                }
                activities.append(ActivityItem(
                    icon: "bed.double.fill",
                    title: "Sleep Session",
                    description: description,
                    date: sleep.startTime,
                    color: TinyStepsDesign.Colors.highlight
                ))
            } else if let nappy = record as? NappyRecord {
                activities.append(ActivityItem(
                    icon: "drop",
                    title: "\(nappy.type.rawValue) Nappy",
                    description: nappy.notes ?? "",
                    date: nappy.date,
                    color: TinyStepsDesign.Colors.success
                ))
            }
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
