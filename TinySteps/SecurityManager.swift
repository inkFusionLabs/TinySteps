import SwiftUI
import Foundation
import CryptoKit
import Security

// MARK: - Security Manager
class SecurityManager: ObservableObject {
    @Published var isPasscodeEnabled: Bool = false
    @Published var isEncryptionEnabled: Bool = true
    @Published var securityLevel: SecurityLevel = .standard
    @Published var lastSecurityCheck: Date = Date()
    
    enum SecurityLevel: String, CaseIterable {
        case basic = "Basic"
        case standard = "Standard"
        case enhanced = "Enhanced"
        case maximum = "Maximum"
        
        var description: String {
            switch self {
            case .basic:
                return "Basic security with local data protection"
            case .standard:
                return "Standard security with encryption"
            case .enhanced:
                return "Enhanced security with passcode protection"
            case .maximum:
                return "Maximum security with end-to-end encryption"
            }
        }
    }
    
    private let keychain = UserDefaults.standard
    private let encryptionKey: SymmetricKey
    
    init() {
        // Generate or retrieve encryption key
        if let existingKey = keychain.data(forKey: "encryption_key") {
            self.encryptionKey = SymmetricKey(data: existingKey)
        } else {
            self.encryptionKey = SymmetricKey(size: .bits256)
            keychain.set(encryptionKey.withUnsafeBytes { Data($0) }, forKey: "encryption_key")
        }
        
        setupSecurity()
    }
    
    private func setupSecurity() {
        // Check if passcode is set up
        if let _ = keychain.string(forKey: "app_passcode") {
            isPasscodeEnabled = true
        }
        
        // Set up security monitoring
        startSecurityMonitoring()
    }
    
    private func startSecurityMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.performSecurityCheck()
        }
    }
    
    private func performSecurityCheck() {
        lastSecurityCheck = Date()
        
        // Check for security vulnerabilities
        checkDataIntegrity()
        checkEncryptionStatus()
        checkPasscodeStatus()
    }
}

// MARK: - Data Encryption
extension SecurityManager {
    func encryptData(_ data: Data) -> Data? {
        guard isEncryptionEnabled else { return data }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
            return sealedBox.combined
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }
    
    func decryptData(_ encryptedData: Data) -> Data? {
        guard isEncryptionEnabled else { return encryptedData }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)
            return decryptedData
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
    
    func encryptString(_ string: String) -> String? {
        guard let data = string.data(using: .utf8),
              let encryptedData = encryptData(data) else { return nil }
        return encryptedData.base64EncodedString()
    }
    
    func decryptString(_ encryptedString: String) -> String? {
        guard let encryptedData = Data(base64Encoded: encryptedString),
              let decryptedData = decryptData(encryptedData),
              let string = String(data: decryptedData, encoding: .utf8) else { return nil }
        return string
    }
}

// MARK: - Secure Storage
extension SecurityManager {
    func secureStore(_ data: Data, forKey key: String) -> Bool {
        guard let encryptedData = encryptData(data) else { return false }
        keychain.set(encryptedData, forKey: key)
        return true
    }
    
    func secureRetrieve(forKey key: String) -> Data? {
        guard let encryptedData = keychain.data(forKey: key) else { return nil }
        return decryptData(encryptedData)
    }
    
    func secureStoreString(_ string: String, forKey key: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return secureStore(data, forKey: key)
    }
    
    func secureRetrieveString(forKey key: String) -> String? {
        guard let data = secureRetrieve(forKey: key),
              let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }
}

// MARK: - Passcode Authentication
extension SecurityManager {
    func authenticateWithPasscode(_ passcode: String) -> Bool {
        guard isPasscodeEnabled else { return true }
        
        guard let storedPasscode = keychain.string(forKey: "app_passcode") else {
            return false
        }
        
        return passcode == storedPasscode
    }
    
    func setPasscode(_ passcode: String) -> Bool {
        guard passcode.count >= 4 else { return false }
        
        keychain.set(passcode, forKey: "app_passcode")
        isPasscodeEnabled = true
        return true
    }
    
    func removePasscode() {
        keychain.removeObject(forKey: "app_passcode")
        isPasscodeEnabled = false
    }
    
    func changePasscode(oldPasscode: String, newPasscode: String) -> Bool {
        guard authenticateWithPasscode(oldPasscode) else { return false }
        return setPasscode(newPasscode)
    }
}

// MARK: - Security Monitoring
extension SecurityManager {
    private func checkDataIntegrity() {
        // Check for data tampering
        let criticalDataKeys = ["baby_data", "user_preferences", "security_settings"]
        
        for key in criticalDataKeys {
            if let data = keychain.data(forKey: key) {
                // Verify data integrity
                let checksum = SHA256.hash(data: data)
                let storedChecksum = keychain.data(forKey: "\(key)_checksum")
                
                if storedChecksum != checksum.withUnsafeBytes({ Data($0) }) {
                    print("Data integrity check failed for key: \(key)")
                    // Handle data corruption
                    handleDataCorruption(forKey: key)
                }
            }
        }
    }
    
    private func checkEncryptionStatus() {
        // Verify encryption is working properly
        let testData = "security_test".data(using: .utf8)!
        
        if let encrypted = encryptData(testData),
           let decrypted = decryptData(encrypted),
           decrypted == testData {
            // Encryption is working
        } else {
            print("Encryption verification failed")
            isEncryptionEnabled = false
        }
    }
    
    private func checkPasscodeStatus() {
        let hasPasscode = keychain.string(forKey: "app_passcode") != nil
        
        if isPasscodeEnabled != hasPasscode {
            print("Passcode status changed: \(hasPasscode)")
            isPasscodeEnabled = hasPasscode
        }
    }
    
    private func handleDataCorruption(forKey key: String) {
        // Remove corrupted data
        keychain.removeObject(forKey: key)
        keychain.removeObject(forKey: "\(key)_checksum")
        
        // Notify user
        NotificationCenter.default.post(
            name: NSNotification.Name("DataCorruptionDetected"),
            object: nil,
            userInfo: ["key": key]
        )
    }
}

// MARK: - Secure Data Manager
class SecureDataManager: ObservableObject {
    private let securityManager = SecurityManager()
    
    func saveBabyData(_ baby: Baby) -> Bool {
        do {
            let data = try JSONEncoder().encode(baby)
            return securityManager.secureStore(data, forKey: "baby_data")
        } catch {
            print("Failed to encode baby data: \(error)")
            return false
        }
    }
    
    func loadBabyData() -> Baby? {
        guard let data = securityManager.secureRetrieve(forKey: "baby_data") else { return nil }
        
        do {
            return try JSONDecoder().decode(Baby.self, from: data)
        } catch {
            print("Failed to decode baby data: \(error)")
            return nil
        }
    }
    
    func saveUserPreferences(_ preferences: [String: Any]) -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: preferences)
            return securityManager.secureStore(data, forKey: "user_preferences")
        } catch {
            print("Failed to encode user preferences: \(error)")
            return false
        }
    }
    
    func loadUserPreferences() -> [String: Any]? {
        guard let data = securityManager.secureRetrieve(forKey: "user_preferences") else { return nil }
        
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            print("Failed to decode user preferences: \(error)")
            return nil
        }
    }
}

// MARK: - Security Settings View
struct SecuritySettingsView: View {
    @StateObject private var securityManager = SecurityManager()
    @State private var showingPasscodeSetup = false
    @State private var showingSecurityAlert = false
    @State private var alertMessage = ""
    @State private var currentPasscode = ""
    @State private var newPasscode = ""
    @State private var confirmPasscode = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Authentication") {
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.blue)
                        Text("Passcode Protection")
                        Spacer()
                        Toggle("", isOn: $securityManager.isPasscodeEnabled)
                            .onChange(of: securityManager.isPasscodeEnabled) { oldValue, newValue in
                                if newValue {
                                    showingPasscodeSetup = true
                                } else {
                                    securityManager.removePasscode()
                                }
                            }
                    }
                }
                
                Section("Data Protection") {
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.green)
                        Text("Data Encryption")
                        Spacer()
                        Toggle("", isOn: $securityManager.isEncryptionEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.shield")
                            .foregroundColor(.orange)
                        Text("Security Level")
                        Spacer()
                        Text(securityManager.securityLevel.rawValue)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Security Status") {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.purple)
                        Text("Last Security Check")
                        Spacer()
                        Text(securityManager.lastSecurityCheck, style: .time)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Security")
            .sheet(isPresented: $showingPasscodeSetup) {
                PasscodeSetupView()
            }
            .alert("Security Alert", isPresented: $showingSecurityAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
} 