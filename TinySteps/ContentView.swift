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
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum NavigationTab: String, CaseIterable, Identifiable {
        case home, progress, journal, info
        var id: String { rawValue }
        var title: String {
            switch self {
            case .home: return "Home"
            case .progress: return "Progress"
            case .journal: return "Journal"
            case .info: return "NICU Info"
            }
        }
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .progress: return "chart.line.uptrend.xyaxis"
            case .journal: return "book.fill"
            case .info: return "stethoscope"
            }
        }
        var color: Color {
            let theme = ThemeManager.shared.currentTheme.colors
            switch self {
            case .home: return theme.primary
            case .progress: return theme.accent
            case .journal: return theme.warning
            case .info: return theme.info
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
                OnboardingViewNeumorphic(showNameEntry: $showNameEntry)
            }
        } else {
            // Check if running on iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad Layout with Split View
                iPadLayout
                    .onAppear {
                        print("🔍 iPad Layout is being used!")
                        print("🔍 Device Model: \(UIDevice.current.model)")
                        print("🔍 Device Name: \(UIDevice.current.name)")
                        print("🔍 User Interface Idiom: \(UIDevice.current.userInterfaceIdiom.rawValue)")
                    }
            } else {
                // iPhone Layout with Tab Bar
                iPhoneLayout
                    .onAppear {
                        print("🔍 iPhone Layout is being used!")
                        print("🔍 Device Model: \(UIDevice.current.model)")
                        print("🔍 Device Name: \(UIDevice.current.name)")
                        print("🔍 User Interface Idiom: \(UIDevice.current.userInterfaceIdiom.rawValue)")
                    }
            }
        }
    }
    
    // MARK: - iPad Layout
    private var iPadLayout: some View {
        ZStack {
            // Background
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            NavigationSplitView {
                // Sidebar for iPad
                iPadSidebar
            } detail: {
                // Main Content
                Group {
                    switch selectedTab {
                    case .home:
                        NICUHomeView()
                    case .progress:
                        NICUProgressView()
                    case .journal:
                        NICUJournalView()
                    case .info:
                        NICUInfoView()
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
        }
    }
    
    // MARK: - iPhone Layout
    private var iPhoneLayout: some View {
        ZStack {
            // Background
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main Content View
                NavigationView {
                    Group {
                        switch selectedTab {
                        case .home:
                            NICUHomeView()
                        case .progress:
                            NICUProgressView()
                        case .journal:
                            NICUJournalView()
                        case .info:
                            NICUInfoView()
                        }
                    }
                    .onChange(of: selectedTab) { oldValue, newValue in
                        print("Tab changed from \(oldValue.title) to \(newValue.title)")
                    }
                    .navigationBarHidden(true)
                }
                
                // Glass Effect Bottom Tab Bar
                GlassTabBar(selectedTab: $selectedTab)
            }
            .sheet(isPresented: $showProfile) {
                NavigationView {
                    ProfileView()
                }
            }
            
            // Sidebar Menu (iPhone only)
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
    
    // MARK: - iPad Sidebar
    private var iPadSidebar: some View {
        VStack(spacing: 0) {
            // Header Section - Enhanced with responsive components
            VStack(spacing: 0) {
                // App Title
                HStack {
                    DesignSystem.iPadOptimization.ResponsiveText(
                        "TinySteps",
                        style: .primary
                    )
                    .font(.system(size: isIPad ? 48 : 24, weight: .bold))
                    
                    Spacer()
                    
                    // Status indicator
                    Circle()
                        .fill(themeManager.currentTheme.colors.success)
                        .frame(width: isIPad ? 12 : 8, height: isIPad ? 12 : 8)
                }
                .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                .padding(.top, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                
                // Profile Section
                HStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(16)) {
                    // Profile Avatar
                    Button(action: { showProfile = true }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.currentTheme.colors.accent)
                                .frame(width: isIPad ? 100 : 56, height: isIPad ? 100 : 56)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: isIPad ? 48 : 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading, spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(4)) {
                        DesignSystem.iPadOptimization.ResponsiveText(
                            "Welcome back,",
                            style: .tertiary
                        )
                        .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                        
                        DesignSystem.iPadOptimization.ResponsiveText(
                            userName.isEmpty ? "Dad" : userName,
                            style: .primary
                        )
                        .font(.system(size: isIPad ? 24 : 20, weight: .semibold))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(24))
            }
            .background(themeManager.currentTheme.colors.backgroundSecondary)
            
            // Navigation Menu - Full Height - Enhanced with responsive components
            VStack(spacing: 0) {
                // Main Section
                VStack(alignment: .leading, spacing: 0) {
                    DesignSystem.iPadOptimization.ResponsiveText(
                        "Main",
                        style: .tertiary
                    )
                    .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    .padding(.top, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(24))
                    .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(12))
                    
                    VStack(spacing: 4) {
                        SidebarMenuItem(
                            title: "Home",
                            icon: "house.fill",
                            isSelected: selectedTab == .home,
                            action: { selectedTab = .home }
                        )
                        
                        SidebarMenuItem(
                            title: "Progress",
                            icon: "chart.line.uptrend.xyaxis",
                            isSelected: selectedTab == .progress,
                            action: { selectedTab = .progress }
                        )
                    }
                }
                
                // Care & Journal Section
                VStack(alignment: .leading, spacing: 0) {
                    DesignSystem.iPadOptimization.ResponsiveText(
                        "Care & Journal",
                        style: .tertiary
                    )
                    .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    .padding(.top, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(32))
                    .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(12))
                    
                    VStack(spacing: 4) {
                        SidebarMenuItem(
                            title: "Journal",
                            icon: "book.fill",
                            isSelected: selectedTab == .journal,
                            action: { selectedTab = .journal }
                        )
                        
                        SidebarMenuItem(
                            title: "NICU Info",
                            icon: "stethoscope",
                            isSelected: selectedTab == .info,
                            action: { selectedTab = .info }
                        )
                    }
                }
                
                
                // Profile Section
                VStack(alignment: .leading, spacing: 0) {
                    DesignSystem.iPadOptimization.ResponsiveText(
                        "Profile",
                        style: .tertiary
                    )
                    .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    .padding(.top, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(32))
                    .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(12))
                    
                    VStack(spacing: 4) {
                        SidebarMenuItem(
                            title: "Profile",
                            icon: "person.circle",
                            isSelected: false,
                            action: { showProfile = true }
                        )
                    }
                }
                
                // Bottom Spacer to push content to fill available space
                Spacer()
                
                // Footer Section - Enhanced with responsive components
                VStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(12)) {
                    Divider()
                        .background(themeManager.currentTheme.colors.border.opacity(0.3))
                        .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(themeManager.currentTheme.colors.error)
                            .font(.system(size: isIPad ? 16 : 12))
                        
                        DesignSystem.iPadOptimization.ResponsiveText(
                            "Made with love for NICU dads",
                            style: .tertiary
                        )
                        .font(.system(size: isIPad ? 14 : 12, weight: .medium))
                        
                        Spacer()
                    }
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    .padding(.bottom, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                }
            }
        }
        .background(themeManager.currentTheme.colors.background)
        .frame(maxWidth: isIPad ? 400 : .infinity, alignment: .leading)
        .ignoresSafeArea(.container, edges: .leading)
    }
}

// MARK: - Sidebar Menu Item - Enhanced with responsive components
struct SidebarMenuItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(12)) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 20 : 16, weight: .medium))
                    .foregroundColor(isSelected ? themeManager.currentTheme.colors.primary : themeManager.currentTheme.colors.textSecondary)
                    .frame(width: isIPad ? 24 : 20, height: isIPad ? 24 : 20)
                
                DesignSystem.iPadOptimization.ResponsiveText(
                    title,
                    style: isSelected ? .primary : .secondary
                )
                .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                .foregroundColor(isSelected ? themeManager.currentTheme.colors.primary : themeManager.currentTheme.colors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
            .padding(.vertical, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(12))
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                    .fill(isSelected ? themeManager.currentTheme.colors.primary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                    .stroke(isSelected ? themeManager.currentTheme.colors.primary.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(8))
    }
}

// MARK: - iOS 16+ Style Tab Bar with Floating Selected Tab
struct GlassTabBar: View {
    @Binding var selectedTab: ContentView.NavigationTab
    @EnvironmentObject var themeManager: ThemeManager
    @State private var animateSelection = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ContentView.NavigationTab.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                        animateSelection = true
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            // Floating pill background for selected tab (iOS 16+ style)
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                tab.color.opacity(0.3),
                                                tab.color.opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.8)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(tab.color.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(
                                        color: tab.color.opacity(0.3),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )
                                    .scaleEffect(animateSelection && selectedTab == tab ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateSelection)
                            }
                            
                            // Icon
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: selectedTab == tab ? .semibold : .medium))
                                .foregroundColor(selectedTab == tab ? tab.color : themeManager.currentTheme.colors.textSecondary)
                                .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                        }
                        .frame(width: 50, height: 50)
                        
                        // Label
                        Text(tab.title)
                            .font(.system(size: 10, weight: selectedTab == tab ? .semibold : .medium))
                            .foregroundColor(selectedTab == tab ? tab.color : themeManager.currentTheme.colors.textSecondary)
                            .opacity(selectedTab == tab ? 1.0 : 0.7)
                            .animation(.easeInOut(duration: 0.2), value: selectedTab)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .padding(.bottom, 8)
        .background(
            // Solid background bar (not floating)
            Rectangle()
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    themeManager.currentTheme.colors.border.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 1)
                )
        )
        .onAppear {
            // Reset animation state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateSelection = false
            }
        }
    }
}

// Sidebar Menu View
struct SidebarMenuView: View {
    @Binding var selectedTab: ContentView.NavigationTab
    @Binding var showSidebar: Bool
    @AppStorage("userName") private var userName: String = ""
    @State private var showProfile = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Background
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                            
                            Text(userName.isEmpty ? "Dad" : userName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
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
                    
                    ForEach([ContentView.NavigationTab.home, ContentView.NavigationTab.progress], id: \.self) { tab in
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
                    
                    ForEach([ContentView.NavigationTab.journal, ContentView.NavigationTab.info], id: \.self) { tab in
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
                    
                    ForEach([ContentView.NavigationTab.info], id: \.self) { tab in
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
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
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
                                .foregroundColor(DesignSystem.Colors.textPrimary)
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
                                .foregroundColor(DesignSystem.Colors.textPrimary)
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

// QuickStatCard moved to HomeView.swift

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
                .foregroundColor(DesignSystem.Colors.accent)
            
            ForEach(cues, id: \.self) { cue in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.accent)
                    
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
                .foregroundColor(DesignSystem.Colors.accent)
            
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
                .foregroundColor(DesignSystem.Colors.accent)
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
                    .foregroundColor(DesignSystem.Colors.accent)
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
            .environmentObject(ThemeManager.shared)
    }
}
#endif

