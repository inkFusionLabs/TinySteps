import SwiftUI

struct EmptyBabyCard: View {
    var onAdd: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white.opacity(0.5))
            Text("No baby profile yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Button(action: onAdd) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Baby")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
} 