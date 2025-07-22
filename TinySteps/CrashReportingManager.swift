import Foundation
import SwiftUI

class CrashReportingManager: ObservableObject {
    static let shared = CrashReportingManager()
    
    private init() {}
    
    func logError(_ error: Error, context: String = "") {
        // Fallback logging to console
        print("🚨 Error logged: \(error.localizedDescription)")
        if !context.isEmpty {
            print("Context: \(context)")
        }
    }
    
    func logMessage(_ message: String, level: LogLevel = .info) {
        // Fallback logging to console
        print("📝 [\(level.rawValue.uppercased())] \(message)")
    }
    
    func setUserProperty(_ value: String, forKey key: String) {
        // Fallback - store in UserDefaults for debugging
        UserDefaults.standard.set(value, forKey: "crash_reporting_\(key)")
    }
    
    func setUserID(_ userID: String) {
        // Fallback
        UserDefaults.standard.set(userID, forKey: "crash_reporting_user_id")
    }
}

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case fatal = "FATAL"
}

// Extension to make error reporting easier
extension View {
    func reportError(_ error: Error, context: String = "") {
        CrashReportingManager.shared.logError(error, context: context)
    }
    
    func logMessage(_ message: String, level: LogLevel = .info) {
        CrashReportingManager.shared.logMessage(message, level: level)
    }
} 