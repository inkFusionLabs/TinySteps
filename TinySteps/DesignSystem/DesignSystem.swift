//
//  DesignSystem.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .organic
	
	private let themeStorageKey = "app_theme"
	
	init() {
		// Load saved theme if available
		if let saved = UserDefaults.standard.string(forKey: themeStorageKey),
		   let savedTheme = AppTheme(rawValue: saved) {
			currentTheme = savedTheme
		}
	}
    
    enum AppTheme: String, CaseIterable {
        case organic = "Organic"
        case modern = "Modern"
        case classic = "Classic"
        
        var colors: ThemeColors {
            switch self {
            case .organic:
                return ThemeColors.organic
            case .modern:
                return ThemeColors.modern
            case .classic:
                return ThemeColors.classic
            }
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
		UserDefaults.standard.set(theme.rawValue, forKey: themeStorageKey)
    }
}

// MARK: - Theme Colors
struct ThemeColors {
    let primary: Color
    let primaryDark: Color
    let primaryLight: Color
    
    let secondary: Color
    let secondaryDark: Color
    let secondaryLight: Color
    
    let accent: Color
    let accentDark: Color
    let accentLight: Color
    
    let success: Color
    let warning: Color
    let error: Color
    let info: Color
    
    let background: Color
    let backgroundSecondary: Color
    let backgroundTertiary: Color
    
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    
    let border: Color
    let borderLight: Color
    
    let shadow: Color
    let shadowDark: Color
    
    let backgroundGradient: LinearGradient
    
    static let organic = ThemeColors(
        primary: Color(red: 0.12, green: 0.18, blue: 0.35), // Deep Ocean Blue
        primaryDark: Color(red: 0.08, green: 0.12, blue: 0.25),
        primaryLight: Color(red: 0.12, green: 0.18, blue: 0.35).opacity(0.3),
        
        secondary: Color(red: 0.85, green: 0.45, blue: 0.65), // Soft Lavender
        secondaryDark: Color(red: 0.75, green: 0.35, blue: 0.55),
        secondaryLight: Color(red: 0.85, green: 0.45, blue: 0.65).opacity(0.3),
        
        accent: Color(red: 0.95, green: 0.55, blue: 0.25), // Warm Terracotta
        accentDark: Color(red: 0.85, green: 0.45, blue: 0.15),
        accentLight: Color(red: 0.95, green: 0.55, blue: 0.25).opacity(0.3),
        
        success: Color(red: 0.25, green: 0.66, blue: 0.56), // Fresh Sage
        warning: Color(red: 0.95, green: 0.65, blue: 0.15), // Golden Amber
        error: Color(red: 0.88, green: 0.35, blue: 0.45), // Soft Coral
        info: Color(red: 0.45, green: 0.65, blue: 0.85), // Sky Blue
        
        background: Color(red: 0.04, green: 0.05, blue: 0.10), // Deep Night
        backgroundSecondary: Color(red: 0.10, green: 0.12, blue: 0.18), // Dark Gray
        backgroundTertiary: Color(red: 0.15, green: 0.17, blue: 0.23), // Lighter Dark Gray
        
        textPrimary: Color.white,
        textSecondary: Color.white.opacity(0.8),
        textTertiary: Color.white.opacity(0.6),
        
        border: Color.white.opacity(0.2),
        borderLight: Color.white.opacity(0.1),
        
        shadow: Color.black.opacity(0.3),
        shadowDark: Color.black.opacity(0.5),
        
        backgroundGradient: LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.12, green: 0.18, blue: 0.35).opacity(0.8),
                Color(red: 0.85, green: 0.45, blue: 0.65).opacity(0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    static let modern = ThemeColors(
        primary: Color(red: 0.0, green: 0.48, blue: 1.0), // System Blue
        primaryDark: Color(red: 0.0, green: 0.38, blue: 0.8),
        primaryLight: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.3),
        
        secondary: Color(red: 0.5, green: 0.0, blue: 0.5), // Purple
        secondaryDark: Color(red: 0.4, green: 0.0, blue: 0.4),
        secondaryLight: Color(red: 0.5, green: 0.0, blue: 0.5).opacity(0.3),
        
        accent: Color(red: 1.0, green: 0.58, blue: 0.0), // Orange
        accentDark: Color(red: 0.8, green: 0.48, blue: 0.0),
        accentLight: Color(red: 1.0, green: 0.58, blue: 0.0).opacity(0.3),
        
        success: Color.green,
        warning: Color.orange,
        error: Color.red,
        info: Color.cyan,
        
        background: Color.black,
        backgroundSecondary: Color.white.opacity(0.1),
        backgroundTertiary: Color.white.opacity(0.05),
        
        textPrimary: Color.white,
        textSecondary: Color.white.opacity(0.8),
        textTertiary: Color.white.opacity(0.6),
        
        border: Color.white.opacity(0.3),
        borderLight: Color.white.opacity(0.1),
        
        shadow: Color.black.opacity(0.3),
        shadowDark: Color.black.opacity(0.5),
        
        backgroundGradient: LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    static let classic = ThemeColors(
        primary: Color(red: 0.0, green: 0.0, blue: 0.5), // Navy Blue
        primaryDark: Color(red: 0.0, green: 0.0, blue: 0.3),
        primaryLight: Color(red: 0.0, green: 0.0, blue: 0.5).opacity(0.3),
        
        secondary: Color(red: 0.5, green: 0.0, blue: 0.0), // Maroon
        secondaryDark: Color(red: 0.3, green: 0.0, blue: 0.0),
        secondaryLight: Color(red: 0.5, green: 0.0, blue: 0.0).opacity(0.3),
        
        accent: Color(red: 0.8, green: 0.4, blue: 0.0), // Dark Orange
        accentDark: Color(red: 0.6, green: 0.3, blue: 0.0),
        accentLight: Color(red: 0.8, green: 0.4, blue: 0.0).opacity(0.3),
        
        success: Color(red: 0.0, green: 0.5, blue: 0.0), // Dark Green
        warning: Color(red: 0.8, green: 0.6, blue: 0.0), // Gold
        error: Color(red: 0.8, green: 0.0, blue: 0.0), // Dark Red
        info: Color(red: 0.0, green: 0.5, blue: 0.8), // Dark Cyan
        
        background: Color(red: 0.05, green: 0.05, blue: 0.1), // Very Dark Blue
        backgroundSecondary: Color(red: 0.1, green: 0.1, blue: 0.15),
        backgroundTertiary: Color(red: 0.15, green: 0.15, blue: 0.2),
        
        textPrimary: Color.white,
        textSecondary: Color.white.opacity(0.8),
        textTertiary: Color.white.opacity(0.6),
        
        border: Color.white.opacity(0.2),
        borderLight: Color.white.opacity(0.1),
        
        shadow: Color.black.opacity(0.4),
        shadowDark: Color.black.opacity(0.6),
        
        backgroundGradient: LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.0, green: 0.0, blue: 0.5).opacity(0.8),
                Color(red: 0.5, green: 0.0, blue: 0.0).opacity(0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

// MARK: - Design System
struct DesignSystem {
    
    // MARK: - Colors (Legacy - Use ThemeManager.shared.currentTheme.colors instead)
    struct Colors {
        // Primary Colors
        static let primary = Color.blue
        static let primaryDark = Color.blue.opacity(0.8)
        static let primaryLight = Color.blue.opacity(0.3)
        
        // Secondary Colors
        static let secondary = Color.purple
        static let secondaryDark = Color.purple.opacity(0.8)
        static let secondaryLight = Color.purple.opacity(0.3)
        
        // Accent Colors
        static let accent = Color("AccentColor")
        static let accentDark = Color("AccentColor").opacity(0.8)
        static let accentLight = Color("AccentColor").opacity(0.3)
        
        // Status Colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.cyan
        
        // Background Colors
        static let background = Color.black
        static let backgroundSecondary = Color.white.opacity(0.1)
        static let backgroundTertiary = Color.white.opacity(0.05)
        
        // Gradient Backgrounds
        static let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Text Colors
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.9)
        static let textTertiary = Color.white.opacity(0.7)
        static let textPlaceholder = Color.white.opacity(0.6)
        
        // Border Colors
        static let border = Color.white.opacity(0.3)
        static let borderLight = Color.white.opacity(0.1)
        
        // Shadow Colors
        static let shadow = Color.black.opacity(0.3)
        static let shadowDark = Color.black.opacity(0.5)
    }
    
    // MARK: - Typography
    struct Typography {
        // Headings
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.semibold)
        
        // Body Text
        static let body = Font.body
        static let bodyEmphasized = Font.body.weight(.medium)
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption1 = Font.caption
        static let caption2 = Font.caption2
        
        // Custom Sizes
        static let hero = Font.system(size: 32, weight: .bold, design: .rounded)
        static let sectionHeader = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let button = Font.system(size: 16, weight: .medium, design: .rounded)
        static let smallButton = Font.system(size: 14, weight: .medium, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
        
        // Custom Spacing
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        
        // Custom Radius
        static let card: CGFloat = 12
        static let button: CGFloat = 8
        static let input: CGFloat = 8
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: Colors.shadow, radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: Colors.shadow, radius: 4, x: 0, y: 2)
        static let large = Shadow(color: Colors.shadow, radius: 8, x: 0, y: 4)
        static let xlarge = Shadow(color: Colors.shadow, radius: 16, x: 0, y: 8)
        
        // Custom Shadows
        static let card = Shadow(color: Colors.shadow, radius: 6, x: 0, y: 3)
        static let button = Shadow(color: Colors.shadow, radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Theme Modifiers
extension View {
    func themedBackground() -> some View {
        self.background(ThemeManager.shared.currentTheme.colors.background)
    }
    
    func themedCard() -> some View {
        self
            .background(ThemeManager.shared.currentTheme.colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card)
                    .stroke(ThemeManager.shared.currentTheme.colors.border, lineWidth: 1)
            )
            .shadow(
                color: ThemeManager.shared.currentTheme.colors.shadow,
                radius: 6,
                x: 0,
                y: 3
            )
    }
    
    func themedButton(style: ButtonStyle = .primary) -> some View {
        self
            .font(DesignSystem.Typography.button)
            .foregroundColor(style == .primary ? .white : ThemeManager.shared.currentTheme.colors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button)
                    .fill(style == .primary ? ThemeManager.shared.currentTheme.colors.primary : ThemeManager.shared.currentTheme.colors.primaryLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button)
                    .stroke(ThemeManager.shared.currentTheme.colors.primary, lineWidth: style == .outline ? 1 : 0)
            )
            .shadow(
                color: ThemeManager.shared.currentTheme.colors.shadow,
                radius: 2,
                x: 0,
                y: 1
            )
    }
    
    func themedText(style: TextStyle = .primary) -> some View {
        self.foregroundColor(
            style == .primary ? ThemeManager.shared.currentTheme.colors.textPrimary :
            style == .secondary ? ThemeManager.shared.currentTheme.colors.textSecondary :
            ThemeManager.shared.currentTheme.colors.textTertiary
        )
    }
    
    // MARK: - iPad Responsive Modifiers
    func responsiveFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let scaledSize = isIPad ? size * 1.2 : size
        return self.font(.system(size: scaledSize, weight: weight))
    }
    
    func responsivePadding(_ basePadding: CGFloat) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let scaledPadding = isIPad ? basePadding * 1.5 : basePadding
        return self.padding(scaledPadding)
    }
    
    func responsiveSpacing(_ baseSpacing: CGFloat) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let scaledSpacing = isIPad ? baseSpacing * 1.3 : baseSpacing
        return self.padding(.vertical, scaledSpacing)
    }
    
    
    func responsiveCornerRadius(_ baseRadius: CGFloat) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let scaledRadius = isIPad ? baseRadius * 1.2 : baseRadius
        return self.cornerRadius(scaledRadius)
    }
}

enum ButtonStyle {
    case primary, secondary, outline
}

enum TextStyle {
    case primary, secondary, tertiary
}

// MARK: - iPad Optimization Components
extension DesignSystem {
    
    // MARK: - iPad Optimization
    struct iPadOptimization {
        
        // MARK: - Adaptive Layout
        struct AdaptiveLayout {
            @Environment(\.horizontalSizeClass) var horizontalSizeClass
            @Environment(\.verticalSizeClass) var verticalSizeClass
            
            var isIPad: Bool {
                horizontalSizeClass == .regular && verticalSizeClass == .regular
            }
            
            var isIPadLandscape: Bool {
                isIPad && horizontalSizeClass == .regular && verticalSizeClass == .compact
            }
            
            var isIPadPortrait: Bool {
                isIPad && horizontalSizeClass == .regular && verticalSizeClass == .regular
            }
        }
        
        // MARK: - Enhanced Responsive Typography
        struct ResponsiveText: View {
            let text: String
            let style: TextStyle
            let alignment: TextAlignment
            
            init(_ text: String, style: TextStyle = .primary, alignment: TextAlignment = .leading) {
                self.text = text
                self.style = style
                self.alignment = alignment
            }
            
            var body: some View {
                Text(text)
                    .font(adaptiveFont(for: style))
                    .multilineTextAlignment(alignment)
                    .themedText(style: style)
            }
            
            private func adaptiveFont(for style: TextStyle) -> Font {
                let isIPad = UIDevice.current.userInterfaceIdiom == .pad
                let baseSize: CGFloat
                let weight: Font.Weight
                
                switch style {
                case .primary:
                    baseSize = isIPad ? 20 : 17
                    weight = .medium
                case .secondary:
                    baseSize = isIPad ? 18 : 15
                    weight = .regular
                case .tertiary:
                    baseSize = isIPad ? 16 : 13
                    weight = .regular
                }
                
                return .system(size: baseSize, weight: weight)
            }
        }
        
        // MARK: - Enhanced iPad Card
        struct iPadCard<Content: View>: View {
            let content: Content
            let isIPad: Bool
            let cardStyle: CardStyle
            
            enum CardStyle {
                case standard, elevated, compact
            }
            
            init(style: CardStyle = .standard, @ViewBuilder content: () -> Content) {
                self.content = content()
                self.isIPad = UIDevice.current.userInterfaceIdiom == .pad
                self.cardStyle = style
            }
            
            var body: some View {
                content
                    .padding(cardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(ThemeManager.shared.currentTheme.colors.backgroundSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(ThemeManager.shared.currentTheme.colors.border, lineWidth: 1)
                            )
                    )
                    .shadow(
                        color: ThemeManager.shared.currentTheme.colors.shadow,
                        radius: shadowRadius,
                        x: 0,
                        y: shadowOffset
                    )
            }
            
            private var cardPadding: CGFloat {
                switch cardStyle {
                case .standard:
                    return isIPad ? 24 : 16
                case .elevated:
                    return isIPad ? 32 : 20
                case .compact:
                    return isIPad ? 16 : 12
                }
            }
            
            private var cornerRadius: CGFloat {
                switch cardStyle {
                case .standard:
                    return isIPad ? 20 : 12
                case .elevated:
                    return isIPad ? 24 : 16
                case .compact:
                    return isIPad ? 16 : 8
                }
            }
            
            private var shadowRadius: CGFloat {
                switch cardStyle {
                case .standard:
                    return isIPad ? 8 : 6
                case .elevated:
                    return isIPad ? 12 : 8
                case .compact:
                    return isIPad ? 4 : 2
                }
            }
            
            private var shadowOffset: CGFloat {
                switch cardStyle {
                case .standard:
                    return isIPad ? 4 : 3
                case .elevated:
                    return isIPad ? 6 : 4
                case .compact:
                    return isIPad ? 2 : 1
                }
            }
        }
        
        // MARK: - Enhanced iPad Grid Layout
        struct iPadGridLayout<Content: View>: View {
            let content: Content
            let isIPad: Bool
            let gridStyle: GridStyle
            
            enum GridStyle {
                case standard, compact, wide
            }
            
            init(style: GridStyle = .standard, @ViewBuilder content: () -> Content) {
                self.content = content()
                self.isIPad = UIDevice.current.userInterfaceIdiom == .pad
                self.gridStyle = style
            }
            
            var body: some View {
                let columns = gridColumns
                let spacing = gridSpacing
                
                LazyVGrid(columns: columns, spacing: spacing) {
                    content
                }
            }
            
            private var gridColumns: [GridItem] {
                let columnCount: Int
                let spacing: CGFloat
                
                switch gridStyle {
                case .standard:
                    columnCount = isIPad ? 3 : 2
                    spacing = isIPad ? 24 : 16
                case .compact:
                    columnCount = isIPad ? 4 : 3
                    spacing = isIPad ? 16 : 12
                case .wide:
                    columnCount = isIPad ? 2 : 1
                    spacing = isIPad ? 32 : 20
                }
                
                return Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
            }
            
            private var gridSpacing: CGFloat {
                switch gridStyle {
                case .standard:
                    return isIPad ? 24 : 16
                case .compact:
                    return isIPad ? 16 : 12
                case .wide:
                    return isIPad ? 32 : 20
                }
            }
        }
        
        // iPad sidebar preview components removed (not used)
        
        // MARK: - Enhanced Adaptive Spacing
        struct AdaptiveSpacing {
            static func padding(_ basePadding: CGFloat) -> CGFloat {
                UIDevice.current.userInterfaceIdiom == .pad ? basePadding * 1.5 : basePadding
            }
            
            static func spacing(_ baseSpacing: CGFloat) -> CGFloat {
                UIDevice.current.userInterfaceIdiom == .pad ? baseSpacing * 1.3 : baseSpacing
            }
            
            static func margin(_ baseMargin: CGFloat) -> CGFloat {
                UIDevice.current.userInterfaceIdiom == .pad ? baseMargin * 1.4 : baseMargin
            }
        }
        
        // MARK: - Responsive Button
        struct ResponsiveButton: View {
            let title: String
            let icon: String?
            let action: () -> Void
            let style: ButtonStyle
            let isIPad: Bool
            
            init(_ title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
                self.title = title
                self.icon = icon
                self.style = style
                self.action = action
                self.isIPad = UIDevice.current.userInterfaceIdiom == .pad
            }
            
            var body: some View {
                Button(action: action) {
                    HStack(spacing: isIPad ? 12 : 8) {
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                        }
                        
                        Text(title)
                            .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                    }
                    .foregroundColor(style == .primary ? .white : ThemeManager.shared.currentTheme.colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isIPad ? 16 : 12)
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                            .fill(style == .primary ? ThemeManager.shared.currentTheme.colors.primary : ThemeManager.shared.currentTheme.colors.primaryLight)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                            .stroke(ThemeManager.shared.currentTheme.colors.primary, lineWidth: style == .outline ? 1 : 0)
                    )
                    .shadow(
                        color: ThemeManager.shared.currentTheme.colors.shadow,
                        radius: isIPad ? 4 : 2,
                        x: 0,
                        y: isIPad ? 2 : 1
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        
        // MARK: - Responsive Section Header
        struct ResponsiveSectionHeader: View {
            let title: String
            let subtitle: String?
            let isIPad: Bool
            
            init(_ title: String, subtitle: String? = nil) {
                self.title = title
                self.subtitle = subtitle
                self.isIPad = UIDevice.current.userInterfaceIdiom == .pad
            }
            
            var body: some View {
                VStack(alignment: .leading, spacing: isIPad ? 8 : 4) {
                    Text(title)
                        .font(.system(size: isIPad ? 28 : 22, weight: .bold))
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, isIPad ? 32 : 16)
                .padding(.vertical, isIPad ? 20 : 16)
            }
        }
    }
}

// MARK: - Design System Components
extension DesignSystem {
    
    // MARK: - Buttons
    struct Buttons {
        static func primary(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .font(DesignSystem.Typography.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.primary)
                    .cornerRadius(DesignSystem.CornerRadius.button)
            }
            .shadow(color: DesignSystem.Shadows.button.color, radius: DesignSystem.Shadows.button.radius, x: DesignSystem.Shadows.button.x, y: DesignSystem.Shadows.button.y)
        }
        
        static func secondary(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .font(DesignSystem.Typography.button)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.primaryLight)
                    .cornerRadius(DesignSystem.CornerRadius.button)
            }
        }
        
        static func outline(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .font(DesignSystem.Typography.button)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button)
                            .stroke(DesignSystem.Colors.primary, lineWidth: 1)
                    )
            }
        }
        
        static func small(title: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Text(title)
                    .font(DesignSystem.Typography.smallButton)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.primaryLight)
                    .cornerRadius(DesignSystem.CornerRadius.sm)
            }
        }
    }
    
    // MARK: - Cards
    struct Cards {
        static func standard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                content()
            }
            .padding(DesignSystem.Spacing.cardPadding)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.card)
            .shadow(color: DesignSystem.Shadows.card.color, radius: DesignSystem.Shadows.card.radius, x: DesignSystem.Shadows.card.x, y: DesignSystem.Shadows.card.y)
        }
        
        static func elevated<Content: View>(@ViewBuilder content: () -> Content) -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                content()
            }
            .padding(DesignSystem.Spacing.cardPadding)
            .background(DesignSystem.Colors.background)
            .cornerRadius(DesignSystem.CornerRadius.card)
            .shadow(color: DesignSystem.Shadows.large.color, radius: DesignSystem.Shadows.large.radius, x: DesignSystem.Shadows.large.x, y: DesignSystem.Shadows.large.y)
        }
        
        static func compact<Content: View>(@ViewBuilder content: () -> Content) -> some View {
            HStack(spacing: DesignSystem.Spacing.md) {
                content()
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.backgroundSecondary)
            .cornerRadius(DesignSystem.CornerRadius.sm)
            .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: DesignSystem.Shadows.small.x, y: DesignSystem.Shadows.small.y)
        }
    }
    
    // MARK: - Input Fields
    struct InputFields {
        static func standard(title: String, text: Binding<String>, placeholder: String = "") -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                TextField(placeholder, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(DesignSystem.Typography.body)
            }
        }
        
        static func secure(title: String, text: Binding<String>, placeholder: String = "") -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                SecureField(placeholder, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(DesignSystem.Typography.body)
            }
        }
        
        // MARK: - Enhanced Input Fields with Better Contrast
        static func enhancedStandard(title: String, text: Binding<String>, placeholder: String = "") -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                TextField(placeholder, text: text)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .accentColor(DesignSystem.Colors.primary)
                    .padding(DesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.input)
                            .fill(DesignSystem.Colors.backgroundSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.input)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                    )
                    .overlay(
                        // Custom placeholder with better contrast
                        Group {
                            if text.wrappedValue.isEmpty {
                                HStack {
                                    Text(placeholder)
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                    Spacer()
                                }
                                .padding(DesignSystem.Spacing.md)
                                .allowsHitTesting(false)
                            }
                        }
                    )
            }
        }
        
        static func enhancedMultiline(title: String, text: Binding<String>, placeholder: String = "", lineLimit: ClosedRange<Int> = 3...6) -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                TextField(placeholder, text: text, axis: .vertical)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .accentColor(DesignSystem.Colors.primary)
                    .lineLimit(lineLimit)
                    .padding(DesignSystem.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.input)
                            .fill(DesignSystem.Colors.backgroundSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.input)
                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                            )
                    )
                    .overlay(
                        // Custom placeholder with better contrast
                        Group {
                            if text.wrappedValue.isEmpty {
                                VStack {
                                    HStack {
                                        Text(placeholder)
                                            .font(DesignSystem.Typography.body)
                                            .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(DesignSystem.Spacing.md)
                                .allowsHitTesting(false)
                            }
                        }
                    )
            }
        }
    }
    
    // MARK: - Lists
    struct Lists {
        static func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.sectionHeader)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                
                VStack(spacing: 0) {
                    content()
                }
                .background(DesignSystem.Colors.backgroundSecondary)
                .cornerRadius(DesignSystem.CornerRadius.md)
            }
        }
        
        static func item<Content: View>(@ViewBuilder content: () -> Content) -> some View {
            HStack(spacing: DesignSystem.Spacing.md) {
                content()
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.background)
        }
    }
    
    // MARK: - Status Indicators
    struct StatusIndicators {
        static func success(_ message: String) -> some View {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(DesignSystem.Colors.success)
                Text(message)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.success.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.sm)
        }
        
        static func warning(_ message: String) -> some View {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(DesignSystem.Colors.warning)
                Text(message)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.warning.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.sm)
        }
        
        static func error(_ message: String) -> some View {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(DesignSystem.Colors.error)
                Text(message)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.error.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.sm)
        }
    }
}

// MARK: - TinySteps Design (Legacy compatibility)
struct TinyStepsDesign {

    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primary = Color("PrimaryColor")
        static let primaryDark = Color("PrimaryDarkColor")
        static let primaryLight = Color("PrimaryLightColor")

        // Secondary Colors
        static let secondary = Color("SecondaryColor")
        static let secondaryDark = Color("SecondaryDarkColor")
        static let secondaryLight = Color("SecondaryLightColor")

        // Accent Colors
        static let accent = Color("AccentColor")
        static let accentDark = Color("AccentDarkColor")
        static let accentLight = Color("AccentLightColor")

        // Status Colors
        static let success = Color("SuccessColor")
        static let warning = Color("WarningColor")
        static let error = Color("ErrorColor")
        static let info = Color("InfoColor")

        // Background Colors
        static let background = Color("BackgroundColor")
        static let backgroundSecondary = Color("BackgroundSecondaryColor")
        static let backgroundTertiary = Color("BackgroundTertiaryColor")

        // Text Colors
        static let textPrimary = Color("TextPrimaryColor")
        static let textSecondary = Color("TextSecondaryColor")
        static let textTertiary = Color("TextTertiaryColor")

        // Border Colors
        static let border = Color("BorderColor")
        static let borderLight = Color("BorderLightColor")

        // Shadow Colors
        static let shadow = Color("ShadowColor")
        static let shadowDark = Color("ShadowColor")
    }

    // MARK: - Typography
    struct Typography {
        // Headings
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.semibold)
        static let headline = Font.headline.weight(.semibold)
        static let subheader = Font.system(size: 18, weight: .semibold, design: .rounded)

        // Body Text
        static let body = Font.body
        static let bodyEmphasized = Font.body.weight(.medium)
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
        static let caption2 = Font.caption2

        // Custom Sizes
        static let hero = Font.system(size: 32, weight: .bold, design: .rounded)
        static let sectionHeader = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let button = Font.system(size: 16, weight: .medium, design: .rounded)
        static let smallButton = Font.system(size: 14, weight: .medium, design: .rounded)
    }

    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64

        // Custom Spacing
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
    }

    // MARK: - Animations
    struct Animations {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
        static let snappy = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.8)
        static let tap = SwiftUI.Animation.easeInOut(duration: 0.15)
        static let hover = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let focus = SwiftUI.Animation.easeInOut(duration: 0.25)
    }
}


// MARK: - Design System Preview
struct DesignSystemPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.sectionSpacing) {
                // Colors
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Colors")
                        .font(DesignSystem.Typography.sectionHeader)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DesignSystem.Spacing.sm) {
                        ColorSwatch(color: DesignSystem.Colors.primary, name: "Primary")
                        ColorSwatch(color: DesignSystem.Colors.secondary, name: "Secondary")
                        ColorSwatch(color: DesignSystem.Colors.accent, name: "Accent")
                        ColorSwatch(color: DesignSystem.Colors.success, name: "Success")
                        ColorSwatch(color: DesignSystem.Colors.warning, name: "Warning")
                        ColorSwatch(color: DesignSystem.Colors.error, name: "Error")
                    }
                }
                
                // Buttons
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Buttons")
                        .font(DesignSystem.Typography.sectionHeader)
                    
                    VStack(spacing: DesignSystem.Spacing.sm) {
                        DesignSystem.Buttons.primary(title: "Primary Button") { }
                        DesignSystem.Buttons.secondary(title: "Secondary Button") { }
                        DesignSystem.Buttons.outline(title: "Outline Button") { }
                        DesignSystem.Buttons.small(title: "Small Button") { }
                    }
                }
                
                // Cards
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Cards")
                        .font(DesignSystem.Typography.sectionHeader)
                    
                    VStack(spacing: DesignSystem.Spacing.sm) {
                        DesignSystem.Cards.standard {
                            Text("Standard Card")
                                .font(DesignSystem.Typography.body)
                        }
                        
                        DesignSystem.Cards.elevated {
                            Text("Elevated Card")
                                .font(DesignSystem.Typography.body)
                        }
                    }
                }
                
                // Status Indicators
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text("Status Indicators")
                        .font(DesignSystem.Typography.sectionHeader)
                    
                    VStack(spacing: DesignSystem.Spacing.sm) {
                        DesignSystem.StatusIndicators.success("Success message")
                        DesignSystem.StatusIndicators.warning("Warning message")
                        DesignSystem.StatusIndicators.error("Error message")
                    }
                }
            }
            .padding(DesignSystem.Spacing.md)
        }
    }
}

struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(color)
                .frame(height: 40)
            
            Text(name)
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}
