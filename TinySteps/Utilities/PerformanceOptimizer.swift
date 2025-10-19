//
//  PerformanceOptimizer.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Performance Optimizer
class PerformanceOptimizer: ObservableObject {
    static let shared = PerformanceOptimizer()
    
    @Published var isOptimizing = false
    @Published var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    
    private var cancellables = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue(label: "performance.background", qos: .utility)
    
    private init() {
        setupPerformanceMonitoring()
    }
    
    // MARK: - Performance Monitoring
    private func setupPerformanceMonitoring() {
        // Monitor app lifecycle for performance optimization
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.optimizeForActiveState()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.optimizeForBackgroundState()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - State-Based Optimization
    private func optimizeForActiveState() {
        // Resume high-quality animations and real-time updates
        isOptimizing = false
    }
    
    private func optimizeForBackgroundState() {
        // Reduce resource usage when app is in background
        isOptimizing = true
        reduceResourceUsage()
    }
    
    // MARK: - Resource Management
    func reduceResourceUsage() {
        // Clear caches
        URLCache.shared.removeAllCachedResponses()
        
        // Reduce animation quality
        // This would be implemented based on specific needs
        
        // Notify views to optimize
        NotificationCenter.default.post(name: .performanceOptimizationRequested, object: nil)
    }
    
    func restoreFullPerformance() {
        isOptimizing = false
        NotificationCenter.default.post(name: .performanceRestorationRequested, object: nil)
    }
}

// MARK: - Performance Metrics
struct PerformanceMetrics {
    var frameRate: Double = 60.0
    var memoryUsage: UInt64 = 0
    var cpuUsage: Double = 0.0
    var animationCount: Int = 0
    var lastUpdate: Date = Date()
}

// MARK: - Performance Notifications
extension Notification.Name {
    static let performanceOptimizationRequested = Notification.Name("performanceOptimizationRequested")
    static let performanceRestorationRequested = Notification.Name("performanceRestorationRequested")
}

// MARK: - Optimized Animation Modifier
struct OptimizedAnimationModifier: ViewModifier {
    @StateObject private var optimizer = PerformanceOptimizer.shared
    @State private var isOptimized = false
    
    let animation: Animation
    let value: Any
    
    init(animation: Animation, value: Any) {
        self.animation = animation
        self.value = value
    }
    
    func body(content: Content) -> some View {
        content
            .animation(isOptimized ? .easeInOut(duration: 0.1) : animation)
            .onReceive(optimizer.$isOptimizing) { optimizing in
                isOptimized = optimizing
            }
    }
}

// MARK: - Optimized View Modifier
struct OptimizedViewModifier: ViewModifier {
    @StateObject private var optimizer = PerformanceOptimizer.shared
    @State private var isOptimized = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(optimizer.$isOptimizing) { optimizing in
                isOptimized = optimizing
            }
            .onReceive(NotificationCenter.default.publisher(for: .performanceOptimizationRequested)) { _ in
                isOptimized = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .performanceRestorationRequested)) { _ in
                isOptimized = false
            }
    }
}

extension View {
    func optimizedAnimation(_ animation: Animation, value: Any) -> some View {
        modifier(OptimizedAnimationModifier(animation: animation, value: value))
    }
    
    func optimized() -> some View {
        modifier(OptimizedViewModifier())
    }
}

// MARK: - Background Task Manager
class BackgroundTaskManager: ObservableObject {
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    func startBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    
    deinit {
        endBackgroundTask()
    }
}

// MARK: - Lazy Loading Manager
class LazyLoadingManager: ObservableObject {
    private var loadedItems: Set<String> = []
    private let maxLoadedItems = 50
    
    func shouldLoadItem(_ id: String) -> Bool {
        return loadedItems.count < maxLoadedItems || loadedItems.contains(id)
    }
    
    func markItemAsLoaded(_ id: String) {
        loadedItems.insert(id)
        
        // Remove oldest items if we exceed the limit
        if loadedItems.count > maxLoadedItems {
            let itemsToRemove = Array(loadedItems.prefix(loadedItems.count - maxLoadedItems))
            itemsToRemove.forEach { loadedItems.remove($0) }
        }
    }
    
    func clearLoadedItems() {
        loadedItems.removeAll()
    }
}

// MARK: - Image Optimization
class ImageOptimizer: ObservableObject {
    static let shared = ImageOptimizer()
    
    private let cache = NSCache<NSString, UIImage>()
    private let backgroundQueue = DispatchQueue(label: "image.optimization", qos: .utility)
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func optimizedImage(from data: Data, size: CGSize) -> UIImage? {
        let key = "\(data.hashValue)_\(size.width)_\(size.height)" as NSString
        
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }
        
        guard let image = UIImage(data: data) else { return nil }
        
        let optimizedImage = resizeImage(image, to: size)
        cache.setObject(optimizedImage, forKey: key)
        
        return optimizedImage
    }
    
    private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Performance Testing
class PerformanceTester: ObservableObject {
    @Published var testResults: [String: Double] = [:]
    
    func measurePerformance<T>(_ name: String, operation: () throws -> T) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        DispatchQueue.main.async {
            self.testResults[name] = timeElapsed
        }
        
        return result
    }
    
    func measureAsyncPerformance<T>(_ name: String, operation: @escaping () async throws -> T) async rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        await MainActor.run {
            self.testResults[name] = timeElapsed
        }
        
        return result
    }
}

// MARK: - Performance Debug View
struct PerformanceDebugView: View {
    @StateObject private var optimizer = PerformanceOptimizer.shared
    @StateObject private var memoryManager = MemoryManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Performance Debug")
                .font(.headline)
            
            HStack {
                Text("Optimizing:")
                Spacer()
                Text(optimizer.isOptimizing ? "Yes" : "No")
                    .foregroundColor(optimizer.isOptimizing ? .orange : .green)
            }
            
            HStack {
                Text("Memory:")
                Spacer()
                Text(formatMemoryUsage(memoryManager.memoryUsage))
                    .foregroundColor(memoryManager.isLowMemory ? .red : .primary)
            }
            
            HStack {
                Text("Frame Rate:")
                Spacer()
                Text("\(Int(optimizer.performanceMetrics.frameRate)) FPS")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatMemoryUsage(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
