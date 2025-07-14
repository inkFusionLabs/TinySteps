import SwiftUI

struct WelcomeView: View {
    @Binding var showNameEntry: Bool

    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                Image("WelcomeImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
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
    }
}

#Preview {
    WelcomeView(showNameEntry: .constant(false))
}

