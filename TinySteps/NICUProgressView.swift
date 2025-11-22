//
//  NICUProgressView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

struct NICUProgressView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    
    @Namespace private var progressNamespace
    @State private var hasAppeared = false
    @State private var sparklineAnimate = false
    @State private var selectedDate = Date()
    @State private var showAddProgress = false
    @State private var editingEntry: ProgressEntry?
    @State private var entryPendingDeletion: ProgressEntry?
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var sortedEntries: [ProgressEntry] {
        dataPersistence.progressEntries.sorted { $0.date > $1.date }
    }
    
    private var entriesForSelectedDate: [ProgressEntry] {
        sortedEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var latestEntry: ProgressEntry? {
        sortedEntries.first
    }
    
    private var recentEntries: [ProgressEntry] {
        Array(sortedEntries.prefix(5))
    }
    
    private var recentWeightSamples: [Double] {
        recentEntries.compactMap { $0.weight }
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background.opacity(0.4)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: isIPad ? 36 : 24) {
                    header
                    summarySection
                    datePickerSection
                    entriesSection
                    recentSection
                    supportCallout
                }
                .padding(.horizontal, isIPad ? 32 : 20)
                .padding(.vertical, isIPad ? 40 : 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.85)) {
                    sparklineAnimate = true
                }
            }
        }
        .sheet(isPresented: $showAddProgress) {
            ProgressEntryFormView(
                entry: nil,
                theme: themeManager.currentTheme.colors
            ) { newEntry in
                dataPersistence.addProgressEntry(newEntry)
            }
            .environmentObject(dataPersistence)
        }
        .sheet(item: $editingEntry) { entry in
            ProgressEntryFormView(
                entry: entry,
                theme: themeManager.currentTheme.colors
            ) { updated in
                dataPersistence.updateProgressEntry(updated)
            }
            .environmentObject(dataPersistence)
        }
        .alert("Delete progress entry?", isPresented: Binding<Bool>(
            get: { entryPendingDeletion != nil },
            set: { if !$0 { entryPendingDeletion = nil } }
        )) {
            Button("Cancel", role: .cancel) {
                entryPendingDeletion = nil
            }
            Button("Delete", role: .destructive) {
                if let entry = entryPendingDeletion {
                    dataPersistence.deleteProgressEntry(entry)
                }
                entryPendingDeletion = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var header: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Progress")
                    .font(isIPad ? .system(size: 40, weight: .bold) : .largeTitle.weight(.bold))
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                Text("Log vitals, support needs, and milestones each day.")
                    .font(isIPad ? .title3 : .subheadline)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
            }
            Spacer()
            Button {
                showAddProgress = true
            } label: {
                Label("Add entry", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .font(.system(size: isIPad ? 44 : 32, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.colors.accent)
            }
            .accessibilityLabel("Add progress entry")
        }
        .padding(.top, isIPad ? 10 : 0)
        .parallaxed(isIPad ? 6 : 4)
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 20)
        .animation(.spring(response: 0.9, dampingFraction: 0.85), value: hasAppeared)
    }
    
    private var summarySection: some View {
        Group {
            if let latest = latestEntry {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Latest entry")
                            .font(isIPad ? .title2.weight(.semibold) : .headline.weight(.semibold))
                            .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                        Spacer()
                        Text(formattedRelativeDate(latest.date))
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    }
                    
                    summaryCardGrid(for: latest)
                    
                    Divider()
                        .background(themeManager.currentTheme.colors.border)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label(latest.breathingSupport, systemImage: "lungs.fill")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                            Spacer()
                            Label(latest.feedingMethod, systemImage: "drop.fill")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                        }
                        
                        if !latest.milestones.isEmpty {
                            Text("Milestones: \(latest.milestones.joined(separator: ", "))")
                                .font(.footnote)
                                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                        }
                        
                        if !latest.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(latest.notes)
                                .font(.footnote)
                                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    if recentWeightSamples.count >= 3 {
                        WeightTrendCard(
                            data: recentWeightSamples,
                            theme: themeManager.currentTheme.colors,
                            animate: sparklineAnimate
                        )
                        .padding(.top, 4)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(isIPad ? 28 : 20)
                .animatedCard(depth: .medium, cornerRadius: isIPad ? 28 : 22)
                .matchedGeometryEffect(id: "summaryCard", in: progressNamespace)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 24)
                .animation(.spring(response: 1.1, dampingFraction: 0.85).delay(0.1), value: hasAppeared)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("No entries yet")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                    Text("Start by logging today's weight, breathing support, and any milestones.")
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .animatedCard(depth: .medium, cornerRadius: 20)
                .shimmering(highlightColor: themeManager.currentTheme.colors.accent)
            }
        }
    }
    
    private var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter by date")
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            
            DatePicker(
                "Select date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.graphical)
            .environment(\.colorScheme, .dark)
            .tint(themeManager.currentTheme.colors.accent)
            .padding()
            .animatedCard(depth: .medium, cornerRadius: 24)
            .parallaxed(isIPad ? 5 : 3)
        }
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 24)
        .animation(.spring(response: 1.0, dampingFraction: 0.9).delay(0.15), value: hasAppeared)
    }
    
    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Entries for \(formattedDay(selectedDate))")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                Spacer()
                if !entriesForSelectedDate.isEmpty {
                    Text("\(entriesForSelectedDate.count) item(s)")
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
            }
            
            if entriesForSelectedDate.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("No data recorded")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                    Text("Tap the add button to create your first entry for this day.")
                        .font(.footnote)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(themeManager.currentTheme.colors.backgroundSecondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                        )
                )
            } else {
                VStack(spacing: 16) {
                    ForEach(entriesForSelectedDate) { entry in
                        ProgressEntryCard(
                            entry: entry,
                            theme: themeManager.currentTheme.colors,
                            onEdit: { editingEntry = $0 },
                            onDelete: { entryPendingDeletion = $0 }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.9, dampingFraction: 0.9), value: entriesForSelectedDate.count)
            }
        }
    }
    
    private var recentSection: some View {
        Group {
            if recentEntries.count > 1 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent highlights")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(recentEntries) { entry in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(formattedDay(entry.date))
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                                    if let weight = entry.weight {
                                        Text("Weight: \(String(format: "%.2f kg", weight))")
                                            .font(.footnote)
                                            .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                                    }
                                    Text("Breathing: \(entry.breathingSupport)")
                                        .font(.footnote)
                                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                                }
                                .padding()
                                .animatedCard(depth: .low, cornerRadius: 18)
                                .parallaxed(4)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var supportCallout: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "lifepreserver")
                    .font(.title3)
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                    .shimmering(speed: 2.2, highlightColor: themeManager.currentTheme.colors.accent)
                Text("Need a hand?")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            }
            Text("Use the Ask Questions manager on the Home tab to capture anything you want to discuss with the NICU team.")
                .font(.footnote)
                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .animatedCard(depth: .low, cornerRadius: 22)
        .parallaxed(3)
    }
    
    private struct WeightTrendCard: View {
        let data: [Double]
        let theme: ThemeColors
        let animate: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Weight trend", systemImage: "waveform.path.ecg")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(theme.textPrimary)
                    Spacer()
                    Text("Last \(data.count) entries")
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }
                
                AnimatedSparkline(data: data, colors: [theme.accent, theme.secondary], animate: animate)
                    .frame(height: 72)
                
                if let delta = weightDelta {
                    Text(delta)
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }
            }
            .padding(16)
            .animatedCard(depth: .low, cornerRadius: 20)
        }
        
        private var weightDelta: String? {
            guard let first = data.first, let last = data.last else { return nil }
            let diff = last - first
            guard diff != 0 else { return nil }
            let formatted = String(format: "%.2f kg", abs(diff))
            return diff > 0 ? "↑ \(formatted) gained" : "↓ \(formatted) lost"
        }
    }
    
    private struct AnimatedSparkline: View {
        let data: [Double]
        let colors: [Color]
        var animate: Bool
        @State private var progress: CGFloat = 0
        
        var body: some View {
            GeometryReader { proxy in
                let path = sparklinePath(in: proxy.size)
                path
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: colors),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: colors.last?.opacity(0.25) ?? .clear, radius: 6, x: 0, y: 4)
                    .onAppear {
                        progress = animate ? 1 : 0
                        if animate {
                            withAnimation(.easeOut(duration: 1.2)) {
                                progress = 1
                            }
                        }
                    }
                    .onChange(of: animate) { _, newValue in
                        if newValue {
                            progress = 0
                            withAnimation(.easeOut(duration: 1.0)) {
                                progress = 1
                            }
                        }
                    }
            }
        }
        
        private func sparklinePath(in size: CGSize) -> Path {
            var path = Path()
            guard let min = data.min(), let maxValue = data.max(), maxValue - min > 0 else {
                let midY = size.height / 2
                path.move(to: .init(x: 0, y: midY))
                path.addLine(to: .init(x: size.width, y: midY))
                return path
            }
            
            let points = data.enumerated().map { index, value -> CGPoint in
                let x = size.width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                let normalized = (value - min) / (maxValue - min)
                let y = size.height - (CGFloat(normalized) * size.height)
                return CGPoint(x: x, y: y)
            }
            
            guard let first = points.first else { return path }
            path.move(to: first)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            return path
        }
    }
    
    private func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func summaryCardGrid(for entry: ProgressEntry) -> some View {
        let cards = summaryCards(for: entry)
        let columns = isIPad
            ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            : [GridItem(.flexible()), GridItem(.flexible())]
        
        return LazyVGrid(columns: columns, spacing: isIPad ? 24 : 16) {
            ForEach(cards) { card in
                ProgressSummaryCard(
                    model: card,
                    theme: themeManager.currentTheme.colors,
                    isIPad: isIPad
                )
            }
        }
    }
    
    private func summaryCards(for entry: ProgressEntry) -> [ProgressSummaryCardModel] {
        var cards: [ProgressSummaryCardModel] = []
        if let weight = entry.weight {
            cards.append(
                ProgressSummaryCardModel(
                    title: "Weight",
                    value: String(format: "%.2f kg", weight),
                    icon: "scalemass.fill",
                    color: themeManager.currentTheme.colors.success
                )
            )
        }
        cards.append(
            ProgressSummaryCardModel(
                title: "Breathing",
                value: entry.breathingSupport,
                icon: "lungs.fill",
                color: themeManager.currentTheme.colors.info
            )
        )
        cards.append(
            ProgressSummaryCardModel(
                title: "Feeding",
                value: entry.feedingMethod,
                icon: "drop.fill",
                color: themeManager.currentTheme.colors.accent
            )
        )
        if let heartRate = entry.heartRate {
            cards.append(
                ProgressSummaryCardModel(
                    title: "Heart Rate",
                    value: "\(heartRate) bpm",
                    icon: "heart.fill",
                    color: themeManager.currentTheme.colors.success
                )
            )
        }
        if let temperature = entry.temperature {
            cards.append(
                ProgressSummaryCardModel(
                    title: "Temperature",
                    value: String(format: "%.1f °C", temperature),
                    icon: "thermometer",
                    color: themeManager.currentTheme.colors.warning
                )
            )
        }
        return cards
    }
}

struct ProgressEntryCard: View {
    let entry: ProgressEntry
    let theme: ThemeColors
    let onEdit: (ProgressEntry) -> Void
    let onDelete: (ProgressEntry) -> Void
    
    private var milestonesText: String? {
        guard !entry.milestones.isEmpty else { return nil }
        return entry.milestones.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.date, style: .time)
                        .font(.headline)
                        .foregroundColor(theme.textPrimary)
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
                Menu {
                    Button {
                        onEdit(entry)
                    } label: {
                        Label("Edit entry", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        onDelete(entry)
                    } label: {
                        Label("Delete entry", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(theme.textSecondary)
                }
            }
            
            Divider()
                .background(theme.border)
            
            HStack(spacing: 12) {
                if let weight = entry.weight {
                    ProgressMetricChip(
                        title: "Weight",
                        value: String(format: "%.2f kg", weight),
                        icon: "scalemass.fill",
                        theme: theme
                    )
                }
                
                if let heartRate = entry.heartRate {
                    ProgressMetricChip(
                        title: "Heart rate",
                        value: "\(heartRate) bpm",
                        icon: "heart.fill",
                        theme: theme
                    )
                }
                
                if let temperature = entry.temperature {
                    ProgressMetricChip(
                        title: "Temp",
                        value: String(format: "%.1f °C", temperature),
                        icon: "thermometer",
                        theme: theme
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Label(entry.breathingSupport, systemImage: "lungs.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(theme.textPrimary)
                Label(entry.feedingMethod, systemImage: "drop.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(theme.textPrimary)
            }
            
            if let milestones = milestonesText {
                Text("Milestones: \(milestones)")
                    .font(.footnote)
                    .foregroundColor(theme.textSecondary)
            }
            
            if !entry.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(entry.notes)
                    .font(.footnote)
                    .foregroundColor(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animatedCard(depth: .medium, cornerRadius: 22)
        .parallaxed(4)
    }
}

struct ProgressMetricChip: View {
    let title: String
    let value: String
    let icon: String
    let theme: ThemeColors
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(theme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(theme.textPrimary)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(theme.textSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(theme.backgroundTertiary.opacity(0.6))
        )
    }
}

struct ProgressSummaryCardModel: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let color: Color
}

struct ProgressSummaryCard: View {
    let model: ProgressSummaryCardModel
    let theme: ThemeColors
    let isIPad: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            Image(systemName: model.icon)
                .font(.system(size: isIPad ? 28 : 22, weight: .semibold))
                .foregroundColor(model.color)
                .padding(10)
                .background(
                    Circle()
                        .fill(model.color.opacity(0.18))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(model.title.uppercased())
                    .font(.system(size: isIPad ? 12 : 11, weight: .semibold))
                    .foregroundColor(theme.textSecondary)
                Text(model.value)
                    .font(.system(size: isIPad ? 24 : 20, weight: .bold))
                    .foregroundColor(theme.textPrimary)
            }
        }
        .padding(isIPad ? 24 : 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animatedCard(depth: .medium, cornerRadius: isIPad ? 24 : 18)
        .shadow(color: model.color.opacity(0.12), radius: 6, x: 0, y: 4)
    }
}

struct ProgressEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataPersistence: DataPersistenceManager
    
    let entry: ProgressEntry?
    let theme: ThemeColors
    let onSave: (ProgressEntry) -> Void
    
    @State private var entryID: UUID = UUID()
    @State private var date: Date = Date()
    @State private var weightText: String = ""
    @State private var breathingSupport: String = "Room Air"
    @State private var feedingMethod: String = "Tube"
    @State private var temperatureText: String = ""
    @State private var heartRateText: String = ""
    @State private var milestonesText: String = ""
    @State private var notes: String = ""
    
    private let breathingOptions = ["Room Air", "Low Flow Oxygen", "High Flow Oxygen", "CPAP", "Ventilator"]
    private let feedingOptions = ["Breastfeeding", "Bottle", "Tube", "Tube + Bottle", "Parenteral"]
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        header
                        
                        formSection
                        
                        Button {
                            saveEntry()
                        } label: {
                            Label("Save Progress Entry", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(theme.primary)
                                .cornerRadius(18)
                        }
                        .padding(.horizontal, isPad ? 48 : 32)
                        .padding(.bottom, 16)
                        .disabled(isSaveDisabled)
                        .opacity(isSaveDisabled ? 0.5 : 1)
                    }
                    .padding(.horizontal, isPad ? 48 : 24)
                    .padding(.top, isPad ? 36 : 24)
                    .padding(.bottom, isPad ? 24 : 16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: isPad ? 28 : 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(entry == nil ? "New Progress Entry" : "Edit Progress Entry")
                        .font(isPad ? .title2.weight(.bold) : .headline.weight(.bold))
                        .foregroundColor(.white)
                }
            }
        }
        .tint(theme.accent)
        .onAppear(perform: configureDefaults)
    }
    
    private var isSaveDisabled: Bool {
        weightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        heartRateText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        temperatureText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        milestonesText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: isPad ? 48 : 40))
                .foregroundColor(.white)
            Text("Track Baby's Daily Progress")
                .font(isPad ? .title.weight(.bold) : .title2.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("Log vitals, respiratory support, feeding milestones, and notes to keep the care team in sync.")
                .font(isPad ? .title3 : .subheadline)
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, isPad ? 32 : 16)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            formCard(title: "Date & Vitals", icon: "calendar.badge.plus", color: theme.accent) {
                DatePicker(
                    "Entry date",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding(.vertical, 4)
                
                FloatingTextField(
                    title: "Weight (kg)",
                    text: $weightText,
                    keyboard: .decimalPad,
                    theme: theme
                )
                
                FloatingTextField(
                    title: "Heart rate (bpm)",
                    text: $heartRateText,
                    keyboard: .numberPad,
                    theme: theme
                )
                
                FloatingTextField(
                    title: "Temperature (°C)",
                    text: $temperatureText,
                    keyboard: .decimalPad,
                    theme: theme
                )
            }
            
            formCard(title: "Support Summary", icon: "lungs.fill", color: theme.info) {
                menuRow(
                    title: "Breathing support",
                    value: breathingSupport,
                    icon: "wind",
                    action: {}
                )
                .contextMenu {
                    ForEach(breathingOptions, id: \.self) { option in
                        Button(option) { breathingSupport = option }
                    }
                }
                .onTapGesture {
                    showOptions(title: "Breathing Support", options: breathingOptions, selection: $breathingSupport)
                }
                
                menuRow(
                    title: "Feeding method",
                    value: feedingMethod,
                    icon: "drop.fill",
                    action: {}
                )
                .contextMenu {
                    ForEach(feedingOptions, id: \.self) { option in
                        Button(option) { feedingMethod = option }
                    }
                }
                .onTapGesture {
                    showOptions(title: "Feeding Method", options: feedingOptions, selection: $feedingMethod)
                }
            }
            
            formCard(title: "Notes & Milestones", icon: "note.text", color: theme.secondary) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Daily notes")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(theme.textSecondary)
                    TextEditor(text: $notes)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: isPad ? 160 : 120, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.backgroundSecondary.opacity(0.85))
                        )
                }
                
                FloatingTextField(
                    title: "Milestones (comma separated)",
                    text: $milestonesText,
                    keyboard: .default,
                    theme: theme
                )
            }
        }
    }
    
    private func formCard<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: isPad ? 26 : 22, weight: .semibold))
                    .foregroundColor(color)
                Text(title)
                    .font(isPad ? .title3.weight(.semibold) : .headline.weight(.semibold))
                    .foregroundColor(theme.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 14, content: content)
        }
        .padding(isPad ? 24 : 18)
        .background(
            RoundedRectangle(cornerRadius: isPad ? 26 : 20)
                .fill(theme.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: isPad ? 26 : 20)
                        .stroke(theme.border, lineWidth: 1)
                )
        )
    }
    
    private func menuRow(title: String, value: String, icon: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(theme.backgroundTertiary.opacity(0.8))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(theme.accent)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(theme.textPrimary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(theme.textSecondary)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
    
    private func showOptions(title: String, options: [String], selection: Binding<String>) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else { return }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        options.forEach { option in
            alert.addAction(UIAlertAction(title: option, style: .default) { _ in
                selection.wrappedValue = option
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func configureDefaults() {
        if let entry {
            entryID = entry.id
            date = entry.date
            if let weight = entry.weight {
                weightText = String(format: "%.2f", weight)
            }
            if let heartRate = entry.heartRate {
                heartRateText = "\(heartRate)"
            }
            if let temperature = entry.temperature {
                temperatureText = String(format: "%.1f", temperature)
            }
            breathingSupport = entry.breathingSupport
            feedingMethod = entry.feedingMethod
            notes = entry.notes
            milestonesText = entry.milestones.joined(separator: ", ")
        }
    }
    
    private func saveEntry() {
        var newEntry = ProgressEntry(
            date: date,
            weight: Double(weightText.replacingOccurrences(of: ",", with: ".")),
            breathingSupport: breathingSupport,
            feedingMethod: feedingMethod,
            temperature: Double(temperatureText.replacingOccurrences(of: ",", with: ".")),
            heartRate: Int(heartRateText),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            milestones: milestonesText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
        newEntry.id = entryID
        onSave(newEntry)
        dismiss()
    }
}

struct FloatingTextField: View {
    let title: String
    @Binding var text: String
    let keyboard: UIKeyboardType
    let theme: ThemeColors
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(theme.textSecondary.opacity(isFocused || !text.isEmpty ? 1.0 : 0.6))
                .padding(.horizontal, 4)
            
            TextField("", text: $text)
                .keyboardType(keyboard)
                .focused($isFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(theme.backgroundTertiary.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isFocused ? theme.accent : theme.border, lineWidth: 1)
                )
                .foregroundColor(theme.textPrimary)
        }
    }
}

#Preview {
    NICUProgressView()
        .environmentObject(ThemeManager.shared)
        .environmentObject(DataPersistenceManager.shared)
}
