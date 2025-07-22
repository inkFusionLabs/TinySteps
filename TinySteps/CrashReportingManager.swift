import Foundation
import SwiftUI

#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

class CrashReportingManager: ObservableObject {
    static let shared = CrashReportingManager()
    
    private init() {}
    
    func logError(_ error: Error, context: String = "") {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().record(error: error)
        if !context.isEmpty {
            Crashlytics.crashlytics().setCustomValue(context, forKey: "error_context")
        }
        #else
        // Fallback logging to console
        print("🚨 Error logged: \(error.localizedDescription)")
        if !context.isEmpty {
            print("Context: \(context)")
        }
        #endif
    }
    
    func logMessage(_ message: String, level: LogLevel = .info) {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().log("\(level.rawValue): \(message)")
        #else
        // Fallback logging to console
        print("📝 [\(level.rawValue.uppercased())] \(message)")
        #endif
    }
    
    func setUserProperty(_ value: String, forKey key: String) {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        #else
        // Fallback - store in UserDefaults for debugging
        UserDefaults.standard.set(value, forKey: "crash_reporting_\(key)")
        #endif
    }
    
    func setUserID(_ userID: String) {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().setUserID(userID)
        #else
        // Fallback
        UserDefaults.standard.set(userID, forKey: "crash_reporting_user_id")
        #endif
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