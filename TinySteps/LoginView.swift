import SwiftUI

struct LoginView: View {
    @AppStorage("app_passcode") private var appPasscode: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    
    @State private var enteredPasscode: String = ""
    @State private var errorMessage: String? = nil
    @State private var showingPasscodeSetup = false
    
    var body: some View {
        ZStack {
            // Background gradient
            Color.clear
                .ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("TinySteps")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Enter your passcode to continue")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Passcode Input
                    VStack(spacing: 20) {
                        SecureField("Enter passcode", text: $enteredPasscode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(maxWidth: 200)
                            .onChange(of: enteredPasscode) { oldValue, newValue in
                                if newValue.count == 4 {
                                    authenticate()
                                }
                            }
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    
                    Button("Unlock") {
                        authenticate()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(enteredPasscode.isEmpty)
                    
                    if appPasscode.isEmpty {
                        Button("Set Up Passcode") {
                            showingPasscodeSetup = true
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                }
                .padding()
                #if os(iOS)
                .navigationBarHidden(true)
                #endif
            }
        }
        .sheet(isPresented: $showingPasscodeSetup) {
            Text("Passcode Setup")
        }
    }
    
    private func authenticate() {
        if appPasscode.isEmpty {
            // No passcode set, allow access
            isLoggedIn = true
        } else if enteredPasscode == appPasscode {
            // Correct passcode
            isLoggedIn = true
            enteredPasscode = ""
            errorMessage = nil
        } else {
            // Wrong passcode
            errorMessage = "Incorrect passcode. Please try again."
            enteredPasscode = ""
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 