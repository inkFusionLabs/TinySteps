//
//  HomeView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var animateCards = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            themeManager.currentTheme.colors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(20)) {
                    // Welcome Header - Enhanced with responsive components
                    VStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(10)) {
                        DesignSystem.iPadOptimization.ResponsiveText(
                            "Welcome Back, Dad!",
                            style: .primary,
                            alignment: .center
                        )
                        .font(.system(size: isIPad ? 48 : 28, weight: .bold))
                        
                        if let baby = dataManager.baby {
                            DesignSystem.iPadOptimization.ResponsiveText(
                                "How is \(baby.name) doing today?",
                                style: .secondary,
                                alignment: .center
                            )
                            .font(.system(size: isIPad ? 24 : 18, weight: .medium))
                        }
                    }
                    .padding(.top, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(20))
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                    
                    // Quick Stats Cards - Enhanced with iPad optimization
                    DesignSystem.iPadOptimization.iPadGridLayout(style: .standard) {
                        QuickStatCard(
                            title: "Today's Feeds",
                            value: "\(dataManager.getTodayFeedingCount())",
                            icon: "drop.fill",
                            color: themeManager.currentTheme.colors.accent
                        )
                        .offset(x: animateCards ? 0 : -50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                        
                        QuickStatCard(
                            title: "Sleep Hours",
                            value: String(format: "%.1f", dataManager.getTodaySleepHours()),
                            icon: "moon.fill",
                            color: themeManager.currentTheme.colors.primary
                        )
                        .offset(x: animateCards ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                        
                        QuickStatCard(
                            title: "Nappy Changes",
                            value: "\(dataManager.getTodayNappyCount())",
                            icon: "drop",
                            color: themeManager.currentTheme.colors.secondary
                        )
                        .offset(x: animateCards ? 0 : -50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
                        
                        QuickStatCard(
                            title: "Milestones",
                            value: "\(dataManager.milestones.count)",
                            icon: "star.fill",
                            color: themeManager.currentTheme.colors.warning
                        )
                        .offset(x: animateCards ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
                        
                        // Additional cards for iPad
                        if isIPad {
                            QuickStatCard(
                                title: "Weight",
                                value: "3.2kg",
                                icon: "scalemass.fill",
                                color: themeManager.currentTheme.colors.info
                            )
                            .offset(x: animateCards ? 0 : -50)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
                            
                            QuickStatCard(
                                title: "Temperature",
                                value: "36.5°C",
                                icon: "thermometer",
                                color: themeManager.currentTheme.colors.error
                            )
                            .offset(x: animateCards ? 0 : 50)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
                        }
                    }
                    .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                    
                    // Quick Actions - Enhanced with responsive components
                    VStack(alignment: .leading, spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(15)) {
                        DesignSystem.iPadOptimization.ResponsiveSectionHeader(
                            "Quick Actions",
                            subtitle: "Tap to perform common tasks"
                        )
                        
                        DesignSystem.iPadOptimization.iPadGridLayout(style: .standard) {
                            QuickActionCard(
                                title: "Log Feeding",
                                icon: "drop.fill",
                                color: .green
                            ) {
                                // Action for logging feeding
                            }
                            
                            QuickActionCard(
                                title: "Add Milestone",
                                icon: "star.fill",
                                color: .yellow
                            ) {
                                // Action for adding milestone
                            }
                            
                            QuickActionCard(
                                title: "Record Weight",
                                icon: "scalemass.fill",
                                color: .blue
                            ) {
                                // Action for recording weight
                            }
                            
                            QuickActionCard(
                                title: "View History",
                                icon: "clock.fill",
                                color: .purple
                            ) {
                                // Action for viewing history
                            }
                            
                            // Additional actions for iPad
                            if isIPad {
                                QuickActionCard(
                                    title: "Take Photo",
                                    icon: "camera.fill",
                                    color: .orange
                                ) {
                                    // Action for taking photo
                                }
                                
                                QuickActionCard(
                                    title: "Emergency",
                                    icon: "phone.fill",
                                    color: .red
                                ) {
                                    // Action for emergency
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                    }
                    
                    // Today's Tip - Enhanced with responsive components
                    VStack(alignment: .leading, spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(15)) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: isIPad ? 28 : 22, weight: .medium))
                            DesignSystem.iPadOptimization.ResponsiveText(
                                "Today's Dad Tip",
                                style: .primary
                            )
                            .font(.system(size: isIPad ? 28 : 22, weight: .bold))
                        }
                        .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                        
                        DesignSystem.iPadOptimization.iPadCard(style: .elevated) {
                            VStack(alignment: .leading, spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(10)) {
                                DesignSystem.iPadOptimization.ResponsiveText(
                                    "Skin-to-Skin Contact",
                                    style: .primary
                                )
                                .font(.system(size: isIPad ? 22 : 18, weight: .semibold))
                                
                                DesignSystem.iPadOptimization.ResponsiveText(
                                    "Hold your baby against your bare chest. It helps with bonding, regulates their temperature, and can improve their breathing and heart rate.",
                                    style: .secondary
                                )
                                .font(.system(size: isIPad ? 18 : 16))
                                .lineSpacing(isIPad ? 6 : 4)
                            }
                        }
                        .padding(.horizontal, DesignSystem.iPadOptimization.AdaptiveSpacing.padding(16))
                    }
                }
                .padding(.bottom, isIPad ? 120 : 100)
            }
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        DesignSystem.iPadOptimization.iPadCard(style: .standard) {
            VStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(8)) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 48 : 24, weight: .bold))
                    .foregroundColor(color)
                
                DesignSystem.iPadOptimization.ResponsiveText(
                    value,
                    style: .primary
                )
                .font(.system(size: isIPad ? 36 : 20, weight: .bold))
                
                DesignSystem.iPadOptimization.ResponsiveText(
                    title,
                    style: .secondary,
                    alignment: .center
                )
                .font(.system(size: isIPad ? 20 : 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: isIPad ? 200 : 120)
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            DesignSystem.iPadOptimization.iPadCard(style: .compact) {
                VStack(spacing: DesignSystem.iPadOptimization.AdaptiveSpacing.spacing(8)) {
                    Image(systemName: icon)
                        .font(.system(size: isIPad ? 48 : 24, weight: .bold))
                        .foregroundColor(color)
                    
                    DesignSystem.iPadOptimization.ResponsiveText(
                        title,
                        style: .primary,
                        alignment: .center
                    )
                    .font(.system(size: isIPad ? 24 : 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .frame(height: isIPad ? 200 : 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
        .environmentObject(BabyDataManager())
        .environmentObject(ThemeManager.shared)
}

