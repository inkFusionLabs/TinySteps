//
//  DadWellnessView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

enum MoodLevel: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case neutral = "Neutral"
    case low = "Low"
    case poor = "Poor"
    
    var emoji: String {
        switch self {
        case .excellent: return "😊"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .low: return "😔"
        case .poor: return "😢"
        }
    }
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .neutral: return .yellow
        case .low: return .orange
        case .poor: return .red
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let mood: MoodLevel
    let notes: String
    let date: Date
}

struct DadWellnessView: View {
    @State private var selectedWellnessTab: WellnessTab = .mood
    @State private var showStressAssessment = false
    @State private var currentMood: MoodLevel = .neutral
    @State private var moodNotes = ""
    @State private var showingMoodEntry = false
    @State private var savedMoodEntries: [MoodEntry] = []
    @StateObject private var countryManager = CountryHealthServicesManager()
    
    enum WellnessTab: String, CaseIterable {
        case mood = "Mood"
        case stress = "Stress"
        case postnatalDepression = "Postnatal Depression"
        case selfCare = "Self-Care"
        case support = "Support"
        case resources = "Resources"
        case favorites = "Favorites"
        
        var color: Color {
            switch self {
            case .mood: return .blue
            case .stress: return .orange
            case .postnatalDepression: return .red
            case .selfCare: return .green
            case .support: return .purple
            case .resources: return .yellow
            case .favorites: return .pink
            }
        }
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Dad Wellness")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Supporting your mental health and wellbeing")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)
                .padding(.horizontal)
                
                // Tab Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(WellnessTab.allCases, id: \.self) { tab in
                            Button(action: {
                                selectedWellnessTab = tab
                            }) {
                                Text(tab.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.clear)
                                    .foregroundColor(selectedWellnessTab == tab ? .white : .white.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        switch selectedWellnessTab {
                        case .mood:
                            VStack(spacing: 20) {
                                MoodTrackingView(currentMood: $currentMood, moodNotes: $moodNotes, showingMoodEntry: $showingMoodEntry)
                                
                                // Saved Mood Entries
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Your Mood Notes")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    if savedMoodEntries.isEmpty {
                                        Text("No mood entries yet. Add your first mood note above.")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding()
                                    } else {
                                        LazyVStack(spacing: 12) {
                                            ForEach(savedMoodEntries.reversed()) { entry in
                                                SavedMoodEntryCard(entry: entry) {
                                                    deleteMoodEntry(entry)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.clear)
                            }
                        case .stress:
                            StressManagementView()
                        case .postnatalDepression:
                            PostnatalDepressionView()
                        case .selfCare:
                            SelfCareView()
                        case .support:
                            SupportNetworkView()
                        case .resources:
                            WellnessResourcesView()
                        case .favorites:
                            FavoritesView()
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingMoodEntry) {
            MoodEntryView(currentMood: $currentMood, moodNotes: $moodNotes)
        }
        .onAppear {
            loadSavedMoods()
        }
    }
    
    private func saveMood() {
        let newEntry = MoodEntry(mood: currentMood, notes: moodNotes, date: Date())
        savedMoodEntries.append(newEntry)
        saveMoodsToStorage()
        moodNotes = ""
        showingMoodEntry = false
    }
    
    private func saveMoodsToStorage() {
        if let encoded = try? JSONEncoder().encode(savedMoodEntries) {
            UserDefaults.standard.set(encoded, forKey: "savedMoodEntries")
        }
    }
    
    private func loadSavedMoods() {
        if let data = UserDefaults.standard.data(forKey: "savedMoodEntries"),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            savedMoodEntries = decoded
        }
    }
    
    private func deleteMoodEntry(_ entry: MoodEntry) {
        savedMoodEntries.removeAll { $0.id == entry.id }
        saveMoodsToStorage()
    }
}

// MARK: - Enhanced View Components

struct MoodTrackingView: View {
    @Binding var currentMood: MoodLevel
    @Binding var moodNotes: String
    @Binding var showingMoodEntry: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Current Mood Display
            VStack(spacing: 16) {
                Text("How are you feeling today?")
                    .font(.headline)
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(MoodLevel.allCases, id: \.self) { mood in
                        VStack(spacing: 8) {
                            Text(mood.emoji)
                                .font(.system(size: 32))
                            Text(mood.rawValue)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(currentMood == mood ? mood.color.opacity(0.5) : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            currentMood = mood
                        }
                    }
                }
                
                Button("Add Mood Notes") {
                    showingMoodEntry = true
                }
                .foregroundColor(.blue)
                .padding(.top)
            }
            .padding()
            .background(Color.clear)
        }
        .padding(.horizontal)
    }
}

struct StressManagementView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Stress Assessment
            VStack(alignment: .leading, spacing: 16) {
                Text("Stress Management")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Recognize and manage stress effectively")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 12) {
                    WellnessTipCard(
                        title: "Deep Breathing",
                        description: "4-7-8 technique: Inhale 4s, hold 7s, exhale 8s",
                        icon: "lungs.fill",
                        color: .blue
                    )
                    
                    WellnessTipCard(
                        title: "Progressive Relaxation",
                        description: "Tense and relax each muscle group for 5 seconds",
                        icon: "figure.mind.and.body",
                        color: .green
                    )
                    
                    WellnessTipCard(
                        title: "Time Management",
                        description: "Break tasks into smaller, manageable chunks",
                        icon: "clock.fill",
                        color: .orange
                    )
                    
                    WellnessTipCard(
                        title: "Physical Exercise",
                        description: "Release endorphins through regular exercise",
                        icon: "figure.run",
                        color: .purple
                    )
                }
            }
            .padding()
            .background(Color.clear)
            
            // Stress Warning Signs
            VStack(alignment: .leading, spacing: 16) {
                Text("Warning Signs of High Stress")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    StressSignCard(sign: "Irritability", description: "Short temper with family")
                    StressSignCard(sign: "Sleep Problems", description: "Difficulty falling or staying asleep")
                    StressSignCard(sign: "Physical Symptoms", description: "Headaches, muscle tension")
                    StressSignCard(sign: "Concentration Issues", description: "Difficulty focusing on tasks")
                    StressSignCard(sign: "Withdrawal", description: "Avoiding social interactions")
                }
            }
            .padding()
            .background(Color.clear)
        }
        .padding(.horizontal)
    }
}

struct PostnatalDepressionView: View {
    @StateObject private var countryManager = CountryHealthServicesManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Information Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Postnatal Depression Support")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Postnatal depression affects 1 in 10 new fathers. It's important to recognize the signs and seek help.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 12) {
                    WellnessTipCard(
                        title: "Common Symptoms",
                        description: "Persistent sadness, irritability, withdrawal, changes in appetite or sleep",
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                    
                    WellnessTipCard(
                        title: "Risk Factors",
                        description: "Previous depression, financial stress, lack of support, relationship issues",
                        icon: "list.bullet",
                        color: .orange
                    )
                    
                    WellnessTipCard(
                        title: "Treatment Options",
                        description: "Therapy, medication, support groups, lifestyle changes",
                        icon: "cross.case.fill",
                        color: .green
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Emergency Resources
            VStack(alignment: .leading, spacing: 16) {
                Text("Emergency Resources")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    EmergencyResourceCard(
                        title: "Crisis Helpline",
                        description: "24/7 support for mental health crises",
                        phone: "116 123",
                        color: .red
                    )
                    
                    EmergencyResourceCard(
                        title: "Postpartum Support",
                        description: "Specialized support for new parents",
                        phone: "0808 1961 776",
                        color: .blue
                    )
                    
                    EmergencyResourceCard(
                        title: "Emergency Services",
                        description: "If you're in immediate danger",
                        phone: countryManager.getEmergencyNumber(),
                        color: .red
                    )
                }
            }
            .padding()
            .background(Color.clear)
        }
        .padding(.horizontal)
    }
}

struct SelfCareView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Self-Care Categories
            VStack(alignment: .leading, spacing: 16) {
                Text("Self-Care Strategies")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    WellnessTipCard(
                        title: "Physical Self-Care",
                        description: "Exercise, healthy eating, adequate sleep, regular check-ups",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    WellnessTipCard(
                        title: "Emotional Self-Care",
                        description: "Journaling, therapy, expressing feelings, setting boundaries",
                        icon: "brain.head.profile",
                        color: .blue
                    )
                    
                    WellnessTipCard(
                        title: "Social Self-Care",
                        description: "Maintaining friendships, asking for help, joining groups",
                        icon: "person.2.fill",
                        color: .green
                    )
                    
                    WellnessTipCard(
                        title: "Spiritual Self-Care",
                        description: "Meditation, nature walks, religious practices, reflection",
                        icon: "leaf.fill",
                        color: .purple
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Quick Self-Care Activities
            VStack(alignment: .leading, spacing: 16) {
                Text("5-Minute Self-Care Activities")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    QuickActivityCard(activity: "Deep breathing", time: "2 minutes")
                    QuickActivityCard(activity: "Stretch", time: "3 minutes")
                    QuickActivityCard(activity: "Gratitude list", time: "2 minutes")
                    QuickActivityCard(activity: "Mindful walk", time: "5 minutes")
                    QuickActivityCard(activity: "Progressive relaxation", time: "5 minutes")
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct SupportNetworkView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Building Support Network
            VStack(alignment: .leading, spacing: 16) {
                Text("Building Your Support Network")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    WellnessTipCard(
                        title: "Family & Friends",
                        description: "Maintain regular contact with loved ones",
                        icon: "house.fill",
                        color: .blue
                    )
                    
                    WellnessTipCard(
                        title: "Other Dads",
                        description: "Connect with other new fathers for shared experiences",
                        icon: "person.2.fill",
                        color: .green
                    )
                    
                    WellnessTipCard(
                        title: "Professional Support",
                        description: "Therapists, counselors, support groups",
                        icon: "cross.case.fill",
                        color: .purple
                    )
                    
                    WellnessTipCard(
                        title: "Online Communities",
                        description: "Join dad-focused online forums and groups",
                        icon: "globe",
                        color: .orange
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Communication Tips
            VStack(alignment: .leading, spacing: 16) {
                Text("Effective Communication")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    CommunicationTipCard(tip: "Be honest about your feelings")
                    CommunicationTipCard(tip: "Ask for specific help when needed")
                    CommunicationTipCard(tip: "Listen actively to others")
                    CommunicationTipCard(tip: "Set realistic expectations")
                    CommunicationTipCard(tip: "Practice active listening")
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct WellnessResourcesView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Professional Resources
            VStack(alignment: .leading, spacing: 16) {
                Text("Professional Resources")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    ResourceCard(
                        title: "Mental Health Professionals",
                        description: "Therapists, psychologists, psychiatrists",
                        contact: "Ask your GP for referrals",
                        color: .blue
                    )
                    
                    ResourceCard(
                        title: "Support Groups",
                        description: "In-person and online support groups for dads",
                        contact: "Check local community centers",
                        color: .green
                    )
                    
                    ResourceCard(
                        title: "Crisis Helplines",
                        description: "24/7 support for mental health emergencies",
                        contact: "988 - National Suicide Prevention Lifeline",
                        color: .red
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Educational Resources
            VStack(alignment: .leading, spacing: 16) {
                Text("Educational Resources")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    ResourceCard(
                        title: "Books & Articles",
                        description: "Reading materials on fatherhood and mental health",
                        contact: "Check your local library",
                        color: .purple
                    )
                    
                    ResourceCard(
                        title: "Online Courses",
                        description: "Mental health and parenting courses",
                        contact: "Various online platforms",
                        color: .orange
                    )
                    
                    ResourceCard(
                        title: "Apps & Tools",
                        description: "Meditation, mood tracking, and wellness apps",
                        contact: "App Store recommendations",
                        color: .yellow
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct FavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Favorites")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Save your favorite wellness resources here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                Text("No favorites yet")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Tap the heart icon on any resource to save it here")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// MARK: - Helper Components

struct WellnessTipCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.clear)
    }
}

struct StressSignCard: View {
    let sign: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(sign)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EmergencyResourceCard: View {
    let title: String
    let description: String
    let phone: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "phone.fill")
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(phone)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.clear)
    }
}

struct QuickActivityCard: View {
    let activity: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .foregroundColor(.green)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct CommunicationTipCard: View {
    let tip: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "message.fill")
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(tip)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ResourceCard: View {
    let title: String
    let description: String
    let contact: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(contact)
                    .font(.caption)
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct MoodEntryView: View {
    @Binding var currentMood: MoodLevel
    @Binding var moodNotes: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("How are you feeling?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Add notes about your mood...", text: $moodNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Mood Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct SavedMoodEntryCard: View {
    let entry: MoodEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.mood.emoji)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.mood.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(entry.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
} 