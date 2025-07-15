//
//  PerformanceOptimizedViews.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

// MARK: - Performance Optimized View Wrapper
struct OptimizedView<Content: View>: View {
    let content: () -> Content
    @State private var isVisible = false
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

// MARK: - Lazy Loading List
struct LazyLoadingList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    let loadMore: () -> Void
    let isLoading: Bool
    
    init(data: Data, isLoading: Bool = false, loadMore: @escaping () -> Void = {}, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.loadMore = loadMore
        self.isLoading = isLoading
    }
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                content(item)
                    .onAppear {
                        if index == data.count - 3 && !isLoading {
                            loadMore()
                        }
                    }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
            }
        }
    }
}

// MARK: - Optimized Chart Data
struct OptimizedChartData {
    let dataPoints: [ChartDataPoint]
    let maxValue: Double
    let minValue: Double
    let averageValue: Double
    
    struct ChartDataPoint {
        let date: Date
        let value: Double
        let label: String
    }
    
    init(from records: [Any], valueExtractor: (Any) -> Double, labelExtractor: (Any) -> String) {
        let points = records.map { record in
            ChartDataPoint(
                date: Self.extractDate(from: record),
                value: valueExtractor(record),
                label: labelExtractor(record)
            )
        }.sorted { $0.date < $1.date }
        
        self.dataPoints = points
        self.maxValue = points.map { $0.value }.max() ?? 0
        self.minValue = points.map { $0.value }.min() ?? 0
        self.averageValue = points.map { $0.value }.reduce(0, +) / Double(max(points.count, 1))
    }
    
    private static func extractDate(from record: Any) -> Date {
        if let feeding = record as? FeedingRecord {
            return feeding.date
        } else if let sleep = record as? SleepRecord {
            return sleep.startTime
        } else if let nappy = record as? NappyRecord {
            return nappy.date
        }
        return Date()
    }
}

// MARK: - Cached Image View
struct CachedImageView: View {
    let imageName: String
    let systemName: String?
    let size: CGSize
    @State private var image: UIImage?
    
    init(imageName: String, size: CGSize = CGSize(width: 100, height: 100)) {
        self.imageName = imageName
        self.systemName = nil
        self.size = size
    }
    
    init(systemName: String, size: CGSize = CGSize(width: 100, height: 100)) {
        self.imageName = ""
        self.systemName = systemName
        self.size = size
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let systemName = systemName {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        // Implement image caching logic here
        // For now, just load the image normally
    }
}

// MARK: - Performance Monitor
class PerformanceMonitor: ObservableObject {
    @Published var isMonitoring = false
    @Published var frameRate: Double = 0
    @Published var memoryUsage: Double = 0
    @Published var cpuUsage: Double = 0
    
    private var displayLink: CADisplayLink?
    private var frameCount = 0
    private var lastFrameTime: CFTimeInterval = 0
    
    func startMonitoring() {
        isMonitoring = true
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopMonitoring() {
        isMonitoring = false
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateFrameRate() {
        frameCount += 1
        let currentTime = CACurrentMediaTime()
        
        if currentTime - lastFrameTime >= 1.0 {
            frameRate = Double(frameCount)
            frameCount = 0
            lastFrameTime = currentTime
            
            updateSystemStats()
        }
    }
    
    private func updateSystemStats() {
        // Get memory usage
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
            memoryUsage = Double(info.resident_size) / 1024.0 / 1024.0 // MB
        }
    }
}

// MARK: - Optimized Navigation
struct OptimizedNavigationLink<Destination: View, Label: View>: View {
    let destination: Destination
    let label: Label
    @State private var isActive = false
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        Button(action: {
            isActive = true
        }) {
            label
        }
        .background(
            NavigationLink(
                value: isActive,
                label: { EmptyView() }
            )
            .navigationDestination(isPresented: $isActive) {
                destination
            }
        )
    }
}

// MARK: - Debounced Text Field
struct DebouncedTextField: View {
    let placeholder: String
    @Binding var text: String
    let onCommit: (String) -> Void
    
    @State private var debouncedText: String = ""
    @State private var debounceTimer: Timer?
    
    init(placeholder: String, text: Binding<String>, onCommit: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self._text = text
        self.onCommit = onCommit
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { _, newValue in
                debounceTimer?.invalidate()
                debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    debouncedText = newValue
                    onCommit(newValue)
                }
            }
    }
}

// MARK: - Optimized Scroll View
struct OptimizedScrollView<Content: View>: View {
    let content: Content
    let showsIndicators: Bool
    let onScroll: ((CGPoint) -> Void)?
    
    @State private var scrollOffset: CGPoint = .zero
    
    init(showsIndicators: Bool = true, onScroll: ((CGPoint) -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.showsIndicators = showsIndicators
        self.onScroll = onScroll
    }
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            content
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    }
                )
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
            onScroll?(value)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

// MARK: - View Modifiers for Performance
struct OptimizedViewModifier: ViewModifier {
    let shouldOptimize: Bool
    
    func body(content: Content) -> some View {
        if shouldOptimize {
            content
                .drawingGroup() // Renders to a bitmap for better performance
                .allowsHitTesting(true)
        } else {
            content
        }
    }
}

extension View {
    func optimized(_ shouldOptimize: Bool = true) -> some View {
        modifier(OptimizedViewModifier(shouldOptimize: shouldOptimize))
    }
    
    func conditionalAnimation<Value: Equatable>(_ animation: Animation?, value: Value) -> some View {
        self.animation(animation, value: value)
    }
} 