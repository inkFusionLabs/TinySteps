//
//  PerformanceSettingsView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct PerformanceSettingsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @StateObject private var performanceMonitor = PerformanceMonitor()
    @Environment(\.dismiss) var dismiss
    @State private var showingOptimizationAlert = false
    @State private var optimizationMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        TinyStepsSectionHeader(
                            title: "Performance & Storage",
                            icon: "speedometer",
                            color: .orange
                        )
                        
                        // Performance Stats
                        VStack(spacing: 15) {
                            ProfileInfoRow(
                                icon: "chart.bar.fill",
                                title: "Total Records",
                                value: "\(dataManager.getPerformanceStats()["totalRecords"] as? Int ?? 0)",
                                color: .blue
                            )
                            
                            ProfileInfoRow(
                                icon: "clock.fill",
                                title: "Last Save",
                                value: formatTimeAgo(dataManager.getPerformanceStats()["lastSaveTime"] as? Date ?? Date()),
                                color: .green
                            )
                            
                            ProfileInfoRow(
                                icon: "memorychip",
                                title: "Cache Age",
                                value: formatCacheAge(dataManager.getPerformanceStats()["cacheAge"] as? Double ?? 0),
                                color: .purple
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                        
                        // Performance Monitor
                        if performanceMonitor.isMonitoring {
                            VStack(spacing: 15) {
                                ProfileInfoRow(
                                    icon: "display",
                                    title: "Frame Rate",
                                    value: String(format: "%.1f FPS", performanceMonitor.frameRate),
                                    color: performanceMonitor.frameRate > 55 ? .green : .orange
                                )
                                
                                ProfileInfoRow(
                                    icon: "memorychip.fill",
                                    title: "Memory Usage",
                                    value: String(format: "%.1f MB", performanceMonitor.memoryUsage),
                                    color: performanceMonitor.memoryUsage < 100 ? .green : .orange
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(12)
                        }
                        
                        // Performance Actions
                        VStack(spacing: 15) {
                            Button(action: {
                                if performanceMonitor.isMonitoring {
                                    performanceMonitor.stopMonitoring()
                                } else {
                                    performanceMonitor.startMonitoring()
                                }
                            }) {
                                HStack {
                                    Image(systemName: performanceMonitor.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                                        .font(.title2)
                                    Text(performanceMonitor.isMonitoring ? "Stop Monitoring" : "Start Performance Monitor")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(performanceMonitor.isMonitoring ? Color.red : Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                optimizeApp()
                            }) {
                                HStack {
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .font(.title2)
                                    Text("Optimize Storage")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                cleanupOldData()
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .font(.title2)
                                    Text("Cleanup Old Records")
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
                        
                        // Information Cards
                        VStack(spacing: 15) {
                            TinyStepsInfoCard(
                                title: "Performance Tips",
                                content: "• Keep your device updated\n• Close other apps when using TinySteps\n• Restart the app if it feels slow\n• Use the optimize feature regularly",
                                icon: "lightbulb.fill",
                                color: .yellow
                            )
                            
                            TinyStepsInfoCard(
                                title: "Storage Management",
                                content: "The app automatically manages storage by keeping recent records and cleaning up old data. Use the cleanup feature to remove records older than one year.",
                                icon: "externaldrive.fill",
                                color: .blue
                            )
                            
                            TinyStepsInfoCard(
                                title: "Cache System",
                                content: "TinySteps uses intelligent caching to improve performance. Frequently accessed data is cached for faster loading times.",
                                icon: "bolt.fill",
                                color: .green
                            )
                        }
                        .padding(.horizontal, TinyStepsDesign.Spacing.md)
                    }
                    .padding()
                }
            }
            .navigationTitle("Performance")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Optimization Result", isPresented: .constant(!optimizationMessage.isEmpty)) {
            Button("OK") {
                optimizationMessage = ""
            }
        } message: {
            Text(optimizationMessage)
        }
    }
    
    private func optimizeApp() {
        dataManager.optimizeStorage()
        optimizationMessage = "Storage optimized successfully! Duplicate records removed and data sorted for better performance."
    }
    
    private func cleanupOldData() {
        dataManager.cleanupOldRecords()
        optimizationMessage = "Old records cleaned up successfully! Records older than one year have been removed."
    }
    
    private func formatTimeAgo(_ date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date)
        if timeInterval < 60 {
            return "Just now"
        } else if timeInterval < 3600 {
            return "\(Int(timeInterval / 60))m ago"
        } else if timeInterval < 86400 {
            return "\(Int(timeInterval / 3600))h ago"
        } else {
            return "\(Int(timeInterval / 86400))d ago"
        }
    }
    
    private func formatCacheAge(_ seconds: Double) -> String {
        if seconds < 60 {
            return "\(Int(seconds))s"
        } else if seconds < 3600 {
            return "\(Int(seconds / 60))m"
        } else {
            return "\(Int(seconds / 3600))h"
        }
    }
} 