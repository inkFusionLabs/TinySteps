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
    @StateObject private var restoreManager = DataRestoreManager()
    @Environment(\.dismiss) var dismiss
    @State private var showingFilePicker = false
    @State private var showingDeleteAlert = false
    @State private var backupToDelete: TinyStepsBackup?
    @State private var showingRestoreAlert = false
    @State private var backupToRestore: TinyStepsBackup?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        TinyStepsSectionHeader(
                            title: "Backup & Restore",
                            icon: "arrow.clockwise",
                            color: TinyStepsDesign.Colors.accent
                        )
                        
                        // Current Status
                        VStack(spacing: 15) {
                            ProfileInfoRow(
                                icon: "clock.fill",
                                title: "Last Backup",
                                value: restoreManager.lastBackupDate?.formatted(date: .abbreviated, time: .shortened) ?? "Never",
                                color: .green
                            )
                            
                            ProfileInfoRow(
                                icon: "archivebox.fill",
                                title: "Available Backups",
                                value: "\(restoreManager.availableBackups.count)",
                                color: .blue
                            )
                            
                            if restoreManager.shouldAutoBackup() {
                                ProfileInfoRow(
                                    icon: "exclamationmark.triangle.fill",
                                    title: "Backup Recommended",
                                    value: "Create backup now",
                                    color: .orange
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                        
                        // Backup Actions
                        VStack(spacing: 15) {
                            Button(action: {
                                Task {
                                    await restoreManager.createBackup(from: dataManager)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                    Text("Create Backup")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                            .disabled(restoreManager.isBackingUp)
                            
                            Button(action: {
                                if let backupURL = restoreManager.exportBackup(from: dataManager) {
                                    let activityVC = UIActivityViewController(
                                        activityItems: [backupURL],
                                        applicationActivities: nil
                                    )
                                    
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first {
                                        window.rootViewController?.present(activityVC, animated: true)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title2)
                                    Text("Export Backup")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingFilePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.title2)
                                    Text("Import Backup")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                        
                        // Progress Indicators
                        if restoreManager.isBackingUp {
                            VStack(spacing: 10) {
                                Text("Creating Backup...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ProgressView(value: restoreManager.backupProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                    .scaleEffect(y: 2)
                                
                                Text("\(Int(restoreManager.backupProgress * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(12)
                        }
                        
                        if restoreManager.isRestoring {
                            VStack(spacing: 10) {
                                Text("Restoring Data...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ProgressView(value: restoreManager.restoreProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                    .scaleEffect(y: 2)
                                
                                Text("\(Int(restoreManager.restoreProgress * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(12)
                        }
                        
                        // Available Backups
                        if !restoreManager.availableBackups.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Available Backups")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ForEach(restoreManager.availableBackups, id: \.timestamp) { backup in
                                    BackupCard(
                                        backup: backup,
                                        onRestore: {
                                            backupToRestore = backup
                                            showingRestoreAlert = true
                                        },
                                        onDelete: {
                                            backupToDelete = backup
                                            showingDeleteAlert = true
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Information Cards
                        VStack(spacing: 15) {
                            TinyStepsInfoCard(
                                title: "Backup Safety",
                                content: "Your data is backed up locally on your device. For additional safety, export backups to iCloud Drive or email them to yourself.",
                                icon: "shield.fill",
                                color: TinyStepsDesign.Colors.success
                            )
                            
                            TinyStepsInfoCard(
                                title: "Restore Process",
                                content: "When you restore from a backup, all current data will be replaced with the backup data. Make sure to create a backup before restoring.",
                                icon: "arrow.clockwise",
                                color: TinyStepsDesign.Colors.warning
                            )
                            
                            TinyStepsInfoCard(
                                title: "App Deletion",
                                content: "If you delete and reinstall the app, you can restore your data by importing a backup file or using a previously created backup.",
                                icon: "trash",
                                color: TinyStepsDesign.Colors.accent
                            )
                        }
                        .padding(.horizontal, TinyStepsDesign.Spacing.md)
                    }
                    .padding()
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
                        await restoreManager.importBackup(from: url, dataManager: dataManager)
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
                    restoreManager.deleteBackup(backup)
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
                        await restoreManager.restoreFromBackup(backup, dataManager: dataManager)
                    }
                }
            }
        } message: {
            Text("This will replace all current data with the backup data. Are you sure you want to continue?")
        }
        .alert("Restore Result", isPresented: .constant(!restoreManager.restoreMessage.isEmpty)) {
            Button("OK") {
                restoreManager.restoreMessage = ""
            }
        } message: {
            Text(restoreManager.restoreMessage)
        }
    }
}

struct BackupCard: View {
    let backup: TinyStepsBackup
    let onRestore: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            BackupInfoView(backup: backup)
            
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