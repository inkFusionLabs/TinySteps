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

// MARK: - Animated Background
struct AnimatedAppBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var animateGradient = false
    @State private var gradientRotation: Double = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                theme.background
                    .overlay(theme.backgroundGradient.opacity(0.55))
                    .ignoresSafeArea()
                
                // Multiple animated gradient layers
                ForEach(0..<3, id: \.self) { index in
                    theme.backgroundGradient
                        .scaleEffect(animateGradient ? (1.3 + Double(index) * 0.2) : (0.9 - Double(index) * 0.1))
                        .rotationEffect(.degrees(gradientRotation + Double(index) * 120))
                        .blur(radius: 80 + CGFloat(index) * 20)
                        .opacity(0.7 - Double(index) * 0.15)
                        .offset(
                            x: sin(time * 0.05 + Double(index)) * 30,
                            y: cos(time * 0.05 + Double(index)) * 30
                        )
                }
                
                // Floating orbs
                FloatingOrbs(time: time, theme: theme)
                
                // Wave layers
                WaveLayer(time: time, theme: theme, index: 0)
                WaveLayer(time: time, theme: theme, index: 1)
                
                AnimatedAuroraLayer(time: time)
                ParticleField(colors: [theme.accent, theme.info, theme.secondary])
                
                // Additional particle layer for depth
                ParticleField(colors: [theme.primary, theme.warning, theme.success], count: 32, speed: 0.15)
                    .opacity(0.6)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            animateGradient = true
            withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }
        }
        .allowsHitTesting(false)
    }
    
    private var theme: ThemeColors {
        themeManager.currentTheme.colors
    }
}

// MARK: - Floating Orbs
private struct FloatingOrbs: View {
    let time: TimeInterval
    let theme: ThemeColors
    
    var body: some View {
        Canvas { context, size in
            let orbCount = 8
            for i in 0..<orbCount {
                let phase = time * 0.3 + Double(i) * .pi * 2 / Double(orbCount)
                let baseX = size.width * (0.2 + Double(i % 3) * 0.3)
                let baseY = size.height * (0.3 + Double(i % 2) * 0.4)
                
                let x = baseX + sin(phase) * size.width * 0.15
                let y = baseY + cos(phase * 0.7) * size.height * 0.2
                
                let radius = 40 + sin(phase * 2) * 20
                let colors = [
                    [theme.accent, theme.secondary],
                    [theme.info, theme.primary],
                    [theme.success, theme.warning]
                ][i % 3]
                
                let rect = CGRect(
                    x: x - radius,
                    y: y - radius,
                    width: radius * 2,
                    height: radius * 2
                )
                
                let gradient = GraphicsContext.Shading.radialGradient(
                    Gradient(colors: [
                        colors[0].opacity(0.4),
                        colors[1].opacity(0.2),
                        Color.clear
                    ]),
                    center: CGPoint(x: rect.midX, y: rect.midY),
                    startRadius: 0,
                    endRadius: radius
                )
                
                context.drawLayer { layer in
                    layer.addFilter(.blur(radius: 30))
                    layer.fill(Path(ellipseIn: rect), with: gradient)
                }
            }
        }
        .blendMode(.plusLighter)
        .opacity(0.6)
    }
}

// MARK: - Wave Layer
private struct WaveLayer: View {
    let time: TimeInterval
    let theme: ThemeColors
    let index: Int
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let waveLength = width / 2
                let amplitude = height * 0.1
                let frequency = 2.0
                
                let phase = time * 0.5 + Double(index) * .pi
                let yOffset = height * (0.3 + Double(index) * 0.4)
                
                path.move(to: CGPoint(x: 0, y: yOffset))
                
                for x in stride(from: 0, through: width, by: 2) {
                    let relativeX = x / waveLength
                    let y = yOffset + amplitude * sin(relativeX * frequency * .pi + phase)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        theme.accent.opacity(0.15 - Double(index) * 0.05),
                        theme.secondary.opacity(0.1 - Double(index) * 0.03),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .blur(radius: 20)
        .blendMode(.screen)
    }
}

// MARK: - Aurora Layer
private struct AnimatedAuroraLayer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let time: TimeInterval
    
    var body: some View {
        Canvas { context, size in
            let gradients = [
                Gradient(colors: [theme.primary.opacity(0.45), theme.secondary.opacity(0.25)]),
                Gradient(colors: [theme.accent.opacity(0.35), theme.info.opacity(0.25)]),
                Gradient(colors: [theme.success.opacity(0.3), theme.warning.opacity(0.2)])
            ]
            
            for (index, gradient) in gradients.enumerated() {
                let phase = time * 0.08 + Double(index) * .pi / 3
                let width = size.width * CGFloat(0.6 + 0.25 * sin(phase))
                let height = size.height * CGFloat(0.5 + 0.3 * cos(phase))
                let x = (size.width - width) / 2 + CGFloat(sin(phase) * Double(size.width) * 0.2)
                let y = (size.height - height) / 2 + CGFloat(cos(phase) * Double(size.height) * 0.2)
                let rect = CGRect(x: x, y: y, width: width, height: height)
                
                let shading = GraphicsContext.Shading.linearGradient(
                    gradient,
                    startPoint: CGPoint(x: rect.minX, y: rect.minY),
                    endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
                )
                
                context.drawLayer { layer in
                    layer.addFilter(.blur(radius: 110))
                    layer.fill(
                        Path(roundedRect: rect, cornerRadius: min(rect.width, rect.height) / 2),
                        with: shading,
                        style: FillStyle(eoFill: true, antialiased: true)
                    )
                }
            }
        }
        .blendMode(.screen)
        .opacity(0.65)
    }
    
    private var theme: ThemeColors {
        themeManager.currentTheme.colors
    }
}

// MARK: - Particle Field
private struct ParticleField: View {
    let colors: [Color]
    var count: Int = 64
    var speed: Double = 0.25
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * speed
            Canvas { context, size in
                for index in 0..<count {
                    let progress = (Double(index) / Double(count)) + time
                    
                    // More varied particle movement patterns
                    let pattern = index % 3
                    let x: CGFloat
                    let y: CGFloat
                    
                    switch pattern {
                    case 0:
                        // Circular motion
                        x = (sin(progress * 1.7) * 0.5 + 0.5) * size.width
                        y = (cos(progress * 1.1) * 0.5 + 0.5) * size.height
                    case 1:
                        // Figure-8 motion
                        x = (sin(progress * 2.0) * 0.5 + 0.5) * size.width
                        y = (sin(progress * 1.0) * cos(progress * 1.0) * 0.5 + 0.5) * size.height
                    default:
                        // Spiral motion
                        let spiral = progress * 0.5
                        x = (sin(spiral) * spiral * 0.1 + 0.5) * size.width
                        y = (cos(spiral) * spiral * 0.1 + 0.5) * size.height
                    }
                    
                    let diameter = max(1.5, 3.5 + sin(progress * 4) * 2.5)
                    let rect = CGRect(
                        x: x - diameter / 2,
                        y: y - diameter / 2,
                        width: diameter,
                        height: diameter
                    )
                    
                    let particle = Path(ellipseIn: rect)
                    let opacity = 0.12 + Double(index % 4) * 0.04 + sin(progress * 2) * 0.03
                    let color = colors[index % colors.count].opacity(opacity)
                    
                    // Add glow effect to some particles
                    if index % 5 == 0 {
                        context.drawLayer { layer in
                            layer.addFilter(.blur(radius: 3))
                            layer.fill(particle, with: .color(color.opacity(0.5)))
                        }
                    }
                    
                    context.fill(particle, with: .color(color))
                }
            }
        }
        .blur(radius: 0.8)
        .blendMode(.plusLighter)
        .allowsHitTesting(false)
    }
}

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


