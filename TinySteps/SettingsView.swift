//
//  SettingsView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingEditContact = false
    @State private var editingContact: EmergencyContact?
    @State private var showingAddContact = false
    @State private var showingDeleteAlert = false
    @State private var contactToDelete: EmergencyContact?
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        // Profile Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Profile")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ProfileInfoRow(
                                    icon: "person.fill",
                                    title: "Baby's Name",
                                    value: dataManager.baby?.name ?? "Not Set",
                                    color: DesignSystem.Colors.accent
                                )
                                
                                ProfileInfoRow(
                                    icon: "calendar",
                                    title: "Birth Date",
                                    value: dataManager.baby?.birthDate.formatted(date: .abbreviated, time: .omitted) ?? "Not Set",
                                    color: DesignSystem.Colors.success
                                )
                                
                                ProfileInfoRow(
                                    icon: "ruler",
                                    title: "Current Weight",
                                    value: dataManager.baby?.weight.map { String(format: "%.2f kg", $0) } ?? "Not Set",
                                    color: DesignSystem.Colors.warning
                                )
                            }
                        }
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Settings")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                NavigationLink(destination: Text("Notification Settings")) {
                                    ProfileInfoRow(
                                        icon: "bell.fill",
                                        title: "Notification Settings",
                                        value: "Configure",
                                        color: DesignSystem.Colors.warning
                                    )
                                }
                                
                                NavigationLink(destination: EmergencyContactsView()) {
                                    ProfileInfoRow(
                                        icon: "phone.fill",
                                        title: "Emergency Contacts",
                                        value: "\(dataManager.emergencyContacts.count) contacts",
                                        color: DesignSystem.Colors.error
                                    )
                                }
                            }
                        }
                        
                        // Privacy Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("Privacy")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                Text("Data Collection")
                                    .font(DesignSystem.Typography.body)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Text("TinySteps collects and stores your baby's data locally on your device. We do not collect, store, or transmit any personal information to external servers.")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("About")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                NavigationLink(destination: Text("About TinySteps")) {
                                    ProfileInfoRow(
                                        icon: "info.circle.fill",
                                        title: "About",
                                        value: "Version 1.0",
                                        color: .gray
                                    )
                                }
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.lg)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 20 : 16) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: isIPad ? 28 : 24, height: isIPad ? 28 : 24)
                .font(isIPad ? .title2 : .title3)
            
            VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
                Text(title)
                    .font(isIPad ? .system(size: 18, weight: .medium) : DesignSystem.Typography.body)
                    .themedText(style: .primary)
                
                Text(value)
                    .font(isIPad ? .system(size: 16) : DesignSystem.Typography.caption1)
                    .themedText(style: .secondary)
            }
            
            Spacer()
        }
        .padding(isIPad ? 20 : 16)
        .themedCard()
    }
}

#Preview {
    SettingsView()
        .environmentObject(BabyDataManager())
}