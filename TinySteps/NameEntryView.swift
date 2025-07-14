import SwiftUI

struct NameEntryView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var tempName: String = ""
    @State private var showError = false

    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Text("What's your name?")
                    .font(.title)
                    .foregroundColor(.white)
                TextField("Your name", text: $tempName)
                    .textFieldStyle(CustomTextFieldStyle())
                    .frame(width: 260)
                    .onSubmit { submitName() }
                if showError {
                    Text("Please enter your name.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Button(action: submitName) {
                    Text("Continue")
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

    private func submitName() {
        let trimmed = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            showError = true
        } else {
            userName = trimmed
        }
    }
} 