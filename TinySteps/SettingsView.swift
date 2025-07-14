//
//  SettingsView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateContent = false
    @State private var showingExportSheet = false
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Settings Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.tools, color: TinyStepsDesign.Colors.accent)
                Text("Dad's Settings")
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
            ScrollView {
                VStack(spacing: 20) {
                    // Data Management Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Data Management")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            Spacer()
                        }
                        
                        Button(action: { showingExportSheet = true }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                Text("Export Data")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Button(action: { showingResetAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Reset All Data")
                                    .foregroundColor(.red)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // Support Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Support & Information")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            Spacer()
                        }
                        
                        Button(action: { showingPrivacyPolicy = true }) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                Text("Privacy Policy")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Link(destination: URL(string: "https://www.bliss.org.uk")!) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                                Text("Bliss - Supporting Premature Babies")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Link(destination: URL(string: "https://www.nhs.uk")!) {
                            HStack {
                                Image(systemName: "cross.fill")
                                    .foregroundColor(.green)
                                Text("NHS - Health Information")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // App Info Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("App Information")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            Spacer()
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Version")
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                                Spacer()
                                Text("1.0.0")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                            
                            HStack {
                                Text("Build")
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                                Spacer()
                                Text("1")
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .sheet(isPresented: $showingExportSheet) {
            NavigationView {
                DataExportView()
            }
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your baby's data. This action cannot be undone.")
        }
    }
    
    private func resetAllData() {
        dataManager.baby = nil
        dataManager.feedingRecords.removeAll()
        dataManager.nappyRecords.removeAll()
        dataManager.sleepRecords.removeAll()
        dataManager.milestones.removeAll()
        dataManager.achievements.removeAll()
        dataManager.reminders.removeAll()
        dataManager.vaccinations.removeAll()
        dataManager.solidFoodRecords.removeAll()
        dataManager.saveData()
    }
    
    private func getURLForContact(_ contact: String) -> URL? {
        switch contact {
        case "NHS 111": return URL(string: "tel:111")
        case "NHS 999": return URL(string: "tel:999")
        case "Bliss Helpline": return URL(string: "tel:08088010322")
        case "NCT Helpline": return URL(string: "tel:03003300700")
        case "Samaritans": return URL(string: "tel:116123")
        case "CALM": return URL(string: "tel:0800585858")
        default: return nil
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
                        TinyStepsSectionHeader(
                            title: "Privacy Policy",
                            icon: "hand.raised.fill",
                            color: TinyStepsDesign.Colors.accent
                        )
                        
                        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                            TinyStepsInfoCard(
                                title: "Data Collection",
                                content: "TinySteps collects and stores your baby's data locally on your device. We do not collect, store, or transmit any personal information to external servers.",
                                icon: "lock.shield.fill",
                                color: TinyStepsDesign.Colors.success
                            )
                            
                            TinyStepsInfoCard(
                                title: "Data Usage",
                                content: "All data is used solely for the purpose of tracking your baby's development and providing you with relevant information and insights.",
                                icon: "chart.line.uptrend.xyaxis",
                                color: TinyStepsDesign.Colors.info
                            )
                            
                            TinyStepsInfoCard(
                                title: "Data Security",
                                content: "Your data is stored securely on your device using iOS security features. We recommend keeping your device updated and using a passcode.",
                                icon: "key.fill",
                                color: TinyStepsDesign.Colors.warning
                            )
                            
                            TinyStepsInfoCard(
                                title: "Third-Party Services",
                                content: "TinySteps may link to external resources (NHS, charities) for additional information. These services have their own privacy policies.",
                                icon: "link",
                                color: TinyStepsDesign.Colors.accent
                            )
                        }
                        .padding(.horizontal, TinyStepsDesign.Spacing.md)
                    }
                    .padding(.vertical, TinyStepsDesign.Spacing.lg)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 