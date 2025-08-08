//
//  BugFixes.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI
import Foundation
#if canImport(CoreData)
import CoreData
#endif

// MARK: - Bug Fixes and Safety Improvements

// 1. Safe Timer class for preventing memory leaks
class SafeTimer {
    private var timer: Timer?
    
    func scheduleTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping () -> Void) {
        invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: { _ in
            block()
        })
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        invalidate()
    }
}

// 2. Optional Binding Safety
struct SafeOptionalBinding<T> {
    let binding: Binding<T?>
    let defaultValue: T
    
    init(_ binding: Binding<T?>, defaultValue: T) {
        self.binding = binding
        self.defaultValue = defaultValue
    }
    
    var safeBinding: Binding<T> {
        Binding<T>(
            get: { self.binding.wrappedValue ?? self.defaultValue },
            set: { self.binding.wrappedValue = $0 }
        )
    }
}

// 3. Data Validation
struct DataValidator {
    static func validateWeight(_ weight: String) -> Double? {
        guard let weightValue = Double(weight), weightValue > 0, weightValue < 50 else {
            return nil
        }
        return weightValue
    }
    
    static func validateHeight(_ height: String) -> Double? {
        guard let heightValue = Double(height), heightValue > 0, heightValue < 200 else {
            return nil
        }
        return heightValue
    }
    
    static func validateAge(_ age: String) -> Int? {
        guard let ageValue = Int(age), ageValue >= 0, ageValue < 18 else {
            return nil
        }
        return ageValue
    }
}

// 4. Safe Array Access
extension Array {
    func safeIndex(_ index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    func safeFirst() -> Element? {
        return first
    }
    
    func safeLast() -> Element? {
        return last
    }
    
    subscript(safe index: Int) -> Element? {
        return safeIndex(index)
    }
}

// 5. Safe URL Creation
struct SafeURL {
    static func create(_ string: String) -> URL? {
        return URL(string: string)
    }
    
    static func createWithFallback(_ string: String, fallback: String) -> URL {
        return URL(string: string) ?? URL(string: fallback) ?? URL(string: "https://example.com")!
    }
}

// 6. Background Thread Safety
class MainThreadDispatcher {
    static func dispatchToMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    static func dispatchToMainAfter(_ delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
} 