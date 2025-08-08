//
//  ContentView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct ContentView: View {
    @AppStorage("userName") private var userName: String = "Dad"
    @State private var showNameEntry = false
    @Binding var selectedTab: NavigationTab
    @State private var showProfile = false
    @State private var showSidebar = false
    
    enum NavigationTab: String, CaseIterable, Identifiable {
        case home, journal, tracking, support, settings, information, wellness, appointments, reminders, milestones, chat, analytics, data, medicalSearch
        var id: String { rawValue }
        var title: String {
            switch self {
            case .home: return "Home"
            case .journal: return "Journal"
            case .tracking: return "Tracking"
            case .support: return "Support"
            case .settings: return "Settings"
            case .information: return "Information Hub"
            case .wellness: return "Dad Wellness"
            case .appointments: return "Appointments"
            case .reminders: return "Reminders"
            case .milestones: return "Milestones"
            case .chat: return "Chat Support"
            case .analytics: return "Analytics"
            case .data: return "Data & Export"
            case .medicalSearch: return "Medical Search"
            }
        }
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .journal: return "book.fill"
            case .tracking: return "chart.bar.fill"
            case .support: return "heart.fill"
            case .settings: return "gear"
            case .information: return "info.circle.fill"
            case .wellness: return "heart.text.square"
            case .appointments: return "calendar"
            case .reminders: return "bell.fill"
            case .milestones: return "star.fill"
            case .chat: return "message.fill"
            case .analytics: return "chart.line.uptrend.xyaxis"
            case .data: return "externaldrive.fill"
            case .medicalSearch: return "magnifyingglass"
            }
        }
        var color: Color {
            switch self {
            case .home: return .blue
            case .journal: return .green
            case .tracking: return .orange
            case .support: return .red
            case .settings: return .gray
            case .information: return .purple
            case .wellness: return .pink
            case .appointments: return .green
            case .reminders: return .orange
            case .milestones: return .yellow
            case .chat: return .blue
            case .analytics: return .cyan
            case .data: return .indigo
            case .medicalSearch: return .indigo
            }
        }
    }

    init(selectedTab: Binding<NavigationTab>) {
        self._selectedTab = selectedTab
    }

    var body: some View {
        if userName.isEmpty {
            if showNameEntry {
                NameEntryView()
            } else {
                WelcomeView(showNameEntry: $showNameEntry)
            }
        } else {
            ZStack {
                // Background
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                // Main Content View
                NavigationView {
                    Group {
                        switch selectedTab {
                        case .home:
                            HomeView(showSidebar: $showSidebar)
                        case .journal:
                            JournalView()
                        case .tracking:
                            TrackingView()
                        case .support:
                            SupportView()
                        case .settings:
                            SettingsView()
                        case .information:
                            InformationHubView()
                        case .wellness:
                            DadWellnessView()
                        case .appointments:
                            AppointmentsView()
                        case .reminders:
                            RemindersView()
                        case .milestones:
                            MilestonesView()
                        case .chat:
                            ChatView(selectedTab: $selectedTab)
                        case .analytics:
                            EnhancedAnalyticsView(selectedTab: $selectedTab)
                        case .data:
                            DataExportView()
                        case .medicalSearch:
                            MedicalSearchView()
                        }
                    }
                    .onChange(of: selectedTab) { oldValue, newValue in
                        print("Tab changed from \(oldValue.title) to \(newValue.title)")
                    }
                    .navigationBarHidden(true)
                }
                .sheet(isPresented: $showProfile) {
                    NavigationView {
                        ProfileView()
                    }
                }
                
                // Sidebar Menu
                if showSidebar {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSidebar = false
                            }
                        }
                    
                    HStack {
                        SidebarMenuView(selectedTab: $selectedTab, showSidebar: $showSidebar)
                            .frame(width: 280)
                            .offset(x: showSidebar ? 0 : -280)
                            .animation(.easeInOut(duration: 0.3), value: showSidebar)
                        
                        Spacer()
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 50 && !showSidebar {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSidebar = true
                            }
                        } else if value.translation.width < -50 && showSidebar {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSidebar = false
                            }
                        }
                    }
            )
        }
    }
}

// Sidebar Menu View
struct SidebarMenuView: View {
    @Binding var selectedTab: ContentView.NavigationTab
    @Binding var showSidebar: Bool
    @AppStorage("userName") private var userName: String = ""
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            // Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.8))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(userName.isEmpty ? "Dad" : userName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    .onAppear {
                        print("SidebarMenuView appeared")
                    }
                
                // Menu Items
                VStack(spacing: 0) {
                // Main Navigation
                VStack(spacing: 0) {
                    Text("MAIN")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    ForEach([ContentView.NavigationTab.home, ContentView.NavigationTab.journal, ContentView.NavigationTab.tracking], id: \.self) { tab in
                        MenuItemView(tab: tab, selectedTab: $selectedTab, showSidebar: $showSidebar)
                            .onAppear {
                                print("Menu item appeared: \(tab.title)")
                            }
                    }
                }
                
                // Support & Care
                VStack(spacing: 0) {
                    Text("SUPPORT & CARE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    ForEach([ContentView.NavigationTab.support, ContentView.NavigationTab.appointments, ContentView.NavigationTab.reminders, ContentView.NavigationTab.milestones, ContentView.NavigationTab.medicalSearch], id: \.self) { tab in
                        MenuItemView(tab: tab, selectedTab: $selectedTab, showSidebar: $showSidebar)
                    }
                }
                
                // Information & Resources
                VStack(spacing: 0) {
                    Text("INFORMATION & RESOURCES")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    ForEach([ContentView.NavigationTab.information, ContentView.NavigationTab.wellness, ContentView.NavigationTab.chat], id: \.self) { tab in
                        MenuItemView(tab: tab, selectedTab: $selectedTab, showSidebar: $showSidebar)
                    }
                }
                
                // Tools & Settings
                VStack(spacing: 0) {
                    Text("TOOLS & SETTINGS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    ForEach([ContentView.NavigationTab.analytics, ContentView.NavigationTab.data, ContentView.NavigationTab.settings], id: \.self) { tab in
                        MenuItemView(tab: tab, selectedTab: $selectedTab, showSidebar: $showSidebar)
                    }
                }
                }
                
                Spacer()
            }
            
            // Bottom Section
            VStack(spacing: 16) {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                Button(action: { showProfile = true }) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Profile")
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 20)
        }
        }
        .sheet(isPresented: $showProfile) {
            NavigationView {
                ProfileView()
            }
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateCards = false
    @State private var showWelcome = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Enhanced Header with animation
                    VStack(spacing: 15) {
                        Image(systemName: "baby.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .scaleEffect(showWelcome ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: showWelcome)
                        
                        Text("Welcome, Dad!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(animateCards ? 1 : 0)
                            .animation(.easeIn(duration: 0.8), value: animateCards)
                        
                        Text("Your journey with \(dataManager.baby?.name ?? "Baby") begins here")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .opacity(animateCards ? 1 : 0)
                            .animation(.easeIn(duration: 0.8).delay(0.2), value: animateCards)
                    }
                    .padding(.vertical, 30)
                    
                    // Enhanced Quick Stats with animations
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        QuickStatCard(
                            title: "Age",
                            value: "\(dataManager.baby?.ageInDays ?? 0) days",
                            icon: "calendar",
                            color: .blue
                        )
                        .offset(x: animateCards ? 0 : -50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                        
                        QuickStatCard(
                            title: "Next Feed",
                            value: formatNextFeeding(),
                            icon: "clock",
                            color: .green
                        )
                        .offset(x: animateCards ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
                        
                        QuickStatCard(
                            title: "Today's Feeds",
                            value: "\(dataManager.getTodayFeedingCount())",
                            icon: "drop.fill",
                            color: .orange
                        )
                        .offset(x: animateCards ? 0 : -50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
                        
                        QuickStatCard(
                            title: "Today's Nappies",
                            value: "\(dataManager.getTodayNappyCount())",
                            icon: "drop",
                            color: .purple
                        )
                        .offset(x: animateCards ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
                    }
                    .padding(.horizontal)
                    
                    // Enhanced Tips Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            Text("Today's Dad Tip")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                DashboardTipCard(
                                    title: "Skin-to-Skin",
                                    description: "Hold your baby against your bare chest. It helps with bonding and regulates their temperature.",
                                    color: .orange,
                                    icon: "heart.fill"
                                )
                                .offset(y: animateCards ? 0 : 100)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
                                
                                DashboardTipCard(
                                    title: "Talk to Your Baby",
                                    description: "Even though they can't respond, talking helps with language development and bonding.",
                                    color: .green,
                                    icon: "message.fill"
                                )
                                .offset(y: animateCards ? 0 : 100)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateCards)
                                
                                DashboardTipCard(
                                    title: "Take Photos",
                                    description: "Capture these precious moments. They grow so quickly!",
                                    color: .purple,
                                    icon: "camera.fill"
                                )
                                .offset(y: animateCards ? 0 : 100)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: animateCards)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Enhanced Emergency Contacts
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                            Text("Emergency Contacts")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            DashboardEmergencyContactRow(
                                name: "NHS 111",
                                number: "111",
                                description: "Non-emergency medical advice",
                                color: .red
                            )
                            .offset(x: animateCards ? 0 : -100)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: animateCards)
                            
                            DashboardEmergencyContactRow(
                                name: "Bliss Helpline",
                                number: "0808 801 0322",
                                description: "Support for premature babies",
                                color: .blue
                            )
                            .offset(x: animateCards ? 0 : 100)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.1), value: animateCards)
                            
                            DashboardEmergencyContactRow(
                                name: "NCT Helpline",
                                number: "0300 330 0771",
                                description: "Parenting support",
                                color: .green
                            )
                            .offset(x: animateCards ? 0 : -100)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.2), value: animateCards)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Dad's Dashboard")
            .onAppear {
                withAnimation {
                    animateCards = true
                    showWelcome = true
                }
            }
        }
    }
    
    private func formatNextFeeding() -> String {
        // Calculate next feeding time based on last feeding
        if let lastFeeding = dataManager.feedingRecords.last {
            let nextFeeding = Calendar.current.date(byAdding: .hour, value: 3, to: lastFeeding.date) ?? Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: nextFeeding)
        }
        return "Not set"
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            
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
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
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

struct DashboardTipCard: View {
    let title: String
    let description: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .frame(width: 280, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct DashboardEmergencyContactRow: View {
    let name: String
    let number: String
    let description: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                
                #if canImport(UIKit)
                if let url = URL(string: "tel:\(number)") {
                    UIApplication.shared.open(url)
                }
                #elseif canImport(AppKit)
                if let url = URL(string: "tel:\(number)") {
                    NSWorkspace.shared.open(url)
                }
                #endif
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                    Text(number)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
        )
    }
}

struct FeedingGuideView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Feeding Basics
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Feeding Basics")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        InfoCard(
                            title: "Breastfeeding Support",
                            content: "• Support your partner by bringing water and snacks\n• Help with positioning and pillows\n• Take care of household tasks\n• Offer emotional support and encouragement",
                            icon: "heart.fill",
                            color: .pink
                        )
                        
                        InfoCard(
                            title: "Bottle Feeding",
                            content: "• Sterilise bottles and equipment\n• Prepare formula according to instructions\n• Hold baby in semi-upright position\n• Burp baby after feeding",
                            icon: "drop.fill",
                            color: .blue
                        )
                        
                        InfoCard(
                            title: "Feeding Schedule",
                            content: "• Newborns feed every 2-3 hours\n• Watch for hunger cues (rooting, sucking hands)\n• Don't wait until baby cries\n• Track feeding times and amounts",
                            icon: "clock.fill",
                            color: .green
                        )
                    }
                    .padding()
                    
                    // Hunger Cues
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recognising Hunger Cues")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 15) {
                            HungerCueCard(
                                title: "Early Signs",
                                cues: ["Rooting", "Sucking hands", "Lip smacking"],
                                color: .green
                            )
                            
                            HungerCueCard(
                                title: "Late Signs",
                                cues: ["Crying", "Fussing", "Head turning"],
                                color: .orange
                            )
                        }
                    }
                    .padding()
                    
                    // UK Guidelines
                    VStack(alignment: .leading, spacing: 15) {
                        Text("UK Guidelines")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 10) {
                            GuidelineRow(
                                title: "NHS Recommendations",
                                description: "Exclusive breastfeeding for first 6 months"
                            )
                            
                            GuidelineRow(
                                title: "Bliss Support",
                                description: "Specialised support for premature babies"
                            )
                            
                            GuidelineRow(
                                title: "Formula Safety",
                                description: "Use only approved UK formulas"
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feeding Guide")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(content)
                .font(.body)
                .lineSpacing(4)
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct HungerCueCard: View {
    let title: String
    let cues: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(TinyStepsDesign.Colors.accent)
            
            ForEach(cues, id: \.self) { cue in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption)
                        .foregroundColor(TinyStepsDesign.Colors.accent)
                    
                    Text(cue)
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct GuidelineRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct SleepGuideView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Safe Sleep
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Safe Sleep Guidelines")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        InfoCard(
                            title: "Back to Sleep",
                            content: "• Always place baby on their back to sleep\n• Use a firm, flat mattress\n• Keep baby in your room for first 6 months\n• Avoid soft bedding and toys",
                            icon: "bed.double.fill",
                            color: .blue
                        )
                        
                        InfoCard(
                            title: "Temperature",
                            content: "• Room temperature 16-20°C\n• Don't overheat baby\n• Use sleep bags instead of blankets\n• Check baby's chest for warmth",
                            icon: "thermometer",
                            color: .orange
                        )
                    }
                    .padding()
                    
                    // Sleep Patterns
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Newborn Sleep Patterns")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                            SleepPatternCard(
                                title: "0-3 months",
                                hours: "16-18 hours",
                                pattern: "Sleep in short bursts"
                            )
                            
                            SleepPatternCard(
                                title: "3-6 months",
                                hours: "14-15 hours",
                                pattern: "Longer night sleep"
                            )
                        }
                    }
                    .padding()
                    
                    // Tips for Dads
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Tips for Dads")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 10) {
                            TipRow(
                                tip: "Take turns with night feeds",
                                icon: "clock.arrow.circlepath"
                            )
                            
                            TipRow(
                                tip: "Create a bedtime routine",
                                icon: "moon.fill"
                            )
                            
                            TipRow(
                                tip: "Use white noise or gentle music",
                                icon: "speaker.wave.2.fill"
                            )
                            
                            TipRow(
                                tip: "Be patient - sleep training takes time",
                                icon: "heart.fill"
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Sleep Guide")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

struct SleepPatternCard: View {
    let title: String
    let hours: String
    let pattern: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(TinyStepsDesign.Colors.accent)
            
            Text(hours)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(pattern)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct TipRow: View {
    let tip: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(TinyStepsDesign.Colors.accent)
                .frame(width: 20)
            
            Text(tip)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct DevelopmentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Milestones
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Development Milestones")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 15) {
                            DevelopmentMilestoneCard(
                                age: "0-1 month",
                                milestones: ["Lifts head briefly", "Follows objects with eyes", "Responds to sounds", "Grasps reflexively"],
                                color: .blue
                            )
                            
                            DevelopmentMilestoneCard(
                                age: "1-2 months",
                                milestones: ["Smiles socially", "Coos and gurgles", "Holds head up better", "Follows moving objects"],
                                color: .green
                            )
                            
                            DevelopmentMilestoneCard(
                                age: "2-3 months",
                                milestones: ["Laughs and squeals", "Reaches for objects", "Rolls from tummy to back", "Holds head steady"],
                                color: .orange
                            )
                        }
                    }
                    .padding()
                    
                    // Activities for Dads
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Activities for Dads")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 10) {
                            ActivityCard(
                                title: "Tummy Time",
                                description: "Place baby on tummy for short periods to strengthen neck and shoulder muscles",
                                duration: "2-3 times daily",
                                icon: "figure.walk"
                            )
                            
                            ActivityCard(
                                title: "Reading Together",
                                description: "Read books with bright pictures and simple words",
                                duration: "10-15 minutes",
                                icon: "book.fill"
                            )
                            
                            ActivityCard(
                                title: "Singing and Talking",
                                description: "Sing songs and talk to your baby throughout the day",
                                duration: "Throughout day",
                                icon: "music.note"
                            )
                        }
                    }
                    .padding()
                    
                    // Warning Signs
                    VStack(alignment: .leading, spacing: 15) {
                        Text("When to Seek Help")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 10) {
                            WarningSignRow(
                                sign: "Not responding to sounds",
                                action: "Contact health visitor"
                            )
                            
                            WarningSignRow(
                                sign: "Not making eye contact",
                                action: "Speak to GP"
                            )
                            
                            WarningSignRow(
                                sign: "Not smiling by 8 weeks",
                                action: "Seek medical advice"
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Development")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

struct DevelopmentMilestoneCard: View {
    let age: String
    let milestones: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(age)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(color)
                    .font(.caption)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(milestones, id: \.self) { milestone in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(color)
                        
                        Text(milestone)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct ActivityCard: View {
    let title: String
    let description: String
    let duration: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(TinyStepsDesign.Colors.accent)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .lineSpacing(2)
            
            Text("Duration: \(duration)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct WarningSignRow: View {
    let sign: String
    let action: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(sign)
                    .font(.headline)
                
                Text(action)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
        }
        .padding()
        .background(Color.clear)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

// MARK: - Menu Item View
struct MenuItemView: View {
    let tab: ContentView.NavigationTab
    @Binding var selectedTab: ContentView.NavigationTab
    @Binding var showSidebar: Bool
    
    var body: some View {
        Button(action: {
            print("Menu item tapped: \(tab.title)")
            selectedTab = tab
            print("Selected tab changed to: \(selectedTab.title)")
            withAnimation(.easeInOut(duration: 0.3)) {
                showSidebar = false
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.title3)
                    .foregroundColor(selectedTab == tab ? tab.color : .white.opacity(0.8))
                    .frame(width: 24)
                
                Text(tab.title)
                    .font(.body)
                    .fontWeight(selectedTab == tab ? .semibold : .medium)
                    .foregroundColor(selectedTab == tab ? tab.color : .white)
                
                Spacer()
                
                if selectedTab == tab {
                    Circle()
                        .fill(tab.color)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                selectedTab == tab ? 
                tab.color.opacity(0.1) : 
                Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: .constant(.home))
            .environmentObject(BabyDataManager())
    }
}
#endif

