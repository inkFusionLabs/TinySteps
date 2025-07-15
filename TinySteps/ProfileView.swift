//
//  ProfileView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

// UserAvatar data model with hex color storage
struct UserAvatar: Codable, Equatable {
    var skinColorHex: String = "#FFE0C4"
    var hairColorHex: String = "#8B5C2A"
    var hairStyle: HairStyle = .short
    var beard: Bool = false
    var glasses: Bool = false
    var shirtColorHex: String = "#007AFF"
    
    enum HairStyle: String, CaseIterable, Codable {
        case short, long, bald
    }
    // Computed properties for SwiftUI Color
    var skinColor: Color { Color(hex: skinColorHex) }
    var hairColor: Color { Color(hex: hairColorHex) }
    var shirtColor: Color { Color(hex: shirtColorHex) }
    mutating func setSkinColor(_ color: Color) { skinColorHex = color.toHex() }
    mutating func setHairColor(_ color: Color) { hairColorHex = color.toHex() }
    mutating func setShirtColor(_ color: Color) { shirtColorHex = color.toHex() }
}

// Color <-> Hex helpers
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 224, 196) // fallback to skin color
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    func toHex() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06X", rgb)
    }
}

// ProfileView additions
struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("userPhone") private var userPhone: String = ""
    @AppStorage("userLocation") private var userLocation: String = ""
    @AppStorage("userBio") private var userBio: String = ""
    @State private var showingNameEdit = false
    @State private var tempUserName = ""
    @State private var tempUserEmail = ""
    @State private var tempUserPhone = ""
    @State private var tempUserLocation = ""
    @State private var tempUserBio = ""
    @State private var showingLogoutAlert = false
    @State private var showingExportSheet = false
    @State private var showingResetAlert = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: BabyDataManager
    @AppStorage("userAvatar") private var userAvatarData: Data = Data()
    @State private var userAvatar: UserAvatar = UserAvatar()
    @State private var showingAvatarBuilder = false
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Profile Header
                    VStack(spacing: 20) {
                        // Avatar
                        Button(action: { showingAvatarBuilder = true }) {
                            SimpleAvatarView(avatar: userAvatar)
                                .frame(width: 120, height: 120)
                                .shadow(radius: 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Edit Avatar")
                            .font(.caption)
                            .foregroundColor(.blue)
                        // User Name
                        VStack(spacing: 8) {
                            Text(userName.isEmpty ? "User" : userName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("TinySteps User")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            if !userEmail.isEmpty {
                                ProfileInfoRow(icon: "envelope.fill", title: "Email", value: userEmail, color: .blue)
                            }
                            if !userPhone.isEmpty {
                                ProfileInfoRow(icon: "phone.fill", title: "Phone", value: userPhone, color: .green)
                            }
                            if !userLocation.isEmpty {
                                ProfileInfoRow(icon: "mappin.and.ellipse", title: "Location", value: userLocation, color: .orange)
                            }
                            if !userBio.isEmpty {
                                ProfileInfoRow(icon: "person.text.rectangle", title: "About Me", value: userBio, color: .purple)
                            }
                            ProfileInfoRow(
                                icon: "calendar.circle.fill",
                                title: "Member Since",
                                value: "Today",
                                color: .orange
                            )
                            
                            ProfileInfoRow(
                                icon: "heart.circle.fill",
                                title: "Baby Care Journey",
                                value: "Active",
                                color: .red
                            )
                        }
                    }
                    .padding(.top, 20)
                    
                    // Profile Options
                    VStack(spacing: 15) {
                        // Edit Profile Button
                        Button(action: {
                            tempUserName = userName
                            showingNameEdit = true
                        }) {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                
                                Text("Edit Profile")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Data Management
                        VStack(spacing: 15) {
                            Button(action: { showingExportSheet = true }) {
                                ProfileInfoRow(
                                    icon: "square.and.arrow.up",
                                    title: "Export Data",
                                    value: "Backup your data",
                                    color: .blue
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { showingResetAlert = true }) {
                                ProfileInfoRow(
                                    icon: "trash",
                                    title: "Reset All Data",
                                    value: "Clear all data",
                                    color: .red
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                        
                        // Logout Button
                        Button(action: {
                            showingLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                
                                Text("Logout")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.red)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingExportSheet) {
            NavigationView {
                DataExportView()
            }
        }
        .sheet(isPresented: $showingNameEdit) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Edit Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Name")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Enter your name", text: $tempUserName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Enter your email", text: $tempUserEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Enter your phone", text: $tempUserPhone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Enter your location", text: $tempUserLocation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About Me / Bio")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Tell us about yourself", text: $tempUserBio)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.2, blue: 0.4),
                            Color(red: 0.2, green: 0.3, blue: 0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingNameEdit = false
                    }
                    .foregroundColor(.white),
                    trailing: Button("Save") {
                        userName = tempUserName
                        userEmail = tempUserEmail
                        userPhone = tempUserPhone
                        userLocation = tempUserLocation
                        userBio = tempUserBio
                        showingNameEdit = false
                    }
                    .foregroundColor(.blue)
                    .disabled(tempUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                )
            }
            .onAppear {
                tempUserName = userName
                tempUserEmail = userEmail
                tempUserPhone = userPhone
                tempUserLocation = userLocation
                tempUserBio = userBio
            }
        }
        .sheet(isPresented: $showingAvatarBuilder, onDismiss: saveAvatar) {
            AvatarBuilderView(avatar: $userAvatar)
        }
        .onAppear {
            if let loaded = try? JSONDecoder().decode(UserAvatar.self, from: userAvatarData), userAvatarData.count > 0 {
                userAvatar = loaded
            }
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                userName = ""
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to logout? You'll need to enter your name again.")
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your baby's data. This action cannot be undone.")
        }
    }
    private func saveAvatar() {
        if let data = try? JSONEncoder().encode(userAvatar) {
            userAvatarData = data
        }
    }
   
    private func resetAllData() {
        dataManager.baby = nil
        dataManager.feedingRecords.removeAll()
        dataManager.nappyRecords.removeAll()
        dataManager.sleepRecords.removeAll()
        dataManager.milestones.removeAll()
        dataManager.achievements.removeAll()
        dataManager.reminders.removeAll()
        dataManager.vaccinations.removeAll()
        dataManager.solidFoodRecords.removeAll()
        dataManager.saveData()
    }
}

// SimpleAvatarView: renders the avatar using colored shapes
struct SimpleAvatarView: View {
    let avatar: UserAvatar
    var body: some View {
        ZStack {
            // Shirt
            RoundedRectangle(cornerRadius: 30)
                .fill(avatar.shirtColor)
                .frame(width: 90, height: 40)
                .offset(y: 40)
            // Face
            Circle()
                .fill(avatar.skinColor)
                .frame(width: 80, height: 80)
            // Hair
            if avatar.hairStyle != .bald {
                Ellipse()
                    .fill(avatar.hairColor)
                    .frame(width: 70, height: 30)
                    .offset(y: -30)
            }
            // Beard
            if avatar.beard {
                Ellipse()
                    .fill(avatar.hairColor)
                    .frame(width: 50, height: 18)
                    .offset(y: 25)
            }
            // Glasses
            if avatar.glasses {
                HStack(spacing: 8) {
                    Circle().stroke(Color.black, lineWidth: 3).frame(width: 18, height: 18)
                    Circle().stroke(Color.black, lineWidth: 3).frame(width: 18, height: 18)
                }
                .offset(y: -5)
            }
        }
    }
}

// AvatarBuilderView: lets user customize avatar
struct AvatarBuilderView: View {
    @Binding var avatar: UserAvatar
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            Form {
                Section("Skin Color") {
                    ColorPicker("Skin", selection: Binding(
                        get: { avatar.skinColor },
                        set: { avatar.setSkinColor($0) }
                    ))
                }
                Section("Hair") {
                    Picker("Style", selection: $avatar.hairStyle) {
                        ForEach(UserAvatar.HairStyle.allCases, id: \.self) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    ColorPicker("Color", selection: Binding(
                        get: { avatar.hairColor },
                        set: { avatar.setHairColor($0) }
                    ))
                }
                Section("Beard & Glasses") {
                    Toggle("Beard", isOn: $avatar.beard)
                    Toggle("Glasses", isOn: $avatar.glasses)
                }
                Section("Shirt Color") {
                    ColorPicker("Shirt", selection: Binding(
                        get: { avatar.shirtColor },
                        set: { avatar.setShirtColor($0) }
                    ))
                }
            }
            .navigationTitle("Customize Avatar")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
} 