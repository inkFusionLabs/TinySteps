import SwiftUI

struct WelcomeView: View {
    @Binding var showNameEntry: Bool
    @State private var showProfile = false
    @AppStorage("userAvatar") private var userAvatarData: Data = Data()
    @State private var userAvatar: UserAvatar = UserAvatar()
    @State private var showAvatarBuilder = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var onboardingPage: Int = 0

    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            VStack(spacing: 40) {
                TabView(selection: $onboardingPage) {
                    // Page 1: Welcome
                    VStack(spacing: 24) {
                        Text("Welcome, Dad!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .accessibilityLabel("Welcome, Dad!")
                            .accessibilityAddTraits(.isHeader)
                        Text("Start your journey with TinySteps.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .accessibilityLabel("Start your journey with TinySteps.")
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.blue)
                            .shadow(radius: 20)
                            .accessibilityHidden(true)
                        Text("For Dads in the NICU and Beyond")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                            .kerning(1.5)
                            .accessibilityLabel("For Dads in the NICU and Beyond")
                        Text("Support, track, and celebrate your baby's journey—from the neonatal unit to home and every milestone along the way.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .accessibilityLabel("Support, track, and celebrate your baby's journey from the neonatal unit to home and every milestone along the way.")
                    }
                    .tag(0)
                    // Page 2: Features
                    VStack(spacing: 24) {
                        Text("Track Every Step")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .font(.system(size: 80))
                            .foregroundColor(.yellow)
                        Text("Log milestones, set reminders, and keep all your baby's important moments in one place.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        Text("Share progress and memories with your family and care team.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .tag(1)
                    // Page 3: Security
                    VStack(spacing: 24) {
                        Text("Your Data, Secure")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Image(systemName: "lock.shield")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        Text("Protect your baby's journey with passcode security.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        Text("You control your data. TinySteps never shares your information.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(height: 420)
                HStack {
                    if onboardingPage < 2 {
                        Button("Skip") {
                            hasSeenOnboarding = true
                        }
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading)
                        Spacer()
                        Button("Next") {
                            onboardingPage += 1
                        }
                        .foregroundColor(.white)
                        .padding(.trailing)
                        .accessibilityLabel("Next onboarding page")
                    } else {
                        Spacer()
                        Button(action: {
                            hasSeenOnboarding = true
                            showNameEntry = true
                        }) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(Color.blue.opacity(0.8)))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Get Started")
                        .accessibilityHint("Begin using TinySteps and set up your profile.")
                        Spacer()
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showAvatarBuilder, onDismiss: saveAvatar) {
            AvatarBuilderView(avatar: $userAvatar)
        }
        .onAppear {
            if let loaded = try? JSONDecoder().decode(UserAvatar.self, from: userAvatarData), userAvatarData.count > 0 {
                userAvatar = loaded
            }
        }
    }

    private func saveAvatar() {
        if let data = try? JSONEncoder().encode(userAvatar) {
            userAvatarData = data
        }
    }
}

#Preview {
    WelcomeView(showNameEntry: .constant(false))
}

