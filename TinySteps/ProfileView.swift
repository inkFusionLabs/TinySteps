//
//  ProfileView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userProfileImageData") private var userProfileImageData: Data?
    @State private var showingNameEdit = false
    @State private var tempUserName = ""
    @State private var showingImagePicker = false
    @State private var showingImageOptions = false
    @State private var selectedImageItem: PhotosPickerItem?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: - Computed Properties
    private var profileHeaderSection: some View {
        VStack(spacing: isIPad ? 24 : 20) {
            // Profile Avatar
            Button(action: {
                showingImageOptions = true
            }) {
                ZStack {
                    if let imageData = userProfileImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: isIPad ? 140 : 120, height: isIPad ? 140 : 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(themeManager.currentTheme.colors.border, lineWidth: 3)
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: isIPad ? 120 : 100))
                            .foregroundColor(themeManager.currentTheme.colors.accent)
                            .background(
                                Circle()
                                    .fill(themeManager.currentTheme.colors.backgroundSecondary)
                                    .frame(width: isIPad ? 140 : 120, height: isIPad ? 140 : 120)
                            )
                    }
                    
                    // Camera icon overlay
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "camera.circle.fill")
                                .font(isIPad ? .title : .title2)
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                                .background(Circle().fill(themeManager.currentTheme.colors.background))
                                .offset(x: isIPad ? -18 : -15, y: isIPad ? 8 : 5)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Profile avatar")
            .accessibilityHint("Tap to change your profile picture")
            
            // User Name
            VStack(spacing: isIPad ? 12 : 8) {
                Text(userName.isEmpty ? "User" : userName)
                    .font(isIPad ? .system(size: 32, weight: .bold) : .title)
                    .fontWeight(.bold)
                    .themedText(style: .primary)
                    .accessibilityLabel(userName.isEmpty ? "User" : userName)
                    .accessibilityAddTraits(.isHeader)
                
                Text("TinySteps User")
                    .font(isIPad ? .system(size: 18) : .subheadline)
                    .themedText(style: .secondary)
                    .accessibilityLabel("TinySteps User")
            }
        }
        .padding(.top, isIPad ? 32 : 20)
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            themeManager.currentTheme.colors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: isIPad ? 40 : 30) {
                    profileHeaderSection
                    
                    // Profile Options
                    VStack(spacing: isIPad ? 20 : 15) {
                        // Edit Profile Button
                        Button(action: {
                            tempUserName = userName
                            showingNameEdit = true
                        }) {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(isIPad ? .title : .title2)
                                    .foregroundColor(themeManager.currentTheme.colors.primary)
                                
                                Text("Edit Profile")
                                    .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                                    .fontWeight(.medium)
                                    .themedText(style: .primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(isIPad ? .body : .caption)
                                    .themedText(style: .tertiary)
                            }
                            .padding(.horizontal, isIPad ? 24 : 20)
                            .padding(.vertical, isIPad ? 18 : 15)
                            .themedCard()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Edit Profile")
                        .accessibilityHint("Edit your profile name.")
                        
                        // App Information
                        VStack(spacing: isIPad ? 20 : 15) {
                            ProfileInfoRow(
                                icon: "info.circle.fill",
                                title: "App Version",
                                value: "1.0.0",
                                color: themeManager.currentTheme.colors.success
                            )
                            
                            ProfileInfoRow(
                                icon: "calendar.circle.fill",
                                title: "Member Since",
                                value: "Today",
                                color: themeManager.currentTheme.colors.warning
                            )
                            
                            ProfileInfoRow(
                                icon: "heart.circle.fill",
                                title: "Baby Care Journey",
                                value: "Active",
                                color: themeManager.currentTheme.colors.error
                            )
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.vertical, isIPad ? 20 : 15)
                        .themedCard()
                        
                        // About Section
                        VStack(spacing: isIPad ? 20 : 15) {
                            NavigationLink(destination: Text("About TinySteps - Coming Soon")) {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .font(isIPad ? .title : .title2)
                                        .foregroundColor(themeManager.currentTheme.colors.info)
                                    
                                    Text("About TinySteps")
                                        .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                                        .fontWeight(.medium)
                                        .themedText(style: .primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(isIPad ? .body : .caption)
                                        .themedText(style: .tertiary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("About TinySteps")
                            .accessibilityHint("Learn more about TinySteps.")
                        }
                        .padding(.horizontal, isIPad ? 24 : 20)
                        .padding(.vertical, isIPad ? 20 : 15)
                        .themedCard()
                    }
                    .padding(.horizontal, isIPad ? 32 : 16)
                }
                .padding(.bottom, isIPad ? 40 : 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImageOptions) {
            NavigationView {
                VStack(spacing: isIPad ? 32 : 20) {
                    Text("Profile Picture")
                        .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                        .fontWeight(.bold)
                        .themedText(style: .primary)
                    
                    VStack(spacing: isIPad ? 20 : 15) {
                        Button(action: {
                            showingImagePicker = true
                            showingImageOptions = false
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(isIPad ? .title : .title2)
                                    .foregroundColor(themeManager.currentTheme.colors.primary)
                                
                                Text("Choose from Photo Library")
                                    .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                                    .fontWeight(.medium)
                                    .themedText(style: .primary)
                                
                                Spacer()
                            }
                            .padding(isIPad ? 20 : 16)
                            .themedCard()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if userProfileImageData != nil {
                            Button(action: {
                                userProfileImageData = nil
                                showingImageOptions = false
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(isIPad ? .title : .title2)
                                        .foregroundColor(themeManager.currentTheme.colors.error)
                                    
                                    Text("Remove Current Picture")
                                        .font(isIPad ? .system(size: 18, weight: .medium) : .body)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.currentTheme.colors.error)
                                    
                                    Spacer()
                                }
                                .padding(isIPad ? 20 : 16)
                                .background(themeManager.currentTheme.colors.error.opacity(0.1))
                                .cornerRadius(isIPad ? 16 : 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Spacer()
                }
                .padding(isIPad ? 32 : 16)
                .background(themeManager.currentTheme.colors.background)
                .navigationBarItems(
                    trailing: Button("Cancel") {
                        showingImageOptions = false
                    }
                    .themedText(style: .primary)
                )
            }
        }
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $selectedImageItem,
            matching: .images
        )
        .onChange(of: selectedImageItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    userProfileImageData = data
                }
            }
        }
        .sheet(isPresented: $showingNameEdit) {
            NavigationView {
                VStack(spacing: isIPad ? 32 : 20) {
                    Text("Edit Profile")
                        .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                        .fontWeight(.bold)
                        .themedText(style: .primary)
                    
                    VStack(alignment: .leading, spacing: isIPad ? 16 : 8) {
                        Text("Your Name")
                            .font(isIPad ? .system(size: 20, weight: .semibold) : .headline)
                            .themedText(style: .primary)
                        
                        TextField("Enter your name", text: $tempUserName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(isIPad ? .system(size: 18) : .body)
                            .padding(.horizontal, isIPad ? 20 : 16)
                    }
                    .padding(.horizontal, isIPad ? 32 : 16)
                    
                    Spacer()
                }
                .padding(isIPad ? 32 : 16)
                .background(themeManager.currentTheme.colors.backgroundGradient)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingNameEdit = false
                    }
                    .themedText(style: .primary),
                    trailing: Button("Save") {
                        userName = tempUserName
                        showingNameEdit = false
                    }
                    .foregroundColor(themeManager.currentTheme.colors.primary)
                    .disabled(tempUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                )
            }
        }
    }
}

// ProfileInfoRow is now defined in SettingsView.swift

#Preview {
    NavigationView {
        ProfileView()
    }
} 