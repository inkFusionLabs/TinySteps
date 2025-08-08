import SwiftUI
import Foundation

struct HomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateCards = false
    @AppStorage("userAvatar") private var userAvatarData: Data = Data()
    @AppStorage("enabledDashboardCards") private var enabledCardsData: Data = Data()
    @State private var userAvatar: UserAvatar = UserAvatar()
    @State private var showProfile = false
    @State private var showDashboardSettings = false
    @State private var enabledCards: Set<DashboardCardType> = []
    @Binding var showSidebar: Bool
    
    var body: some View {
        return ZStack {
            // Theme Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Welcome Banner at the very top
                HStack {
                    Button(action: { showDashboardSettings = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
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
                .padding(.horizontal)
                .padding(.top)
                
                // Main content area
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Dashboard Cards
                        if enabledCards.contains(.dailySummary) {
                            DailySummaryCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.quickActions) {
                            QuickActionsCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.babyStatus) {
                            BabyStatusCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.appointments) {
                            AppointmentsCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.moodTracker) {
                            DadMoodCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.milestones) {
                            RecentMilestonesCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.tips) {
                            DailyTipCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.emergency) {
                            EmergencyContactsCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.photos) {
                            PhotoGalleryCard()
                                .padding(.horizontal)
                        }
                        
                        if enabledCards.contains(.resources) {
                            ResourcesCard()
                                .padding(.horizontal)
                        }
                        
                        // Information Hub Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Information Hub")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            NavigationLink(destination: InformationHubView()) {
                                HStack(spacing: 12) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .frame(width: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Dad's Info Hub")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        
                                        Text("Guidance, support & resources for NICU dads")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(Color.clear)
                                .cornerRadius(12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            // Sidebar Menu Overlay
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSidebar = false
                        }
                    }
                
                HStack {
                    SidebarMenuView(selectedTab: .constant(.home), showSidebar: $showSidebar)
                        .frame(width: 280)
                        .offset(x: showSidebar ? 0 : -280)
                        .animation(.easeInOut(duration: 0.3), value: showSidebar)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showDashboardSettings) {
            DashboardSettingsView()
        }
        .onChange(of: showDashboardSettings) { isShowing in
            if !isShowing {
                // Reload enabled cards when dashboard settings sheet is dismissed
                loadEnabledCards()
            }
        }
        .onAppear {
            if let loaded = try? JSONDecoder().decode(UserAvatar.self, from: userAvatarData), userAvatarData.count > 0 {
                userAvatar = loaded
            }
            loadEnabledCards()
        }
    }
    
    private func loadEnabledCards() {
        if let data = try? JSONDecoder().decode(Set<DashboardCardType>.self, from: enabledCardsData) {
            enabledCards = data
        } else {
            // Default enabled cards
            enabledCards = [.dailySummary, .quickActions, .babyStatus, .appointments]
        }
    }
    
    // MARK: - Helper Methods
    func formatNextFeeding() -> String {
        if let nextTime = dataManager.getNextFeedingTime() {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: nextTime)
        }
        return "Soon"
    }
    

    
    // Helper to format duration as hours and minutes
    func formatDuration(hours: Double) -> String {
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
