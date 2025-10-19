//
//  InputValidator.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI

// MARK: - Validation Result
struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
    
    init(isValid: Bool, errorMessage: String? = nil) {
        self.isValid = isValid
        self.errorMessage = errorMessage
    }
    
    static let valid = ValidationResult(isValid: true)
    static func invalid(_ message: String) -> ValidationResult {
        return ValidationResult(isValid: false, errorMessage: message)
    }
}

// MARK: - Input Validator
class InputValidator: ObservableObject {
    
    // MARK: - Text Validation
    static func validateName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .invalid("Name is required")
        }
        
        if trimmed.count < 2 {
            return .invalid("Name must be at least 2 characters")
        }
        
        if trimmed.count > 50 {
            return .invalid("Name must be less than 50 characters")
        }
        
        // Check for valid characters (letters, spaces, hyphens, apostrophes)
        let validCharacterSet = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: "-'"))
        if trimmed.rangeOfCharacter(from: validCharacterSet.inverted) != nil {
            return .invalid("Name contains invalid characters")
        }
        
        return .valid
    }
    
    // MARK: - Weight Validation
    static func validateWeight(_ weightString: String, unit: String = "kg") -> ValidationResult {
        let trimmed = weightString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .invalid("Weight is required")
        }
        
        guard let weight = Double(trimmed) else {
            return .invalid("Please enter a valid number")
        }
        
        let minWeight: Double = unit == "kg" ? 0.1 : 0.2
        let maxWeight: Double = unit == "kg" ? 50.0 : 110.0
        
        if weight < minWeight {
            return .invalid("Weight must be at least \(minWeight) \(unit)")
        }
        
        if weight > maxWeight {
            return .invalid("Weight must be less than \(maxWeight) \(unit)")
        }
        
        return .valid
    }
    
    // MARK: - Height Validation
    static func validateHeight(_ heightString: String, unit: String = "cm") -> ValidationResult {
        let trimmed = heightString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .invalid("Height is required")
        }
        
        guard let height = Double(trimmed) else {
            return .invalid("Please enter a valid number")
        }
        
        let minHeight: Double = unit == "cm" ? 10.0 : 4.0
        let maxHeight: Double = unit == "cm" ? 200.0 : 79.0
        
        if height < minHeight {
            return .invalid("Height must be at least \(minHeight) \(unit)")
        }
        
        if height > maxHeight {
            return .invalid("Height must be less than \(maxHeight) \(unit)")
        }
        
        return .valid
    }
    
    // MARK: - Date Validation
    static func validateBirthDate(_ date: Date) -> ValidationResult {
        let now = Date()
        let calendar = Calendar.current
        
        if date > now {
            return .invalid("Birth date cannot be in the future")
        }
        
        // Check if date is not too far in the past (more than 2 years)
        if let twoYearsAgo = calendar.date(byAdding: .year, value: -2, to: now),
           date < twoYearsAgo {
            return .invalid("Birth date cannot be more than 2 years ago")
        }
        
        return .valid
    }
    
    static func validateDueDate(_ dueDate: Date, birthDate: Date) -> ValidationResult {
        if dueDate <= birthDate {
            return .invalid("Due date must be after birth date")
        }
        
        let calendar = Calendar.current
        let daysDifference = calendar.dateComponents([.day], from: birthDate, to: dueDate).day ?? 0
        
        if daysDifference > 100 {
            return .invalid("Due date seems too far from birth date")
        }
        
        return .valid
    }
    
    // MARK: - Phone Number Validation
    static func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .invalid("Phone number is required")
        }
        
        // Remove all non-digit characters for validation
        let digitsOnly = trimmed.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if digitsOnly.count < 10 {
            return .invalid("Phone number must be at least 10 digits")
        }
        
        if digitsOnly.count > 15 {
            return .invalid("Phone number must be less than 15 digits")
        }
        
        return .valid
    }
    
    // MARK: - Email Validation
    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .invalid("Email is required")
        }
        
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: trimmed) {
            return .invalid("Please enter a valid email address")
        }
        
        return .valid
    }
    
    // MARK: - Notes Validation
    static func validateNotes(_ notes: String, maxLength: Int = 500) -> ValidationResult {
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.count > maxLength {
            return .invalid("Notes must be less than \(maxLength) characters")
        }
        
        return .valid
    }
    
    // MARK: - Password Validation
    static func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .invalid("Password is required")
        }
        
        if password.count < 6 {
            return .invalid("Password must be at least 6 characters")
        }
        
        if password.count > 50 {
            return .invalid("Password must be less than 50 characters")
        }
        
        return .valid
    }
    
    static func validatePasswordConfirmation(_ password: String, confirmation: String) -> ValidationResult {
        if confirmation.isEmpty {
            return .invalid("Password confirmation is required")
        }
        
        if password != confirmation {
            return .invalid("Passwords do not match")
        }
        
        return .valid
    }
}

// MARK: - Validation View Modifier
struct ValidationModifier: ViewModifier {
    let validation: ValidationResult
    @State private var showError = false
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content
                .onChange(of: validation.isValid) { isValid in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showError = !isValid
                    }
                }
            
            if showError, let errorMessage = validation.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

extension View {
    func validation(_ result: ValidationResult) -> some View {
        modifier(ValidationModifier(validation: result))
    }
}

// MARK: - Form Validation
class FormValidator: ObservableObject {
    @Published var errors: [String: String] = [:]
    
    func validateField(_ field: String, value: String, validation: ValidationResult) {
        if validation.isValid {
            errors.removeValue(forKey: field)
        } else {
            errors[field] = validation.errorMessage
        }
    }
    
    var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    func clearErrors() {
        errors.removeAll()
    }
    
    func getError(for field: String) -> String? {
        return errors[field]
    }
}

