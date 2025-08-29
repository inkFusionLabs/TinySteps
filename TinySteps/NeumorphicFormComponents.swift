//
//  NeumorphicFormComponents.swift
//  TinySteps
//
//  Created by Neumorphic Theme Implementation
//

import SwiftUI

// MARK: - Shared Neumorphic Form Components

struct NeumorphicTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(TinyStepsDesign.Colors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(NeumorphicThemeManager.NeumorphicColors.cardBackground)
                        .neumorphicCard()
                )
        }
    }
}

struct NeumorphicDatePicker: View {
    let title: String
    @Binding var date: Date
    let icon: String
    let displayedComponents: DatePickerComponents = .date.union(.hourAndMinute)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(TinyStepsDesign.Colors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
            }
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(NeumorphicThemeManager.NeumorphicColors.cardBackground)
                        .neumorphicCard()
                )
        }
    }
}

struct NeumorphicPicker<T: CaseIterable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    let options: [T]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(TinyStepsDesign.Colors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
            }
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(NeumorphicThemeManager.NeumorphicColors.cardBackground)
                    .neumorphicCard()
            )
        }
    }
}

// MARK: - Specialized Date Picker for Date Only
struct NeumorphicDateOnlyPicker: View {
    let title: String
    @Binding var date: Date
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(TinyStepsDesign.Colors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NeumorphicThemeManager.NeumorphicColors.textPrimary)
            }
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(NeumorphicThemeManager.NeumorphicColors.cardBackground)
                        .neumorphicCard()
                )
        }
    }
}
