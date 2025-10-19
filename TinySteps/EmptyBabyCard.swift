import SwiftUI

struct EmptyBabyCard: View {
    var onAdd: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Enhanced Icon with Animation
            ZStack {
                // Background glow with design system colors
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                DesignSystem.Colors.accent.opacity(0.3), 
                                DesignSystem.Colors.primary.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isHovered)
                
                // Main icon
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .scaleEffect(isHovered ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isHovered)
            }
            .onHover { hovering in
                isHovered = hovering
            }
            
            // Enhanced Text
            VStack(spacing: 8) {
                Text("Welcome to Baby Profile")
                    .font(DesignSystem.Typography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Start tracking your baby's development and milestones")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Enhanced Button
            Button(action: onAdd) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("Add Baby Profile")
                        .font(DesignSystem.Typography.button)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    DesignSystem.Colors.accent, 
                                    DesignSystem.Colors.primary
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: DesignSystem.Colors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                )
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovered)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Feature highlights
            VStack(spacing: 16) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Track growth and development")
                FeatureRow(icon: "heart.fill", text: "Monitor health and milestones")
                FeatureRow(icon: "clock.fill", text: "Record daily activities")
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(DesignSystem.Colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    DesignSystem.Colors.accent.opacity(0.3), 
                                    DesignSystem.Colors.primary.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: DesignSystem.Colors.shadow, radius: 6, x: 0, y: 3)
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.accent)
                .frame(width: 20)
            
            Text(text)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
        }
    }
} 