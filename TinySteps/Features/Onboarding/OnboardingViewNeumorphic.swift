import SwiftUI

struct OnboardingViewNeumorphic: View {
    @Binding var showNameEntry: Bool
    @State private var currentPage: Int = 0
    @State private var isAnimating = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack {
                headerSection
                    .slideIn(from: .fromTop)
                
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    featuresPage.tag(1)
                    securityPage.tag(2)
                    getStartedPage.tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(TinyStepsDesign.Animations.pageTransition, value: currentPage)
                
                navigationControls
                    .slideIn(from: .fromBottom)
            }
            .onAppear {
                withAnimation(TinyStepsDesign.Animations.gentle) {
                    isAnimating = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            if currentPage < 3 {
                Button("Skip") {
                    completeOnboarding()
                }
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
            } else {
                Spacer()
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index <= currentPage ? 
                              TinyStepsDesign.NeumorphicColors.primary : 
                              TinyStepsDesign.NeumorphicColors.textMuted.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding()
    }
    
    private var welcomePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(TinyStepsDesign.NeumorphicColors.base)
                    .frame(width: 120, height: 120)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: 8, x: -4, y: -4)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: 8, x: 4, y: 4)
                
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 48))
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.primary)
            }
            
            VStack(spacing: 12) {
                Text("Welcome to TinySteps")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
                
                Text("For Dads in the NICU and Beyond")
                    .font(.title3)
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.primary)
            }
            
            Text("Support, track, and celebrate your baby's journey—from the neonatal unit to home and every milestone along the way.")
                .font(.body)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    private var featuresPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Track Every Step")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                FeatureCard(icon: "list.bullet.rectangle.portrait", title: "Milestones", color: TinyStepsDesign.NeumorphicColors.primary)
                FeatureCard(icon: "bell.fill", title: "Reminders", color: TinyStepsDesign.NeumorphicColors.warning)
                FeatureCard(icon: "chart.line.uptrend.xyaxis", title: "Growth", color: TinyStepsDesign.NeumorphicColors.success)
                FeatureCard(icon: "heart.fill", title: "Health", color: TinyStepsDesign.NeumorphicColors.error)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    private var securityPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(TinyStepsDesign.NeumorphicColors.base)
                    .frame(width: 120, height: 120)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: 8, x: -4, y: -4)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: 8, x: 4, y: 4)
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 48))
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.success)
            }
            
            Text("Your Data, Secure")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
            
            Text("Protect your baby's journey with enterprise-grade security and privacy controls.")
                .font(.body)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    private var getStartedPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(TinyStepsDesign.NeumorphicColors.base)
                    .frame(width: 120, height: 120)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: 8, x: -4, y: -4)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: 8, x: 4, y: 4)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(TinyStepsDesign.NeumorphicColors.success)
            }
            
            Text("Ready to Begin?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
            
            Text("Start your journey with TinySteps and create lasting memories of your baby's growth and development.")
                .font(.body)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    private var navigationControls: some View {
        HStack {
            if currentPage > 0 {
                Button("Back") {
                    withAnimation {
                        currentPage -= 1
                    }
                }
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textSecondary)
                .padding()
            } else {
                Spacer()
            }
            
            Spacer()
            
            if currentPage < 3 {
                Button("Next") {
                    withAnimation(TinyStepsDesign.Animations.bouncy) {
                        currentPage += 1
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(TinyStepsDesign.NeumorphicColors.primary)
                )
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .animation(TinyStepsDesign.Animations.bouncy.delay(0.5), value: isAnimating)
            } else {
                Button("Get Started") {
                    completeOnboarding()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(TinyStepsDesign.NeumorphicColors.primary)
                )
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .animation(TinyStepsDesign.Animations.bouncy.delay(0.5), value: isAnimating)
            }
        }
        .padding()
    }
    
    private func completeOnboarding() {
        hasSeenOnboarding = true
        showNameEntry = true
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(TinyStepsDesign.NeumorphicColors.base)
                    .frame(width: 60, height: 60)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: isPressed ? 2 : 4, x: isPressed ? -1 : -2, y: isPressed ? -1 : -2)
                    .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: isPressed ? 2 : 4, x: isPressed ? 1 : 2, y: isPressed ? 1 : 2)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(TinyStepsDesign.NeumorphicColors.textPrimary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(TinyStepsDesign.NeumorphicColors.base)
                .shadow(color: TinyStepsDesign.NeumorphicColors.lightShadow, radius: isPressed ? 2 : 3, x: isPressed ? -0.5 : -1, y: isPressed ? -0.5 : -1)
                .shadow(color: TinyStepsDesign.NeumorphicColors.darkShadow, radius: isPressed ? 2 : 3, x: isPressed ? 0.5 : 1, y: isPressed ? 0.5 : 1)
        )
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
        }
    }
}
