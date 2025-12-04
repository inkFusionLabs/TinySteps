//
//  ContentView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
import Combine
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
    @State private var showSettings = false
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showTabMenu = false
    @Namespace private var tabNamespace
    
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
            case .progress: return "Track"
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
            ZStack {
                AnimatedAppBackground()
                // Force iPhone-style layout on all devices (including iPad)
                iPhoneLayout
            }
            .errorHandling()
        }
    }
    
    
    
    // MARK: - iPhone Layout
    private var iPhoneLayout: some View {
        ZStack {
            themeManager.currentTheme.colors.background.opacity(0.35)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.98)),
                    removal: .opacity.combined(with: .scale(scale: 1.02))
                ))
                .animation(.spring(response: 0.65, dampingFraction: 0.88), value: selectedTab)
                .onChange(of: selectedTab) { _, _ in
                    lastTabChangeTime = Date()
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showProfile) {
                NavigationView {
                    Text("Profile - Coming Soon")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(themeManager)
            }
        }
        .overlay(alignment: .bottom) {
            FloatingTabMenu(
                isOpen: $showTabMenu,
                selectedTab: $selectedTab,
                theme: themeManager.currentTheme.colors,
                namespace: tabNamespace,
                onSettingsTap: {
                    showSettings = true
                }
            )
            .responsivePadding(.bottom, 18)
            .parallaxed(8)
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToTab)) { output in
            guard let rawValue = output.userInfo?["tab"] as? String,
                  let destination = ContentView.NavigationTab(rawValue: rawValue) else { return }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = destination
                showTabMenu = false
            }
        }
    }
}

// MARK: - Floating Tab Menu

struct FloatingTabMenu: View {
    @Binding var isOpen: Bool
    @Binding var selectedTab: ContentView.NavigationTab
    let theme: ThemeColors
    let namespace: Namespace.ID
    var onSettingsTap: (() -> Void)? = nil

    @Environment(\.deviceLayout) private var deviceLayout

    @State private var isPulsing = false

    private var isIPad: Bool {
        deviceLayout.isIPad
    }

    private var buttonDiameter: CGFloat {
        deviceLayout.fontScaleMultiplier * 58
    }

    private var pulseDiameter: CGFloat {
        buttonDiameter + deviceLayout.spacingMultiplier * 6
    }

    var body: some View {
        VStack(spacing: deviceLayout.spacingMultiplier * 18) {
            if isOpen {
                HStack(spacing: deviceLayout.spacingMultiplier * 12) {
                    ForEach(Array(ContentView.NavigationTab.allCases.enumerated()), id: \.element.id) { index, tab in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedTab = tab
                                isOpen = false
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: tab.icon)
                                    .responsiveFont(size: 18, weight: .semibold)
                                    .scaleEffect(selectedTab == tab ? 1.05 : 0.95)
                                Text(tab.title)
                                    .font(.system(size: 9, weight: .regular))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .foregroundColor(.white)
                            .responsivePadding(.vertical, 10)
                            .responsivePadding(.horizontal, 14)
                            .background(
                                ZStack {
                                    if selectedTab == tab {
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        theme.accent,
                                                        theme.secondary,
                                                        theme.info
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .matchedGeometryEffect(id: "tabHighlight", in: namespace)
                                            .shadow(color: theme.shadow.opacity(0.5), radius: 12, x: 0, y: 6)
                                    } else {
                                        Capsule()
                                            .fill(theme.backgroundSecondary.opacity(0.9))
                                    }
                                }
                            )
                            .shadow(color: theme.shadow.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .cascadeAnimation(index: index, delay: 0.05)
                    }

                    // Settings Button
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            onSettingsTap?()
                            isOpen = false
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "gear")
                                .responsiveFont(size: 18, weight: .semibold)
                            Text("Settings")
                                .font(.system(size: 9, weight: .regular))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .foregroundColor(.white)
                        .responsivePadding(.vertical, 10)
                        .responsivePadding(.horizontal, 14)
                        .background(
                            Capsule()
                                .fill(theme.backgroundSecondary.opacity(0.9))
                        )
                        .shadow(color: theme.shadow.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .cascadeAnimation(index: ContentView.NavigationTab.allCases.count, delay: 0.05)
                }
                .padding(.top, 6)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isOpen.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.orange.opacity(0.35), lineWidth: 1.5)
                        .frame(width: pulseDiameter, height: pulseDiameter)
                        .scaleEffect(isPulsing ? 1.02 : 0.92)
                        .opacity(isPulsing ? 0 : 0.7)
                        .animation(
                            .easeInOut(duration: 1.8).repeatForever(autoreverses: false),
                            value: isPulsing
                        )
                    Image(systemName: isOpen ? "xmark" : "line.3.horizontal")
                        .font(.system(size: isIPad ? 28 : 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: buttonDiameter, height: buttonDiameter)
                        .background(
                            Circle()
                                .fill(Color.orange)
                                .shadow(color: Color.orange.opacity(0.45), radius: 14, x: 0, y: 8)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, isIPad ? 24 : 16)
        .onAppear {
            isPulsing = true
        }
    }
}

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
