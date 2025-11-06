//
//  PerformanceOptimizations.swift
//  TinySteps
//
//  Created by inkfusionlabs on 24/10/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Advanced Performance Optimizations

// Optimized List View for large datasets
struct OptimizedListView<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    @StateObject private var lazyLoader = LazyLoadingManager()
    @State private var visibleItems: Set<String> = []
    
    private let batchSize = 20
    private let prefetchThreshold = 5
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(items.prefix(visibleItems.count + batchSize)), id: \.id) { item in
                content(item)
                    .onAppear {
                        visibleItems.insert(item.id as? String ?? "")
                    }
                    .onDisappear {
                        visibleItems.remove(item.id as? String ?? "")
                    }
            }
        }
        .onAppear {
            loadInitialBatch()
        }
    }
    
    private func loadInitialBatch() {
        let initialItems = Array(items.prefix(batchSize))
        for item in initialItems {
            visibleItems.insert(item.id as? String ?? "")
        }
    }
}

// Memory-efficient image loading
struct OptimizedImageView: View {
    let imageData: Data?
    let placeholder: String
    let size: CGSize
    
    @StateObject private var imageOptimizer = ImageOptimizer.shared
    @State private var optimizedImage: UIImage?
    
    var body: some View {
        Group {
            if let image = optimizedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            } else {
                Image(systemName: placeholder)
                    .font(.system(size: size.width * 0.5))
                    .foregroundColor(.secondary)
                    .frame(width: size.width, height: size.height)
            }
        }
        .onAppear {
            loadOptimizedImage()
        }
    }
    
    private func loadOptimizedImage() {
        guard let data = imageData else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image = imageOptimizer.optimizedImage(from: data, size: size)
            
            DispatchQueue.main.async {
                self.optimizedImage = image
            }
        }
    }
}

// Debounced text input for performance
struct DebouncedTextField: View {
    @Binding var text: String
    let placeholder: String
    let onTextChange: (String) -> Void
    
    @State private var debouncedText = ""
    @State private var textChangeTimer: Timer?
    
    private let debounceDelay: TimeInterval = 0.5
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { _, newValue in
                textChangeTimer?.invalidate()
                textChangeTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { _ in
                    onTextChange(newValue)
                }
            }
    }
}

// Performance monitoring view
struct PerformanceMonitorView: View {
    @StateObject private var optimizer = PerformanceOptimizer.shared
    @StateObject private var memoryManager = MemoryManager.shared
    @State private var frameRate: Double = 60.0
    @State private var lastFrameTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Performance Monitor")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("FPS:")
                Spacer()
                Text("\(Int(frameRate))")
                    .foregroundColor(frameRate < 30 ? .red : .green)
            }
            
            HStack {
                Text("Memory:")
                Spacer()
                Text(formatMemory(memoryManager.memoryUsage))
                    .foregroundColor(memoryManager.isLowMemory ? .red : .primary)
            }
            
            HStack {
                Text("Optimizing:")
                Spacer()
                Text(optimizer.isOptimizing ? "Yes" : "No")
                    .foregroundColor(optimizer.isOptimizing ? .orange : .green)
            }
            
            HStack {
                Text("CPU:")
                Spacer()
                Text("\(Int(optimizer.performanceMetrics.cpuUsage))%")
                    .foregroundColor(optimizer.performanceMetrics.cpuUsage > 80 ? .red : .primary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .onAppear {
            startFrameRateMonitoring()
        }
    }
    
    private func startFrameRateMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let now = Date()
            let timeInterval = now.timeIntervalSince(lastFrameTime)
            frameRate = 1.0 / timeInterval
            lastFrameTime = now
        }
    }
    
    private func formatMemory(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

// Optimized navigation performance - moved to OptimizedNavigation.swift

// Batch processing for data operations
class BatchProcessor<T> {
    private var batch: [T] = []
    private let batchSize: Int
    private let processingInterval: TimeInterval
    private var timer: Timer?
    private let processor: ([T]) -> Void
    
    init(batchSize: Int = 10, processingInterval: TimeInterval = 1.0, processor: @escaping ([T]) -> Void) {
        self.batchSize = batchSize
        self.processingInterval = processingInterval
        self.processor = processor
    }
    
    func addItem(_ item: T) {
        batch.append(item)
        
        if batch.count >= batchSize {
            processBatch()
        } else {
            scheduleProcessing()
        }
    }
    
    private func scheduleProcessing() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: processingInterval, repeats: false) { [weak self] _ in
            self?.processBatch()
        }
    }
    
    private func processBatch() {
        guard !batch.isEmpty else { return }
        
        let itemsToProcess = batch
        batch.removeAll()
        
        processor(itemsToProcess)
    }
    
    func flush() {
        processBatch()
    }
}

// View caching for expensive computations
class ViewCache {
    private var cache: [String: Any] = [:]
    private let maxCacheSize = 50
    
    func get<T>(_ key: String, as type: T.Type) -> T? {
        return cache[key] as? T
    }
    
    func set<T>(_ key: String, value: T) {
        if cache.count >= maxCacheSize {
            // Remove oldest entries
            let keysToRemove = Array(cache.keys.prefix(cache.count - maxCacheSize + 1))
            keysToRemove.forEach { cache.removeValue(forKey: $0) }
        }
        
        cache[key] = value
    }
    
    func clear() {
        cache.removeAll()
    }
}

// Optimized view modifier for expensive operations
struct ExpensiveOperationModifier: ViewModifier {
    let operation: () -> Void
    @State private var hasPerformedOperation = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasPerformedOperation {
                    operation()
                    hasPerformedOperation = true
                }
            }
    }
}

extension View {
    func expensiveOperation(_ operation: @escaping () -> Void) -> some View {
        modifier(ExpensiveOperationModifier(operation: operation))
    }
}

// Performance testing utilities
struct PerformanceTestView: View {
    @StateObject private var tester = PerformanceTester()
    @State private var testResults: [String: Double] = [:]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Performance Tests")
                .font(.headline)
            
            ForEach(Array(testResults.keys.sorted()), id: \.self) { testName in
                HStack {
                    Text(testName)
                    Spacer()
                    Text(String(format: "%.3fs", testResults[testName] ?? 0))
                        .foregroundColor((testResults[testName] ?? 0) > 1.0 ? .red : .green)
                }
            }
            
            Button("Run Tests") {
                runPerformanceTests()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func runPerformanceTests() {
        // Test view rendering performance
        let _ = tester.measurePerformance("View Rendering") {
            // Simulate view rendering
            for _ in 0..<1000 {
                _ = UUID()
            }
        }
        
        // Test data processing performance
        let _ = tester.measurePerformance("Data Processing") {
            let data = Array(0..<10000)
            _ = data.map { $0 * 2 }.filter { $0 > 1000 }
        }
        
        // Test memory allocation performance
        let _ = tester.measurePerformance("Memory Allocation") {
            var array: [String] = []
            for i in 0..<1000 {
                array.append("Item \(i)")
            }
        }
        
        testResults = tester.testResults
    }
}
