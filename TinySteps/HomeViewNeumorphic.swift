//
//  HomeViewNeumorphic.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct HomeViewNeumorphic: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @StateObject private var systemManager = SystemManager.shared
    @State private var showingBabyForm = false
    @State private var showingEmergencyContacts = false
    @State private var isAnimating = false
    @State private var cardOffset: CGFloat = 0
    @State private var showingInformationHub = false
    
    var body: some View {
        ZStack {
            // Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                        .slideIn(from: .fromTop)
                    
                    // Quick Actions Grid
                    quickActionsSection
                        .slideIn(from: .fromLeft)
                    
                    // Baby Info Card
                    if let baby = dataManager.baby {
                        babyInfoCard(baby: baby)
                            .slideIn(from: .fromRight)
                    } else {
                        emptyBabyCard
                            .slideIn(from: .fromRight)
                    }
                    
                    // Information Hub
                    informationHubSection
                        .slideIn(from: .fromBottom)
                    
                    // Emergency Contacts
                    emergencyContactsSection
                        .slideIn(from: .fromBottom)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .onAppear {
                withAnimation(TinyStepsDesign.Animations.gentle) {
                    isAnimating = true
                }
            }
        }
        .sheet(isPresented: $showingBabyForm) {
            BabyFormView()
        }
        .sheet(isPresented: $showingEmergencyContacts) {
            EmergencyContactsView()
        }
        .sheet(isPresented: $showingInformationHub) {
            InformationHubView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome Back!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                    
                    Text("Track your baby's journey")
                        .font(.subheadline)
                        .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                }
                
                Spacer()
                
                // Profile Button
                TinyStepsIconButton(
                    icon: "person.circle.fill",
                    color: TinyStepsDesign.NeumorphicColors.primary,
                    size: 28,
                    action: {
                        // Profile action
                    }
                )
            }
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                TinyStepsSectionHeader(
                    title: "Quick Actions",
                    icon: "bolt.fill"
                )
            
            ResponsiveGrid(columns: 2, spacing: 16) {
                QuickActionButton(
                    title: "Feed",
                    icon: "drop.fill",
                    color: TinyStepsDesign.NeumorphicColors.primary,
                    action: { /* Feed action */ }
                )
                .animation(TinyStepsDesign.Animations.slideIn.delay(0.1), value: isAnimating)
                
                QuickActionButton(
                    title: "Diaper",
                    icon: "heart.fill",
                    color: TinyStepsDesign.NeumorphicColors.success,
                    action: { /* Diaper action */ }
                )
                .animation(TinyStepsDesign.Animations.slideIn.delay(0.2), value: isAnimating)
                
                QuickActionButton(
                    title: "Sleep",
                    icon: "moon.fill",
                    color: TinyStepsDesign.NeumorphicColors.success,
                    action: { /* Sleep action */ }
                )
                .animation(TinyStepsDesign.Animations.slideIn.delay(0.3), value: isAnimating)
                
                QuickActionButton(
                    title: "Weight",
                    icon: "scalemass.fill",
                    color: TinyStepsDesign.NeumorphicColors.warning,
                    action: { /* Weight action */ }
                )
                .animation(TinyStepsDesign.Animations.slideIn.delay(0.4), value: isAnimating)
            }
        }
    }
    
    // MARK: - Baby Info Card
    private func babyInfoCard(baby: Baby) -> some View {
        TinyStepsCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(baby.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                        
                        Text("Born \(baby.birthDate, style: .date)")
                            .font(.subheadline)
                            .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Baby Avatar
                    Circle()
                        .fill(TinyStepsDesign.NeumorphicColors.primary.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(TinyStepsDesign.NeumorphicColors.primary)
                        )
                }
                
                // Stats Row
                HStack(spacing: 20) {
                    StatItem(title: "Age", value: "\(baby.ageInDays) days")
                    StatItem(title: "Weight", value: String(format: "%.1f kg", baby.weight ?? 0))
                    StatItem(title: "Height", value: String(format: "%.1f cm", baby.height ?? 0))
                }
            }
        }
    }
    
    // MARK: - Empty Baby Card
    private var emptyBabyCard: some View {
        TinyStepsCard {
            VStack(spacing: 16) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 48))
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.primary)
                
                Text("Add Your Baby")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                
                Text("Start tracking your baby's journey by adding their information")
                    .font(.subheadline)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                TinyStepsButton(
                    backgroundColor: TinyStepsDesign.NeumorphicColors.primary,
                    foregroundColor: .white,
                    cornerRadius: 12,
                    isEnabled: true,
                    action: {
                        showingBabyForm = true
                    }
                ) {
                    HStack {
                        Text("Add Baby")
                            .fontWeight(.semibold)
                        Image(systemName: "plus")
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Information Hub Section
    private var informationHubSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                TinyStepsSectionHeader(
                    title: "Information Hub",
                    icon: "info.circle.fill"
                )
            
            VStack(spacing: 12) {
                Button(action: {
                    showingInformationHub = true
                }) {
                    TinyStepsInfoCard(
                        title: "Development Milestones",
                        content: "Track your baby's growth and development",
                        icon: "chart.line.uptrend.xyaxis",
                        color: TinyStepsDesign.NeumorphicColors.primary
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingInformationHub = true
                }) {
                    TinyStepsInfoCard(
                        title: "Health & Safety",
                        content: "Important health information and safety tips",
                        icon: "heart.text.square",
                        color: TinyStepsDesign.NeumorphicColors.success
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingInformationHub = true
                }) {
                    TinyStepsInfoCard(
                        title: "Parenting Tips",
                        content: "Expert advice and parenting resources",
                        icon: "lightbulb",
                        color: TinyStepsDesign.NeumorphicColors.warning
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Emergency Contacts Section
    private var emergencyContactsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                TinyStepsSectionHeader(
                    title: "Emergency Contacts",
                    icon: "phone.fill"
                )
            
            TinyStepsCard {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Emergency Services")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                        
                        Text("911 (US) / 999 (UK) / 112 (EU)")
                            .font(.subheadline)
                            .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    TinyStepsIconButton(
                        icon: "phone.fill",
                        color: TinyStepsDesign.NeumorphicColors.error,
                        size: 20,
                        action: {
                            // Call emergency services
                        }
                    )
                }
            }
            
            TinyStepsButton(
                backgroundColor: TinyStepsDesign.NeumorphicColors.primary,
                foregroundColor: .white,
                cornerRadius: 12,
                isEnabled: true,
                action: {
                    showingEmergencyContacts = true
                }
            ) {
                HStack {
                    Text("View All Contacts")
                        .fontWeight(.semibold)
                    Image(systemName: "phone")
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
struct HomeViewNeumorphic_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewNeumorphic()
            .environmentObject(BabyDataManager())
    }
}