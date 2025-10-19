//
//  ThemeSelectorView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import SwiftUI

struct ThemeSelectorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTheme: ThemeManager.AppTheme = .organic
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Your Theme")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .themedText(style: .primary)
                
                Text("Select a theme that matches your style")
                    .font(.subheadline)
                    .themedText(style: .secondary)
            }
            .padding(.top, 20)
            
            // Theme Options
            VStack(spacing: 16) {
                ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
                    ThemeOptionCard(
                        theme: theme,
                        isSelected: selectedTheme == theme,
                        onTap: {
                            selectedTheme = theme
                            themeManager.setTheme(theme)
                        }
                    )
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .themedBackground()
        .onAppear {
            selectedTheme = themeManager.currentTheme
        }
    }
}

struct ThemeOptionCard: View {
    let theme: ThemeManager.AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Theme Preview
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(theme.colors.primary)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.colors.secondary)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.colors.accent)
                            .frame(width: 12, height: 12)
                    }
                    
                    Text(theme.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .themedText(style: .secondary)
                }
                .frame(width: 60)
                
                // Theme Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(themeDescription(for: theme))
                        .font(.caption)
                        .themedText(style: .secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(theme.colors.primary)
                } else {
                    Image(systemName: "circle")
                        .font(.title2)
                        .themedText(style: .tertiary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? theme.colors.primary.opacity(0.1) : theme.colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? theme.colors.primary : theme.colors.border,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func themeDescription(for theme: ThemeManager.AppTheme) -> String {
        switch theme {
        case .organic:
            return "Natural colors inspired by nature with warm, earthy tones"
        case .modern:
            return "Clean, contemporary design with vibrant system colors"
        case .classic:
            return "Traditional dark theme with navy and maroon accents"
        }
    }
}

#Preview {
    ThemeSelectorView()
        .environmentObject(ThemeManager.shared)
}

