import SwiftUI

struct HomeButton: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: ContentView.NavigationTab
    
    var body: some View {
        Button(action: {
            // Navigate to home tab
            selectedTab = .home
            // Dismiss current view if it's presented modally
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .font(.system(size: 16, weight: .medium))
                Text("Home")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }
} 