//
//  NICUJournalView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

struct NICUJournalView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var dataManager = DataPersistenceManager.shared
    @State private var selectedTab = JournalTab.entries
    @State private var showNewEntry = false
    
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
                                .font(.title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Your NICU journey, one entry at a time")
                                .font(.subheadline)
                                .themedText(style: .secondary)
                        }
                        Spacer()
                        
                        Button(action: { showNewEntry = true }) {
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
                                        .font(.title3)
                                    
                                    Text(tab.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(selectedTab == tab ? themeManager.currentTheme.colors.accent : themeManager.currentTheme.colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.6)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        switch selectedTab {
                        case .entries:
                            ForEach(dataManager.journalEntries.sorted(by: { $0.date > $1.date })) { entry in
                                JournalEntryCard(entry: entry)
                            }
                        case .prompts:
                            ForEach(JournalPrompt.allPrompts, id: \.id) { prompt in
                                JournalPromptCard(prompt: prompt)
                            }
                        case .memories:
                            ForEach(dataManager.memoryItems.sorted(by: { $0.date > $1.date }), id: \.id) { memory in
                                MemoryCard(memory: memory)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
        .sheet(isPresented: $showNewEntry) {
            NewJournalEntryView()
        }
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
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
                
                Text(entry.mood.emoji)
                    .font(.title2)
            }
            
            
            Text(entry.content)
                .font(.body)
                .themedText(style: .secondary)
                .lineLimit(3)
            
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
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
    }
}

// MARK: - New Journal Entry View
struct NewJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var dataManager = DataPersistenceManager.shared
    
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
                        .padding(.horizontal, isIPad ? 32 : 20)
                        
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
                        .padding(.horizontal, isIPad ? 32 : 20)
                        
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
        let newEntry = JournalEntry(
            title: title.isEmpty ? "Untitled" : title,
            content: content,
            mood: selectedMood,
            tags: Array(selectedTags)
        )
        dataManager.addJournalEntry(newEntry)
        dismiss()
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
                .padding(isIPad ? 20 : 16)
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
        self.colorName = color.description
    }
    
    var color: Color {
        // Convert string back to Color for UI
        switch colorName {
        case "pink": return .pink
        case "yellow": return .yellow
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        case "teal": return .teal
        default: return .gray
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
}