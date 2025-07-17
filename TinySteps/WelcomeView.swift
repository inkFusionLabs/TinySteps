import SwiftUI

struct WelcomeView: View {
    @Binding var showNameEntry: Bool
    @State private var showProfile = false
    @AppStorage("userAvatar") private var userAvatarData: Data = Data()
    @State private var userAvatar: UserAvatar = UserAvatar()
    @State private var showAvatarBuilder = false

    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Welcome Banner (Support & Care style)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Welcome, Dad!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Start your journey with TinySteps.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)
                .padding(.top)
                Spacer()
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.blue)
                    .shadow(radius: 20)
                    .padding(.top, 40)

                Text("TINYSTEPS")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)

                Text("For Dads in the NICU and Beyond")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.cyan)
                    .kerning(1.5)
                    .padding(.bottom, 4)
                Text("Support, track, and celebrate your baby's journey—from the neonatal unit to home and every milestone along the way.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                Button(action: { showNameEntry = true }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.blue.opacity(0.8)))
                }
                .buttonStyle(PlainButtonStyle())
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

