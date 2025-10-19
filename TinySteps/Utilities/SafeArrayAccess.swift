//
//  SafeArrayAccess.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation

// MARK: - Safe Array Access Extensions
extension Array {
    /// Safely get the first element of an array
    func safeFirst() -> Element? {
        return self.first
    }
    
    /// Safely get the last element of an array
    func safeLast() -> Element? {
        return self.last
    }
    
    /// Safely get an element at a specific index
    func safeElement(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    /// Safely get a range of elements
    func safeSubrange(from startIndex: Int, to endIndex: Int) -> ArraySlice<Element>? {
        guard startIndex >= 0 && 
              endIndex >= startIndex && 
              endIndex < count else { return nil }
        return self[startIndex...endIndex]
    }
}

// MARK: - Safe Collection Access
extension Collection {
    /// Safely check if collection is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Safely get count with nil safety
    var safeCount: Int {
        return count
    }
}

// MARK: - Safe Dictionary Access
extension Dictionary {
    /// Safely get a value from dictionary with type safety
    func safeValue<T>(forKey key: Key, as type: T.Type) -> T? {
        guard let value = self[key] as? T else { return nil }
        return value
    }
    
    /// Safely get a string value from dictionary
    func safeString(forKey key: Key) -> String? {
        return safeValue(forKey: key, as: String.self)
    }
    
    /// Safely get an integer value from dictionary
    func safeInt(forKey key: Key) -> Int? {
        return safeValue(forKey: key, as: Int.self)
    }
    
    /// Safely get a double value from dictionary
    func safeDouble(forKey key: Key) -> Double? {
        return safeValue(forKey: key, as: Double.self)
    }
}

// MARK: - Safe UserDefaults Access
class SafeUserDefaults {
    static let shared = SafeUserDefaults()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    /// Safely get a string value from UserDefaults
    func safeString(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    /// Safely get an integer value from UserDefaults
    func safeInt(forKey key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    /// Safely get a double value from UserDefaults
    func safeDouble(forKey key: String) -> Double {
        return userDefaults.double(forKey: key)
    }
    
    /// Safely get a boolean value from UserDefaults
    func safeBool(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    /// Safely get a date value from UserDefaults
    func safeDate(forKey key: String) -> Date? {
        return userDefaults.object(forKey: key) as? Date
    }
    
    /// Safely get data from UserDefaults
    func safeData(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    /// Safely set a value in UserDefaults
    func safeSet(_ value: Any?, forKey key: String) {
        if let value = value {
            userDefaults.set(value, forKey: key)
        } else {
            userDefaults.removeObject(forKey: key)
        }
    }
}

