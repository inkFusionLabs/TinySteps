import SwiftUI

struct AvatarBuilderView: View {
    @Binding var avatar: UserAvatar
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: AvatarCategory = .hairStyle
    
    enum AvatarCategory: String, CaseIterable {
        case hairStyle = "Hair Style"
        case hairColor = "Hair Color"
        case eyeColor = "Eye Color"
        case skinTone = "Skin Tone"
        case facialHair = "Facial Hair"
        case accessories = "Accessories"
        
        var icon: String {
            switch self {
            case .hairStyle: return "person.crop.circle"
            case .hairColor: return "paintbrush"
            case .eyeColor: return "eye"
            case .skinTone: return "hand.raised"
            case .facialHair: return "mustache"
            case .accessories: return "crown"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Avatar Preview
                    VStack(spacing: 15) {
                        Text("Your Avatar")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        SimpleAvatarView(avatar: avatar)
                            .frame(width: 120, height: 120)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 140, height: 140)
                            )
                    }
                    .padding()
                    
                    // Category Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(AvatarCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                                        
                                        Text(category.rawValue)
                                            .font(.caption)
                                            .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedCategory == category ? Color.blue : Color.white.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Options for Selected Category
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                            ForEach(getOptionsForCategory(selectedCategory), id: \.self) { option in
                                Button(action: {
                                    updateAvatar(for: selectedCategory, with: option)
                                }) {
                                    VStack(spacing: 8) {
                                        getIconForOption(selectedCategory, option)
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        
                                        Text(option)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Avatar Builder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func getOptionsForCategory(_ category: AvatarCategory) -> [String] {
        switch category {
        case .hairStyle:
            return UserAvatar.HairStyle.allCases.map { $0.rawValue }
        case .hairColor:
            return UserAvatar.HairColor.allCases.map { $0.rawValue }
        case .eyeColor:
            return UserAvatar.EyeColor.allCases.map { $0.rawValue }
        case .skinTone:
            return UserAvatar.SkinTone.allCases.map { $0.rawValue }
        case .facialHair:
            return UserAvatar.FacialHair.allCases.map { $0.rawValue }
        case .accessories:
            return UserAvatar.Accessory.allCases.map { $0.rawValue }
        }
    }
    
    private func getIconForOption(_ category: AvatarCategory, _ option: String) -> some View {
        switch category {
        case .hairStyle:
            if let hairStyle = UserAvatar.HairStyle(rawValue: option) {
                return AnyView(Image(systemName: hairStyle.icon))
            }
        case .hairColor:
            if let hairColor = UserAvatar.HairColor(rawValue: option) {
                return AnyView(Image(systemName: "paintbrush.fill")
                    .foregroundColor(hairColor.color))
            }
        case .eyeColor:
            if let eyeColor = UserAvatar.EyeColor(rawValue: option) {
                return AnyView(Image(systemName: "eye.fill")
                    .foregroundColor(eyeColor.color))
            }
        case .skinTone:
            if let skinTone = UserAvatar.SkinTone(rawValue: option) {
                return AnyView(Image(systemName: "hand.raised.fill")
                    .foregroundColor(skinTone.color))
            }
        case .facialHair:
            if let facialHair = UserAvatar.FacialHair(rawValue: option) {
                return AnyView(Image(systemName: facialHair.icon))
            }
        case .accessories:
            if let accessory = UserAvatar.Accessory(rawValue: option) {
                return AnyView(Image(systemName: accessory.icon))
            }
        }
        return AnyView(Image(systemName: "questionmark"))
    }
    
    private func updateAvatar(for category: AvatarCategory, with option: String) {
        switch category {
        case .hairStyle:
            if let hairStyle = UserAvatar.HairStyle(rawValue: option) {
                avatar.hairStyle = hairStyle
            }
        case .hairColor:
            if let hairColor = UserAvatar.HairColor(rawValue: option) {
                avatar.hairColor = hairColor
            }
        case .eyeColor:
            if let eyeColor = UserAvatar.EyeColor(rawValue: option) {
                avatar.eyeColor = eyeColor
            }
        case .skinTone:
            if let skinTone = UserAvatar.SkinTone(rawValue: option) {
                avatar.skinTone = skinTone
            }
        case .facialHair:
            if let facialHair = UserAvatar.FacialHair(rawValue: option) {
                avatar.facialHair = facialHair
            }
        case .accessories:
            if let accessory = UserAvatar.Accessory(rawValue: option) {
                if avatar.accessories.contains(accessory) {
                    avatar.accessories.removeAll { $0 == accessory }
                } else {
                    avatar.accessories.append(accessory)
                }
            }
        }
    }
}

public struct SimpleAvatarView: View {
    let avatar: UserAvatar
    
    public var body: some View {
        ZStack {
            // Background circle with skin tone
            Circle()
                .fill(avatar.skinTone.color)
                .frame(width: 100, height: 100)
            
            // Hair
            if avatar.hairStyle != .bald {
                Circle()
                    .fill(avatar.hairColor.color)
                    .frame(width: 80, height: 80)
                    .offset(y: -10)
            }
            
            // Eyes
            HStack(spacing: 15) {
                Circle()
                    .fill(avatar.eyeColor.color)
                    .frame(width: 12, height: 12)
                
                Circle()
                    .fill(avatar.eyeColor.color)
                    .frame(width: 12, height: 12)
            }
            .offset(y: -5)
            
            // Glasses
            if avatar.glasses {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 40, height: 20)
                    .offset(y: -5)
            }
            
            // Facial hair
            if avatar.facialHair != .none {
                Rectangle()
                    .fill(avatar.hairColor.color)
                    .frame(width: 30, height: 8)
                    .offset(y: 15)
            }
        }
    }
}

#Preview {
    AvatarBuilderView(avatar: .constant(UserAvatar()))
} 