//
//  MemoryManager.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Memory Manager
class MemoryManager: ObservableObject {
    static let shared = MemoryManager()
    
    @Published var memoryUsage: UInt64 = 0
    @Published var isLowMemory = false
    
    private var memoryTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        startMemoryMonitoring()
        setupMemoryWarnings()
    }
    
    deinit {
        stopMemoryMonitoring()
    }
    
    // MARK: - Memory Monitoring
    private func startMemoryMonitoring() {
        memoryTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateMemoryUsage()
        }
    }
    
    private func stopMemoryMonitoring() {
        memoryTimer?.invalidate()
        memoryTimer = nil
    }
    
    private func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            DispatchQueue.main.async {
                self.memoryUsage = info.resident_size
                self.isLowMemory = info.resident_size > 100 * 1024 * 1024 // 100MB threshold
            }
        }
    }
    
    private func setupMemoryWarnings() {
        NotificationCenter.default
            .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                self?.handleMemoryWarning()
            }
            .store(in: &cancellables)
    }
    
    private func handleMemoryWarning() {
        isLowMemory = true
        cleanupMemory()
    }
    
    // MARK: - Memory Cleanup
    func cleanupMemory() {
        // Clear caches
        URLCache.shared.removeAllCachedResponses()
        
        // Force garbage collection
        autoreleasepool {
            // This will help release any autoreleased objects
        }
        
        // Notify other parts of the app to clean up
        NotificationCenter.default.post(name: .memoryCleanupRequested, object: nil)
    }
    
    // MARK: - Memory Optimization Helpers
    func optimizeImageData(_ data: Data, maxSize: CGSize = CGSize(width: 1024, height: 1024)) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        
        let size = image.size
        let aspectRatio = size.width / size.height
        
        var newSize = maxSize
        if aspectRatio > 1 {
            newSize.height = newSize.width / aspectRatio
        } else {
            newSize.width = newSize.height * aspectRatio
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage?.jpegData(compressionQuality: 0.8)
    }
}

// MARK: - Memory Cleanup Notification
extension Notification.Name {
    static let memoryCleanupRequested = Notification.Name("memoryCleanupRequested")
}

// MARK: - Weak Reference Wrapper
class WeakRef<T: AnyObject> {
    weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

// MARK: - Memory-Efficient Timer
class MemoryEfficientTimer: ObservableObject {
    private var timer: Timer?
    private var isActive = false
    
    func start(timeInterval: TimeInterval, repeats: Bool = true, block: @escaping () -> Void) {
        stop()
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { [weak self] _ in
            guard self?.isActive == true else { return }
            block()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isActive = false
    }
    
    deinit {
        stop()
    }
}

// MARK: - Memory-Efficient Image Cache
class ImageCache: ObservableObject {
    private var cache: [String: UIImage] = [:]
    private let maxCacheSize = 50 // Maximum number of images to cache
    private let queue = DispatchQueue(label: "image.cache", attributes: .concurrent)
    
    func image(for key: String) -> UIImage? {
        return queue.sync {
            return cache[key]
        }
    }
    
    func setImage(_ image: UIImage, for key: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            // Remove oldest images if cache is full
            if self.cache.count >= self.maxCacheSize {
                let keysToRemove = Array(self.cache.keys.prefix(self.cache.count - self.maxCacheSize + 1))
                keysToRemove.forEach { self.cache.removeValue(forKey: $0) }
            }
            
            self.cache[key] = image
        }
    }
    
    func clearCache() {
        queue.async(flags: .barrier) { [weak self] in
            self?.cache.removeAll()
        }
    }
}

// MARK: - Memory-Efficient Data Manager
class MemoryEfficientDataManager: ObservableObject {
    private var dataCache: [String: Any] = [:]
    private let maxCacheSize = 100
    private let queue = DispatchQueue(label: "data.cache", attributes: .concurrent)
    
    func getData<T>(for key: String, as type: T.Type) -> T? {
        return queue.sync {
            return dataCache[key] as? T
        }
    }
    
    func setData<T>(_ data: T, for key: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            if self.dataCache.count >= self.maxCacheSize {
                let keysToRemove = Array(self.dataCache.keys.prefix(self.dataCache.count - self.maxCacheSize + 1))
                keysToRemove.forEach { self.dataCache.removeValue(forKey: $0) }
            }
            
            self.dataCache[key] = data
        }
    }
    
    func clearCache() {
        queue.async(flags: .barrier) { [weak self] in
            self?.dataCache.removeAll()
        }
    }
}

// MARK: - Memory-Efficient View Modifier
struct MemoryEfficientModifier: ViewModifier {
    @StateObject private var memoryManager = MemoryManager.shared
    @State private var isLowMemory = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(memoryManager.$isLowMemory) { lowMemory in
                isLowMemory = lowMemory
            }
            .onReceive(NotificationCenter.default.publisher(for: .memoryCleanupRequested)) { _ in
                // Perform cleanup when memory warning is received
                performCleanup()
            }
    }
    
    private func performCleanup() {
        // This would be implemented based on the specific view's needs
        // For example, clearing caches, releasing resources, etc.
    }
}

extension View {
    func memoryEfficient() -> some View {
        modifier(MemoryEfficientModifier())
    }
}

// MARK: - Memory Usage Monitor
struct MemoryUsageMonitor: View {
    @StateObject private var memoryManager = MemoryManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Memory Usage")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text(formatMemoryUsage(memoryManager.memoryUsage))
                    .font(.caption2)
                    .foregroundColor(memoryManager.isLowMemory ? .red : .primary)
                
                Spacer()
                
                if memoryManager.isLowMemory {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption2)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .cornerRadius(4)
    }
    
    private func formatMemoryUsage(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
