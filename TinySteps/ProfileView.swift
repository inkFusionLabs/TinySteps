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
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Profile Header
                    VStack(spacing: 20) {
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
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 100))
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .fill(Color.clear)
                                                .frame(width: 120, height: 120)
                                        )
                                }
                                
                                // Camera icon overlay
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "camera.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                            .background(Circle().fill(Color.white))
                                            .offset(x: -15, y: 5)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Profile avatar")
                        .accessibilityHint("Tap to change your profile picture")
                        
                        // User Name
                        VStack(spacing: 8) {
                            Text(userName.isEmpty ? "User" : userName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityLabel(userName.isEmpty ? "User" : userName)
                                .accessibilityAddTraits(.isHeader)
                            
                            Text("TinySteps User")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .accessibilityLabel("TinySteps User")
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
                            .background(Color.clear)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Edit Profile")
                        .accessibilityHint("Edit your profile name.")
                        
                        // App Information
                        VStack(spacing: 15) {
                            ProfileInfoRow(
                                icon: "info.circle.fill",
                                title: "App Version",
                                value: "1.0.0",
                                color: .green
                            )
                            
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
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.clear)
                        )
                        
                        // Support Section
                        VStack(spacing: 15) {
                            NavigationLink(destination: SupportView()) {
                                HStack {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.yellow)
                                    
                                    Text("Help & Support")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("Help and Support")
                            .accessibilityHint("Get help and support for TinySteps.")
                            
                            NavigationLink(destination: AboutTinyStepsView()) {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.cyan)
                                    
                                    Text("About TinySteps")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("About TinySteps")
                            .accessibilityHint("Learn more about TinySteps.")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.clear)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImageOptions) {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Profile Picture")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            showingImagePicker = true
                            showingImageOptions = false
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                
                                Text("Choose from Photo Library")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if userProfileImageData != nil {
                            Button(action: {
                                userProfileImageData = nil
                                showingImageOptions = false
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                    
                                    Text("Remove Current Picture")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(TinyStepsDesign.Colors.background)
                .navigationBarItems(
                    trailing: Button("Cancel") {
                        showingImageOptions = false
                    }
                    .foregroundColor(.white)
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
                    
                    Spacer()
                }
                .padding()
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
                        showingNameEdit = false
                    }
                    .foregroundColor(.blue)
                    .disabled(tempUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                )
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
                .accessibilityLabel(title)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .accessibilityLabel(value)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
} 