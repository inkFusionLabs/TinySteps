//
//  NICUJournalView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI
import UIKit

struct NICUJournalView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    @State private var selectedTab = JournalTab.entries
    @State private var showNewEntry = false
    @State private var showNewMemory = false
    
    enum JournalTab: String, CaseIterable {
        case entries = "Entries"
        case prompts = "Prompts"
        case memories = "Memories"
        
        var icon: String {
            switch self {
            case .entries: return "book.fill"
            case .prompts: return "lightbulb.fill"
            case .memories: return "heart.fill"
            }
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dad's Journal")
                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Your NICU journey, one entry at a time")
                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .headline : .subheadline)
                                .themedText(style: .secondary)
                        }
                        Spacer()
                        
                        Button(action: {
                            if selectedTab == .memories {
                                showNewMemory = true
                            } else {
                                showNewEntry = true
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(themeManager.currentTheme.colors.accent)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Tab Picker
                    HStack(spacing: 0) {
                        ForEach(JournalTab.allCases, id: \.self) { tab in
                            Button(action: { selectedTab = tab }) {
                                VStack(spacing: 4) {
                                    Image(systemName: tab.icon)
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3)
                                    
                                    Text(tab.rawValue)
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .subheadline : .caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(selectedTab == tab ? themeManager.currentTheme.colors.accent : themeManager.currentTheme.colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.currentTheme.colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                                    .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                }
                
                // Content
                Group {
                    if selectedTab == .entries {
                        EntriesListView()
                    } else if selectedTab == .memories {
                        MemoriesListView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                switch selectedTab {
                                case .prompts:
                                    ForEach(JournalPrompt.allPrompts, id: \.id) { prompt in
                                        JournalPromptCard(prompt: prompt)
                                            .padding(.horizontal)
                                    }
                                default:
                                    EmptyView()
                                }
                                
                                // UK Support Resources
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Need Support?")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .themedText(style: .primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "flag.fill")
                                            .font(.title3)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        UKSupportRow(
                                            name: "Bliss Charity",
                                            number: "0808 801 0322",
                                            description: "Premature baby support",
                                            icon: "heart.fill",
                                            color: .pink
                                        )
                                        
                                        UKSupportRow(
                                            name: "NHS 111",
                                            number: "111",
                                            description: "Non-emergency health advice",
                                            icon: "cross.case.fill",
                                            color: .blue
                                        )
                                        
                                        UKSupportRow(
                                            name: "Samaritans",
                                            number: "116 123",
                                            description: "24/7 emotional support",
                                            icon: "phone.fill",
                                            color: .green
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, selectedTab == .prompts ? 20 : 0)
                                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 100) // Space for tab bar
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showNewEntry) {
            NewJournalEntryView()
        }
        .sheet(isPresented: $showNewMemory) {
            NewMemoryEntryView()
        }
    }
}

// MARK: - Swipeable Card Wrapper
struct SwipeableCard<Content: View>: View {
    let content: Content
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var isSwiped: Bool = false
    
    private let swipeThreshold: CGFloat = 80
    private let buttonWidth: CGFloat = 80
    
    init(@ViewBuilder content: () -> Content, onEdit: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons (behind content)
            HStack(spacing: 0) {
                // Edit button
                Button(action: {
                    withAnimation(.spring()) {
                        dragOffset = 0
                        isSwiped = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onEdit()
                    }
                }) {
                    ZStack {
                        Color.blue
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .frame(width: buttonWidth)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .allowsHitTesting(true) // Always allow button touches
                
                // Delete button
                Button(action: {
                    withAnimation(.spring()) {
                        dragOffset = 0
                        isSwiped = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onDelete()
                    }
                }) {
                    ZStack {
                        Color.red
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .frame(width: buttonWidth)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .allowsHitTesting(true) // Always allow button touches
            }
            .frame(maxHeight: .infinity)
            .zIndex(isSwiped ? 2 : 0) // Bring buttons to front when swiped
            
            // Content card (on top)
            content
                .offset(x: dragOffset)
                .zIndex(1) // Content is always on top (but offset reveals buttons)
                .allowsHitTesting(!isSwiped) // Disable content touches when swiped so buttons can be tapped
                .background(
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isSwiped {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
            
            // Gesture view covering entire card - must be in ZStack, not overlay
            SwipeGestureView(
                dragOffset: $dragOffset,
                isSwiped: $isSwiped,
                swipeThreshold: swipeThreshold,
                buttonWidth: buttonWidth
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(!isSwiped) // Disable gesture view when swiped so buttons can be tapped
            .zIndex(isSwiped ? 0 : 3) // Behind buttons when swiped, on top when not
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}

// MARK: - UIKit Gesture Handler
struct SwipeGestureView: UIViewRepresentable {
    @Binding var dragOffset: CGFloat
    @Binding var isSwiped: Bool
    let swipeThreshold: CGFloat
    let buttonWidth: CGFloat
    
    func makeUIView(context: Context) -> SwipeGestureContainerView {
        let view = SwipeGestureContainerView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.isOpaque = false
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.delegate = context.coordinator
        panGesture.maximumNumberOfTouches = 1
        panGesture.cancelsTouchesInView = false // Don't cancel touches, allow simultaneous recognition
        view.addGestureRecognizer(panGesture)
        
        context.coordinator.view = view
        context.coordinator.panGesture = panGesture
        return view
    }
    
    func updateUIView(_ uiView: SwipeGestureContainerView, context: Context) {
        // Ensure the view is enabled and ready based on swipe state
        uiView.isUserInteractionEnabled = !isSwiped
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class SwipeGestureContainerView: UIView {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            // Always return self if point is inside and view is enabled
            if bounds.contains(point) && isUserInteractionEnabled && !isHidden && alpha > 0 {
                return self
            }
            return nil
        }
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            // Always accept points within bounds
            return bounds.contains(point)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Ensure we fill the entire available space
            if let superview = superview {
                let newFrame = superview.bounds
                if frame != newFrame {
                    frame = newFrame
                }
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let parent: SwipeGestureView
        var view: SwipeGestureContainerView?
        var panGesture: UIPanGestureRecognizer?
        private var initialTranslation: CGFloat = 0
        private var isHorizontalDrag: Bool = false
        
        init(_ parent: SwipeGestureView) {
            self.parent = parent
        }
        
        // Allow simultaneous recognition with ScrollView
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allow simultaneous recognition so ScrollView can scroll vertically
            return true
        }
        
        // Always allow the gesture to begin - we'll filter in the handler
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            // Always return true - we'll determine if it's horizontal in handlePan
            return true
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let gestureView = gesture.view else { return }
            
            let translation = gesture.translation(in: gestureView)
            let velocity = gesture.velocity(in: gestureView)
            let horizontalMovement = abs(translation.x)
            let verticalMovement = abs(translation.y)
            
            switch gesture.state {
            case .began:
                initialTranslation = parent.dragOffset
                // Determine if this is a horizontal drag - be more lenient
                isHorizontalDrag = horizontalMovement > 5 && horizontalMovement > verticalMovement * 1.1
                
                // If it's clearly vertical, don't process
                if !isHorizontalDrag && verticalMovement > horizontalMovement * 1.5 {
                    isHorizontalDrag = false
                    return
                }
                
            case .changed:
                // Only process if it's a horizontal drag or already swiped
                if isHorizontalDrag || parent.isSwiped {
                    let newOffset = initialTranslation + translation.x
                    if newOffset < 0 {
                        parent.dragOffset = max(newOffset, -parent.buttonWidth * 2)
                    } else if parent.isSwiped {
                        parent.dragOffset = min(newOffset, 0)
                    }
                }
                
            case .ended, .cancelled:
                if isHorizontalDrag || parent.isSwiped {
                    let finalOffset = initialTranslation + translation.x
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        if finalOffset < -parent.swipeThreshold || (finalOffset < 0 && velocity.x < -500) {
                            parent.dragOffset = -parent.buttonWidth * 2
                            parent.isSwiped = true
                        } else if finalOffset > parent.swipeThreshold && parent.isSwiped || (finalOffset > 0 && velocity.x > 500 && parent.isSwiped) {
                            parent.dragOffset = 0
                            parent.isSwiped = false
                        } else {
                            // Snap back
                            parent.dragOffset = parent.isSwiped ? -parent.buttonWidth * 2 : 0
                        }
                    }
                } else {
                    // Reset if it wasn't a horizontal drag
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                        parent.dragOffset = parent.isSwiped ? -parent.buttonWidth * 2 : 0
                    }
                }
                isHorizontalDrag = false
                
            default:
                break
            }
        }
    }
}

// MARK: - Memories List View with selection and tap-to-edit
struct MemoriesListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    @State private var editingMemory: MemoryItem?
    @State private var selectedMemories: Set<UUID> = []
    @State private var isSelectionMode: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Selection toolbar
            if isSelectionMode {
                HStack {
                    Button(action: {
                        selectedMemories.removeAll()
                        isSelectionMode = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(themeManager.currentTheme.colors.accent)
                    }
                    
                    Spacer()
                    
                    Text("\(selectedMemories.count) selected")
                        .font(.headline)
                        .themedText(style: .primary)
                    
                    Spacer()
                    
                    Button(action: {
                        deleteSelectedMemories()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    .disabled(selectedMemories.isEmpty)
                }
                .padding()
                .background(themeManager.currentTheme.colors.backgroundSecondary)
            } else if !dataManager.memoryItems.isEmpty {
                // Select button (only show when not in selection mode and there are items)
                HStack {
                    Spacer()
                    Button(action: {
                        isSelectionMode = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle")
                            Text("Select")
                        }
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.colors.accent)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(themeManager.currentTheme.colors.accent.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    if dataManager.memoryItems.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 48))
                                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                            Text("No memories yet")
                                .font(.headline)
                                .themedText(style: .secondary)
                            Text("Tap the + button to create your first memory")
                                .font(.subheadline)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .padding(.horizontal)
                    } else {
                        ForEach(dataManager.memoryItems.sorted(by: { $0.date > $1.date }), id: \.id) { memory in
                            SelectableMemoryCard(
                                memory: memory,
                                isSelected: selectedMemories.contains(memory.id),
                                isSelectionMode: isSelectionMode,
                                onTap: {
                                    if isSelectionMode {
                                        toggleSelection(memory.id)
                                    } else {
                                        editingMemory = memory
                                    }
                                },
                                onLongPress: {
                                    if !isSelectionMode {
                                        isSelectionMode = true
                                        selectedMemories.insert(memory.id)
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 100)
            }
        }
        .background(themeManager.currentTheme.colors.background)
        .onAppear {
            #if DEBUG
            print("💝 MemoriesListView appeared - Current memories count: \(dataManager.memoryItems.count)")
            print("   Memory items: \(dataManager.memoryItems.map { $0.title })")
            #endif
        }
        .refreshable {
            #if DEBUG
            print("🔄 Refreshing memories...")
            #endif
        }
        .sheet(item: $editingMemory) { memory in
            EditMemoryView(memory: memory)
        }
    }
    
    private func toggleSelection(_ id: UUID) {
        if selectedMemories.contains(id) {
            selectedMemories.remove(id)
            if selectedMemories.isEmpty {
                isSelectionMode = false
            }
        } else {
            selectedMemories.insert(id)
        }
    }
    
    private func deleteSelectedMemories() {
        let memoriesToDelete = dataManager.memoryItems.filter { selectedMemories.contains($0.id) }
        for memory in memoriesToDelete {
            dataManager.deleteMemoryItem(memory)
        }
        selectedMemories.removeAll()
        isSelectionMode = false
    }
}

// MARK: - Entries List View with selection and tap-to-edit
struct EntriesListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    @State private var editingEntry: JournalEntry?
    @State private var selectedEntries: Set<UUID> = []
    @State private var isSelectionMode: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Selection toolbar
            if isSelectionMode {
                HStack {
                    Button(action: {
                        selectedEntries.removeAll()
                        isSelectionMode = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(themeManager.currentTheme.colors.accent)
                    }
                    
                    Spacer()
                    
                    Text("\(selectedEntries.count) selected")
                        .font(.headline)
                        .themedText(style: .primary)
                    
                    Spacer()
                    
                    Button(action: {
                        deleteSelectedEntries()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    .disabled(selectedEntries.isEmpty)
                }
                .padding()
                .background(themeManager.currentTheme.colors.backgroundSecondary)
            } else if !dataManager.journalEntries.isEmpty {
                // Select button (only show when not in selection mode and there are items)
                HStack {
                    Spacer()
                    Button(action: {
                        isSelectionMode = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle")
                            Text("Select")
                        }
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.colors.accent)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(themeManager.currentTheme.colors.accent.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    if dataManager.journalEntries.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 48))
                                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                            Text("No entries yet")
                                .font(.headline)
                                .themedText(style: .secondary)
                            Text("Tap the + button to create your first journal entry")
                                .font(.subheadline)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .padding(.horizontal)
                    } else {
                        ForEach(dataManager.journalEntries.sorted(by: { $0.date > $1.date })) { entry in
                            SelectableJournalEntryCard(
                                entry: entry,
                                isSelected: selectedEntries.contains(entry.id),
                                isSelectionMode: isSelectionMode,
                                onTap: {
                                    if isSelectionMode {
                                        toggleSelection(entry.id)
                                    } else {
                                        editingEntry = entry
                                    }
                                },
                                onLongPress: {
                                    if !isSelectionMode {
                                        isSelectionMode = true
                                        selectedEntries.insert(entry.id)
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 100)
            }
        }
        .background(themeManager.currentTheme.colors.background)
        .onAppear {
            #if DEBUG
            print("📖 EntriesListView appeared - Current entries count: \(dataManager.journalEntries.count)")
            print("   Entry titles: \(dataManager.journalEntries.map { $0.title })")
            #endif
        }
        .refreshable {
            #if DEBUG
            print("🔄 Refreshing entries...")
            #endif
        }
        .sheet(item: $editingEntry) { entry in
            EditJournalEntryView(entry: entry)
        }
    }
    
    private func toggleSelection(_ id: UUID) {
        if selectedEntries.contains(id) {
            selectedEntries.remove(id)
            if selectedEntries.isEmpty {
                isSelectionMode = false
            }
        } else {
            selectedEntries.insert(id)
        }
    }
    
    private func deleteSelectedEntries() {
        let entriesToDelete = dataManager.journalEntries.filter { selectedEntries.contains($0.id) }
        for entry in entriesToDelete {
            dataManager.deleteJournalEntry(entry)
        }
        selectedEntries.removeAll()
        isSelectionMode = false
    }
}

// MARK: - Journal Entry Card
struct JournalEntryCard: View {
    let entry: JournalEntry
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(entry.date, style: .date)
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .subheadline : .caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
                
                Text(entry.mood.emoji)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title2)
            }
            
            
            Text(entry.content)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .body)
                .themedText(style: .secondary)
                .lineLimit(3)
            
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag.rawValue)
                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .subheadline : .caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(themeManager.currentTheme.colors.accent.opacity(0.2))
                                )
                                .foregroundColor(themeManager.currentTheme.colors.accent)
                        }
                    }
                }
            }
        }
        .padding()
        .themedCard()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Journal Prompt Card
struct JournalPromptCard: View {
    let prompt: JournalPrompt
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: prompt.icon)
                    .font(.title2)
                    .foregroundColor(prompt.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(prompt.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(prompt.category)
                        .font(.caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
            }
            
            Text(prompt.prompt)
                .font(.body)
                .themedText(style: .secondary)
                .lineSpacing(4)
            
            if !prompt.tips.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tips:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    ForEach(prompt.tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(prompt.color)
                            Text(tip)
                                .font(.body)
                                .themedText(style: .secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(prompt.color.opacity(0.1))
                )
            }
        }
        .padding()
        .themedCard()
    }
}

// MARK: - Memory Card
struct MemoryCard: View {
    let memory: MemoryItem
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: memory.icon)
                    .font(.title2)
                    .foregroundColor(memory.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(memory.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(memory.date, style: .date)
                        .font(.caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
            }
            
            
            Text(memory.description)
                .font(.body)
                .themedText(style: .secondary)
                .lineSpacing(4)
        }
        .padding()
        .themedCard()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Selectable Journal Entry Card
struct SelectableJournalEntryCard: View {
    let entry: JournalEntry
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox (only shown in selection mode)
            if isSelectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? themeManager.currentTheme.colors.accent : themeManager.currentTheme.colors.textSecondary)
            }
            
            // Entry card content
            JournalEntryCard(entry: entry)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap()
                }
                .onLongPressGesture {
                    onLongPress()
                }
        }
    }
}

// MARK: - Selectable Memory Card
struct SelectableMemoryCard: View {
    let memory: MemoryItem
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox (only shown in selection mode)
            if isSelectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? themeManager.currentTheme.colors.accent : themeManager.currentTheme.colors.textSecondary)
            }
            
            // Memory card content
            MemoryCard(memory: memory)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap()
                }
                .onLongPressGesture {
                    onLongPress()
                }
        }
    }
}

// MARK: - New Journal Entry View
struct NewJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood = JournalMood.neutral
    @State private var selectedTags: Set<JournalTag> = []
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 32 : 24) {
                        // Header
                        VStack(spacing: isIPad ? 16 : 12) {
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: isIPad ? 48 : 40))
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                            
                            Text("Capture Your Journey")
                                .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Record your thoughts, feelings, and precious moments")
                                .font(isIPad ? .system(size: 18) : .body)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? 24 : 16)
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        // Form Fields
                        VStack(spacing: isIPad ? 24 : 20) {
                            // Title Section
                            JournalFormField(
                                title: "Title",
                                icon: "textformat",
                                color: themeManager.currentTheme.colors.primary
                            ) {
                                TextField("What's on your mind today?", text: $title)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .overlay(
                                        // Custom placeholder with better contrast
                                        Group {
                                            if title.isEmpty {
                                                HStack {
                                                    Text("What's on your mind today?")
                                                        .font(isIPad ? .system(size: 18) : .body)
                                                        .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                                    Spacer()
                                                }
                                                .allowsHitTesting(false)
                                            }
                                        }
                                    )
                            }
                            
                            // Mood Section
                            JournalFormField(
                                title: "How are you feeling?",
                                icon: "heart.fill",
                                color: themeManager.currentTheme.colors.accent
                            ) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: isIPad ? 16 : 12) {
                                    ForEach(JournalMood.allCases, id: \.self) { mood in
                                        MoodSelectorButton(
                                            mood: mood,
                                            isSelected: selectedMood == mood,
                                            action: { selectedMood = mood }
                                        )
                                    }
                                }
                            }
                            
                            // Thoughts Section
                            JournalFormField(
                                title: "Your thoughts",
                                icon: "quote.bubble.fill",
                                color: themeManager.currentTheme.colors.info
                            ) {
                                TextField("Write about your day, your feelings, your hopes...", text: $content, axis: .vertical)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .lineLimit(5...10)
                                    .overlay(
                                        // Custom placeholder with better contrast
                                        Group {
                                            if content.isEmpty {
                                                VStack {
                                                    HStack {
                                                        Text("Write about your day, your feelings, your hopes...")
                                                            .font(isIPad ? .system(size: 18) : .body)
                                                            .foregroundColor(DesignSystem.Colors.textPlaceholder)
                                                        Spacer()
                                                    }
                                                    Spacer()
                                                }
                                                .allowsHitTesting(false)
                                            }
                                        }
                                    )
                            }
                            
                            // Tags Section
                            JournalFormField(
                                title: "Tags (optional)",
                                icon: "tag.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: isIPad ? 12 : 8) {
                                    ForEach(JournalTag.allCases, id: \.self) { tag in
                                        TagSelectorButton(
                                            tag: tag,
                                            isSelected: selectedTags.contains(tag),
                                            action: {
                                                if selectedTags.contains(tag) {
                                                    selectedTags.remove(tag)
                                                } else {
                                                    selectedTags.insert(tag)
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themedText(style: .primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveJournalEntry()
                    }
                    .themedText(style: .primary)
                    .fontWeight(.semibold)
                    .disabled(content.isEmpty)
                }
            }
        }
    }
    
    private func saveJournalEntry() {
        // Validate that we have content before saving
        guard !content.isEmpty else {
            #if DEBUG
            print("⚠️ Cannot save: content is empty")
            #endif
            return
        }
        
        let newEntry = JournalEntry(
            title: title.isEmpty ? "Untitled" : title,
            content: content,
            mood: selectedMood,
            tags: Array(selectedTags)
        )
        
        #if DEBUG
        print("💾 Saving journal entry: '\(newEntry.title)' with \(newEntry.content.count) characters")
        print("   Mood: \(newEntry.mood.rawValue), Tags: \(newEntry.tags.count)")
        #endif
        
        // Save the entry - this happens synchronously
        dataManager.addJournalEntry(newEntry)
        
        // Verify the entry was added
        let entryCount = dataManager.journalEntries.count
        #if DEBUG
        print("✅ Journal entry saved. Total entries: \(entryCount)")
        if let savedEntry = dataManager.journalEntries.first(where: { $0.id == newEntry.id }) {
            print("   Verified entry exists in array: '\(savedEntry.title)'")
        } else {
            print("   ⚠️ WARNING: Entry not found in array after save!")
        }
        #endif
        
        // Dismiss immediately after save
        dismiss()
    }
}

// MARK: - Edit Journal Entry View
struct EditJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    
    let entry: JournalEntry
    
    @State private var title: String
    @State private var content: String
    @State private var selectedMood: JournalMood
    @State private var selectedTags: Set<JournalTag>
    
    init(entry: JournalEntry) {
        self.entry = entry
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _selectedMood = State(initialValue: entry.mood)
        _selectedTags = State(initialValue: Set(entry.tags))
    }
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 32 : 24) {
                        // Header
                        VStack(spacing: isIPad ? 16 : 12) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: isIPad ? 48 : 40))
                                .foregroundColor(themeManager.currentTheme.colors.primary)
                            
                            Text("Edit Entry")
                                .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? 24 : 16)
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        // Form Fields (same as NewJournalEntryView)
                        VStack(spacing: isIPad ? 24 : 20) {
                            // Title Section
                            JournalFormField(
                                title: "Title",
                                icon: "textformat",
                                color: themeManager.currentTheme.colors.primary
                            ) {
                                TextField("What's on your mind today?", text: $title)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                            }
                            
                            // Mood Section
                            JournalFormField(
                                title: "How are you feeling?",
                                icon: "heart.fill",
                                color: themeManager.currentTheme.colors.accent
                            ) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: isIPad ? 16 : 12) {
                                    ForEach(JournalMood.allCases, id: \.self) { mood in
                                        MoodSelectorButton(
                                            mood: mood,
                                            isSelected: selectedMood == mood,
                                            action: { selectedMood = mood }
                                        )
                                    }
                                }
                            }
                            
                            // Thoughts Section
                            JournalFormField(
                                title: "Your thoughts",
                                icon: "quote.bubble.fill",
                                color: themeManager.currentTheme.colors.info
                            ) {
                                TextField("Write about your day, your feelings, your hopes...", text: $content, axis: .vertical)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .lineLimit(5...10)
                            }
                            
                            // Tags Section
                            JournalFormField(
                                title: "Tags (optional)",
                                icon: "tag.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: isIPad ? 12 : 8) {
                                    ForEach(JournalTag.allCases, id: \.self) { tag in
                                        TagSelectorButton(
                                            tag: tag,
                                            isSelected: selectedTags.contains(tag),
                                            action: {
                                                if selectedTags.contains(tag) {
                                                    selectedTags.remove(tag)
                                                } else {
                                                    selectedTags.insert(tag)
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themedText(style: .primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveJournalEntry()
                    }
                    .themedText(style: .primary)
                    .fontWeight(.semibold)
                    .disabled(content.isEmpty)
                }
            }
        }
    }
    
    private func saveJournalEntry() {
        var updatedEntry = entry
        updatedEntry.title = title.isEmpty ? "Untitled" : title
        updatedEntry.content = content
        updatedEntry.mood = selectedMood
        updatedEntry.tags = Array(selectedTags)
        
        #if DEBUG
        print("💾 Updating journal entry: \(updatedEntry.title)")
        #endif
        
        dataManager.updateJournalEntry(updatedEntry)
        
        #if DEBUG
        print("✅ Journal entry updated. Total entries: \(dataManager.journalEntries.count)")
        #endif
        
        dismiss()
    }
}

// MARK: - New Memory Entry View
struct NewMemoryEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedIcon = "heart.fill"
    @State private var selectedColor: Color = .pink
    @State private var selectedDate = Date()
    
    private let availableIcons = [
        "heart.fill", "hand.point.up.left.fill", "face.smiling.fill", "scalemass.fill",
        "camera.fill", "star.fill", "sparkles", "gift.fill", "balloon.fill", "birthday.cake.fill"
    ]
    
    private let availableColors: [Color] = [.pink, .yellow, .blue, .green, .purple, .orange, .red, .teal]
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 32 : 24) {
                        // Header
                        VStack(spacing: isIPad ? 16 : 12) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: isIPad ? 48 : 40))
                                .foregroundColor(selectedColor)
                            
                            Text("Capture a Memory")
                                .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Save a precious moment from your NICU journey")
                                .font(isIPad ? .system(size: 18) : .body)
                                .themedText(style: .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? 24 : 16)
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        // Form Fields
                        VStack(spacing: isIPad ? 24 : 20) {
                            // Title Section
                            JournalFormField(
                                title: "Memory Title",
                                icon: "textformat",
                                color: themeManager.currentTheme.colors.primary
                            ) {
                                TextField("e.g., First Touch", text: $title)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            // Description Section
                            JournalFormField(
                                title: "Description",
                                icon: "quote.bubble.fill",
                                color: themeManager.currentTheme.colors.info
                            ) {
                                TextField("Describe this special moment...", text: $description, axis: .vertical)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .lineLimit(5...10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Date Section
                            JournalFormField(
                                title: "Date",
                                icon: "calendar",
                                color: themeManager.currentTheme.colors.accent
                            ) {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .accentColor(themeManager.currentTheme.colors.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Icon Selection
                            JournalFormField(
                                title: "Icon",
                                icon: "star.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(availableIcons, id: \.self) { icon in
                                            Button(action: {
                                                selectedIcon = icon
                                            }) {
                                                Image(systemName: icon)
                                                    .font(.title2)
                                                    .foregroundColor(selectedIcon == icon ? selectedColor : .gray)
                                                    .frame(width: 44, height: 44)
                                                    .background(
                                                        Circle()
                                                            .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.gray.opacity(0.1))
                                                    )
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedIcon == icon ? selectedColor : Color.clear, lineWidth: 2)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            // Color Selection
                            JournalFormField(
                                title: "Color",
                                icon: "paintpalette.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(availableColors, id: \.self) { color in
                                            Button(action: {
                                                selectedColor = color
                                            }) {
                                                Circle()
                                                    .fill(color)
                                                    .frame(width: 44, height: 44)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 3)
                                                    )
                                                    .overlay(
                                                        Image(systemName: "checkmark")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 18, weight: .bold))
                                                            .opacity(selectedColor == color ? 1 : 0)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationTitle("New Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themedText(style: .primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMemory()
                    }
                    .themedText(style: .primary)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
    
    private func saveMemory() {
        let newMemory = MemoryItem(
            title: title,
            description: description,
            date: selectedDate,
            icon: selectedIcon,
            color: selectedColor
        )
        dataManager.addMemoryItem(newMemory)
        dismiss()
    }
}

// MARK: - Edit Memory View
struct EditMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    
    let memory: MemoryItem
    
    @State private var title: String
    @State private var description: String
    @State private var selectedIcon: String
    @State private var selectedColor: Color
    @State private var selectedDate: Date
    
    init(memory: MemoryItem) {
        self.memory = memory
        _title = State(initialValue: memory.title)
        _description = State(initialValue: memory.description)
        _selectedIcon = State(initialValue: memory.icon)
        _selectedColor = State(initialValue: memory.color)
        _selectedDate = State(initialValue: memory.date)
    }
    
    private let availableIcons = [
        "heart.fill", "hand.point.up.left.fill", "face.smiling.fill", "scalemass.fill",
        "camera.fill", "star.fill", "sparkles", "gift.fill", "balloon.fill", "birthday.cake.fill"
    ]
    
    private let availableColors: [Color] = [.pink, .yellow, .blue, .green, .purple, .orange, .red, .teal]
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                themeManager.currentTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 32 : 24) {
                        // Header
                        VStack(spacing: isIPad ? 16 : 12) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: isIPad ? 48 : 40))
                                .foregroundColor(selectedColor)
                            
                            Text("Edit Memory")
                                .font(isIPad ? .system(size: 28, weight: .bold) : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? 24 : 16)
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        // Form Fields (same as NewMemoryEntryView)
                        VStack(spacing: isIPad ? 24 : 20) {
                            // Title Section
                            JournalFormField(
                                title: "Memory Title",
                                icon: "textformat",
                                color: themeManager.currentTheme.colors.primary
                            ) {
                                TextField("e.g., First Touch", text: $title)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            // Description Section
                            JournalFormField(
                                title: "Description",
                                icon: "quote.bubble.fill",
                                color: themeManager.currentTheme.colors.info
                            ) {
                                TextField("Describe this special moment...", text: $description, axis: .vertical)
                                    .font(isIPad ? .system(size: 18) : .body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .accentColor(themeManager.currentTheme.colors.primary)
                                    .lineLimit(5...10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Date Section
                            JournalFormField(
                                title: "Date",
                                icon: "calendar",
                                color: themeManager.currentTheme.colors.accent
                            ) {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .accentColor(themeManager.currentTheme.colors.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Icon Selection
                            JournalFormField(
                                title: "Icon",
                                icon: "star.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(availableIcons, id: \.self) { icon in
                                            Button(action: {
                                                selectedIcon = icon
                                            }) {
                                                Image(systemName: icon)
                                                    .font(.title2)
                                                    .foregroundColor(selectedIcon == icon ? selectedColor : .gray)
                                                    .frame(width: 44, height: 44)
                                                    .background(
                                                        Circle()
                                                            .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.gray.opacity(0.1))
                                                    )
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedIcon == icon ? selectedColor : Color.clear, lineWidth: 2)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            // Color Selection
                            JournalFormField(
                                title: "Color",
                                icon: "paintpalette.fill",
                                color: themeManager.currentTheme.colors.warning
                            ) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(availableColors, id: \.self) { color in
                                            Button(action: {
                                                selectedColor = color
                                            }) {
                                                Circle()
                                                    .fill(color)
                                                    .frame(width: 44, height: 44)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 3)
                                                    )
                                                    .overlay(
                                                        Image(systemName: "checkmark")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 18, weight: .bold))
                                                            .opacity(selectedColor == color ? 1 : 0)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 16)
                        
                        Spacer(minLength: isIPad ? 40 : 20)
                    }
                }
            }
            .navigationTitle("Edit Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themedText(style: .primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMemory()
                    }
                    .themedText(style: .primary)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
    
    private func saveMemory() {
        // Create a new MemoryItem with updated values since date is let
        let updatedMemory = MemoryItem(
            title: title,
            description: description,
            date: selectedDate,
            icon: selectedIcon,
            color: selectedColor
        )
        // Preserve the original ID
        var memoryToUpdate = updatedMemory
        memoryToUpdate.id = memory.id
        
        #if DEBUG
        print("💾 Updating memory: '\(memoryToUpdate.title)' with color: \(memoryToUpdate.colorName)")
        #endif
        
        dataManager.updateMemoryItem(memoryToUpdate)
        
        #if DEBUG
        print("✅ Memory updated. Total memories: \(dataManager.memoryItems.count)")
        #endif
        
        dismiss()
    }
}

// MARK: - Quick Journal Bar (mood + short note)
struct QuickJournalBar: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    @State private var selectedQuickMood: QuickMood? = nil
    @State private var note: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // Title
            HStack(spacing: 8) {
                Image(systemName: "bolt.heart.fill")
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                Text(NSLocalizedString("ui.journal.quick", comment: "Quick Journal"))
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .headline)
                    .fontWeight(.semibold)
                    .themedText(style: .primary)
                Spacer()
            }
            
            HStack(spacing: 8) {
                QuickMoodButton(mood: .good, selected: $selectedQuickMood)
                QuickMoodButton(mood: .okay, selected: $selectedQuickMood)
                QuickMoodButton(mood: .hard, selected: $selectedQuickMood)
            }
            
            HStack(spacing: 8) {
                TextField(NSLocalizedString("ui.note.placeholder", comment: "Add a short note"), text: $note)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .padding(UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12)
                    .background(themeManager.currentTheme.colors.backgroundSecondary)
                    .cornerRadius(10)
                
                Button(action: saveQuickEntry) {
                    Text(NSLocalizedString("ui.save", comment: "Save"))
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .headline : .callout).fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 12 : 10)
                        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14)
                        .background(themeManager.currentTheme.colors.primary)
                        .cornerRadius(10)
                }
                .disabled(selectedQuickMood == nil && note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity((selectedQuickMood == nil && note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.5 : 1)
            }
        }
        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
        .themedCard()
    }
    
    private func saveQuickEntry() {
        let mappedMood: JournalMood = {
            switch selectedQuickMood {
            case .good: return .happy
            case .okay: return .neutral
            case .hard: return .worried
            case .none: return .neutral
            }
        }()
        let content = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = JournalEntry(
            title: NSLocalizedString("ui.journal.quick", comment: "Quick Journal"),
            content: content.isEmpty ? "" : content,
            mood: mappedMood,
            tags: []
        )
        dataManager.addJournalEntry(entry)
        // reset
        selectedQuickMood = nil
        note = ""
    }
}

enum QuickMood: String, CaseIterable {
    case good, okay, hard
    
    var emoji: String {
        switch self {
        case .good: return "😊"
        case .okay: return "😌"
        case .hard: return "😞"
        }
    }
}

struct QuickMoodButton: View {
    let mood: QuickMood
    @Binding var selected: QuickMood?
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: { selected = mood }) {
            Text(mood.emoji)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3)
                .frame(maxWidth: .infinity)
                .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 14 : 10)
                .background((selected == mood) ? themeManager.currentTheme.colors.primary.opacity(0.15) : Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((selected == mood) ? themeManager.currentTheme.colors.primary : themeManager.currentTheme.colors.border, lineWidth: (selected == mood) ? 2 : 1)
                )
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(minHeight: 44)
        .accessibilityLabel(Text("Mood: \(mood.rawValue)"))
    }
}

// MARK: - Journal Form Field
struct JournalFormField<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            HStack(spacing: isIPad ? 12 : 8) {
                Image(systemName: icon)
                    .font(isIPad ? .system(size: 20) : .title3)
                    .foregroundColor(color)
                    .frame(width: isIPad ? 24 : 20)
                
                Text(title)
                    .font(isIPad ? .system(size: 20, weight: .semibold) : .headline)
                    .themedText(style: .primary)
            }
            
            content
                .padding(isIPad ? 16 : 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                        .fill(themeManager.currentTheme.colors.backgroundSecondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                                .stroke(themeManager.currentTheme.colors.border, lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Mood Selector Button
struct MoodSelectorButton: View {
    let mood: JournalMood
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: isIPad ? 8 : 6) {
                Text(mood.emoji)
                    .font(.system(size: isIPad ? 32 : 28))
                
                Text(mood.rawValue)
                    .font(isIPad ? .system(size: 14, weight: .medium) : .caption)
                    .themedText(style: isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(isIPad ? 16 : 12)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .fill(isSelected ? themeManager.currentTheme.colors.primary.opacity(0.15) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .stroke(
                        isSelected ? themeManager.currentTheme.colors.primary : themeManager.currentTheme.colors.border,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Tag Selector Button
struct TagSelectorButton: View {
    let tag: JournalTag
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            Text(tag.rawValue)
                .font(isIPad ? .system(size: 16, weight: .medium) : .caption)
                .padding(.horizontal, isIPad ? 16 : 12)
                .padding(.vertical, isIPad ? 10 : 8)
                .background(
                    RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                        .fill(isSelected ? tag.color : tag.color.opacity(0.15))
                )
                .foregroundColor(isSelected ? .white : tag.color)
                .overlay(
                    RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                        .stroke(tag.color, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Nurse Shift Section
struct NurseShiftSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataPersistenceManager
    @State private var nurseName: String = ""
    @State private var notes: String = ""
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            HStack {
                Image(systemName: "stethoscope")
                    .foregroundColor(themeManager.currentTheme.colors.accent)
                Text("Nurse on Shift")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .themedText(style: .primary)
                Spacer()
            }
            
            HStack(spacing: isIPad ? 12 : 8) {
                TextField("Enter nurse name", text: $nurseName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .padding(isIPad ? 14 : 12)
                    .background(themeManager.currentTheme.colors.backgroundSecondary)
                    .cornerRadius(isIPad ? 12 : 10)
                    .submitLabel(.done)
                    .onSubmit { addShift() }

                Button(action: addShift) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Add")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, isIPad ? 12 : 10)
                    .padding(.horizontal, isIPad ? 16 : 14)
                    .background(themeManager.currentTheme.colors.primary)
                    .cornerRadius(isIPad ? 12 : 10)
                    .opacity(nurseName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(nurseName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            if !dataManager.nurseShifts.isEmpty {
                // Use List to enable native swipe-to-delete
                List {
                    ForEach(dataManager.nurseShifts) { shift in
                        HStack(alignment: .firstTextBaseline) {
                            Text(shift.nurseName)
                                .font(.subheadline)
                                .themedText(style: .primary)
                            Spacer()
                            Text(shift.date, style: .date)
                                .font(.caption)
                                .themedText(style: .tertiary)
                        }
                        .listRowBackground(themeManager.currentTheme.colors.backgroundSecondary)
                    }
                    .onDelete(perform: dataManager.deleteNurseShift(atOffsets:))
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                .frame(minHeight: min(CGFloat(dataManager.nurseShifts.count) * (isIPad ? 56 : 50), 300), maxHeight: 300)
                .background(Color.clear)
            }
        }
        .padding()
        .themedCard()
    }
    
    private func addShift() {
        let trimmed = nurseName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let record = NurseShiftRecord(nurseName: trimmed, notes: notes.isEmpty ? nil : notes)
        dataManager.addNurseShift(record)
        nurseName = ""
        notes = ""
    }
}

// MARK: - Data Models
struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    let date: Date
    var mood: JournalMood
    var tags: [JournalTag]
    
    init(title: String, content: String, date: Date = Date(), mood: JournalMood = .neutral, tags: [JournalTag] = []) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
        self.mood = mood
        self.tags = tags
    }
}

enum JournalMood: String, CaseIterable, Codable {
    case happy = "Happy"
    case hopeful = "Hopeful"
    case worried = "Worried"
    case sad = "Sad"
    case grateful = "Grateful"
    case neutral = "Neutral"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .hopeful: return "🌟"
        case .worried: return "😟"
        case .sad: return "😢"
        case .grateful: return "🙏"
        case .neutral: return "😐"
        }
    }
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling.fill"
        case .hopeful: return "hand.raised.fill"
        case .worried: return "hand.point.down.fill"
        case .sad: return "face.dashed.fill"
        case .grateful: return "heart.fill"
        case .neutral: return "face.label.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return .yellow
        case .hopeful: return .green
        case .worried: return .orange
        case .sad: return .blue
        case .grateful: return .pink
        case .neutral: return .gray
        }
    }
}

enum JournalTag: String, CaseIterable, Codable {
    case progress = "Progress"
    case worries = "Worries"
    case gratitude = "Gratitude"
    case questions = "Questions"
    case milestones = "Milestones"
    case family = "Family"
    case hope = "Hope"
    
    var color: Color {
        switch self {
        case .progress: return .green
        case .worries: return .red
        case .gratitude: return .purple
        case .questions: return .blue
        case .milestones: return .orange
        case .family: return .pink
        case .hope: return .teal
        }
    }
}

struct JournalPrompt: Identifiable {
    let id = UUID()
    let title: String
    let prompt: String
    let category: String
    let icon: String
    let color: Color
    let tips: [String]
    
    static let allPrompts = [
        JournalPrompt(
            title: "Today's Progress",
            prompt: "What positive changes did you notice in your baby today? Even the smallest improvements matter.",
            category: "Progress",
            icon: "chart.line.uptrend.xyaxis",
            color: .green,
            tips: [
                "Look for small wins - weight gain, breathing improvements, or new skills",
                "Celebrate every milestone, no matter how small",
                "Remember that progress isn't always linear"
            ]
        ),
        JournalPrompt(
            title: "Your Feelings",
            prompt: "How are you feeling right now? It's okay to have mixed emotions - this is a complex journey.",
            category: "Emotions",
            icon: "heart.fill",
            color: .red,
            tips: [
                "All feelings are valid - you don't have to be strong all the time",
                "Write without judgment - this is for you",
                "Consider what might be causing these feelings"
            ]
        ),
        JournalPrompt(
            title: "Gratitude",
            prompt: "What are you grateful for today? Even in difficult times, there are often small blessings.",
            category: "Gratitude",
            icon: "star.fill",
            color: .orange,
            tips: [
                "Think about the medical team, family support, or small moments of joy",
                "Gratitude can help shift your perspective",
                "Even tiny things count - a kind word, a good cup of coffee"
            ]
        ),
        JournalPrompt(
            title: "Questions for Tomorrow",
            prompt: "What questions do you want to ask the medical team tomorrow? Write them down so you don't forget.",
            category: "Planning",
            icon: "questionmark.circle.fill",
            color: .blue,
            tips: [
                "No question is too small or silly",
                "Ask about your baby's progress, next steps, or your concerns",
                "Consider asking about how you can help or be more involved"
            ]
        ),
        JournalPrompt(
            title: "Hopes and Dreams",
            prompt: "What are you looking forward to? What dreams do you have for your baby's future?",
            category: "Hope",
            icon: "sparkles",
            color: .purple,
            tips: [
                "Dreaming about the future can provide hope and motivation",
                "Think about firsts you're excited to experience",
                "Consider what kind of parent you want to be"
            ]
        ),
        JournalPrompt(
            title: "Self-Care",
            prompt: "How did you take care of yourself today? Remember, you can't pour from an empty cup.",
            category: "Self-Care",
            icon: "person.fill.checkmark",
            color: .teal,
            tips: [
                "Self-care isn't selfish - it's necessary",
                "Even small acts of self-care count",
                "Think about what you need to feel better"
            ]
        )
    ]
}

struct MemoryItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    let date: Date
    var icon: String
    var colorName: String // Store color as string instead of Color
    
    init(title: String, description: String, date: Date = Date(), icon: String, color: Color) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.icon = icon
        self.colorName = MemoryItem.colorToString(color)
    }
    
    private static func colorToString(_ color: Color) -> String {
        // Convert Color to a reliable string representation
        // Use a simple approach: compare RGB values with tolerance
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "pink" // Fallback if color space doesn't support RGB
        }
        
        // Match against known colors (using approximate RGB values for SwiftUI standard colors)
        // Pink: RGB(1.0, 0.75, 0.8)
        if red > 0.9 && green > 0.6 && green < 0.9 && blue > 0.7 {
            return "pink"
        }
        // Yellow: RGB(1.0, 1.0, 0.0)
        if red > 0.9 && green > 0.9 && blue < 0.1 {
            return "yellow"
        }
        // Blue: RGB(0.0, 0.5, 1.0)
        if red < 0.1 && green > 0.4 && green < 0.6 && blue > 0.9 {
            return "blue"
        }
        // Green: RGB(0.0, 0.8, 0.2)
        if red < 0.1 && green > 0.7 && blue < 0.3 {
            return "green"
        }
        // Purple: RGB(0.5, 0.0, 0.5)
        if red > 0.4 && red < 0.6 && green < 0.1 && blue > 0.4 && blue < 0.6 {
            return "purple"
        }
        // Orange: RGB(1.0, 0.65, 0.0)
        if red > 0.9 && green > 0.5 && green < 0.8 && blue < 0.1 {
            return "orange"
        }
        // Red: RGB(1.0, 0.0, 0.0)
        if red > 0.9 && green < 0.1 && blue < 0.1 {
            return "red"
        }
        // Teal: RGB(0.0, 0.5, 0.5)
        if red < 0.1 && green > 0.4 && green < 0.6 && blue > 0.4 && blue < 0.6 {
            return "teal"
        }
        #endif
        
        return "pink" // Default fallback
    }
    
    var color: Color {
        // Convert string back to Color for UI
        switch colorName.lowercased() {
        case "pink": return .pink
        case "yellow": return .yellow
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        case "teal": return .teal
        default: return .pink // Default to pink instead of gray
        }
    }
    
    static let allMemories = [
        MemoryItem(
            title: "First Touch",
            description: "The first time you held your baby's tiny hand through the incubator opening.",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            icon: "hand.point.up.left.fill",
            color: .pink
        ),
        MemoryItem(
            title: "First Smile",
            description: "That moment when your baby opened their eyes and seemed to look right at you.",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            icon: "face.smiling.fill",
            color: .yellow
        ),
        MemoryItem(
            title: "Weight Milestone",
            description: "The day your baby reached 1.5kg - a small but significant milestone.",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            icon: "scalemass.fill",
            color: .green
        )
    ]
}

// MARK: - Sample Data
let sampleEntries = [
    JournalEntry(
        title: "First Day in NICU",
        content: "Today was overwhelming but also filled with hope. The medical team is amazing and I can see how much they care about our little one. I'm scared but also grateful we're in such good hands.",
        date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
        mood: .hopeful,
        tags: [.gratitude, .hope]
    ),
    JournalEntry(
        title: "Small Wins",
        content: "Baby gained 10g today! The nurse said that's great progress. I know it's small but it feels like a huge victory. Every gram counts.",
        date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
        mood: .happy,
        tags: [.progress, .milestones]
    ),
    JournalEntry(
        title: "Feeling Overwhelmed",
        content: "Sometimes I feel like I'm not doing enough. I want to be there every moment but I also need to work and take care of myself. It's hard to balance everything.",
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        mood: .worried,
        tags: [.worries]
    )
]

#Preview {
    NICUJournalView()
        .environmentObject(ThemeManager.shared)
        .environmentObject(DataPersistenceManager.shared)
}