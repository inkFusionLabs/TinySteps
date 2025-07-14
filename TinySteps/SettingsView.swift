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
                    // Example Card
                    ZStack {
                        // Card content here
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferences")
                                .font(TinyStepsDesign.Typography.subheader)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                            // ... existing settings content ...
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    // ... repeat for other cards/buttons ...
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
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