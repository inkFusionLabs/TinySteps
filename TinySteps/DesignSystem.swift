//
//  DesignSystem.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

// MARK: - Design System
struct TinyStepsDesign {
    
    // MARK: - Dad-Focused Color Palette
    struct Colors {
        // Primary Dad Colors
        static let primary = Color(red: 0.07, green: 0.13, blue: 0.28) // Deep Navy
        static let accent = Color(red: 0.13, green: 0.47, blue: 0.87) // Bold Blue
        static let highlight = Color(red: 1.0, green: 0.67, blue: 0.13) // Energetic Orange
        static let success = Color(red: 0.18, green: 0.8, blue: 0.44) // Vibrant Green
        static let warning = Color(red: 1.0, green: 0.8, blue: 0.2) // Strong Yellow
        static let error = Color(red: 0.95, green: 0.23, blue: 0.21) // Confident Red
        static let info = Color(red: 0.13, green: 0.67, blue: 0.87) // Dad Blue

        // Backgrounds
        static let background = LinearGradient(
            gradient: Gradient(colors: [primary, accent]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let cardBackground = Color.white.opacity(0.10)
        static let cardBackgroundDark = Color(red: 0.09, green: 0.11, blue: 0.18)

        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.85)
        static let textTertiary = Color.white.opacity(0.6)
    }

    // MARK: - Dad-Focused Icons
    struct Icons {
        static let dad = Image(systemName: "figure.and.child.holdinghands")
        static let tools = Image(systemName: "wrench.and.screwdriver")
        static let sports = Image(systemName: "sportscourt")
        static let support = Image(systemName: "person.2.wave.2")
        // Add more dad-themed SF Symbols as needed
    }
    // MARK: - Dad Illustrations
    // TODO: Add custom dad-focused illustrations here (SVG or PNG)
    // Example: static let dadWithBaby = Image("dad_with_baby")
    // MARK: - Typography
    struct Typography {
        static let header = Font.system(size: 28, weight: .bold, design: .rounded)
        static let subheader = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 14, weight: .medium, design: .rounded)
    }
    // MARK: - DadIcon View
    struct DadIcon: View {
        let symbol: Image
        let color: Color
        var body: some View {
            symbol
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }

    // MARK: - Dad-Themed Icons/Illustrations (future)
    // static let dadIcon = Image("DadIcon")
    // static let dadBabyIllustration = Image("DadBabyIllustration")
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Reusable Components
struct TinyStepsCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadow: Shadow?
    
    init(
        backgroundColor: Color = TinyStepsDesign.Colors.cardBackground,
        cornerRadius: CGFloat = TinyStepsDesign.CornerRadius.medium,
        shadow: Shadow? = TinyStepsDesign.Shadows.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(TinyStepsDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.clear)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(
                color: shadow?.color ?? .clear,
                radius: shadow?.radius ?? 0,
                x: shadow?.x ?? 0,
                y: shadow?.y ?? 0
            )
    }
}

struct TinyStepsButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat
    let isEnabled: Bool
    
    init(
        backgroundColor: Color = TinyStepsDesign.Colors.accent,
        foregroundColor: Color = TinyStepsDesign.Colors.textPrimary,
        cornerRadius: CGFloat = TinyStepsDesign.CornerRadius.medium,
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.isEnabled = isEnabled
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
                .foregroundColor(foregroundColor)
                .padding(.horizontal, TinyStepsDesign.Spacing.lg)
                .padding(.vertical, TinyStepsDesign.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isEnabled ? backgroundColor : backgroundColor.opacity(0.5))
                )
        }
        .disabled(!isEnabled)
    }
}

struct TinyStepsIconButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    init(
        icon: String,
        color: Color = TinyStepsDesign.Colors.accent,
        size: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(color)
                .frame(width: size + 8, height: size + 8)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
        }
    }
}

struct TinyStepsSectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    
    init(title: String, icon: String, color: Color = TinyStepsDesign.Colors.accent) {
        self.title = title
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: TinyStepsDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(TinyStepsDesign.Typography.header)
                .foregroundColor(color)
            
            Text(title)
                .font(TinyStepsDesign.Typography.subheader)
                .fontWeight(.bold)
                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, TinyStepsDesign.Spacing.sm)
    }
}

struct TinyStepsInfoCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    
    var body: some View {
        TinyStepsCard {
            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.xs) {
                    Text(title)
                        .font(TinyStepsDesign.Typography.header)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    Text(content)
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Animations
struct TinyStepsAnimations {
    static let spring = Animation.spring(response: 0.6, dampingFraction: 0.8)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
    static let easeIn = Animation.easeIn(duration: 0.2)
    static let easeOut = Animation.easeOut(duration: 0.2)
}

// MARK: - UK Guidelines 2025
struct UKGuidelines2025 {
    // Vaccination Schedule (Updated for 2025)
    static let vaccinationSchedule = [
        ("8 weeks", ["6-in-1 vaccine", "Rotavirus vaccine", "MenB vaccine"]),
        ("12 weeks", ["6-in-1 vaccine (2nd dose)", "Rotavirus vaccine (2nd dose)", "PCV vaccine"]),
        ("16 weeks", ["6-in-1 vaccine (3rd dose)", "MenB vaccine (2nd dose)"]),
        ("1 year", ["Hib/MenC vaccine", "MMR vaccine", "PCV vaccine (2nd dose)", "MenB vaccine (3rd dose)"]),
        ("2-10 years", ["Annual flu vaccine (nasal spray)"]),
        ("3 years 4 months", ["MMR vaccine (2nd dose)", "4-in-1 pre-school booster"]),
        ("12-13 years", ["HPV vaccine", "Td/IPV booster"]),
        ("14 years", ["MenACWY vaccine", "3-in-1 teenage booster"])
    ]
    
    // NHS Guidelines
    static let nhsGuidelines = [
        "Exclusive breastfeeding recommended for first 6 months",
        "Introduce solid foods at around 6 months",
        "Continue breastfeeding alongside solid foods until at least 12 months",
        "Safe sleep: Back to sleep, clear cot, room sharing for first 6 months",
        "Regular health visitor checks at 5 days, 10-14 days, 6-8 weeks, 9-12 months, 2-2.5 years"
    ]
    
    // Growth Standards (WHO standards used in UK)
    static let growthStandards = [
        "Weight: Track using WHO growth charts",
        "Height: Measure lying down until 2 years, standing after",
        "Head circumference: Important for brain development monitoring",
        "Percentiles: 3rd to 97th percentile considered normal range"
    ]
    
    // Development Milestones (Updated for 2025)
    static let developmentMilestones = [
        ("0-3 months", ["Lifts head when on tummy", "Follows objects with eyes", "Responds to sounds", "Smiles at people"]),
        ("3-6 months", ["Rolls from tummy to back", "Reaches for objects", "Babbles and coos", "Recognises familiar faces"]),
        ("6-9 months", ["Sits without support", "Crawls or scoots", "Says 'mama' or 'dada'", "Picks up small objects"]),
        ("9-12 months", ["Pulls to stand", "Cruises along furniture", "Says first words", "Waves goodbye"]),
        ("12-18 months", ["Walks independently", "Says 5-10 words", "Follows simple commands", "Points to body parts"]),
        ("18-24 months", ["Runs and climbs", "Says 50+ words", "Combines 2 words", "Shows independence"])
    ]
    
    // Safety Guidelines
    static let safetyGuidelines = [
        "Car seats: Must meet EU safety standards (R129 or R44.04)",
        "Sleep safety: Firm, flat mattress, no loose bedding",
        "Bath safety: Never leave baby unattended, test water temperature",
        "Choking prevention: Avoid small objects, cut food appropriately",
        "Sun protection: Keep out of direct sun, use appropriate sunscreen from 6 months"
    ]
    
    // Emergency Contacts
    static let emergencyContacts = [
        ("NHS 111", "Non-emergency medical advice"),
        ("NHS 999", "Emergency services"),
        ("Bliss Helpline", "0808 801 0322 - Premature baby support"),
        ("NCT Helpline", "0300 330 0700 - Parenting support"),
        ("Samaritans", "116 123 - Mental health support"),
        ("CALM", "0800 58 58 58 - Men's mental health")
    ]
} 

// MARK: - TabView Customization
@available(iOS 18.0, *)
class TabViewCustomization: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var tabBarStyle: TabBarStyle = .default
    
    enum TabBarStyle {
        case `default`
        case custom
    }
}

 