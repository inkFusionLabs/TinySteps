import SwiftUI

enum ProfileStyle: String, CaseIterable, Codable {
    case icon = "Icon"
    case text = "Text"
    case initials = "Initials"
}

struct ProfilePictureData: Codable {
    let style: ProfileStyle
    let colorIndex: Int
    let icon: String
    let customText: String
    
    init(style: ProfileStyle, colorIndex: Int, icon: String, customText: String) {
        self.style = style
        self.colorIndex = colorIndex
        self.icon = icon
        self.customText = customText
    }
    
    var color: Color {
        let colors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .yellow, .mint, .cyan, .indigo, .brown, .gray]
        return colorIndex < colors.count ? colors[colorIndex] : .blue
    }
}

struct ProfilePictureView: View {
    @Binding var profileImageData: Data
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedIcon: String = "person.fill"
    @State private var customText: String = ""
    @State private var showTextInput = false
    @State private var selectedStyle: ProfileStyle = .icon
    
    let colors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink, 
        .yellow, .mint, .cyan, .indigo, .brown, .gray
    ]
    
    @State private var selectedColorIndex: Int = 0
    
    let icons = [
        "person.fill", "heart.fill", "star.fill", "crown.fill", 
        "bolt.fill", "leaf.fill", "sun.fill", "moon.fill",
        "cloud.fill", "snowflake", "flame.fill", "drop.fill",
        "house.fill", "car.fill", "airplane", "gamecontroller.fill",
        "book.fill", "pencil", "scissors", "wrench.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Preview
                    VStack(spacing: 20) {
                        Text("Profile Picture Preview")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        // Profile Picture Preview
                        ZStack {
                            Circle()
                                .fill(colors[selectedColorIndex])
                                .frame(width: 120, height: 120)
                                // Removed shadow for seamless blending
                            
                            if selectedStyle == .icon {
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            } else if selectedStyle == .text {
                                Text(customText.isEmpty ? "T" : String(customText.prefix(1)))
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            } else if selectedStyle == .initials {
                                Text(getInitials())
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    // Style Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Style")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 15) {
                            ForEach(ProfileStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    selectedStyle = style
                                    if style == .text {
                                        showTextInput = true
                                    }
                                }) {
                                    Text(style.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedStyle == style ? .white : .white.opacity(0.7))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedStyle == style ? colors[selectedColorIndex] : Color.clear)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Color Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Color")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                            ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                                Button(action: {
                                    selectedColorIndex = index
                                }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedColorIndex == index ? Color.white : Color.clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Icon Selection (only show if icon style is selected)
                    if selectedStyle == .icon {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Icon")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.clear)
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: icon)
                                                .font(.title3)
                                                .foregroundColor(selectedIcon == icon ? colors[selectedColorIndex] : .white)
                                        }
                                        .overlay(
                                            Circle()
                                                .stroke(selectedIcon == icon ? Color.white : Color.clear, lineWidth: 2)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())

                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Text Input (only show if text style is selected)
                    if selectedStyle == .text {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Custom Text")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("Enter text...", text: $customText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                
                                .cornerRadius(8)
                                .onChange(of: customText) { _, newValue in
                                    // Limit to 1 character for profile picture
                                    if newValue.count > 1 {
                                        customText = String(newValue.prefix(1))
                                    }
                                }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button(action: saveProfilePicture) {
                        Text("Save Profile Picture")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colors[selectedColorIndex])
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Profile Picture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showTextInput) {
            TextInputView(text: $customText)
        }
    }

    }
    
    private func getInitials() -> String {
        // Get user name from AppStorage
        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        let words = userName.components(separatedBy: " ")
        if words.count >= 2 {
            return "\(words[0].prefix(1))\(words[1].prefix(1))".uppercased()
        } else if !userName.isEmpty {
            return String(userName.prefix(2)).uppercased()
        } else {
            return "TS" // TinySteps initials
        }
    }
    
    private func saveProfilePicture() {
        // Create profile picture data
        let profileData = ProfilePictureData(
            style: selectedStyle,
            colorIndex: selectedColorIndex,
            icon: selectedIcon,
            customText: customText
        )
        if let data = try? JSONEncoder().encode(profileData) {
            profileImageData = data
        }
        
        dismiss()
    }
}

struct TextInputView: View {
    @Binding var text: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Enter Custom Text")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    TextField("Enter text...", text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(8)
                        .onChange(of: text) { _, newValue in
                            // Limit to 1 character
                            if newValue.count > 1 {
                                text = String(newValue.prefix(1))
                            }
                        }
                    
                    Text("Only the first character will be used")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Custom Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ProfilePictureView(profileImageData: .constant(Data()))
} 