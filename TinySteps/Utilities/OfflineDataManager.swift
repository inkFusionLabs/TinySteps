//
//  OfflineDataManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Tracking Types
enum TrackingType: String, Codable, CaseIterable {
    case feeding = "feeding"
    case sleep = "sleep"
    case nappy = "nappy"
    case weight = "weight"
    case height = "height"
    case milestone = "milestone"
}

struct TrackingRecord: Codable, Identifiable {
    let id: UUID
    let type: TrackingType
    let value: Double
    let unit: String
    let date: Date
    let notes: String?
    
    init(id: UUID = UUID(), type: TrackingType, value: Double, unit: String, date: Date, notes: String? = nil) {
        self.id = id
        self.type = type
        self.value = value
        self.unit = unit
        self.date = date
        self.notes = notes
    }
}

// MARK: - Offline Data Manager
class OfflineDataManager: ObservableObject {
    static let shared = OfflineDataManager()
    
    @Published var isOnline = true
    @Published var pendingChanges: [PendingChange] = []
    @Published var syncStatus: SyncStatus = .idle
    @Published var lastSyncDate: Date?
    
    private var networkMonitor: NetworkMonitor?
    private var syncTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupNetworkMonitoring()
        setupSyncTimer()
        loadPendingChanges()
    }
    
    deinit {
        syncTimer?.invalidate()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        networkMonitor = NetworkMonitor()
        
        networkMonitor?.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isOnline = isConnected
                if isConnected {
                    self?.attemptSync()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Sync Timer
    private func setupSyncTimer() {
        syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            if self?.isOnline == true {
                self?.attemptSync()
            }
        }
    }
    
    // MARK: - Pending Changes Management
    func addPendingChange(_ change: PendingChange) {
        pendingChanges.append(change)
        savePendingChanges()
    }
    
    func removePendingChange(_ change: PendingChange) {
        pendingChanges.removeAll { $0.id == change.id }
        savePendingChanges()
    }
    
    func clearPendingChanges() {
        pendingChanges.removeAll()
        savePendingChanges()
    }
    
    // MARK: - Sync Operations
    func attemptSync() {
        guard isOnline, !pendingChanges.isEmpty else { return }
        
        syncStatus = .syncing
        
        Task {
            do {
                try await syncPendingChanges()
                await MainActor.run {
                    self.syncStatus = .success
                    self.lastSyncDate = Date()
                    self.clearPendingChanges()
                }
            } catch {
                await MainActor.run {
                    self.syncStatus = .failed(error.localizedDescription)
                }
            }
        }
    }
    
    private func syncPendingChanges() async throws {
        for change in pendingChanges {
            try await syncChange(change)
        }
    }
    
    private func syncChange(_ change: PendingChange) async throws {
        // This would implement the actual sync logic based on the change type
        // For now, we'll simulate a network request
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Simulate success/failure
        if Bool.random() {
            throw NSError(domain: "SyncError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sync failed"])
        }
    }
    
    // MARK: - Data Persistence
    private func savePendingChanges() {
        if let data = try? JSONEncoder().encode(pendingChanges) {
            UserDefaults.standard.set(data, forKey: "pendingChanges")
        }
    }
    
    private func loadPendingChanges() {
        if let data = UserDefaults.standard.data(forKey: "pendingChanges"),
           let changes = try? JSONDecoder().decode([PendingChange].self, from: data) {
            pendingChanges = changes
        }
    }
}

// MARK: - Pending Change
struct PendingChange: Codable, Identifiable {
    let id: UUID
    let type: ChangeType
    let data: Data
    let timestamp: Date
    let retryCount: Int
    
    init(type: ChangeType, data: Data, retryCount: Int = 0) {
        self.id = UUID()
        self.type = type
        self.data = data
        self.timestamp = Date()
        self.retryCount = retryCount
    }
}

enum ChangeType: String, Codable, CaseIterable {
    case babyUpdate = "baby_update"
    case milestoneCreate = "milestone_create"
    case milestoneUpdate = "milestone_update"
    case milestoneDelete = "milestone_delete"
    case appointmentCreate = "appointment_create"
    case appointmentUpdate = "appointment_update"
    case appointmentDelete = "appointment_delete"
    case trackingRecord = "tracking_record"
    case emergencyContact = "emergency_contact"
    
    var description: String {
        switch self {
        case .babyUpdate:
            return "Baby Information Update"
        case .milestoneCreate:
            return "New Milestone"
        case .milestoneUpdate:
            return "Milestone Update"
        case .milestoneDelete:
            return "Milestone Deletion"
        case .appointmentCreate:
            return "New Appointment"
        case .appointmentUpdate:
            return "Appointment Update"
        case .appointmentDelete:
            return "Appointment Deletion"
        case .trackingRecord:
            return "Tracking Record"
        case .emergencyContact:
            return "Emergency Contact"
        }
    }
}

// MARK: - Sync Status
enum SyncStatus {
    case idle
    case syncing
    case success
    case failed(String)
    
    var description: String {
        switch self {
        case .idle:
            return "Idle"
        case .syncing:
            return "Syncing..."
        case .success:
            return "Synced"
        case .failed(let error):
            return "Failed: \(error)"
        }
    }
    
    var color: Color {
        switch self {
        case .idle:
            return .gray
        case .syncing:
            return .blue
        case .success:
            return .green
        case .failed:
            return .red
        }
    }
}

// MARK: - Network Monitor
class NetworkMonitor: ObservableObject {
    @Published var isConnected = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        // This would implement actual network monitoring
        // For now, we'll simulate network status changes
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnected = Bool.random()
            }
        }
    }
}

// MARK: - Offline Data Manager Extensions
extension OfflineDataManager {
    
    // MARK: - Baby Data Sync
    func syncBabyUpdate(_ baby: Baby) {
        if let data = try? JSONEncoder().encode(baby) {
            let change = PendingChange(type: .babyUpdate, data: data)
            addPendingChange(change)
        }
    }
    
    // MARK: - Milestone Data Sync
    func syncMilestoneCreate(_ milestone: Milestone) {
        if let data = try? JSONEncoder().encode(milestone) {
            let change = PendingChange(type: .milestoneCreate, data: data)
            addPendingChange(change)
        }
    }
    
    func syncMilestoneUpdate(_ milestone: Milestone) {
        if let data = try? JSONEncoder().encode(milestone) {
            let change = PendingChange(type: .milestoneUpdate, data: data)
            addPendingChange(change)
        }
    }
    
    func syncMilestoneDelete(_ milestoneId: UUID) {
        if let data = try? JSONEncoder().encode(milestoneId) {
            let change = PendingChange(type: .milestoneDelete, data: data)
            addPendingChange(change)
        }
    }
    
    // MARK: - Appointment Data Sync
    func syncAppointmentCreate(_ appointment: Appointment) {
        if let data = try? JSONEncoder().encode(appointment) {
            let change = PendingChange(type: .appointmentCreate, data: data)
            addPendingChange(change)
        }
    }
    
    func syncAppointmentUpdate(_ appointment: Appointment) {
        if let data = try? JSONEncoder().encode(appointment) {
            let change = PendingChange(type: .appointmentUpdate, data: data)
            addPendingChange(change)
        }
    }
    
    func syncAppointmentDelete(_ appointmentId: UUID) {
        if let data = try? JSONEncoder().encode(appointmentId) {
            let change = PendingChange(type: .appointmentDelete, data: data)
            addPendingChange(change)
        }
    }
    
    // MARK: - Tracking Data Sync
    func syncTrackingRecord(_ record: TrackingRecord) {
        if let data = try? JSONEncoder().encode(record) {
            let change = PendingChange(type: .trackingRecord, data: data)
            addPendingChange(change)
        }
    }
    
    // MARK: - Emergency Contact Sync
    func syncEmergencyContact(_ contact: EmergencyContact) {
        if let data = try? JSONEncoder().encode(contact) {
            let change = PendingChange(type: .emergencyContact, data: data)
            addPendingChange(change)
        }
    }
}

// MARK: - Offline Status View
struct OfflineStatusView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: offlineManager.isOnline ? "wifi" : "wifi.slash")
                .foregroundColor(offlineManager.isOnline ? .green : .red)
            
            Text(offlineManager.isOnline ? "Online" : "Offline")
                .font(.caption)
                .foregroundColor(offlineManager.isOnline ? .green : .red)
            
            if !offlineManager.pendingChanges.isEmpty {
                Text("(\(offlineManager.pendingChanges.count) pending)")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Sync Status View
struct SyncStatusView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sync Status")
                    .font(.headline)
                
                Spacer()
                
                Button("Sync Now") {
                    offlineManager.attemptSync()
                }
                .disabled(!offlineManager.isOnline || offlineManager.pendingChanges.isEmpty)
                .buttonStyle(.bordered)
            }
            
            HStack {
                Circle()
                    .fill(offlineManager.syncStatus.color)
                    .frame(width: 8, height: 8)
                
                Text(offlineManager.syncStatus.description)
                    .font(.body)
                
                Spacer()
                
                if let lastSync = offlineManager.lastSyncDate {
                    Text("Last sync: \(lastSync, formatter: DateFormatter.shortTime)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if !offlineManager.pendingChanges.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pending Changes (\(offlineManager.pendingChanges.count))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ForEach(offlineManager.pendingChanges.prefix(5)) { change in
                        HStack {
                            Text(change.type.description)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text(change.timestamp, formatter: DateFormatter.shortTime)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if offlineManager.pendingChanges.count > 5 {
                        Text("... and \(offlineManager.pendingChanges.count - 5) more")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
