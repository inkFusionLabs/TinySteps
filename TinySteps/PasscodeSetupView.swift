import SwiftUI

struct PasscodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("app_passcode") private var appPasscode: String = ""
    
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                Text("Set Up Passcode")
                    .font(.title)
                    .fontWeight(.bold)
                
                SecureField("New Passcode", text: $newPasscode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(maxWidth: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Passcode", text: $confirmPasscode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(maxWidth: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button("Save Passcode") {
                    setupPasscode()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Passcode")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    private var canSave: Bool {
        newPasscode.count == 4 && confirmPasscode.count == 4 && !newPasscode.isEmpty && !confirmPasscode.isEmpty
    }
    
    private func setupPasscode() {
        guard newPasscode.count == 4, confirmPasscode.count == 4 else {
            errorMessage = "Passcode must be 4 digits."
            return
        }
        guard newPasscode == confirmPasscode else {
            errorMessage = "Passcodes do not match."
            return
        }
        appPasscode = newPasscode
        errorMessage = nil
        dismiss()
    }
}
