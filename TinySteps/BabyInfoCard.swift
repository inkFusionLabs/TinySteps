import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct BabyInfoCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingEditForm = false
    let baby: Baby
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
#if os(iOS)
            if let photoURL = baby.photoURL, let url = URL(string: photoURL), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                    .shadow(radius: 8)
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white.opacity(0.5))
            }
#else
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white.opacity(0.5))
#endif
            Text(baby.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Birth Date")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(baby.birthDate, style: .date)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                if let weight = baby.weight {
                    VStack(alignment: .leading) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(String(format: "%.2f kg (%.2f lbs)", weight, weight * 2.20462))
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                if let height = baby.height {
                    VStack(alignment: .leading) {
                        Text("Height")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(String(format: "%.2f cm", height))
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            if let dueDate = baby.dueDate {
                Text("Due Date: \(dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Text("Gender: \(baby.gender.rawValue)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Button(action: { onEdit?() }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.clear)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
} 