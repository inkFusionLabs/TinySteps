//
//  OfflineDataManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import Network
import Combine
import SwiftUI
import UIKit

class OfflineDataManager: ObservableObject {
    static let shared = OfflineDataManager()
    
    @Published var isOnline = true
    @Published var syncStatus: SyncStatus = .idle
    @Published var pendingSyncItems: [SyncItem] = []
    @Published var lastSyncDate: Date?
    

    @Published var syncProgress: Double = 0.0
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var cancellables = Set<AnyCancellable>()
    
    private let userDefaults = UserDefaults.standard
    private let syncQueue = DispatchQueue(label: "SyncQueue", qos: .background)
    
    enum SyncStatus: Equatable {
        case idle
        case syncing
        case completed
        case failed(String)
        
        var description: String {
            switch self {
            case .idle: return "Ready"
            case .syncing: return "Syncing..."
            case .completed: return "Sync Complete"
            case .failed(let error): return "Sync Failed: \(error)"
            }
        }
        
        var color: String {
            switch self {
            case .idle: return "gray"
            case .syncing: return "blue"
            case .completed: return "green"
            case .failed: return "red"
            }
        }
        
        static func == (lhs: SyncStatus, rhs: SyncStatus) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.syncing, .syncing):
                return true
            case (.completed, .completed):
                return true
            case (.failed(let lhsError), .failed(let rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        }
    }
    
    struct SyncItem: Codable, Identifiable {
        var id = UUID()
        let type: SyncItemType
        let data: Data
        let timestamp: Date
        let action: SyncAction
        
        enum SyncItemType: String, Codable, CaseIterable {
            case feeding = "feeding"
            case sleep = "sleep"
            case nappy = "nappy"
            case milestone = "milestone"
            case weight = "weight"
            case height = "height"
            case vaccination = "vaccination"
            case appointment = "appointment"
            case reminder = "reminder"
            case mood = "mood"
            case selfCare = "selfCare"
        }
        
        enum SyncAction: String, Codable {
            case create = "create"
            case update = "update"
            case delete = "delete"
        }
    }
    
    init() {
        setupNetworkMonitoring()
        loadPendingSyncItems()
        loadLastSyncDate()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
                
                if self?.isOnline == true {
                    self?.attemptSync()
                }
            }
        }
        networkMonitor.start(queue: queue)
    }
    
    // MARK: - Data Management
    func saveDataLocally<T: Codable>(_ data: T, type: SyncItem.SyncItemType, action: SyncItem.SyncAction) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let syncItem = SyncItem(type: type, data: encodedData, timestamp: Date(), action: action)
            
            addToPendingSync(syncItem)
            saveToLocalStorage(data, type: type)
        } catch {
            print("Error saving data locally: \(error)")
        }
    }
    
    func loadDataLocally<T: Codable>(type: SyncItem.SyncItemType) -> T? {
        let key = "local_\(type.rawValue)"
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error loading local data: \(error)")
            return nil
        }
    }
    
    func deleteDataLocally(type: SyncItem.SyncItemType, id: String) {
        let key = "local_\(type.rawValue)_\(id)"
        userDefaults.removeObject(forKey: key)
        
        // Add to sync queue for remote deletion
        let syncItem = SyncItem(type: type, data: Data(), timestamp: Date(), action: .delete)
        addToPendingSync(syncItem)
    }
    
    // MARK: - Sync Management
    func attemptSync() {
        guard isOnline && !pendingSyncItems.isEmpty else { return }
        
        syncStatus = .syncing
        syncProgress = 0.0
        
        let totalItems = pendingSyncItems.count
        
        for (index, item) in pendingSyncItems.enumerated() {
            syncItem(item) { [weak self] success in
                DispatchQueue.main.async {
                    self?.syncProgress = Double(index + 1) / Double(totalItems)
                    
                    if index == totalItems - 1 {
                        self?.completeSync(success: success)
                    }
                }
            }
        }
    }
    
    private func syncItem(_ item: SyncItem, completion: @escaping (Bool) -> Void) {
        // Simulate network request
        DispatchQueue.global().asyncAfter(deadline: .now() + Double.random(in: 0.5...2.0)) {
            let success = Bool.random() // Simulate success/failure
            completion(success)
        }
    }
    
    private func completeSync(success: Bool) {
        if success {
            syncStatus = .completed
            pendingSyncItems.removeAll()
            lastSyncDate = Date()
            saveLastSyncDate()
            savePendingSyncItems()
        } else {
            syncStatus = .failed("Some items failed to sync")
        }
    }
    
    // MARK: - Storage Management
    private func addToPendingSync(_ item: SyncItem) {
        pendingSyncItems.append(item)
        savePendingSyncItems()
    }
    
    private func saveToLocalStorage<T: Codable>(_ data: T, type: SyncItem.SyncItemType) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let key = "local_\(type.rawValue)"
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error saving to local storage: \(error)")
        }
    }
    
    private func savePendingSyncItems() {
        do {
            let encodedData = try JSONEncoder().encode(pendingSyncItems)
            userDefaults.set(encodedData, forKey: "PendingSyncItems")
        } catch {
            print("Error saving pending sync items: \(error)")
        }
    }
    
    private func loadPendingSyncItems() {
        guard let data = userDefaults.data(forKey: "PendingSyncItems") else { return }
        
        do {
            pendingSyncItems = try JSONDecoder().decode([SyncItem].self, from: data)
        } catch {
            print("Error loading pending sync items: \(error)")
        }
    }
    
    private func saveLastSyncDate() {
        userDefaults.set(lastSyncDate, forKey: "LastSyncDate")
    }
    
    private func loadLastSyncDate() {
        lastSyncDate = userDefaults.object(forKey: "LastSyncDate") as? Date
    }
    
    // MARK: - Data Export/Import
    func exportData() -> Data? {
        let exportData = ExportData(
            babyData: loadAllLocalData(),
            syncItems: pendingSyncItems,
            lastSync: lastSyncDate,
            exportDate: Date()
        )
        
        do {
            return try JSONEncoder().encode(exportData)
        } catch {
            print("Error exporting data: \(error)")
            return nil
        }
    }
    
    func importData(_ data: Data) -> Bool {
        do {
            let importData = try JSONDecoder().decode(ExportData.self, from: data)
            restoreFromExport(importData)
            return true
        } catch {
            print("Error importing data: \(error)")
            return false
        }
    }
    
    private func loadAllLocalData() -> [String: Data] {
        var allData: [String: Data] = [:]
        
        for type in SyncItem.SyncItemType.allCases {
            let key = "local_\(type.rawValue)"
            if let data = userDefaults.data(forKey: key) {
                allData[type.rawValue] = data
            }
        }
        
        return allData
    }
    
    private func restoreFromExport(_ exportData: ExportData) {
        // Restore local data
        for (type, data) in exportData.babyData {
            userDefaults.set(data, forKey: "local_\(type)")
        }
        
        // Restore sync items
        pendingSyncItems = exportData.syncItems
        savePendingSyncItems()
        
        // Restore sync date
        lastSyncDate = exportData.lastSync
        saveLastSyncDate()
    }
    
    // MARK: - Cache Management
    func clearCache() {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { key in
            key.hasPrefix("local_") || key == "PendingSyncItems"
        }
        
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
        
        pendingSyncItems.removeAll()
        lastSyncDate = nil
    }
    
    func getCacheSize() -> Int64 {
        var totalSize: Int64 = 0
        
        for (key, value) in userDefaults.dictionaryRepresentation() {
            if key.hasPrefix("local_") {
                if let data = value as? Data {
                    totalSize += Int64(data.count)
                }
            }
        }
        
        return totalSize
    }
    
    // MARK: - Health Check
    func performHealthCheck() -> HealthCheckResult {
        var issues: [String] = []
        var warnings: [String] = []
        
        // Check data integrity
        for type in SyncItem.SyncItemType.allCases {
            let key = "local_\(type.rawValue)"
            if let data = userDefaults.data(forKey: key) {
                do {
                    _ = try JSONSerialization.jsonObject(with: data)
                } catch {
                    issues.append("Corrupted data for \(type.rawValue)")
                }
            }
        }
        
        // Check sync queue
        if pendingSyncItems.count > 100 {
            warnings.append("Large sync queue (\(pendingSyncItems.count) items)")
        }
        
        // Check last sync
        if let lastSync = lastSyncDate {
            let daysSinceSync = Calendar.current.dateComponents([.day], from: lastSync, to: Date()).day ?? 0
            if daysSinceSync > 7 {
                warnings.append("No sync for \(daysSinceSync) days")
            }
        }
        
        // Check cache size
        let cacheSize = getCacheSize()
        if cacheSize > 50 * 1024 * 1024 { // 50MB
            warnings.append("Large cache size (\(cacheSize / 1024 / 1024)MB)")
        }
        
        return HealthCheckResult(
            isHealthy: issues.isEmpty,
            issues: issues,
            warnings: warnings,
            cacheSize: cacheSize,
            pendingItems: pendingSyncItems.count
        )
    }
}

// MARK: - Supporting Models

struct ExportData: Codable {
    let babyData: [String: Data]
    let syncItems: [OfflineDataManager.SyncItem]
    let lastSync: Date?
    let exportDate: Date
}

struct HealthCheckResult {
    let isHealthy: Bool
    let issues: [String]
    let warnings: [String]
    let cacheSize: Int64
    let pendingItems: Int
    
    init(isHealthy: Bool, issues: [String], warnings: [String], cacheSize: Int64, pendingItems: Int) {
        self.isHealthy = isHealthy
        self.issues = issues
        self.warnings = warnings
        self.cacheSize = cacheSize
        self.pendingItems = pendingItems
    }
}

// MARK: - Offline Status View
struct OfflineStatusView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    @State private var showingHealthCheck = false
    @State private var showingExportOptions = false
    @State private var showingImportOptions = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Connection Status
            HStack {
                Image(systemName: offlineManager.isOnline ? "wifi" : "wifi.slash")
                    .foregroundColor(offlineManager.isOnline ? .green : .red)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(offlineManager.isOnline ? "Online" : "Offline")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(offlineManager.isOnline ? "Data will sync automatically" : "Changes saved locally")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding()
            
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)

            .padding(.horizontal)
            
            // Sync Status
            VStack(spacing: 15) {
                HStack {
                    Text("Sync Status")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(offlineManager.syncStatus.description)
                        .font(.caption)
                        .foregroundColor(Color(offlineManager.syncStatus.color))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(offlineManager.syncStatus.color).opacity(0.2))

                }
                
                if offlineManager.syncStatus == .syncing {
                    ProgressView(value: offlineManager.syncProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                
                if !offlineManager.pendingSyncItems.isEmpty {
                    Text("\(offlineManager.pendingSyncItems.count) items pending sync")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if let lastSync = offlineManager.lastSyncDate {
                    Text("Last sync: \(lastSync, style: .relative)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)

            .padding(.horizontal)
            
            // Actions
            VStack(spacing: 12) {
                Button(action: { offlineManager.attemptSync() }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Sync Now")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.3))
        
                }
                .disabled(!offlineManager.isOnline || offlineManager.pendingSyncItems.isEmpty)
                
                Button(action: { showingHealthCheck = true }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Health Check")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.3))
        
                }
                
                HStack(spacing: 12) {
                    Button(action: { showingExportOptions = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.3))

                    }
                    
                    Button(action: { showingImportOptions = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Import")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple.opacity(0.3))

                    }
                }
            }
            .padding(.horizontal)
            
            // Pending Items List
            if !offlineManager.pendingSyncItems.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Pending Sync Items")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(offlineManager.pendingSyncItems) { item in
                                PendingSyncItemRow(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
        .sheet(isPresented: $showingHealthCheck) {
            HealthCheckView()
        }
        .sheet(isPresented: $showingExportOptions) {
            ExportOptionsView()
        }
        .sheet(isPresented: $showingImportOptions) {
            ImportOptionsView()
        }
    }
}

struct PendingSyncItemRow: View {
    let item: OfflineDataManager.SyncItem
    
    var body: some View {
        HStack {
            Image(systemName: iconForType(item.type))
                .foregroundColor(colorForType(item.type))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.type.rawValue.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(item.action.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(item.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))

    }
    
    private func iconForType(_ type: OfflineDataManager.SyncItem.SyncItemType) -> String {
        switch type {
        case .feeding: return "drop.fill"
        case .sleep: return "bed.double.fill"
        case .nappy: return "drop"
        case .milestone: return "star.fill"
        case .weight: return "scalemass.fill"
        case .height: return "ruler.fill"
        case .vaccination: return "cross.fill"
        case .appointment: return "calendar"
        case .reminder: return "bell.fill"
        case .mood: return "heart.fill"
        case .selfCare: return "figure.walk"
        }
    }
    
    private func colorForType(_ type: OfflineDataManager.SyncItem.SyncItemType) -> Color {
        switch type {
        case .feeding: return .blue
        case .sleep: return .purple
        case .nappy: return .green
        case .milestone: return .yellow
        case .weight: return .orange
        case .height: return .cyan
        case .vaccination: return .red
        case .appointment: return .indigo
        case .reminder: return .pink
        case .mood: return .pink
        case .selfCare: return .green
        }
    }
}

struct HealthCheckView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var healthResult: HealthCheckResult?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let result = healthResult {
                            // Health Status
                            HStack {
                                Image(systemName: result.isHealthy ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(result.isHealthy ? .green : .red)
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(result.isHealthy ? "Healthy" : "Issues Found")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("Data integrity check completed")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                            .padding()
                            
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.clear)
    
                            .padding(.horizontal)
                            
                            // Issues
                            if !result.issues.isEmpty {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Issues")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                    
                                    VStack(spacing: 8) {
                                        ForEach(result.issues, id: \.self) { issue in
                                            HStack {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                                Text(issue)
                                                    .foregroundColor(.white)
                                                Spacer()
                                            }
                                            .padding()
                                            
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.red.opacity(0.1))
                    
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Warnings
                            if !result.warnings.isEmpty {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Warnings")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                        .padding(.horizontal)
                                    
                                    VStack(spacing: 8) {
                                        ForEach(result.warnings, id: \.self) { warning in
                                            HStack {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.orange)
                                                Text(warning)
                                                    .foregroundColor(.white)
                                                Spacer()
                                            }
                                            .padding()
                                            
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.orange.opacity(0.1))
                    
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Statistics
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Statistics")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 10) {
                                    StatRow(
                                        title: "Cache Size",
                                        value: "\(result.cacheSize / 1024 / 1024) MB",
                                        icon: "memorychip",
                                        color: .blue
                                    )
                                    
                                    StatRow(
                                        title: "Pending Items",
                                        value: "\(result.pendingItems)",
                                        icon: "clock.fill",
                                        color: .orange
                                    )
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            ProgressView("Running health check...")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Health Check")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                healthResult = offlineManager.performHealthCheck()
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
        
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))

    }
}

struct ExportOptionsView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var exportData: Data?
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Export Data")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Export your data for backup or transfer to another device")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        exportData = offlineManager.exportData()
                        showingShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export Data")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.3))

                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let data = exportData {
                    ShareSheet(activityItems: [data])
                }
            }
        }
    }
}

struct ImportOptionsView: View {
    @StateObject private var offlineManager = OfflineDataManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showingDocumentPicker = false
    @State private var importSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Import Data")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Import data from a backup file")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Button(action: { showingDocumentPicker = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Select File")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.3))

                    }
                    .padding(.horizontal)
                    
                    if importSuccess {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Import successful!")
                                .foregroundColor(.green)
                        }
                        .padding()
                        
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.1))

                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}



#Preview {
    OfflineStatusView()
} 