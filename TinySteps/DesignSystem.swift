//
//  DesignSystem.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

// MARK: - Design System
struct TinyStepsDesign {
    
    // MARK: - Animation Constants
    struct Animations {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let bouncy = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
        static let snappy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.9, blendDuration: 0)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.8)
        
        // Micro-interactions
        static let tap = SwiftUI.Animation.easeInOut(duration: 0.1)
        static let hover = SwiftUI.Animation.easeInOut(duration: 0.15)
        static let focus = SwiftUI.Animation.easeInOut(duration: 0.2)
        
        // Page transitions
        static let pageTransition = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let slideIn = SwiftUI.Animation.easeOut(duration: 0.3)
        static let slideOut = SwiftUI.Animation.easeIn(duration: 0.2)
        
        // Loading states
        static let pulse = SwiftUI.Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
        static let shimmer = SwiftUI.Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
        static let rotate = SwiftUI.Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
    }
    
    // MARK: - Vibrant Color Palette
    struct Colors {
        // Primary Vibrant Colors
        static let primary = Color(red: 0.2, green: 0.6, blue: 1.0) // Bright Blue
        static let accent = Color(red: 0.0, green: 0.8, blue: 0.4) // Vibrant Green
        static let highlight = Color(red: 1.0, green: 0.6, blue: 0.0) // Energetic Orange
        static let success = Color(red: 0.0, green: 0.8, blue: 0.4) // Vibrant Green
        static let warning = Color(red: 1.0, green: 0.8, blue: 0.0) // Bright Yellow
        static let error = Color(red: 0.9, green: 0.2, blue: 0.2) // Confident Red
        static let info = Color(red: 0.2, green: 0.6, blue: 1.0) // Bright Blue

        // Backgrounds
        static let background = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.05, green: 0.1, blue: 0.2),  // Very dark blue
                Color(red: 0.1, green: 0.2, blue: 0.4),   // Dark blue
                Color(red: 0.2, green: 0.4, blue: 0.8)    // Medium blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let backgroundSolid = primary
        static let cardBackground = Color.white.opacity(0.08)
        static let cardBackgroundDark = Color(red: 0.09, green: 0.11, blue: 0.18)
        
        // Glassmorphism Effects
        static let glassBackground = Color.white.opacity(0.15)
        static let glassBorder = Color.white.opacity(0.2)
        static let glassShadow = Color.black.opacity(0.1)

        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.85)
        static let textTertiary = Color.white.opacity(0.6)
    }

    // MARK: - Neumorphic Components
    struct NeumorphicColors {
        // Base colors for neumorphic effects
        static let base = TinyStepsDesign.Colors.cardBackground
        static let background = TinyStepsDesign.Colors.background
        static let backgroundSecondary = TinyStepsDesign.Colors.cardBackgroundDark

        // Light and dark variants for shadows
        static let lightShadow = Color.white.opacity(0.7)
        static let darkShadow = Color.black.opacity(0.15)

        // Semantic colors
        static let textPrimary = TinyStepsDesign.Colors.textPrimary
        static let textSecondary = TinyStepsDesign.Colors.textSecondary
        static let textMuted = TinyStepsDesign.Colors.textTertiary

        // Accent colors
        static let primary = TinyStepsDesign.Colors.primary
        static let secondary = TinyStepsDesign.Colors.accent
        static let success = TinyStepsDesign.Colors.success
        static let warning = TinyStepsDesign.Colors.warning
        static let error = TinyStepsDesign.Colors.error
        static let info = TinyStepsDesign.Colors.info
    }
    
    // MARK: - Neumorphic Icons
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
    
    // MARK: - Glassmorphism Modifiers
    struct Glassmorphism {
        struct GlassEffect: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(TinyStepsDesign.Colors.glassBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(TinyStepsDesign.Colors.glassBorder, lineWidth: 1)
                            )
                            .shadow(color: TinyStepsDesign.Colors.glassShadow, radius: 10, x: 0, y: 5)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        
        struct SubtleGlass: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                            )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        
        struct CardGlass: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                    )
            }
        }
        
        static func glassEffect() -> GlassEffect {
            GlassEffect()
        }
        
        static func subtleGlass() -> SubtleGlass {
            SubtleGlass()
        }
        
        static func cardGlass() -> CardGlass {
            CardGlass()
        }
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

// MARK: - Responsive Grid Component
struct ResponsiveGrid<Content: View>: View {
    let columns: Int
    let spacing: CGFloat
    let content: () -> Content
    
    init(columns: Int, spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
            content()
        }
    }
}

// MARK: - Quick Action Button Component
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(TinyStepsDesign.NeumorphicColors.base)
                        .frame(width: 60, height: 60)
                        .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: isPressed ? 2 : 4, x: isPressed ? -1 : -2, y: isPressed ? -1 : -2)
                        .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: isPressed ? 2 : 4, x: isPressed ? 1 : 2, y: isPressed ? 1 : 2)
                        .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.05 : 1.0))
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(TinyStepsDesign.NeumorphicColors.base)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: isPressed ? 2 : 3, x: isPressed ? -0.5 : -1, y: isPressed ? -0.5 : -1)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: isPressed ? 2 : 3, x: isPressed ? 0.5 : 1, y: isPressed ? 0.5 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(TinyStepsDesign.Animations.tap, value: isPressed)
        .animation(TinyStepsDesign.Animations.hover, value: isHovered)
        .onTapGesture {
            withAnimation(TinyStepsDesign.Animations.tap) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(TinyStepsDesign.Animations.tap) {
                    isPressed = false
                }
            }
        }
        .onHover { hovering in
            withAnimation(TinyStepsDesign.Animations.hover) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Animated View Modifiers
struct AnimatedNeumorphicModifier: ViewModifier {
    @State private var isPressed = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(TinyStepsDesign.Animations.tap, value: isPressed)
            .onTapGesture {
                withAnimation(TinyStepsDesign.Animations.tap) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(TinyStepsDesign.Animations.tap) {
                        isPressed = false
                    }
                }
                action()
            }
    }
}

struct PulseAnimationModifier: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .opacity(isPulsing ? 0.7 : 1.0)
            .animation(TinyStepsDesign.Animations.pulse, value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase * 200 - 100)
                .animation(TinyStepsDesign.Animations.shimmer, value: phase)
            )
            .onAppear {
                phase = 1
            }
    }
}

struct SlideInModifier: ViewModifier {
    let direction: SlideDirection
    @State private var offset: CGFloat = 0
    
    enum SlideDirection {
        case fromLeft, fromRight, fromTop, fromBottom
    }
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: direction == .fromLeft ? -offset : (direction == .fromRight ? offset : 0),
                y: direction == .fromTop ? -offset : (direction == .fromBottom ? offset : 0)
            )
            .animation(TinyStepsDesign.Animations.slideIn, value: offset)
            .onAppear {
                offset = 300
            }
    }
}

// MARK: - View Extensions for Animations
extension View {
    func animatedNeumorphic(action: @escaping () -> Void) -> some View {
        self.modifier(AnimatedNeumorphicModifier(action: action))
    }
    
    func pulseAnimation() -> some View {
        self.modifier(PulseAnimationModifier())
    }
    
    func shimmerEffect() -> some View {
        self.modifier(ShimmerModifier())
    }
    
    func slideIn(from direction: SlideInModifier.SlideDirection) -> some View {
        self.modifier(SlideInModifier(direction: direction))
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
    
    // Emergency Contacts (Location-based)
    static let emergencyContacts = [
        ("Emergency Services", "911 (US) / 999 (UK) / 112 (EU) - Emergency"),
        ("Non-Emergency Medical", "111 (UK) / 311 (US) - Medical advice"),
        ("Bliss Helpline", "0808 801 0322 - Premature baby support (UK)"),
        ("NCT Helpline", "0300 330 0700 - Parenting support (UK)"),
        ("Samaritans", "116 123 - Mental health support (UK)"),
        ("CALM", "0800 58 58 58 - Men's mental health (UK)"),
        ("March of Dimes", "1-888-MODIMES - Premature baby support (US)"),
        ("NICU Parent Support", "Local hospital NICU - Parent support groups")
    ]
}


 