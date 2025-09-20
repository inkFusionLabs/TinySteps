//
//  ScreenSizeUtility.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI
import UIKit

// MARK: - Screen Size Utility
struct ScreenSizeUtility {
    
    // MARK: - Device Categories
    enum DeviceCategory {
        case iPhoneSE         // 4.7" or smaller
        case iPhoneStandard   // 5.4" - 6.1" (iPhone 12/13/14 mini, standard)
        case iPhoneAir        // 6.1" - 6.3" (iPhone Air - mid-range)
        case iPhoneLarge      // 6.5" - 6.7" (iPhone Plus/Max models)
        case iPhoneProMax     // 6.7" - 6.9" (iPhone 14/15/16 Pro Max)
        case iPhone17Pro      // 6.9" + (iPhone 17 Pro - largest)
        case iPad             // All iPad models
        case iPadPro          // iPad Pro models (larger screens)
        
        var isCompact: Bool {
            switch self {
            case .iPhoneSE, .iPhoneStandard, .iPhoneAir:
                return true
            case .iPhoneLarge, .iPhoneProMax, .iPhone17Pro, .iPad, .iPadPro:
                return false
            }
        }
        
        var hasHomeIndicator: Bool {
            switch self {
            case .iPhoneSE, .iPhoneStandard:
                return false
            case .iPhoneAir, .iPhoneLarge, .iPhoneProMax, .iPhone17Pro, .iPad, .iPadPro:
                return true
            }
        }
        
        var recommendedGridColumns: Int {
            switch self {
            case .iPhoneSE:
                return 2
            case .iPhoneStandard, .iPhoneAir:
                return 2
            case .iPhoneLarge:
                return 3
            case .iPhoneProMax:
                return 3
            case .iPhone17Pro:
                return 4
            case .iPad:
                return 4
            case .iPadPro:
                return 5
            }
        }
        
        var cardSpacing: CGFloat {
            switch self {
            case .iPhoneSE:
                return 12
            case .iPhoneStandard, .iPhoneAir:
                return 16
            case .iPhoneLarge:
                return 20
            case .iPhoneProMax:
                return 24
            case .iPhone17Pro:
                return 28
            case .iPad:
                return 24
            case .iPadPro:
                return 28
            }
        }
        
        var buttonHeight: CGFloat {
            switch self {
            case .iPhoneSE:
                return 44
            case .iPhoneStandard, .iPhoneAir:
                return 48
            case .iPhoneLarge:
                return 52
            case .iPhoneProMax:
                return 56
            case .iPhone17Pro:
                return 60
            case .iPad:
                return 56
            case .iPadPro:
                return 60
            }
        }
        
        var fontScale: CGFloat {
            switch self {
            case .iPhoneSE:
                return 0.9
            case .iPhoneStandard, .iPhoneAir:
                return 1.0
            case .iPhoneLarge:
                return 1.05
            case .iPhoneProMax:
                return 1.1
            case .iPhone17Pro:
                return 1.15
            case .iPad:
                return 1.2
            case .iPadPro:
                return 1.25
            }
        }
    }
    
    // MARK: - Screen Properties
    static var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    static var screenWidth: CGFloat {
        screenSize.width
    }
    
    static var screenHeight: CGFloat {
        screenSize.height
    }
    
    static var deviceCategory: DeviceCategory {
        // iPad detection
        if UIDevice.current.userInterfaceIdiom == .pad {
            return screenWidth > 1000 ? .iPadPro : .iPad
        }
        
        // iPhone detection based on screen size
        let diagonal = sqrt(pow(screenSize.width, 2) + pow(screenSize.height, 2)) / UIScreen.main.scale
        
        if diagonal <= 4.7 {
            return .iPhoneSE
        } else if diagonal <= 6.1 {
            return .iPhoneStandard
        } else if diagonal <= 6.3 {
            return .iPhoneAir
        } else if diagonal <= 6.7 {
            return .iPhoneLarge
        } else if diagonal <= 6.9 {
            return .iPhoneProMax
        } else {
            return .iPhone17Pro
        }
    }
    
    // MARK: - Layout Properties
    static var maxContentWidth: CGFloat {
        switch deviceCategory {
        case .iPhoneSE:
            return screenWidth - 32
        case .iPhoneStandard, .iPhoneAir:
            return min(screenWidth - 32, 380)
        case .iPhoneLarge:
            return min(screenWidth - 32, 420)
        case .iPhoneProMax:
            return min(screenWidth - 32, 440)
        case .iPhone17Pro:
            return min(screenWidth - 32, 480)
        case .iPad:
            return min(screenWidth - 64, 600)
        case .iPadPro:
            return min(screenWidth - 80, 800)
        }
    }
    
    static var cardWidth: CGFloat {
        switch deviceCategory {
        case .iPhoneSE:
            return screenWidth - 32
        case .iPhoneStandard, .iPhoneAir:
            return (screenWidth - 48) / 2 // 2 columns
        case .iPhoneLarge:
            return (screenWidth - 60) / 3 // 3 columns
        case .iPhoneProMax:
            return (screenWidth - 64) / 3 // 3 columns
        case .iPhone17Pro:
            return (screenWidth - 80) / 4 // 4 columns
        case .iPad:
            return (screenWidth - 96) / 4 // 4 columns
        case .iPadPro:
            return (screenWidth - 112) / 5 // 5 columns
        }
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    static var statusBarHeight: CGFloat {
        safeAreaInsets.top
    }
    
    static var bottomSafeArea: CGFloat {
        safeAreaInsets.bottom
    }
    
    // MARK: - Responsive Helpers
    static func scaledFont(size: CGFloat) -> Font {
        let scaledSize = size * deviceCategory.fontScale
        return .system(size: scaledSize)
    }
    
    static func scaledValue(_ value: CGFloat) -> CGFloat {
        return value * deviceCategory.fontScale
    }
    
    static var isLandscape: Bool {
        return screenWidth > screenHeight
    }
    
    static var isPortrait: Bool {
        return screenHeight > screenWidth
    }
}

// MARK: - Screen Size Specific Modifiers
struct ScreenSizeSpecificViewModifier: ViewModifier {
    let seView: () -> AnyView
    let standardView: () -> AnyView
    let airView: () -> AnyView
    let largeView: () -> AnyView
    let proMaxView: () -> AnyView
    let iPhone17ProView: () -> AnyView

    func body(content: Content) -> some View {
        switch ScreenSizeUtility.deviceCategory {
        case .iPhoneSE:
            seView()
        case .iPhoneStandard:
            standardView()
        case .iPhoneAir:
            airView()
        case .iPhoneLarge:
            largeView()
        case .iPhoneProMax:
            proMaxView()
        case .iPhone17Pro:
            iPhone17ProView()
        case .iPad, .iPadPro:
            // Use large view for iPads
            largeView()
        }
    }
}

// MARK: - View Extensions
extension View {
    func screenSizeSpecific<SEContent: View, StandardContent: View, AirContent: View, LargeContent: View, ProMaxContent: View, iPhone17ProContent: View>(
        @ViewBuilder se: @escaping () -> SEContent,
        @ViewBuilder standard: @escaping () -> StandardContent,
        @ViewBuilder air: @escaping () -> AirContent,
        @ViewBuilder large: @escaping () -> LargeContent,
        @ViewBuilder proMax: @escaping () -> ProMaxContent,
        @ViewBuilder iPhone17Pro: @escaping () -> iPhone17ProContent
    ) -> some View {
        modifier(ScreenSizeSpecificViewModifier(
            seView: { AnyView(se()) },
            standardView: { AnyView(standard()) },
            airView: { AnyView(air()) },
            largeView: { AnyView(large()) },
            proMaxView: { AnyView(proMax()) },
            iPhone17ProView: { AnyView(iPhone17Pro()) }
        ))
    }
    
    func responsivePadding() -> some View {
        self.padding(ScreenSizeUtility.deviceCategory.cardSpacing / 2)
    }
    
    func responsiveFont(size: CGFloat) -> some View {
        self.font(ScreenSizeUtility.scaledFont(size: size))
    }
    
    func responsiveFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self.frame(
            width: width.map { ScreenSizeUtility.scaledValue($0) },
            height: height.map { ScreenSizeUtility.scaledValue($0) }
        )
    }
}


