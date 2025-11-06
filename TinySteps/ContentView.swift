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
    @EnvironmentObject var themeManager: ThemeManager
    
    // Performance optimizations
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var isViewVisible = true
    @State private var lastTabChangeTime = Date()
    @State private var cachedTabContent: [NavigationTab: AnyView] = [:]
    
    
    
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
            // Force iPhone-style layout on all devices (including iPad)
            iPhoneLayout
                .onAppear {
                    print("🔍 iPhone-style Layout is being used on \(UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone")!")
                    print("🔍 Device Model: \(UIDevice.current.model)")
                    print("🔍 Device Name: \(UIDevice.current.name)")
                    print("🔍 User Interface Idiom: \(UIDevice.current.userInterfaceIdiom.rawValue)")
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
                Group {
                    switch selectedTab {
                    case .home:
                        NICUHomeView()
                            .optimized()
                    case .progress:
                        NICUProgressView()
                            .optimized()
                    case .journal:
                        NICUJournalView()
                            .optimized()
                    case .info:
                        NICUInfoView()
                            .optimized()
                    }
                }
                .onChange(of: selectedTab) { oldValue, newValue in
                    lastTabChangeTime = Date()
                    print("Tab changed from \(oldValue.title) to \(newValue.title)")
                }
                
                // Glass Effect Bottom Tab Bar
                GlassTabBar(selectedTab: $selectedTab)
            }
            .sheet(isPresented: $showProfile) {
                NavigationView {
                    Text("Profile - Coming Soon")
                }
            }
        }
        
    }
}

// iPad-specific sidebar components removed

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

// Sidebar components removed

// MARK: - Performance Optimized Components

// LazyView for performance optimization
struct LazyView<Content: View>: View {
    let content: () -> Content
    
    init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

// Optimized Tab Bar
struct OptimizedTabBar: View {
    @Binding var selectedTab: ContentView.NavigationTab
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ContentView.NavigationTab.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: selectedTab == tab ? .semibold : .medium))
                            .foregroundColor(selectedTab == tab ? tab.color : themeManager.currentTheme.colors.textSecondary)
                            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                        
                        Text(tab.title)
                            .font(.system(size: 10, weight: selectedTab == tab ? .semibold : .medium))
                            .foregroundColor(selectedTab == tab ? tab.color : themeManager.currentTheme.colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .opacity(0.8)
        )
        .optimized()
    }
}
