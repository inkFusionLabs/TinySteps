//
//  SettingsView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI
import LocalAuthentication
#if canImport(UIKit)
import UIKit
#endif

struct SettingsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var animateContent = false
    @State private var showingPrivacyPolicy = false
    @State private var showingHelpSupport = false
    @State private var showingAboutTinySteps = false
    @State private var showingDataRestore = false
    @State private var showingPerformance = false
    @State private var showingEditContact = false
    @State private var editingContact: EmergencyContact? = nil
    @State private var faceIDEnabled: Bool = false
    @State private var touchIDEnabled: Bool = false
    @State private var showingResetPassword = false
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var resetPasswordError: String? = nil
    @State private var resetPasswordSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Settings Banner
            VStack(alignment: .leading, spacing: 5) {
                Text("Dad's Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Manage your preferences and app settings.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal)
            .padding(.top)
            // Main Content
            ScrollView {
                VStack(spacing: 20) {
                    // Security Section
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.purple)
                            Text("Security")
                                .font(.headline)
                                .foregroundColor(.white)
                                .accessibilityLabel("Security settings")
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                        }
                        Toggle(isOn: $faceIDEnabled) {
                            Label("Enable Face ID", systemImage: "faceid")
                        }
                        .disabled(!isFaceIDAvailable())
                        .foregroundColor(.white)
                        .accessibilityLabel("Enable Face ID")
                        .accessibilityHint("Toggle Face ID authentication on or off.")
                        Toggle(isOn: $touchIDEnabled) {
                            Label("Enable Touch ID", systemImage: "touchid")
                        }
                        .disabled(!isTouchIDAvailable())
                        .foregroundColor(.white)
                        .accessibilityLabel("Enable Touch ID")
                        .accessibilityHint("Toggle Touch ID authentication on or off.")
                        Button(action: { showingResetPassword = true }) {
                            Label("Reset Password", systemImage: "key.fill")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Reset Password")
                        .accessibilityHint("Open the form to reset your password.")
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Emergency Contacts Section (moved above Data Management)
                    if !dataManager.emergencyContacts.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Emergency Contacts")
                                    .font(TinyStepsDesign.Typography.subheader)
                                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                Spacer()
                            }
                            ForEach(dataManager.emergencyContacts) { contact in
                                EmergencyContactCard(contact: contact, onEdit: { editContact in
                                    editingContact = editContact
                                    showingEditContact = true
                                })
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    
                    // App Information Section
                    VStack(spacing: 15) {
                        ProfileInfoRow(
                            icon: "info.circle.fill",
                            title: "App Version",
                            value: "1.0.0",
                            color: .green
                        )
                        
                        Button(action: {
                            showingDataRestore = true
                        }) {
                            ProfileInfoRow(
                                icon: "arrow.clockwise",
                                title: "Backup & Restore",
                                value: "Manage data",
                                color: .purple
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            showingPerformance = true
                        }) {
                            ProfileInfoRow(
                                icon: "speedometer",
                                title: "Performance",
                                value: "Optimize app",
                                color: .orange
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            showingHelpSupport = true
                        }) {
                            ProfileInfoRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                value: "Get assistance",
                                color: .yellow
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            showingAboutTinySteps = true
                        }) {
                            ProfileInfoRow(
                                icon: "info.circle.fill",
                                title: "About TinySteps",
                                value: "Learn more",
                                color: .cyan
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: { showingPrivacyPolicy = true }) {
                            ProfileInfoRow(
                                icon: "hand.raised.fill",
                                title: "Privacy Policy",
                                value: "View policy",
                                color: .blue
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    
                    // App Icon Section
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "app.fill")
                                .foregroundColor(.blue)
                            Text("App Icon")
                                .font(.headline)
                                .foregroundColor(.white)
                                .accessibilityLabel("App icon selection")
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                        }
                        let iconOptions: [(label: String, iconName: String?)] = [
                            ("Default", nil),
                            ("Dark", "AppIconDark"),
                            ("Tinted", "AppIconTinted")
                        ]
                        ForEach(iconOptions, id: \.iconName) { (label, iconName) in
                            Button(action: {
                                #if canImport(UIKit)
                                UIApplication.shared.setAlternateIconName(iconName) { error in
                                    // Optionally handle error
                                }
                                #endif
                            }) {
                                HStack {
                                    Text(label)
                                        .foregroundColor(.white)
                                    if UIApplication.shared.alternateIconName == iconName {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    }
                                    Spacer()
                                }
                            }
                            .accessibilityLabel("Switch to \(label) app icon")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Support Email Section
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                            Text("Contact Support")
                                .font(.headline)
                                .foregroundColor(.white)
                                .accessibilityLabel("Contact Support")
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                        }
                        Button(action: {
                            if let url = URL(string: "mailto:inkfusionlabs@icloud.com") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("inkfusionlabs@icloud.com")
                                .foregroundColor(.white)
                                .underline()
                        }
                        .accessibilityLabel("Email support at inkfusionlabs@icloud.com")
                        .accessibilityHint("Opens your email app to contact support.")
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingAboutTinySteps) {
            AboutTinyStepsView()
        }
        .sheet(isPresented: $showingDataRestore) {
            DataRestoreView()
        }
        .sheet(isPresented: $showingPerformance) {
            PerformanceSettingsView()
        }
        .sheet(isPresented: $showingEditContact) {
            if let contact = editingContact {
                EmergencyContactEditSheet(contact: $dataManager.emergencyContacts.first(where: { $0.id == contact.id })!)
            }
        }
        .sheet(isPresented: $showingResetPassword) {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Confirm New Password", text: $confirmNewPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let error = resetPasswordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                if resetPasswordSuccess {
                    Text("Password updated successfully!")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
                Button("Update Password") {
                    resetPasswordError = nil
                    resetPasswordSuccess = false
                    if newPassword.isEmpty || confirmNewPassword.isEmpty {
                        resetPasswordError = "Please fill in all fields."
                    } else if newPassword != confirmNewPassword {
                        resetPasswordError = "Passwords do not match."
                    } else {
                        UserDefaults.standard.set(newPassword, forKey: "registeredPassword")
                        resetPasswordSuccess = true
                        newPassword = ""
                        confirmNewPassword = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Cancel") {
                    showingResetPassword = false
                    newPassword = ""
                    confirmNewPassword = ""
                    resetPasswordError = nil
                    resetPasswordSuccess = false
                }
                .foregroundColor(.red)
            }
            .padding()
            .background(Color.white.opacity(0.95))
            .cornerRadius(16)
            .padding()
        }
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
    
    // Helper functions for biometrics
    private func isFaceIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && context.biometryType == .faceID
    }
    private func isTouchIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && context.biometryType == .touchID
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

// EmergencyContactCard View with edit button
struct EmergencyContactCard: View {
    let contact: EmergencyContact
    var onEdit: ((EmergencyContact) -> Void)? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: contact.isEmergency ? "exclamationmark.triangle.fill" : "person.fill")
                    .font(.title2)
                    .foregroundColor(contact.isEmergency ? .red : .blue)
                Text(contact.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if let url = URL(string: "tel:\(contact.phoneNumber)") {
                    Link(destination: url) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
                if let onEdit = onEdit {
                    Button(action: { onEdit(contact) }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
            }
            Text(contact.relationship)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text(contact.phoneNumber)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            if contact.isEmergency {
                Text("EMERGENCY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
            }
            if let notes = contact.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// EmergencyContactEditSheet
struct EmergencyContactEditSheet: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Binding var contact: EmergencyContact
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var relationship: String = ""
    @State private var phone: String = ""
    @State private var isEmergency: Bool = false
    @State private var notes: String = ""
    var body: some View {
        NavigationView {
            Form {
                Section("Contact Info") {
                    TextField("Name", text: $name)
                    TextField("Relationship", text: $relationship)
                    TextField("Phone Number", text: $phone)
                        .keyboardType(.phonePad)
                    Toggle("Emergency", isOn: $isEmergency)
                }
                Section("Notes") {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Edit Contact")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveContact()
                        dismiss()
                    }
                }
            }
            .onAppear {
                name = contact.name
                relationship = contact.relationship
                phone = contact.phoneNumber
                isEmergency = contact.isEmergency
                notes = contact.notes ?? ""
            }
        }
    }
    private func saveContact() {
        if let idx = dataManager.emergencyContacts.firstIndex(where: { $0.id == contact.id }) {
            dataManager.emergencyContacts[idx].name = name
            dataManager.emergencyContacts[idx].relationship = relationship
            dataManager.emergencyContacts[idx].phoneNumber = phone
            dataManager.emergencyContacts[idx].isEmergency = isEmergency
            dataManager.emergencyContacts[idx].notes = notes.isEmpty ? nil : notes
            dataManager.saveData()
        }
    }
}

struct HelpSupportView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
                        TinyStepsSectionHeader(
                            title: "Help & Support",
                            icon: "questionmark.circle.fill",
                            color: .yellow
                        )
                        
                        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                            TinyStepsInfoCard(
                                title: "Getting Started",
                                content: "Welcome to TinySteps! This app is designed specifically for dads with babies in NICU and beyond. Start by adding your baby's information and explore the different features to track your baby's journey.",
                                icon: "play.circle.fill",
                                color: TinyStepsDesign.Colors.accent
                            )
                            
                            TinyStepsInfoCard(
                                title: "Tracking Your Baby",
                                content: "Use the Tracking screen to monitor feeds, sleep, nappies, and other important metrics. The charts will help you visualize your baby's progress over time.",
                                icon: "chart.bar.fill",
                                color: TinyStepsDesign.Colors.success
                            )
                            
                            TinyStepsInfoCard(
                                title: "Milestones & Achievements",
                                content: "Celebrate your baby's milestones and unlock badges as they grow. Each milestone is a step forward in your baby's development journey.",
                                icon: "star.fill",
                                color: TinyStepsDesign.Colors.highlight
                            )
                            
                            TinyStepsInfoCard(
                                title: "Information Hub",
                                content: "Access comprehensive information about NICU care, feeding, health topics, and UK resources. Everything you need to support your baby's development.",
                                icon: "info.circle.fill",
                                color: TinyStepsDesign.Colors.info
                            )
                            
                            TinyStepsInfoCard(
                                title: "Support & Care",
                                content: "Find health visitor information, manage appointments, set reminders, and access parenting tips. Plus, locate nearby hospitals and medical facilities.",
                                icon: "heart.fill",
                                color: .pink
                            )
                            
                            TinyStepsInfoCard(
                                title: "Emergency Contacts",
                                content: "Store important contact information for family, friends, and healthcare providers. Quick access to emergency numbers when you need them most.",
                                icon: "phone.fill",
                                color: .red
                            )
                        }
                        .padding(.horizontal, TinyStepsDesign.Spacing.md)
                    }
                    .padding(.vertical, TinyStepsDesign.Spacing.lg)
                }
            }
            .navigationTitle("Help & Support")
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

struct AboutTinyStepsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
                        TinyStepsSectionHeader(
                            title: "About TinySteps",
                            icon: "info.circle.fill",
                            color: .cyan
                        )
                        
                        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                            TinyStepsInfoCard(
                                title: "Our Mission",
                                content: "TinySteps is dedicated to supporting dads through the challenging journey of having a baby in NICU and beyond. We believe every dad deserves the tools and information to be the best parent they can be.",
                                icon: "heart.fill",
                                color: .pink
                            )
                            
                            TinyStepsInfoCard(
                                title: "Built for Dads",
                                content: "This app was created specifically with dads in mind. We understand the unique challenges and emotions that come with having a baby in neonatal care, and we're here to support you every step of the way.",
                                icon: "figure.and.child.holdinghands",
                                color: TinyStepsDesign.Colors.accent
                            )
                            
                            TinyStepsInfoCard(
                                title: "Privacy First",
                                content: "Your baby's data stays on your device. We don't collect, store, or transmit any personal information. Your privacy and your baby's information are completely secure.",
                                icon: "lock.shield.fill",
                                color: TinyStepsDesign.Colors.success
                            )
                            
                            TinyStepsInfoCard(
                                title: "UK Focused",
                                content: "TinySteps is designed for UK families, with information and resources specific to the NHS, UK guidelines, and local support services available to you.",
                                icon: "flag.fill",
                                color: TinyStepsDesign.Colors.accent
                            )
                            
                            TinyStepsInfoCard(
                                title: "External Services Disclaimer",
                                content: "TinySteps provides information about healthcare services and organizations (NHS, Bliss, DadPad, March of Dimes, etc.) for informational purposes only. We are not affiliated with, endorsed by, or sponsored by any of these organizations. Please refer to their official websites for the most current information and policies.",
                                icon: "exclamationmark.triangle.fill",
                                color: .orange
                            )
                            
                            TinyStepsInfoCard(
                                title: "Version 1.0.0",
                                content: "This is the first version of TinySteps. We're committed to continuous improvement and adding new features based on feedback from dads like you.",
                                icon: "star.circle.fill",
                                color: TinyStepsDesign.Colors.highlight
                            )
                            
                            TinyStepsInfoCard(
                                title: "Contact & Feedback",
                                content: "We'd love to hear from you! Your feedback helps us improve TinySteps and make it better for all dads. Share your thoughts, suggestions, or report any issues.\n\nEmail: inkFusionLabs@icloud.com",
                                icon: "envelope.fill",
                                color: TinyStepsDesign.Colors.info
                            )
                        }
                        .padding(.horizontal, TinyStepsDesign.Spacing.md)
                    }
                    .padding(.vertical, TinyStepsDesign.Spacing.lg)
                }
            }
            .navigationTitle("About TinySteps")
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