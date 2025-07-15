import SwiftUI

struct JournalEntry: Hashable, Identifiable {
    var id: UUID = UUID()
    let date: Date
    let text: String
    let mood: JournalMood
    let tags: [String]
    
    enum JournalMood: String, CaseIterable {
        case happy = "😊"
        case content = "😌"
        case tired = "😴"
        case worried = "😟"
        case excited = "🤗"
        case grateful = "🙏"
        
        var color: Color {
            switch self {
            case .happy: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .content: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .tired: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .worried: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .excited: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            case .grateful: return Color(red: 0.1, green: 0.2, blue: 0.7) // Medium-dark blue
            }
        }
    }
}

struct JournalView: View {
    @State private var entryText: String = ""
    @State private var entries: [JournalEntry] = []
    @State private var selectedMood: JournalEntry.JournalMood = .content
    @State private var selectedTags: Set<String> = []
    @State private var animateContent = false
    @State private var showNewEntry = false
    
    let availableTags = [
        "Firsts", "Milestones", "Challenges", "Gratitude", 
        "Learning", "Bonding", "Support", "Growth"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Journal Banner (Support & Care style)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Dad's Journal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { showNewEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                Text("Record your thoughts and memories")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal)
            .padding(.top)
            // Main Content
            ScrollView {
                VStack(spacing: 20) {
                    // Example Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Entries")
                            .font(TinyStepsDesign.Typography.subheader)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        // ... existing journal content ...
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    // ... repeat for other cards/buttons ...
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
    }
    
    private func saveEntry() {
        guard !entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newEntry = JournalEntry(
            date: Date(),
            text: entryText,
            mood: selectedMood,
            tags: Array(selectedTags)
        )
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            entries.insert(newEntry, at: 0)
        }
        
        // Reset form
        entryText = ""
        selectedMood = .content
        selectedTags.removeAll()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showNewEntry = false
        }
    }
}

struct NewEntryView: View {
    @Binding var entryText: String
    @Binding var selectedMood: JournalEntry.JournalMood
    @Binding var selectedTags: Set<String>
    let availableTags: [String]
    let onSave: () -> Void
    @State private var animateMood = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Mood Selector
            VStack(alignment: .leading, spacing: 12) {
                Text("How are you feeling?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    ForEach(JournalEntry.JournalMood.allCases, id: \.self) { mood in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedMood = mood
                            }
                        }) {
                            Text(mood.rawValue)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(selectedMood == mood ? mood.color.opacity(0.3) : TinyStepsDesign.Colors.cardBackground)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedMood == mood ? mood.color : TinyStepsDesign.Colors.cardBackground.opacity(0.3), lineWidth: selectedMood == mood ? 2 : 1)
                                        )
                                )
                                .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedMood)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Text Editor
            VStack(alignment: .leading, spacing: 12) {
                Text("What's on your mind?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                TextEditor(text: $entryText)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(TinyStepsDesign.Colors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(TinyStepsDesign.Colors.cardBackground.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
            }
            
            // Tags Selector
            VStack(alignment: .leading, spacing: 12) {
                Text("Add tags (optional)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                    ForEach(availableTags, id: \.self) { tag in
                        TagButton(
                            tag: tag,
                            isSelected: selectedTags.contains(tag)
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                }
            }
            
            // Save Button
            Button(action: onSave) {
                HStack(spacing: 10) {
                    Image(systemName: "bookmark.fill")
                        .font(.title2)
                    Text("Save Entry")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(TinyStepsDesign.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(TinyStepsDesign.Colors.cardBackground.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue.opacity(0.3) : TinyStepsDesign.Colors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color.blue : TinyStepsDesign.Colors.cardBackground.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    @State private var isHovered = false
    @State private var showFullText = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text(entry.mood.rawValue)
                    .font(.system(size: 30))
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isHovered)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(entry.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "bookmark.fill")
                    .foregroundColor(entry.mood.color)
                    .font(.title3)
            }
            
            // Content
            Text(entry.text)
                .font(.body)
                .foregroundColor(TinyStepsDesign.Colors.textPrimary.opacity(0.9))
                .lineLimit(showFullText ? nil : 3)
                .lineSpacing(4)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFullText.toggle()
                    }
                }
            
            // Tags
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(entry.mood.color.opacity(0.3))
                                )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(entry.mood.color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(color: entry.mood.color.opacity(0.2), radius: isHovered ? 15 : 10, x: 0, y: 5)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct EmptyJournalView: View {
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.6))
                .scaleEffect(animateIcon ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
            
            VStack(spacing: 8) {
                Text("Your journal is empty")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Start writing to capture your journey as a dad")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .onAppear {
            animateIcon = true
        }
    }
}

#Preview {
    JournalView()
} 