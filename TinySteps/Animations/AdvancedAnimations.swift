//
//  AdvancedAnimations.swift
//  TinySteps
//
//  Created by GPT-5.1 Codex on 15/11/2025.
//

import SwiftUI
import CoreMotion
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Optimized Animated Background
struct AnimatedAppBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var animateGradient = false

    var body: some View {
        ZStack {
            theme.background
                .overlay(theme.backgroundGradient.opacity(0.4))
                .ignoresSafeArea()

            // Single subtle animated gradient layer
            theme.backgroundGradient
                .scaleEffect(animateGradient ? 1.1 : 0.9)
                .blur(radius: 60)
                .opacity(0.3)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
        .allowsHitTesting(false)
    }

    private var theme: ThemeColors {
        themeManager.currentTheme.colors
    }
}

// Performance optimized - heavy components removed

// MARK: - Motion Driven Parallax
final class MotionManager: ObservableObject {
    static let shared = MotionManager()
    
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0
    
    private let manager = CMMotionManager()
    private let queue = OperationQueue()
    
    private init() {
        #if targetEnvironment(simulator)
        startSimulatorMock()
        #else
        startMotionUpdates()
        #endif
    }
    
    private func startMotionUpdates() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
            guard let strongMotion = motion else { return }
            let roll = CGFloat(strongMotion.attitude.roll)
            let pitch = CGFloat(strongMotion.attitude.pitch)
            DispatchQueue.main.async {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.9)) {
                    self?.x = roll
                    self?.y = pitch
                }
            }
        }
    }
    
    private func startSimulatorMock() {
        let duration: Double = 6
        Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            let now = Date().timeIntervalSinceReferenceDate
            withAnimation(.easeInOut(duration: 0.3)) {
                self.x = CGFloat(sin(now / duration))
                self.y = CGFloat(cos(now / duration))
            }
        }
    }
}

struct ParallaxMotionModifier: ViewModifier {
    @ObservedObject private var motion = MotionManager.shared
    var intensity: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: motion.x * intensity,
                y: motion.y * intensity
            )
    }
}

// MARK: - Animated Card Styling
enum AnimatedCardDepth {
    case low, medium, high
}

private struct AnimatedCardStyleModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    let depth: AnimatedCardDepth
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(theme.backgroundSecondary.opacity(0.92))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        theme.border,
                                        theme.borderLight.opacity(0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: strokeWidth
                            )
                    )
                    .shadow(
                        color: theme.shadow.opacity(shadowOpacity),
                        radius: shadowRadius,
                        x: 0,
                        y: shadowOffset
                    )
                    .overlay(glowLayer)
            )
            .modifier(ParallaxMotionModifier(intensity: parallaxIntensity))
    }
    
    private var theme: ThemeColors {
        themeManager.currentTheme.colors
    }
    
    private var strokeWidth: CGFloat {
        switch depth {
        case .low: return 0.6
        case .medium: return 1.0
        case .high: return 1.4
        }
    }
    
    private var shadowOpacity: Double {
        switch depth {
        case .low: return 0.25
        case .medium: return 0.35
        case .high: return 0.5
        }
    }
    
    private var shadowRadius: CGFloat {
        switch depth {
        case .low: return 8
        case .medium: return 14
        case .high: return 22
        }
    }
    
    private var shadowOffset: CGFloat {
        switch depth {
        case .low: return 4
        case .medium: return 6
        case .high: return 10
        }
    }
    
    private var parallaxIntensity: CGFloat {
        switch depth {
        case .low: return 2
        case .medium: return 4
        case .high: return 7
        }
    }
    
    @ViewBuilder
    private var glowLayer: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [
                        theme.accent.opacity(0.35),
                        theme.secondary.opacity(0.25),
                        theme.info.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
            .blur(radius: 24)
            .blendMode(.screen)
            .opacity(depth == .high ? 0.9 : 0.4)
    }
}

// MARK: - Cascade Animation
private struct CascadeAnimationModifier: ViewModifier {
    let index: Int
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 24)
            .onAppear {
                withAnimation(
                    .spring(response: 0.7, dampingFraction: 0.85)
                        .delay(Double(index) * delay)
                ) {
                    isVisible = true
                }
            }
    }
}

// MARK: - Animated Button Style
struct AnimatedLiftButtonStyle: SwiftUI.ButtonStyle {
    var scale: CGFloat = 0.94
    var hapticOnPress: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                #if os(iOS)
                if hapticOnPress, newValue {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                #endif
            }
    }
}

// MARK: - View Helpers
extension View {
    func immersiveBackground() -> some View {
        background(AnimatedAppBackground())
    }
    
    func animatedCard(depth: AnimatedCardDepth = .medium, cornerRadius: CGFloat = 20) -> some View {
        modifier(AnimatedCardStyleModifier(depth: depth, cornerRadius: cornerRadius))
    }
    
    func parallaxed(_ intensity: CGFloat = 6) -> some View {
        modifier(ParallaxMotionModifier(intensity: intensity))
    }
    
    func cascadeAnimation(index: Int, delay: Double = 0.05) -> some View {
        modifier(CascadeAnimationModifier(index: index, delay: delay))
    }
}

// MARK: - Shimmer
private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    var speed: Double
    var highlightColor: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        highlightColor.opacity(0.9),
                        .clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .mask(content)
                .opacity(0.8)
                .rotationEffect(.degrees(10))
                .offset(x: phase)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: speed)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 240
                }
            }
    }
}

extension View {
    func shimmering(speed: Double = 1.4, highlightColor: Color = .white) -> some View {
        modifier(ShimmerModifier(speed: speed, highlightColor: highlightColor))
    }
}


