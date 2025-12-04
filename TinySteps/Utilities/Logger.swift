//
//  Logger.swift
//  TinySteps
//
//  Created by inkFusionLabs on 13/07/2025.
//

import Foundation
import OSLog

class Logger {
    static let shared = Logger()

    private let logger: os.Logger

    private init() {
        self.logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.tinysteps", category: "TinySteps")
    }

    enum LogLevel {
        case debug, info, warning, error

        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }
    }

    func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(function) - \(message)"

        #if DEBUG
        // In debug mode, also print to console for easier debugging
        print("[\(levelString(level))] \(logMessage)")
        #endif

        logger.log(level: level.osLogType, "\(logMessage)")
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }

    private func levelString(_ level: LogLevel) -> String {
        switch level {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}

