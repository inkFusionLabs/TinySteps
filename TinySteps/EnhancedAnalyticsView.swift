//
//  EnhancedAnalyticsView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct EnhancedAnalyticsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Binding var selectedTab: ContentView.NavigationTab
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedMetric: AnalyticsMetric = .feeding
    @State private var animateCharts = false
    @State private var showInsights = false
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case quarter = "Quarter"
        case year = "Year"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .quarter: return 90
            case .year: return 365
            }
        }
    }
    
    enum AnalyticsMetric: String, CaseIterable {
        case feeding = "Feeding"
        case sleep = "Sleep"
        case nappy = "Nappy"
        case growth = "Growth"
        case milestones = "Milestones"
        
        var icon: String {
            switch self {
            case .feeding: return "drop.fill"
            case .sleep: return "bed.double.fill"
            case .nappy: return "drop"
            case .growth: return "chart.line.uptrend.xyaxis"
            case .milestones: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .feeding: return TinyStepsDesign.Colors.accent
            case .sleep: return TinyStepsDesign.Colors.highlight
            case .nappy: return TinyStepsDesign.Colors.success
            case .growth: return TinyStepsDesign.Colors.info
            case .milestones: return TinyStepsDesign.Colors.warning
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("Dad's Analytics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Track patterns and celebrate progress")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Check if baby data exists
                        if dataManager.baby == nil {
                            VStack(spacing: 20) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("No Baby Data")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("Add your baby's information to see analytics")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            // Time Range Picker
                            timeRangePicker
                            
                            // Metric Selector
                            metricSelector
                            
                            // Analytics Content
                            analyticsContent
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackScreen("Analytics", screenClass: "EnhancedAnalyticsView")
            withAnimation(.easeInOut(duration: 0.5)) {
                animateCharts = true
            }
        }
    }
    
    // MARK: - Time Range Picker
    private var timeRangePicker: some View {
        HStack {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTimeRange = range
                    }
                }) {
                    Text(range.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTimeRange == range ? .white : .white.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedTimeRange == range ? Color.blue.opacity(0.3) : Color.clear)

                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Metric Selector
    private var metricSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(AnalyticsMetric.allCases, id: \.self) { metric in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedMetric = metric
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: metric.icon)
                                .font(.title2)
                                .foregroundColor(selectedMetric == metric ? .white : .white.opacity(0.6))
                            
                            Text(metric.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(selectedMetric == metric ? .white : .white.opacity(0.6))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedMetric == metric ? metric.color.opacity(0.3) : Color.clear)

                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Analytics Content
    private var analyticsContent: some View {
        VStack(spacing: 20) {
            // Summary Cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                AnalyticsSummaryCard(
                    title: "Total Feeds",
                    value: "\(dataManager.getTodayFeedingCount())",
                    icon: "drop.fill",
                    color: .blue
                )
                
                AnalyticsSummaryCard(
                    title: "Sleep Hours",
                    value: String(format: "%.1f", dataManager.getTodaySleepHours()),
                    icon: "bed.double.fill",
                    color: .purple
                )
                
                AnalyticsSummaryCard(
                    title: "Nappy Changes",
                    value: "\(dataManager.getTodayNappyCount())",
                    icon: "drop",
                    color: .green
                )
                
                AnalyticsSummaryCard(
                    title: "Days Tracked",
                    value: "7",
                    icon: "calendar",
                    color: .orange
                )
            }
            
            // Chart Section
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("Analytics Chart")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Chart data will appear here")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
                    .padding(.horizontal, 20)
            }
            
            // Insights Section
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    Text("Insights")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 10) {
                    InsightCard(
                        title: "Feeding Pattern",
                        description: "Your baby is feeding well with consistent intervals",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    InsightCard(
                        title: "Sleep Quality",
                        description: "Sleep duration is within healthy range",
                        icon: "moon.fill",
                        color: .blue
                    )
                    
                    InsightCard(
                        title: "Growth Tracking",
                        description: "Continue monitoring weight and height",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .orange
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Supporting Components

struct AnalyticsSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.2))
        )
    }
}

struct InsightCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
        )
    }
}

#Preview {
    EnhancedAnalyticsView(selectedTab: .constant(ContentView.NavigationTab.home))
        .environmentObject(BabyDataManager())
} 