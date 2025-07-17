//
//  ProfileView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var showingNameEdit = false
    @State private var tempUserName = ""
    @State private var showingLogoutAlert = false
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
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                            )
                        
                        // User Name
                        VStack(spacing: 8) {
                            Text(userName.isEmpty ? "User" : userName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("TinySteps User")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
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
                                .fill(Color.white.opacity(0.1))
                        )
                        
                        // Support Section
                        VStack(spacing: 15) {
                            Button(action: {
                                // Navigate to support
                            }) {
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
                            
                            Button(action: {
                                // Navigate to about
                            }) {
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
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                userName = ""
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to logout? You'll need to enter your name again.")
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