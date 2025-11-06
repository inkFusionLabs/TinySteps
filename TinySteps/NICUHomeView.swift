//
//  NICUHomeView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

struct NICUHomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var animateContent = false
    @State private var showEncouragement = false
    @State private var showEditContacts = false
    @AppStorage("nicuNurseNumber") private var nicuNurseNumber: String = "Ext. 1234"
    @AppStorage("nicuDoctorNumber") private var nicuDoctorNumber: String = "Ext. 5678"
    @AppStorage("nicuSocialWorkerNumber") private var nicuSocialWorkerNumber: String = "Ext. 9012"
    
    // Performance optimizations
    @State private var isViewVisible = true
    @State private var cachedQuickStats: QuickStatsData?
    @State private var lastStatsUpdate = Date()
    @State private var currentTipIndex: Int = 0
    @State private var cachedTips: [String] = []
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        ZStack {
            // Background
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: isIPad ? 80 : 24) {
                    // NICU Dad Header
                    VStack(spacing: isIPad ? 24 : 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: isIPad ? 12 : 8) {
                                Text("You're doing great, Dad")
                                    .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                                    .fontWeight(.bold)
                                    .themedText(style: .primary)
                                
                                Text("Every day in the NICU is a step forward")
                                    .font(isIPad ? .system(size: 24, weight: .medium) : .subheadline)
                                    .themedText(style: .secondary)
                            }
                            Spacer()
                            
                            // Encouragement button
                            Button(action: { showEncouragement = true }) {
                                Image(systemName: "heart.fill")
                                    .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                                    .foregroundColor(themeManager.currentTheme.colors.error)
                            }
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                        .padding(.top, isIPad ? 32 : 20)
                    }
                    
                    // Today's Focus Cards
                    VStack(alignment: .leading, spacing: isIPad ? 24 : 16) {
                        Text("Today's Focus")
                            .font(isIPad ? .title2 : .headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal, isIPad ? 32 : 20)
                        
                            LazyVGrid(columns: isIPad ? [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ] : [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: isIPad ? 32 : 16) {
                            NICUActionCard(
                                title: "Skin-to-Skin",
                                description: "Hold your baby close",
                                icon: "heart.fill",
                                color: themeManager.currentTheme.colors.error,
                                action: { /* Handle skin-to-skin */ }
                            )
                            
                            NICUActionCard(
                                title: "Talk to Baby",
                                description: "Your voice matters",
                                icon: "message.fill",
                                color: themeManager.currentTheme.colors.accent,
                                action: { /* Handle talking */ }
                            )
                            
                            NICUActionCard(
                                title: "Ask Questions",
                                description: "Stay informed",
                                icon: "questionmark.circle.fill",
                                color: themeManager.currentTheme.colors.info,
                                action: { /* Handle questions */ }
                            )
                            
                            NICUActionCard(
                                title: "Take Photos",
                                description: "Capture moments",
                                icon: "camera.fill",
                                color: themeManager.currentTheme.colors.warning,
                                action: { /* Handle photos */ }
                            )
                            
                            // Additional cards for iPad 3-column layout
                            if isIPad {
                                NICUActionCard(
                                    title: "Read Stories",
                                    description: "Bond with baby",
                                    icon: "book.fill",
                                    color: themeManager.currentTheme.colors.info,
                                    action: { /* Handle stories */ }
                                )
                                
                                NICUActionCard(
                                    title: "Track Progress",
                                    description: "Monitor growth",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: themeManager.currentTheme.colors.success,
                                    action: { /* Handle progress */ }
                                )
                            }
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                    }
                    
                    // Quick Journal Bar
                    QuickJournalBar()
                        .padding(.horizontal, isIPad ? 32 : 20)
                    
                    // Nurse on Shift Section
                    NurseShiftSection()
                        .padding(.horizontal, isIPad ? 32 : 20)
                    
                    // Baby's Progress Summary removed; Progress lives on its dedicated tab
                    
                    // Tip of the Day
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("ui.tip.title", comment: "Tip of the Day"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal)
                        
                        let tips = cachedTips
                        if !tips.isEmpty {
                            let tip = tips[currentTipIndex % tips.count]
                            VStack(alignment: .leading, spacing: 12) {
                                Text(tip)
                                    .font(isIPad ? .title3 : .body)
                                    .themedText(style: .secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                HStack(spacing: 12) {
                                    Button(action: { currentTipIndex = (currentTipIndex + 1) % tips.count }) {
                                        Text(NSLocalizedString("ui.see.next", comment: "See another"))
                                            .font(isIPad ? .headline : .subheadline)
                                            .foregroundColor(.white)
                                            .padding(.vertical, isIPad ? 12 : 8)
                                            .padding(.horizontal, isIPad ? 16 : 12)
                                            .background(themeManager.currentTheme.colors.accent)
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: { saveTipToJournal(tip) }) {
                                        Text(NSLocalizedString("ui.add.to.journal", comment: "Save to journal"))
                                            .font(isIPad ? .headline : .subheadline)
                                            .foregroundColor(.white)
                                            .padding(.vertical, isIPad ? 12 : 8)
                                            .padding(.horizontal, isIPad ? 16 : 12)
                                            .background(themeManager.currentTheme.colors.primary)
                                            .cornerRadius(10)
                                    }
                                    .accessibilityLabel(Text("Save tip to journal"))
                                }
                            }
                            .padding(isIPad ? 20 : 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themeManager.currentTheme.colors.backgroundSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                            .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // Daily Encouragement
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Daily Encouragement")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            EncouragementCard(
                                message: "You're stronger than you know. Every visit, every touch, every moment matters.",
                                author: "NICU Dad Community"
                            )
                            
                            EncouragementCard(
                                message: "It's okay to feel overwhelmed. Take it one day at a time.",
                                author: "NICU Support Team"
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Emergency Contacts
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Quick Contacts")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            Spacer()
                            
                            Button(action: { showEditContacts = true }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(themeManager.currentTheme.colors.accent)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            QuickContactRow(
                                name: "NICU Nurse Station",
                                number: nicuNurseNumber,
                                icon: "phone.fill",
                                color: themeManager.currentTheme.colors.error
                            )
                            
                            QuickContactRow(
                                name: "NICU Doctor",
                                number: nicuDoctorNumber,
                                icon: "stethoscope",
                                color: themeManager.currentTheme.colors.info
                            )
                            
                            QuickContactRow(
                                name: "Social Worker",
                                number: nicuSocialWorkerNumber,
                                icon: "person.2.fill",
                                color: themeManager.currentTheme.colors.secondary
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // UK Support Resources
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("UK Support Resources")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            Spacer()
                            
                            Image(systemName: "flag.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            UKSupportRow(
                                name: "Bliss Charity",
                                number: "0808 801 0322",
                                description: "Premature baby support",
                                icon: "heart.fill",
                                color: .pink
                            )
                            
                            UKSupportRow(
                                name: "NHS 111",
                                number: "111",
                                description: "Non-emergency health advice",
                                icon: "cross.case.fill",
                                color: .blue
                            )
                            
                            UKSupportRow(
                                name: "Samaritans",
                                number: "116 123",
                                description: "24/7 emotional support",
                                icon: "phone.fill",
                                color: .green
                            )
                            
                            UKSupportRow(
                                name: "Mind",
                                number: "0300 123 3393",
                                description: "Mental health support",
                                icon: "brain.head.profile",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateContent = true
            }
            // Initialize tip index based on day for determinism
            if let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) {
                currentTipIndex = max(0, day - 1)
            }
            if cachedTips.isEmpty {
                cachedTips = TipsManager.allTips()
            }
        }
        .sheet(isPresented: $showEncouragement) {
            EncouragementView()
        }
        .sheet(isPresented: $showEditContacts) {
            EditContactsView(
                nicuNurseNumber: $nicuNurseNumber,
                nicuDoctorNumber: $nicuDoctorNumber,
                nicuSocialWorkerNumber: $nicuSocialWorkerNumber
            )
        }
    }
}

// MARK: - NICU Action Card
struct NICUActionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: isIPad ? 20 : 12) {
                Image(systemName: icon)
                    .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                    .foregroundColor(color)
                
                VStack(spacing: isIPad ? 8 : 4) {
                    Text(title)
                        .font(isIPad ? .system(size: 24, weight: .bold) : .headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(isIPad ? .system(size: 16, weight: .medium) : .caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isIPad ? 200 : 120)
            .padding(isIPad ? 32 : 16)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                    .fill(color.opacity(0.2))
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Save tip to journal helper
extension NICUHomeView {
    func saveTipToJournal(_ tip: String) {
        let entry = JournalEntry(
            title: NSLocalizedString("ui.tip.title", comment: "Tip of the Day"),
            content: tip,
            mood: .neutral,
            tags: [.hope]
        )
        DataPersistenceManager.shared.addJournalEntry(entry)
    }
}

// MARK: - NICU Progress Row
struct NICUProgressRow: View {
    let title: String
    let value: String
    let trend: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(trend)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Encouragement Card
struct EncouragementCard: View {
    let message: String
    let author: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Text("— \(author)")
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .subheadline : .caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ThemeManager.shared.currentTheme.colors.backgroundSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                        .stroke(ThemeManager.shared.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Quick Contact Row
struct QuickContactRow: View {
    let name: String
    let number: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12) {
            Image(systemName: icon)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3)
                .foregroundColor(color)
                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 28 : 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .headline : .subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(number)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .subheadline : .caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: { /* Handle call */ }) {
                Image(systemName: "phone.fill")
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3)
                    .foregroundColor(color)
            }
        }
        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ThemeManager.shared.currentTheme.colors.backgroundSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                        .stroke(ThemeManager.shared.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Encouragement View
struct EncouragementView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    let encouragements = [
        "You're not alone in this journey. Every NICU dad has felt exactly what you're feeling right now.",
        "Your presence matters more than you know. Your baby recognizes your voice and your touch.",
        "It's okay to cry, to feel scared, to feel overwhelmed. These feelings don't make you weak - they make you human.",
        "Every small step forward is a victory. Celebrate the little wins, they add up to big progress.",
        "You're doing the hardest job in the world with grace and strength. Be proud of yourself.",
        "Take care of yourself too. You can't pour from an empty cup. Your baby needs you to be strong.",
        "The NICU journey is a marathon, not a sprint. Pace yourself and be patient with the process.",
        "Your love and dedication are making a difference, even when it doesn't feel like it."
    ]
    
    @State private var currentEncouragement = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(themeManager.currentTheme.colors.error)
                
                Text("You've Got This, Dad")
                    .font(.title)
                    .fontWeight(.bold)
                    .themedText(style: .primary)
                
                Text(encouragements[currentEncouragement])
                    .font(.body)
                    .themedText(style: .secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        currentEncouragement = (currentEncouragement + 1) % encouragements.count
                    }
                }) {
                    Text("Another One")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.currentTheme.colors.primary)
                        )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Encouragement")
            .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Edit Contacts View
struct EditContactsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var nicuNurseNumber: String
    @Binding var nicuDoctorNumber: String
    @Binding var nicuSocialWorkerNumber: String
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.colors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 32 : 24) {
                        // Header Section
                        VStack(spacing: isIPad ? 16 : 12) {
                            Image(systemName: "phone.fill")
                                .font(.system(size: isIPad ? 48 : 40, weight: .medium))
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                            
                            Text("Edit NICU Contacts")
                                .font(isIPad ? .system(size: 32, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Add your NICU's contact numbers")
                                .font(isIPad ? .system(size: 18) : .body)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                        .padding(.top, isIPad ? 24 : 20)
                        
                        // Contact Fields
                        VStack(spacing: isIPad ? 20 : 16) {
                            ContactEditField(
                                title: "NICU Nurse Station",
                                icon: "phone.fill",
                                color: themeManager.currentTheme.colors.error,
                                text: $nicuNurseNumber,
                                placeholder: "Ext. 1234 or +44 123 456 7890"
                            )
                            
                            ContactEditField(
                                title: "NICU Doctor",
                                icon: "stethoscope",
                                color: themeManager.currentTheme.colors.info,
                                text: $nicuDoctorNumber,
                                placeholder: "Ext. 5678 or +44 123 456 7891"
                            )
                            
                            ContactEditField(
                                title: "Social Worker",
                                icon: "person.2.fill",
                                color: themeManager.currentTheme.colors.secondary,
                                text: $nicuSocialWorkerNumber,
                                placeholder: "Ext. 9012 or +44 123 456 7892"
                            )
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(
                // Custom Header
                VStack {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                        .fontWeight(.medium)
                        .themedText(style: .primary)
                        
                        Spacer()
                        
                        Button("Save") {
                            dismiss()
                        }
                        .font(isIPad ? .system(size: 18, weight: .semibold) : .body)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.currentTheme.colors.primary)
                    }
                    .padding(.horizontal, isIPad ? 32 : 20)
                    .padding(.top, isIPad ? 16 : 12)
                    .padding(.bottom, isIPad ? 12 : 8)
                    .background(themeManager.currentTheme.colors.background.opacity(0.95))
                    
                    Spacer()
                }
            )
        }
    }
}

// MARK: - Contact Edit Field
struct ContactEditField: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var text: String
    let placeholder: String
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 12 : 8) {
            HStack(spacing: isIPad ? 12 : 8) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 22 : 20, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(isIPad ? .system(size: 20, weight: .semibold) : .headline)
                    .themedText(style: .primary)
            }
            
            TextField(placeholder, text: $text)
                .font(isIPad ? .system(size: 18) : .body)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .padding(.horizontal, isIPad ? 18 : 14)
                .padding(.vertical, isIPad ? 14 : 10)
                .background(themeManager.currentTheme.colors.backgroundSecondary)
                .cornerRadius(isIPad ? 14 : 10)
                .overlay(
                    RoundedRectangle(cornerRadius: isIPad ? 14 : 10)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        }
    }
}

// MARK: - UK Support Row
struct UKSupportRow: View {
    let name: String
    let number: String
    let description: String
    let icon: String
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel:\(number)") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: isIPad ? 16 : 12) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 24 : 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: isIPad ? 32 : 28, height: isIPad ? 32 : 28)
                
                VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
                    Text(name)
                        .font(isIPad ? .system(size: 20, weight: .semibold) : .headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(isIPad ? .system(size: 16) : .caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: isIPad ? 4 : 2) {
                    Text(number)
                        .font(isIPad ? .system(size: 18, weight: .semibold) : .subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                    
                    Text("Tap to call")
                        .font(isIPad ? .system(size: 14) : .caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, isIPad ? 20 : 16)
            .padding(.vertical, isIPad ? 16 : 12)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                            .fill(.ultraThinMaterial)
                            .opacity(0.6)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Performance Optimization Components

struct QuickStatsData {
    let todayFeedingCount: Int
    let todayNappyCount: Int
    let todaySleepHours: Double
    let lastFeedingTime: Date?
    let nextFeedingTime: Date?
    let lastUpdate: Date
}

// Optimized Quick Stats View
struct OptimizedQuickStatsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var cachedStats: QuickStatsData?
    @State private var lastUpdate = Date()
    
    private let cacheValidityDuration: TimeInterval = 60 // 1 minute
    
    var body: some View {
        let stats = getCachedStats()
        
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                QuickStatCard(
                    title: "Today's Feeds",
                    value: "\(stats.todayFeedingCount)",
                    icon: "drop.fill",
                    color: .blue
                )
                
                QuickStatCard(
                    title: "Today's Nappies",
                    value: "\(stats.todayNappyCount)",
                    icon: "wind",
                    color: .green
                )
            }
            
            HStack(spacing: 20) {
                QuickStatCard(
                    title: "Sleep Hours",
                    value: String(format: "%.1fh", stats.todaySleepHours),
                    icon: "moon.fill",
                    color: .purple
                )
                
                QuickStatCard(
                    title: "Last Feed",
                    value: formatLastFeedingTime(stats.lastFeedingTime),
                    icon: "clock.fill",
                    color: .orange
                )
            }
        }
        .optimized()
    }
    
    private func getCachedStats() -> QuickStatsData {
        let now = Date()
        
        if let cached = cachedStats,
           now.timeIntervalSince(cached.lastUpdate) < cacheValidityDuration {
            return cached
        }
        
        let stats = QuickStatsData(
            todayFeedingCount: dataManager.getTodayFeedingCount(),
            todayNappyCount: dataManager.getTodayNappyCount(),
            todaySleepHours: dataManager.getTodaySleepHours(),
            lastFeedingTime: dataManager.feedingRecords.last?.date,
            nextFeedingTime: calculateNextFeedingTime(),
            lastUpdate: now
        )
        
        cachedStats = stats
        return stats
    }
    
    private func calculateNextFeedingTime() -> Date? {
        guard let lastFeeding = dataManager.feedingRecords.last else { return nil }
        return Calendar.current.date(byAdding: .hour, value: 3, to: lastFeeding.date)
    }
    
    private func formatLastFeedingTime(_ date: Date?) -> String {
        guard let date = date else { return "None" }
        return Self.timeFormatter.string(from: date)
    }
    
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()
}

// Optimized Quick Stat Card
struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .optimized()
    }
}

#Preview {
    NICUHomeView()
        .environmentObject(BabyDataManager())
        .environmentObject(ThemeManager.shared)
}

