import SwiftUI

struct LoginView: View {
    @AppStorage("registeredEmail") private var registeredEmail: String = ""
    @AppStorage("registeredPassword") private var registeredPassword: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isRegistering: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 24) {
                    Text(isRegistering ? "Register" : "Login")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        #if os(iOS)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        #else
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        #endif
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if isRegistering {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    
                    Button(action: {
                        errorMessage = nil
                        if isRegistering {
                            register()
                        } else {
                            login()
                        }
                    }) {
                        Text(isRegistering ? "Register" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        isRegistering.toggle()
                        errorMessage = nil
                    }) {
                        Text(isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                #if os(iOS)
                .navigationBarHidden(true)
                #endif
            }
        }
    }
    
    private func register() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return
        }
        registeredEmail = email
        registeredPassword = password
        isLoggedIn = true
    }
    
    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        guard email == registeredEmail, password == registeredPassword else {
            errorMessage = "Invalid email or password."
            return
        }
        isLoggedIn = true
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 