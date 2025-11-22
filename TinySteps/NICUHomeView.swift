//
//  NICUHomeView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI
import Combine

struct NICUHomeView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var animateContent = false
    @State private var showEncouragement = false
    @State private var showEditContacts = false
    @State private var showSkinToSkinTimer = false
    @State private var showTalkToBabyTips = false
    @State private var showQuestionManager = false
    @State private var showStorySuggestions = false
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
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                themeManager.currentTheme.colors.textPrimary,
                                                themeManager.currentTheme.colors.textPrimary.opacity(0.9)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    .tracking(0.5)
                                
                                Text("Every day in the NICU is a step forward")
                                    .font(isIPad ? .system(size: 24, weight: .medium) : .subheadline)
                                    .themedText(style: .secondary)
                                    .tracking(0.2)
                                    .lineSpacing(4)
                            }
                            Spacer()
                            
                            // Encouragement button with enhanced styling
                            Button(action: { 
                                showEncouragement = true
                                HapticsPreferences.impact(.medium)
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    themeManager.currentTheme.colors.error.opacity(0.3),
                                                    themeManager.currentTheme.colors.error.opacity(0.1)
                                                ]),
                                                center: .center,
                                                startRadius: 10,
                                                endRadius: isIPad ? 40 : 30
                                            )
                                        )
                                        .blur(radius: 12)
                                    
                                    Image(systemName: "heart.fill")
                                        .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    themeManager.currentTheme.colors.error,
                                                    themeManager.currentTheme.colors.error.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: themeManager.currentTheme.colors.error.opacity(0.6), radius: 12, x: 0, y: 6)
                                }
                            }
                            .buttonStyle(EnhancedCardButtonStyle())
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                        .padding(.top, isIPad ? 32 : 20)
                    }
                    .scaleEffect(animateContent ? 1 : 0.92)
                    .opacity(animateContent ? 1 : 0)
                    .parallaxed(isIPad ? 10 : 6)
                    .animation(.spring(response: 0.8, dampingFraction: 0.85), value: animateContent)
                    
                    // Today's Focus Cards
                    VStack(alignment: .leading, spacing: isIPad ? 24 : 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: isIPad ? 20 : 16, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themeManager.currentTheme.colors.accent,
                                            themeManager.currentTheme.colors.secondary
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("Today's Focus")
                                .font(isIPad ? .title2 : .headline)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themeManager.currentTheme.colors.textPrimary,
                                            themeManager.currentTheme.colors.textPrimary.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .tracking(0.3)
                        }
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
                                action: { showSkinToSkinTimer = true },
                                animationDelay: 0
                            )
                            
                            NICUActionCard(
                                title: "Talk to Baby",
                                description: "Gentle conversation starters",
                                icon: "message.fill",
                                color: themeManager.currentTheme.colors.accent,
                                action: { showTalkToBabyTips = true },
                                animationDelay: 0.05
                            )
                            
                            NICUActionCard(
                                title: "Ask Questions",
                                description: "Capture questions for the care team",
                                icon: "questionmark.circle.fill",
                                color: themeManager.currentTheme.colors.info,
                                action: { showQuestionManager = true },
                                animationDelay: 0.1
                            )
                            
                            NICUActionCard(
                                title: "Read Stories",
                                description: "Storytime ideas for bonding",
                                icon: "book.fill",
                                color: themeManager.currentTheme.colors.secondary,
                                action: { showStorySuggestions = true },
                                animationDelay: 0.15
                            )
                            
                            NICUActionCard(
                                title: "Daily Progress",
                                description: "Jump straight to daily tracking",
                                icon: "chart.line.uptrend.xyaxis",
                                color: themeManager.currentTheme.colors.success,
                                action: navigateToProgressTab,
                                animationDelay: 0.2
                            )
                            
                            if isIPad {
                                NICUActionCard(
                                    title: "Encouragement",
                                    description: "Boost your spirits anytime",
                                    icon: "sparkles",
                                    color: themeManager.currentTheme.colors.warning,
                                    action: { showEncouragement = true },
                                    animationDelay: 0.25
                                )
                            }
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)
                    }
                    
                    // Quick Journal Bar
                    QuickJournalBar()
                        .padding(.horizontal, isIPad ? 32 : 20)
                        .parallaxed(isIPad ? 6 : 4)
                    
                    // Nurse on Shift Section
                    NurseShiftSection()
                        .padding(.horizontal, isIPad ? 32 : 20)
                        .parallaxed(isIPad ? 5 : 3)
                    
                    // Baby's Progress Summary removed; Progress lives on its dedicated tab
                    
                    // Tip of the Day
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themeManager.currentTheme.colors.warning,
                                            themeManager.currentTheme.colors.accent
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text(NSLocalizedString("ui.tip.title", comment: "Tip of the Day"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themeManager.currentTheme.colors.textPrimary,
                                            themeManager.currentTheme.colors.textPrimary.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .tracking(0.3)
                        }
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
                                    Button(action: { 
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            currentTipIndex = (currentTipIndex + 1) % tips.count
                                        }
                                        HapticsPreferences.impact(.light)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "arrow.right.circle.fill")
                                                .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                                            Text(NSLocalizedString("ui.see.next", comment: "See another"))
                                                .font(isIPad ? .headline : .subheadline)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .padding(.vertical, isIPad ? 12 : 8)
                                        .padding(.horizontal, isIPad ? 16 : 12)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    themeManager.currentTheme.colors.accent,
                                                    themeManager.currentTheme.colors.accent.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(12)
                                        .shadow(color: themeManager.currentTheme.colors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                                    }
                                    .buttonStyle(EnhancedCardButtonStyle())
                                    
                                    Button(action: { 
                                        saveTipToJournal(tip)
                                        HapticsPreferences.notify(.success)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "bookmark.fill")
                                                .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                                            Text(NSLocalizedString("ui.add.to.journal", comment: "Save to journal"))
                                                .font(isIPad ? .headline : .subheadline)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .padding(.vertical, isIPad ? 12 : 8)
                                        .padding(.horizontal, isIPad ? 16 : 12)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    themeManager.currentTheme.colors.primary,
                                                    themeManager.currentTheme.colors.primary.opacity(0.8)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(12)
                                        .shadow(color: themeManager.currentTheme.colors.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                                    }
                                    .buttonStyle(EnhancedCardButtonStyle())
                                    .accessibilityLabel(Text("Save tip to journal"))
                                }
                            }
                            .padding(isIPad ? 20 : 16)
                            .animatedCard(depth: .medium, cornerRadius: 18)
                            .padding(.horizontal)
                        }
                    }
                    .parallaxed(isIPad ? 5 : 3)
                    
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
                    .parallaxed(isIPad ? 5 : 3)
                    
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
                    .parallaxed(isIPad ? 5 : 3)
                    
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
                    .parallaxed(isIPad ? 5 : 3)
                    
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
        .sheet(isPresented: $showSkinToSkinTimer) {
            SkinToSkinTimerView()
                .environmentObject(themeManager)
                .environmentObject(dataPersistence)
        }
        .sheet(isPresented: $showTalkToBabyTips) {
            TalkToBabyTipsView()
                .environmentObject(themeManager)
                .environmentObject(dataPersistence)
        }
        .sheet(isPresented: $showQuestionManager) {
            AskQuestionsManagerView()
                .environmentObject(themeManager)
                .environmentObject(dataPersistence)
        }
        .sheet(isPresented: $showStorySuggestions) {
            ReadStoriesSuggestionsView()
                .environmentObject(themeManager)
                .environmentObject(dataPersistence)
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
    var animationDelay: Double = 0
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @State private var isVisible = false
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.6
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Enhanced gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.25),
                        color.opacity(0.15),
                        themeManager.currentTheme.colors.backgroundSecondary.opacity(0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Glow effect
                RoundedRectangle(cornerRadius: isIPad ? 28 : 20)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(glowIntensity * 0.4),
                                color.opacity(0)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: isIPad ? 100 : 60
                        )
                    )
                    .blur(radius: isIPad ? 20 : 12)
                    .opacity(isPressed ? 0.8 : 0.5)
                
                VStack(spacing: isIPad ? 20 : 12) {
                    // Icon with enhanced styling
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: isIPad ? 64 : 48, height: isIPad ? 64 : 48)
                            .blur(radius: 8)
                        
                        Image(systemName: icon)
                            .font(isIPad ? .system(size: 48, weight: .bold) : .title2)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        color,
                                        color.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
                    }
                    
                    VStack(spacing: isIPad ? 8 : 4) {
                        Text(title)
                            .font(isIPad ? .system(size: 24, weight: .bold) : .headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            .tracking(0.3)
                        
                        Text(description)
                            .font(isIPad ? .system(size: 16, weight: .medium) : .caption)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isIPad ? 200 : 120)
            .padding(isIPad ? 24 : 16)
            .contentShape(RoundedRectangle(cornerRadius: isIPad ? 28 : 20))
        }
        .buttonStyle(EnhancedCardButtonStyle())
        .animatedCard(depth: .high, cornerRadius: isIPad ? 28 : 20)
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 28 : 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.6),
                            color.opacity(0.3),
                            color.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .blendMode(.screen)
                .padding(1)
        )
        .overlay(
            // Animated shimmer on hover
            RoundedRectangle(cornerRadius: isIPad ? 28 : 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            color.opacity(0.1),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(isPressed ? 0.3 : 0)
                .animation(.easeInOut(duration: 0.3), value: isPressed)
        )
        .scaleEffect(isVisible ? 1 : 0.9)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            guard !isVisible else { return }
            withAnimation(
                .spring(response: 0.7, dampingFraction: 0.85)
                    .delay(animationDelay)
            ) {
                isVisible = true
            }
            
            // Animate glow
            withAnimation(
                .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.0
            }
        }
    }
}

// MARK: - Enhanced Card Button Style
struct EnhancedCardButtonStyle: SwiftUI.ButtonStyle {
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
                if newValue {
                    HapticsPreferences.impact(.light)
                }
            }
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
    
    func navigateToProgressTab() {
        NotificationCenter.default.post(
            name: .navigateToTab,
            object: nil,
            userInfo: ["tab": ContentView.NavigationTab.progress.rawValue]
        )
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
        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
        .animatedCard(depth: .medium, cornerRadius: 16)
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
        .animatedCard(depth: .medium, cornerRadius: 14)
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
                .animatedCard(depth: .medium, cornerRadius: isIPad ? 16 : 12)
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
            .animatedCard(depth: .medium, cornerRadius: isIPad ? 20 : 14)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SkinToSkinTimerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var elapsedSeconds = 0
    @State private var timer: Timer?
    @State private var timerRunning = false
    @State private var showSavedConfirmation = false
    
    private let benefits: [String] = [
        "Helps regulate your baby's heart rate, breathing, and temperature.",
        "Supports brain development through familiar sounds and heartbeat rhythm.",
        "Boosts milk production by stimulating oxytocin.",
        "Reduces stress for both baby and parent.",
        "Encourages better sleep patterns and weight gain."
    ]
    
    private let calmingIdeas: [String] = [
        "Hum the song you played during pregnancy.",
        "Gently describe what you see in the NICU around you.",
        "Repeat a positive affirmation: “You are safe, you are loved, you are strong.”"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    timerHeader
                    controlButtons
                    benefitsSection
                    calmingSection
                }
                .padding()
            }
            .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
            .navigationTitle("Skin-to-Skin Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                }
            }
        }
        .alert("Session saved", isPresented: $showSavedConfirmation) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Your skin-to-skin session has been saved to the journal.")
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var timerHeader: some View {
        VStack(spacing: 12) {
            Text(formattedTime)
                .font(.system(size: 56, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            Text(timerRunning ? "Session in progress" : "Tap start to begin")
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private var controlButtons: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button(action: toggleTimer) {
                    Label(timerRunning ? "Pause" : (elapsedSeconds == 0 ? "Start" : "Resume"), systemImage: timerRunning ? "pause.fill" : "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.currentTheme.colors.accent)
                        .cornerRadius(16)
                }
                
                Button(action: resetTimer) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.currentTheme.colors.backgroundSecondary)
                        .cornerRadius(16)
                }
                .disabled(elapsedSeconds == 0)
                .opacity(elapsedSeconds == 0 ? 0.5 : 1.0)
            }
            
            Button(action: saveSession) {
                Label("Save to Journal", systemImage: "square.and.arrow.down")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(themeManager.currentTheme.colors.success)
                    .cornerRadius(18)
            }
            .disabled(elapsedSeconds < 60)
            .opacity(elapsedSeconds < 60 ? 0.5 : 1.0)
        }
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Benefits for Your Baby")
                .font(.title3.weight(.semibold))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            ForEach(benefits, id: \.self) { benefit in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(themeManager.currentTheme.colors.success)
                    Text(benefit)
                        .font(.body)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private var calmingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Grounding Ideas While You Hold")
                .font(.title3.weight(.semibold))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            ForEach(calmingIdeas, id: \.self) { idea in
                Text("• \(idea)")
                    .font(.body)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        if timerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }
    
    private func pauseTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        elapsedSeconds = 0
        pauseTimer()
    }
    
    private func saveSession() {
        guard elapsedSeconds >= 60 else { return }
        pauseTimer()
        
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        let timeDescription = minutes > 0
            ? "\(minutes) min \(seconds) sec"
            : "\(seconds) seconds"
        
        let journalEntry = JournalEntry(
            title: "Skin-to-Skin Session",
            content: "We completed a \(timeDescription) skin-to-skin session today. Baby felt calm and steady in my arms.",
            mood: .hopeful,
            tags: [.family, .hope]
        )
        dataPersistence.addJournalEntry(journalEntry)
        showSavedConfirmation = true
    }
}

struct TalkToBabyTipsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    @Environment(\.dismiss) private var dismiss
    @State private var savedTipMessage: String?
    
    private let conversationTips: [TalkTip] = [
        TalkTip(title: "Narrate the Day", description: "Describe what happened today or what will happen when you visit tomorrow. Your voice brings reassurance.", category: .bonding),
        TalkTip(title: "Celebrate Progress", description: "Share small wins: “You took 5ml by bottle today – I’m so proud of you.”", category: .bonding),
        TalkTip(title: "Explain the Sounds", description: "Gently explain the monitors, pumps, and beeps to help your baby feel safe with the environment.", category: .soothing),
        TalkTip(title: "Read a Message from Family", description: "Bring a message from a sibling or grandparent and read it aloud.", category: .connection),
        TalkTip(title: "Guided Calm", description: "Whisper a simple breathing rhythm: “In… two… three… out… two… three…”", category: .soothing),
        TalkTip(title: "Dream Ahead", description: "Imagine future adventures together: “One day we’ll visit the park and feel the sun on our faces.”", category: .bonding)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    
                    ForEach(TalkTip.Category.allCases) { category in
                        let tipsForCategory = conversationTips.filter { $0.category == category }
                        if !tipsForCategory.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Text(category.displayName)
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                                
                                ForEach(tipsForCategory) { tip in
                                    tipCard(for: tip)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(themeManager.currentTheme.colors.backgroundSecondary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
            .navigationTitle("Talk to Baby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                }
            }
        }
        .alert("Added to Journal", isPresented: Binding<Bool>(
            get: { savedTipMessage != nil },
            set: { newValue in
                if !newValue { savedTipMessage = nil }
            }
        )) {
            Button("OK", role: .cancel) { savedTipMessage = nil }
        } message: {
            Text(savedTipMessage ?? "")
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your baby already knows your voice.")
                .font(.title2.weight(.semibold))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            Text("Even tiny conversations help with bonding, language development, and emotional reassurance. Try these prompts during visits or skin-to-skin time.")
                .font(.body)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private func tipCard(for tip: TalkTip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(tip.title)
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            Text(tip.description)
                .font(.body)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Button {
                saveTipToJournal(tip)
            } label: {
                Label("Save to Journal", systemImage: "square.and.arrow.down")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(themeManager.currentTheme.colors.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentTheme.colors.backgroundTertiary.opacity(0.6))
        )
    }
    
    private func saveTipToJournal(_ tip: TalkTip) {
        let entry = JournalEntry(
            title: "Talk to Baby Idea",
            content: "\(tip.title)\n\n\(tip.description)",
            mood: .hopeful,
            tags: [.family, .hope]
        )
        dataPersistence.addJournalEntry(entry)
        savedTipMessage = "“\(tip.title)” was saved to your journal."
    }
}

struct TalkTip: Identifiable {
    enum Category: CaseIterable, Identifiable {
        case bonding, soothing, connection
        
        var id: String { displayName }
        
        var displayName: String {
            switch self {
            case .bonding: return "Bonding Moments"
            case .soothing: return "Soothing Support"
            case .connection: return "Staying Connected"
            }
        }
    }
    
    let id = UUID()
    let title: String
    let description: String
    let category: Category
}

struct AskQuestionsManagerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var newQuestionText: String = ""
    @State private var selectedCategory: ParentQuestion.Category = .medical
    @State private var notes: String = ""
    @State private var showJournalConfirmation = false
    
    private var questions: [ParentQuestion] {
        dataPersistence.parentQuestions.sorted { lhs, rhs in
            if lhs.isAsked != rhs.isAsked {
                return !lhs.isAsked && rhs.isAsked == true
            }
            return lhs.createdDate > rhs.createdDate
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                formSection
                
                if questions.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(questions) { question in
                                questionRow(question)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                if questions.contains(where: { $0.isAsked }) {
                    Button {
                        saveAskedQuestionsToJournal()
                    } label: {
                        Label("Log answered questions", systemImage: "square.and.arrow.down")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.currentTheme.colors.success)
                            .cornerRadius(18)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
            .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
            .navigationTitle("Ask Questions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                }
            }
        }
        .alert("Saved to Journal", isPresented: $showJournalConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your answered questions were added to today's journal entry.")
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 14) {
            Text("Capture questions as they come to mind. Mark them when you've discussed them with the care team.")
                .font(.body)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
            
            TextField("What would you like to ask?", text: $newQuestionText)
                .padding()
                .background(themeManager.currentTheme.colors.backgroundSecondary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(ParentQuestion.Category.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            
            TextField("Additional context (optional)", text: $notes)
                .padding()
                .background(themeManager.currentTheme.colors.backgroundSecondary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
            
            Button {
                addQuestion()
            } label: {
                Label("Add Question", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.currentTheme.colors.accent)
                    .cornerRadius(18)
            }
            .disabled(newQuestionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(newQuestionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet")
                .font(.system(size: 36))
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
            Text("No questions saved yet")
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            Text("Write down your questions here so you never forget them during rounds.")
                .font(.body)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private func questionRow(_ question: ParentQuestion) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: question.category.icon)
                    .font(.title3)
                    .foregroundColor(question.isAsked ? themeManager.currentTheme.colors.success : themeManager.currentTheme.colors.accent)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(question.isAsked ? themeManager.currentTheme.colors.success.opacity(0.15) : themeManager.currentTheme.colors.accent.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(question.question)
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    if let notes = question.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    }
                    
                    HStack(spacing: 12) {
                        Text(question.createdDate, style: .date)
                            .font(.caption)
                            .foregroundColor(themeManager.currentTheme.colors.textTertiary)
                        if question.isAsked, let askedDate = question.askedDate {
                            Text("Asked \(askedDate, style: .relative)")
                                .font(.caption)
                                .foregroundColor(themeManager.currentTheme.colors.success)
                        }
                    }
                }
                Spacer()
            }
            
            Divider().background(themeManager.currentTheme.colors.border)
            
            HStack {
                Button {
                    dataPersistence.toggleQuestionAsked(question)
                } label: {
                    Label(question.isAsked ? "Mark as pending" : "Mark as asked", systemImage: question.isAsked ? "arrow.uturn.left.circle" : "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(question.isAsked ? themeManager.currentTheme.colors.info : themeManager.currentTheme.colors.success)
                }
                
                Spacer()
                
                Button(role: .destructive) {
                    dataPersistence.deleteParentQuestion(question)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(themeManager.currentTheme.colors.error)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private func addQuestion() {
        let trimmed = newQuestionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let question = ParentQuestion(
            question: trimmed,
            category: selectedCategory,
            createdDate: Date(),
            notes: notes.isEmpty ? nil : notes
        )
        dataPersistence.addParentQuestion(question)
        newQuestionText = ""
        notes = ""
        selectedCategory = .medical
    }
    
    private func saveAskedQuestionsToJournal() {
        let askedQuestions = questions.filter { $0.isAsked }
        guard !askedQuestions.isEmpty else { return }
        
        let body = askedQuestions
            .map { "• \($0.question)" }
            .joined(separator: "\n")
        
        let entry = JournalEntry(
            title: "Care Team Questions",
            content: "Today we received answers to the following questions:\n\n\(body)",
            mood: .hopeful,
            tags: [.questions, .progress]
        )
        dataPersistence.addJournalEntry(entry)
        showJournalConfirmation = true
    }
}

struct ReadStoriesSuggestionsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    @Environment(\.dismiss) private var dismiss
    @State private var savedStoryMessage: String?
    
    private let storySuggestions: [StorySuggestion] = [
        StorySuggestion(
            title: "Tell Our Story",
            description: "Share the story of how you chose your baby's name or a special moment from pregnancy.",
            length: "2-3 minutes"
        ),
        StorySuggestion(
            title: "Future Adventure",
            description: "Paint a picture of a future outing – the park, a beach day, or meeting family members.",
            length: "3-4 minutes"
        ),
        StorySuggestion(
            title: "Bedtime Tradition",
            description: "Create a calming nighttime ritual story you can repeat, mentioning familiar voices and gentle sounds.",
            length: "Any length"
        ),
        StorySuggestion(
            title: "Family Voices",
            description: "Read a note from a sibling, grandparent, or friend so your baby hears familiar names and love.",
            length: "1-2 minutes"
        )
    ]
    
    private let nicuFriendlyBooks: [StorySuggestion] = [
        StorySuggestion(
            title: "Black and White Baby Books",
            description: "Contrast-heavy board books are perfect for developing eyesight without overstimulation.",
            length: "Short"
        ),
        StorySuggestion(
            title: "Gentle Poetry",
            description: "Read a favorite poem or lyrics with a slow cadence – your calm voice is comforting.",
            length: "Flexible"
        ),
        StorySuggestion(
            title: "Daily Journal Excerpts",
            description: "Read a journal entry aloud to reinforce connection and memory-making.",
            length: "Flexible"
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    heroCard
                    
                    suggestionSection(title: "Story Prompts You Can Tell", suggestions: storySuggestions)
                    suggestionSection(title: "NICU-Friendly Reading", suggestions: nicuFriendlyBooks)
                }
                .padding()
            }
            .background(themeManager.currentTheme.colors.background.ignoresSafeArea())
            .navigationTitle("Read Stories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                }
            }
        }
        .alert("Added to Journal", isPresented: Binding<Bool>(
            get: { savedStoryMessage != nil },
            set: { newValue in
                if !newValue { savedStoryMessage = nil }
            }
        )) {
            Button("OK", role: .cancel) { savedStoryMessage = nil }
        } message: {
            Text(savedStoryMessage ?? "")
        }
    }
    
    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Storytime builds connection")
                .font(.title2.weight(.semibold))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            Text("Your voice helps your baby feel safe, builds language pathways, and becomes a calming ritual you can continue at home.")
                .font(.body)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(themeManager.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                )
        )
    }
    
    private func suggestionSection(title: String, suggestions: [StorySuggestion]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            ForEach(suggestions) { suggestion in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(suggestion.title)
                            .font(.headline)
                            .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                        Spacer()
                        if let length = suggestion.length {
                            Text(length)
                                .font(.caption)
                                .foregroundColor(themeManager.currentTheme.colors.textTertiary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(themeManager.currentTheme.colors.backgroundTertiary.opacity(0.6))
                                )
                        }
                    }
                    
                    Text(suggestion.description)
                        .font(.body)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        saveStoryToJournal(suggestion)
                    } label: {
                        Label("Log Storytime", systemImage: "square.and.arrow.down")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(themeManager.currentTheme.colors.accent)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(themeManager.currentTheme.colors.backgroundSecondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private func saveStoryToJournal(_ suggestion: StorySuggestion) {
        let entry = JournalEntry(
            title: "Storytime Moment",
            content: "We shared “\(suggestion.title)” today in the NICU.\n\n\(suggestion.description)",
            mood: .grateful,
            tags: [.family, .hope]
        )
        dataPersistence.addJournalEntry(entry)
        savedStoryMessage = "“\(suggestion.title)” was saved to your journal."
    }
}

struct StorySuggestion: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let length: String?
    
    init(title: String, description: String, length: String? = nil) {
        self.title = title
        self.description = description
        self.length = length
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

