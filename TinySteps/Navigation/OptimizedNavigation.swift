//
//  OptimizedNavigation.swift
//  TinySteps
//
//  Created by inkfusionlabs on 24/10/2025.
//

import SwiftUI
import Combine

// MARK: - Optimized Navigation System

class NavigationOptimizer: ObservableObject {
    static let shared = NavigationOptimizer()
    
    @Published var isNavigationOptimized = false
    @Published var currentNavigationDepth = 0
    @Published var navigationHistory: [String] = []
    
    private let maxNavigationDepth = 5
    private var navigationTimer: Timer?
    
    private init() {
        setupNavigationMonitoring()
    }
    
    private func setupNavigationMonitoring() {
        // Monitor navigation depth
        $currentNavigationDepth
            .sink { [weak self] depth in
                self?.optimizeForNavigationDepth(depth)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func optimizeForNavigationDepth(_ depth: Int) {
        if depth > maxNavigationDepth {
            isNavigationOptimized = true
            // Implement navigation optimization strategies
            reduceNavigationAnimations()
            clearNavigationCache()
        } else {
            isNavigationOptimized = false
        }
    }
    
    private func reduceNavigationAnimations() {
        // Reduce animation complexity for deep navigation
        NotificationCenter.default.post(
            name: .navigationOptimizationRequested,
            object: nil
        )
    }
    
    private func clearNavigationCache() {
        // Clear cached views and data for memory optimization
        NotificationCenter.default.post(
            name: .navigationCacheClearRequested,
            object: nil
        )
    }
    
    func navigateTo(_ destination: String) {
        navigationHistory.append(destination)
        currentNavigationDepth = navigationHistory.count
        
        // Limit navigation history
        if navigationHistory.count > maxNavigationDepth {
            navigationHistory.removeFirst()
        }
    }
    
    func navigateBack() {
        if !navigationHistory.isEmpty {
            navigationHistory.removeLast()
            currentNavigationDepth = navigationHistory.count
        }
    }
}

// MARK: - Optimized Navigation View

struct OptimizedNavigationView<Content: View>: View {
    let content: Content
    @StateObject private var navigationOptimizer = NavigationOptimizer.shared
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationOptimized()
                .onReceive(navigationOptimizer.$isNavigationOptimized) { isOptimized in
                    if isOptimized {
                        // Apply navigation optimizations
                        reduceNavigationComplexity()
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force stack style for better performance
    }
    
    private func reduceNavigationComplexity() {
        // Reduce navigation complexity when optimized
        withAnimation(.easeInOut(duration: 0.1)) {
            // Apply optimization strategies
        }
    }
}

// MARK: - Navigation Optimization Modifier

struct NavigationOptimizedModifier: ViewModifier {
    @StateObject private var navigationOptimizer = NavigationOptimizer.shared
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var isOptimized = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(navigationOptimizer.$isNavigationOptimized) { optimized in
                isOptimized = optimized
            }
            .onReceive(performanceOptimizer.$isOptimizing) { optimizing in
                if optimizing {
                    isOptimized = true
                }
            }
            .animation(isOptimized ? .easeInOut(duration: 0.1) : .default, value: isOptimized)
    }
}

extension View {
    func navigationOptimized() -> some View {
        modifier(NavigationOptimizedModifier())
    }
}

// MARK: - Optimized Tab Navigation

struct OptimizedTabView<SelectionValue: Hashable, Content: View>: View {
    @Binding var selection: SelectionValue
    let content: Content
    @StateObject private var navigationOptimizer = NavigationOptimizer.shared
    @State private var tabChangeTime = Date()
    
    init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        TabView(selection: $selection) {
            content
        }
        .onChange(of: selection) { _, newValue in
            tabChangeTime = Date()
            navigationOptimizer.navigateTo("tab_\(newValue)")
        }
        .navigationOptimized()
    }
}

// MARK: - Optimized Sheet Presentation

struct OptimizedSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    content
                        .optimized()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
    }
}

// MARK: - Navigation Performance Monitoring

struct NavigationPerformanceMonitor: View {
    @StateObject private var navigationOptimizer = NavigationOptimizer.shared
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var navigationMetrics: NavigationMetrics = NavigationMetrics()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Navigation Performance")
                .font(.headline)
            
            HStack {
                Text("Depth:")
                Spacer()
                Text("\(navigationOptimizer.currentNavigationDepth)")
                    .foregroundColor(navigationOptimizer.currentNavigationDepth > 3 ? .red : .green)
            }
            
            HStack {
                Text("Optimized:")
                Spacer()
                Text(navigationOptimizer.isNavigationOptimized ? "Yes" : "No")
                    .foregroundColor(navigationOptimizer.isNavigationOptimized ? .orange : .green)
            }
            
            HStack {
                Text("History:")
                Spacer()
                Text("\(navigationOptimizer.navigationHistory.count) items")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct NavigationMetrics {
    var navigationTime: TimeInterval = 0
    var animationDuration: TimeInterval = 0
    var memoryUsage: UInt64 = 0
    var lastUpdate: Date = Date()
}

// MARK: - Navigation Notifications

extension Notification.Name {
    static let navigationOptimizationRequested = Notification.Name("navigationOptimizationRequested")
    static let navigationCacheClearRequested = Notification.Name("navigationCacheClearRequested")
}

// MARK: - Optimized Navigation Link

struct OptimizedNavigationLink<Destination: View, Label: View>: View {
    let destination: Destination
    let label: Label
    @StateObject private var navigationOptimizer = NavigationOptimizer.shared
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination: destination.navigationOptimized()) {
            label
        }
        .onTapGesture {
            navigationOptimizer.navigateTo("navigation_link")
        }
    }
}

// MARK: - Navigation Cache Manager

class NavigationCacheManager: ObservableObject {
    static let shared = NavigationCacheManager()
    
    private var viewCache: [String: AnyView] = [:]
    private let maxCacheSize = 20
    
    private init() {
        setupCacheMonitoring()
    }
    
    private func setupCacheMonitoring() {
        NotificationCenter.default
            .publisher(for: .navigationCacheClearRequested)
            .sink { [weak self] _ in
                self?.clearCache()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func cacheView<Content: View>(_ key: String, view: Content) {
        if viewCache.count >= maxCacheSize {
            // Remove oldest entries
            let keysToRemove = Array(viewCache.keys.prefix(viewCache.count - maxCacheSize + 1))
            keysToRemove.forEach { viewCache.removeValue(forKey: $0) }
        }
        
        viewCache[key] = AnyView(view)
    }
    
    func getCachedView(_ key: String) -> AnyView? {
        return viewCache[key]
    }
    
    func clearCache() {
        viewCache.removeAll()
    }
}
