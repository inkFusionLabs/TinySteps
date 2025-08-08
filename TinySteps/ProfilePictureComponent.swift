import SwiftUI

struct ProfilePictureComponent: View {
    let profileImageData: Data
    let size: CGFloat
    let showBorder: Bool
    
    init(profileImageData: Data, size: CGFloat = 40, showBorder: Bool = true) {
        self.profileImageData = profileImageData
        self.size = size
        self.showBorder = showBorder
    }
    
    var body: some View {
        ZStack {
            if let profileData = try? JSONDecoder().decode(ProfilePictureData.self, from: profileImageData) {
                // Custom profile picture
                Circle()
                    .fill(profileData.color)
                    .frame(width: size, height: size)
                    // Removed border for seamless blending
                
                if profileData.style == .icon {
                    Image(systemName: profileData.icon)
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.white)
                } else if profileData.style == .text {
                    Text(profileData.customText.isEmpty ? "T" : String(profileData.customText.prefix(1)))
                        .font(.system(size: size * 0.4, weight: .bold))
                        .foregroundColor(.white)
                } else if profileData.style == .initials {
                    Text(getInitials())
                        .font(.system(size: size * 0.35, weight: .bold))
                        .foregroundColor(.white)
                }
            } else {
                // Default profile picture
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: size, height: size)
                    // Removed border for seamless blending
                
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func getInitials() -> String {
        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        let words = userName.components(separatedBy: " ")
        if words.count >= 2 {
            return "\(words[0].prefix(1))\(words[1].prefix(1))".uppercased()
        } else if !userName.isEmpty {
            return String(userName.prefix(2)).uppercased()
        } else {
            return "TS"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProfilePictureComponent(profileImageData: Data())
        ProfilePictureComponent(profileImageData: Data(), size: 60)
        ProfilePictureComponent(profileImageData: Data(), size: 80, showBorder: false)
    }
    .padding()
    
} 