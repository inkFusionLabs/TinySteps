//
//  DataRestoreView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

struct DataRestoreView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @StateObject private var restoreManager = BabyDataManager()
    @Environment(\.dismiss) var dismiss
    @State private var showingFilePicker = false
    @State private var showingDeleteAlert = false
    @State private var backupToDelete: String?
    @State private var showingRestoreAlert = false
    @State private var backupToRestore: String?
    
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Backup & Restore")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }
                        
                        // Current Status
                        VStack(spacing: 15) {
                            ProfileInfoRow(
                                icon: "clock.fill",
                                title: "Last Backup",
                                value: "Never",
                                color: .green
                            )
                            
                            ProfileInfoRow(
                                icon: "archivebox.fill",
                                title: "Available Backups",
                                value: "0",
                                color: .blue
                            )
                            
                            ProfileInfoRow(
                                icon: "exclamationmark.triangle.fill",
                                title: "Backup Recommended",
                                value: "Create backup now",
                                color: .orange
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                        
                        // Backup Actions
                        VStack(spacing: 15) {
                            Button {
                                Task {
                                    // createBackup functionality removed - simplified app
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                    Text("Create Backup")
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(false)
                            
                            Button {
                                // exportBackup functionality removed - simplified app
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title2)
                                    Text("Export Backup")
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button {
                                showingFilePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.title2)
                                    Text("Import Backup")
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                        
                        // Progress Indicators removed - simplified app
                        
                        // Restore progress removed - simplified app
                        
                        // Available Backups removed - simplified app
                        
                        // Information Cards
                        VStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "shield.fill")
                                        .foregroundColor(Color.green)
                                    Text("Backup Safety")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                Text("Your data is backed up locally on your device. For additional safety, export backups to iCloud Drive or email them to yourself.")
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .foregroundColor(Color.orange)
                                    Text("Restore Process")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                Text("When you restore from a backup, all current data will be replaced with the backup data. Make sure to create a backup before restoring.")
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "trash")
                                        .foregroundColor(Color.blue)
                                    Text("App Deletion")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                Text("If you delete and reinstall the app, you can restore your data by importing a backup file or using a previously created backup.")
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.md)
                    }
                    .padding()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isAnimating = true
                        }
                    }
                }
            }
            .navigationTitle("Backup & Restore")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [UTType.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        // importBackup functionality removed - simplified app
                    }
                }
            case .failure(let error):
                print("File import failed: \(error)")
            }
        }
        .alert("Delete Backup", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let backup = backupToDelete {
                    // deleteBackup functionality removed - simplified app
                }
            }
        } message: {
            Text("Are you sure you want to delete this backup? This action cannot be undone.")
        }
        .alert("Restore from Backup", isPresented: $showingRestoreAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Restore", role: .destructive) {
                if let backup = backupToRestore {
                    Task {
                        // restoreFromBackup functionality removed - simplified app
                    }
                }
            }
        } message: {
            Text("This will replace all current data with the backup data. Are you sure you want to continue?")
        }
        .alert("Restore Result", isPresented: .constant(false)) {
            Button("OK") {
                // restoreMessage functionality removed - simplified app
            }
        } message: {
            Text("Restore functionality removed - simplified app")
        }
    }
}

struct BackupCard: View {
    let backup: String
    let onRestore: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Backup: \(backup)")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 15) {
                Button(action: onRestore) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Restore")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
                Button(action: onDelete) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
} 