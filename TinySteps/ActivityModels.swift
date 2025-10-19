import SwiftUI

struct ActivityItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let date: Date
    let color: Color
}

struct ActivityRow: View {
    let item: ActivityItem
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.color)
                    .frame(width: 36, height: 36)
                Image(systemName: item.icon)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(item.date, style: .date)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
