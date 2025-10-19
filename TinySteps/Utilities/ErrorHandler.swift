//
//  ErrorHandler.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI

// MARK: - App Error Types
enum TinyStepsError: LocalizedError, Equatable {
    case networkError(String)
    case dataValidationError(String)
    case fileOperationError(String)
    case coreDataError(String)
    case userInputError(String)
    case systemError(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .dataValidationError(let message):
            return "Data Error: \(message)"
        case .fileOperationError(let message):
            return "File Error: \(message)"
        case .coreDataError(let message):
            return "Database Error: \(message)"
        case .userInputError(let message):
            return "Input Error: \(message)"
        case .systemError(let message):
            return "System Error: \(message)"
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .dataValidationError:
            return "Please check your input and try again."
        case .fileOperationError:
            return "Please try again or contact support if the problem persists."
        case .coreDataError:
            return "Please restart the app and try again."
        case .userInputError:
            return "Please correct the highlighted fields and try again."
        case .systemError:
            return "Please restart the app and try again."
        case .unknownError:
            return "Please contact support if this problem continues."
        }
    }
}

// MARK: - Error Handler
class ErrorHandler: ObservableObject {
    @Published var currentError: TinyStepsError?
    @Published var showError = false
    @Published var errorLog: [ErrorLogEntry] = []
    
    static let shared = ErrorHandler()
    
    private init() {}
    
    // MARK: - Error Handling Methods
    func handle(_ error: Error, context: String = "") {
        let tinyStepsError: TinyStepsError
        
        if let appError = error as? TinyStepsError {
            tinyStepsError = appError
        } else {
            tinyStepsError = .unknownError(error.localizedDescription)
        }
        
        // Log the error
        logError(tinyStepsError, context: context)
        
        // Show error to user
        DispatchQueue.main.async {
            self.currentError = tinyStepsError
            self.showError = true
        }
    }
    
    func handle(_ error: TinyStepsError, context: String = "") {
        logError(error, context: context)
        
        DispatchQueue.main.async {
            self.currentError = error
            self.showError = true
        }
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
    
    // MARK: - Error Logging
    private func logError(_ error: TinyStepsError, context: String) {
        let logEntry = ErrorLogEntry(
            error: error,
            context: context,
            timestamp: Date(),
            userInfo: [
                "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
                "deviceModel": UIDevice.current.model,
                "systemVersion": UIDevice.current.systemVersion
            ]
        )
        
        errorLog.append(logEntry)
        
        // Keep only last 100 errors
        if errorLog.count > 100 {
            errorLog.removeFirst(errorLog.count - 100)
        }
        
        // Log to console in debug mode
        #if DEBUG
        print("🚨 Error: \(error.errorDescription ?? "Unknown")")
        print("📍 Context: \(context)")
        print("💡 Suggestion: \(error.recoverySuggestion ?? "None")")
        #endif
    }
    
    // MARK: - Error Recovery
    func retryLastOperation() {
        // This would be implemented based on the last operation
        // For now, just clear the error
        clearError()
    }
    
    func reportError() {
        // This would implement error reporting to a service like Crashlytics
        guard let error = currentError else { return }
        
        // In a real implementation, you would send this to your error reporting service
        print("📤 Reporting error: \(error.errorDescription ?? "Unknown")")
    }
}

// MARK: - Error Log Entry
struct ErrorLogEntry: Identifiable {
    let id = UUID()
    let error: TinyStepsError
    let context: String
    let timestamp: Date
    let userInfo: [String: String]
}

// MARK: - Error Alert View
struct ErrorAlertView: View {
    @ObservedObject var errorHandler: ErrorHandler
    let onRetry: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    init(
        errorHandler: ErrorHandler = ErrorHandler.shared,
        onRetry: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.errorHandler = errorHandler
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        if errorHandler.showError, let error = errorHandler.currentError {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                
                Text("Oops! Something went wrong")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(error.errorDescription ?? "An unknown error occurred")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 15) {
                    if onRetry != nil {
                        Button("Try Again") {
                            onRetry?()
                            errorHandler.clearError()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button("Dismiss") {
                        onDismiss?()
                        errorHandler.clearError()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
    }
}

// MARK: - Error Handling View Modifier
struct ErrorHandlingModifier: ViewModifier {
    @StateObject private var errorHandler = ErrorHandler.shared
    let onRetry: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    init(onRetry: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if errorHandler.showError {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        errorHandler.clearError()
                    }
                
                ErrorAlertView(
                    errorHandler: errorHandler,
                    onRetry: onRetry,
                    onDismiss: onDismiss
                )
            }
        }
    }
}

extension View {
    func errorHandling(
        onRetry: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(ErrorHandlingModifier(onRetry: onRetry, onDismiss: onDismiss))
    }
}

// MARK: - Safe Execution Helpers
extension ErrorHandler {
    func safeExecute<T>(
        _ operation: () throws -> T,
        context: String = "",
        fallback: T? = nil
    ) -> T? {
        do {
            return try operation()
        } catch {
            handle(error, context: context)
            return fallback
        }
    }
    
    func safeExecuteAsync<T>(
        _ operation: @escaping () async throws -> T,
        context: String = "",
        fallback: T? = nil,
        completion: @escaping (T?) -> Void
    ) {
        Task {
            do {
                let result = try await operation()
                await MainActor.run {
                    completion(result)
                }
            } catch {
                await MainActor.run {
                    self.handle(error, context: context)
                    completion(fallback)
                }
            }
        }
    }
}

