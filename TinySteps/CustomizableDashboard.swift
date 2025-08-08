import SwiftUI

// MARK: - Dashboard Card Types
enum DashboardCardType: String, CaseIterable, Identifiable, Codable {
    case dailySummary = "Daily Summary"
    case quickActions = "Quick Actions"
    case babyStatus = "Baby's Status"
    case appointments = "Today's Schedule"
    case moodTracker = "Dad's Mood"
    case milestones = "Recent Milestones"
    case tips = "Daily Tip"
    case emergency = "Emergency Contacts"
    case photos = "Photo Gallery"
    case resources = "Resources"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dailySummary: return "chart.bar.fill"
        case .quickActions: return "bolt.fill"
        case .babyStatus: return "heart.fill"
        case .appointments: return "calendar"
        case .moodTracker: return "face.smiling"
        case .milestones: return "star.fill"
        case .tips: return "lightbulb.fill"
        case .emergency: return "phone.fill"
        case .photos: return "photo.fill"
        case .resources: return "book.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .dailySummary: return .blue
        case .quickActions: return .green
        case .babyStatus: return .red
        case .appointments: return .orange
        case .moodTracker: return .purple
        case .milestones: return .yellow
        case .tips: return .indigo
        case .emergency: return .red
        case .photos: return .pink
        case .resources: return .teal
        }
    }
    
    var description: String {
        switch self {
        case .dailySummary: return "Key metrics and progress"
        case .quickActions: return "One-tap common tasks"
        case .babyStatus: return "Current health status"
        case .appointments: return "Today's schedule"
        case .moodTracker: return "Track your wellbeing"
        case .milestones: return "Recent achievements"
        case .tips: return "Daily parenting advice"
        case .emergency: return "Important contacts"
        case .photos: return "Baby's photo gallery"
        case .resources: return "Helpful resources"
        }
    }
}

// MARK: - Dashboard Card
struct DashboardCard: View {
    let cardType: DashboardCardType
    let isEnabled: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: cardType.icon)
                .font(.title2)
                .foregroundColor(isEnabled ? cardType.color : .gray)
                .frame(width: 32)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(cardType.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isEnabled ? .white : .gray)
                
                Text(cardType.description)
                    .font(.caption)
                    .foregroundColor(isEnabled ? .white.opacity(0.7) : .gray.opacity(0.7))
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: { onToggle($0) }
            ))
            .toggleStyle(SwitchToggleStyle(tint: cardType.color))
        }
        .padding()
        .background(Color.white.opacity(isEnabled ? 0.1 : 0.05))
        .cornerRadius(12)
    }
}

// MARK: - Dashboard Settings View
struct DashboardSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("enabledDashboardCards") private var enabledCardsData: Data = Data()
    @State private var enabledCards: Set<DashboardCardType> = []
    @State private var originalEnabledCards: Set<DashboardCardType> = []
    
    // Computed property to check if all cards are enabled
    private var allCardsEnabled: Bool {
        enabledCards.count == DashboardCardType.allCases.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Customize Dashboard")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Choose what appears on your home screen")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                        
                        // Enable All/Disable All Toggle
                        HStack {
                            Text(allCardsEnabled ? "Disable All Cards" : "Enable All Cards")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: toggleAllCards) {
                                HStack(spacing: 6) {
                                    Image(systemName: allCardsEnabled ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundColor(allCardsEnabled ? .green : .gray)
                                    
                                    Text(allCardsEnabled ? "All Enabled" : "Enable All")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(allCardsEnabled ? .green : .white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(allCardsEnabled ? 0.15 : 0.05))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Cards List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(DashboardCardType.allCases) { cardType in
                                DashboardCard(
                                    cardType: cardType,
                                    isEnabled: enabledCards.contains(cardType)
                                ) { isEnabled in
                                    if isEnabled {
                                        enabledCards.insert(cardType)
                                    } else {
                                        enabledCards.remove(cardType)
                                    }
                                    // Don't auto-save, only save when "Save" button is pressed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Restore original settings
                        enabledCards = originalEnabledCards
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEnabledCards()
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadEnabledCards()
        }
    }
    
    private func loadEnabledCards() {
        if let data = try? JSONDecoder().decode(Set<DashboardCardType>.self, from: enabledCardsData) {
            enabledCards = data
        } else {
            // Default enabled cards
            enabledCards = [.dailySummary, .quickActions, .babyStatus, .appointments]
        }
        // Store original state for cancel functionality
        originalEnabledCards = enabledCards
    }
    
    private func saveEnabledCards() {
        if let data = try? JSONEncoder().encode(enabledCards) {
            enabledCardsData = data
        }
    }
    
    private func toggleAllCards() {
        if allCardsEnabled {
            // Disable all cards
            enabledCards.removeAll()
        } else {
            // Enable all cards
            enabledCards = Set(DashboardCardType.allCases)
        }
        // Don't auto-save, only save when "Save" button is pressed
    }
}

// MARK: - Dashboard Card Content Views
struct DailySummaryCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    
    private var todaysFeedings: Int {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return dataManager.feedingRecords.filter { record in
            record.date >= today && record.date < tomorrow
        }.count
    }
    
    private var todaysNappies: Int {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return dataManager.nappyRecords.filter { record in
            record.date >= today && record.date < tomorrow
        }.count
    }
    
    private var latestWeight: String {
        guard let baby = dataManager.baby else { return "N/A" }
        if let latestEntry = baby.weightHistory.sorted(by: { $0.date > $1.date }).first {
            return String(format: "%.1f kg", latestEntry.weight)
        } else if let weight = baby.weight {
            return String(format: "%.1f kg", weight)
        }
        return "No records"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Daily Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            
            if let baby = dataManager.baby {
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Current Weight")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(latestWeight)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Age")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(baby.ageInDays) days")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Feeds Today")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(todaysFeedings)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Nappies Today")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(todaysNappies)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                }
            } else {
                Text("Add baby information to see daily summary")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct QuickActionsCard: View {
    @State private var showingFeedingLog = false
    @State private var showingMilestone = false
    @State private var showingWeightEntry = false
    @State private var showingSkinToSkinTimer = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Quick Actions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                QuickActionButton(title: "Log Feeding", icon: "drop.fill", color: .blue) {
                    showingFeedingLog = true
                }
                QuickActionButton(title: "Add Milestone", icon: "star.fill", color: .yellow) {
                    showingMilestone = true
                }
                QuickActionButton(title: "Record Weight", icon: "scalemass.fill", color: .orange) {
                    showingWeightEntry = true
                }
                QuickActionButton(title: "Skin-to-Skin", icon: "heart.fill", color: .red) {
                    showingSkinToSkinTimer = true
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .sheet(isPresented: $showingFeedingLog) {
            FeedingLogView()
        }
        .sheet(isPresented: $showingMilestone) {
            NewMilestoneView()
        }
        .sheet(isPresented: $showingWeightEntry) {
            WeightEntryView()
        }
        .sheet(isPresented: $showingSkinToSkinTimer) {
            SkinToSkinTimerView()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BabyStatusCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("Baby's Status")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            
            if dataManager.baby != nil {
                VStack(spacing: 8) {
                    StatusRow(title: "Breathing", status: "Stable", color: .green)
                    StatusRow(title: "Feeding", status: "Tube + Bottle", color: .blue)
                    StatusRow(title: "Temperature", status: "Normal", color: .green)
                    StatusRow(title: "Oxygen", status: "Room Air", color: .green)
                }
            } else {
                Text("Add baby information to see status")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatusRow: View {
    let title: String
    let status: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(status)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

struct AppointmentsCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    
    var todaysAppointments: [Appointment] {
        let today = Date()
        return dataManager.appointments.filter { appointment in
            Calendar.current.isDate(appointment.startDate, inSameDayAs: today)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Today's Schedule")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            
            if todaysAppointments.isEmpty {
                Text("No appointments today")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(todaysAppointments.prefix(3).enumerated()), id: \.offset) { index, appointment in
                        AppointmentRow(appointment: appointment)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(appointment.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text(appointment.startDate, style: .time)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            Text(appointment.type.rawValue)
                .font(.caption)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.3))
                .foregroundColor(.blue)
                .cornerRadius(4)
        }
    }
}

// MARK: - Additional Dashboard Cards

struct DadMoodCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @AppStorage("savedMoodEntries") private var savedMoodEntriesData: Data = Data()
    @State private var savedMoodEntries: [MoodEntry] = []
    
    private var todaysMood: MoodEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return savedMoodEntries.filter { entry in
            entry.date >= today && entry.date < tomorrow
        }.sorted(by: { $0.date > $1.date }).first
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "face.smiling")
                    .font(.title2)
                    .foregroundColor(.purple)
                Text("Dad's Mood")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: DadWellnessView()) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if let mood = todaysMood {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(mood.mood.emoji)
                            .font(.title)
                        Text(mood.mood.rawValue)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Mood")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(mood.notes.isEmpty ? "No notes recorded" : mood.notes)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            } else {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("😐")
                            .font(.title)
                        Text("No entry")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Mood")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Tap to record your mood for today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            loadSavedMoods()
        }
    }
    
    private func loadSavedMoods() {
        if let data = try? JSONDecoder().decode([MoodEntry].self, from: savedMoodEntriesData) {
            savedMoodEntries = data
        }
    }
}

struct RecentMilestonesCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                Text("Recent Milestones")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: MilestonesView()) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Content
            MilestoneContentView(milestones: dataManager.milestones)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MilestoneContentView: View {
    let milestones: [Milestone]
    
    var body: some View {
        if milestones.isEmpty {
            Text("No milestones recorded yet")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        } else {
            VStack(spacing: 8) {
                ForEach(Array(milestones.prefix(3).enumerated()), id: \.offset) { index, milestone in
                    MilestoneRowView(milestone: milestone)
                }
            }
        }
    }
}

struct MilestoneRowView: View {
    let milestone: Milestone
    
    var body: some View {
        HStack {
            Text("⭐")
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(milestone.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                if let achievedDate = milestone.achievedDate {
                    Text(achievedDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text("Not achieved yet")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            Spacer()
        }
    }
}

struct DailyTipCard: View {
    private let tips = [
        "Skin-to-skin contact helps regulate baby's temperature and heart rate",
        "Your voice is familiar and comforting to your baby",
        "Small improvements each day are still progress",
        "It's okay to feel overwhelmed - seek support when needed",
        "Celebrate tiny victories in the NICU journey"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundColor(.indigo)
                Text("Daily Tip")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: ParentingTipsView()) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Text(tips.randomElement() ?? tips[0])
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct EmergencyContactsCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @AppStorage("emergencyContacts") private var emergencyContactsData: Data = Data()
    @State private var emergencyContacts: [EmergencyContact] = []
    
    private var defaultContacts: [EmergencyContact] {
        [
            EmergencyContact(name: "NICU Direct", relationship: "Medical", phoneNumber: "999", isEmergency: true, canPickup: false),
            EmergencyContact(name: "Hospital Main", relationship: "Medical", phoneNumber: "101", isEmergency: false, canPickup: false),
            EmergencyContact(name: "Emergency Services", relationship: "Emergency", phoneNumber: "999", isEmergency: true, canPickup: false)
        ]
    }
    
    private var displayContacts: [EmergencyContact] {
        if emergencyContacts.isEmpty {
            return Array(defaultContacts.prefix(2))
        } else {
            return Array(emergencyContacts.filter { $0.isEmergency }.prefix(2))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "phone.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("Emergency Contacts")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: EmergencyContactsView()) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack(spacing: 8) {
                ForEach(displayContacts) { contact in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(contact.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            Text(contact.relationship)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Button(action: {
                            if let url = URL(string: "tel://\(contact.phoneNumber)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "phone.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                if displayContacts.isEmpty {
                    Text("No emergency contacts set up")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            loadEmergencyContacts()
        }
    }
    
    private func loadEmergencyContacts() {
        if let data = try? JSONDecoder().decode([EmergencyContact].self, from: emergencyContactsData) {
            emergencyContacts = data
        }
    }
}

struct PhotoGalleryCard: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingPhotoGallery = false
    
    var body: some View {
        Button {
            showingPhotoGallery = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                        .foregroundColor(.pink)
                    Text("Photo Gallery")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // Photo thumbnails and count
                HStack(spacing: 8) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title3)
                                    .foregroundColor(.white.opacity(0.6))
                            )
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("12")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Photos")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .sheet(isPresented: $showingPhotoGallery) {
            PhotoGalleryView()
        }
    }
}

struct PhotoGalleryView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Photo Gallery")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Capture precious moments")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Grid of Photos
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(0..<12) { _ in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.1))
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.6))
                                    )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add photo action
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct ResourcesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.title2)
                    .foregroundColor(.teal)
                Text("Resources")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: InformationHubView()) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundColor(.teal)
                        .frame(width: 16)
                    Text("NICU Parent Guide")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "video")
                        .font(.caption)
                        .foregroundColor(.teal)
                        .frame(width: 16)
                    Text("Care Instructions")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "heart")
                        .font(.caption)
                        .foregroundColor(.teal)
                        .frame(width: 16)
                    Text("Support Groups")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views

struct SkinToSkinTimerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isTimerRunning = false
    @State private var startTime = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var sessionNotes = ""
    @State private var showingHistory = false
    
    private var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 20) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.red)
                        
                        Text("Skin-to-Skin Timer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Track your bonding time with baby")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Timer Section - Center of screen
                    VStack(spacing: 40) {
                        Text(formattedTime)
                            .font(.system(size: 72, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Button(action: toggleTimer) {
                            HStack(spacing: 12) {
                                Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                    .font(.title2)
                                Text(isTimerRunning ? "Pause" : "Start")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(isTimerRunning ? Color.orange : Color.green)
                            .cornerRadius(30)
                        }
                    }
                    
                    Spacer()
                    
                    // Notes Section - Bottom
                    if elapsedTime > 0 {
                        VStack(spacing: 20) {
                            Text("Session Notes")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            TextField("How was the session?", text: $sessionNotes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3)
                                .padding(.horizontal, 20)
                            
                            Button("Save Session") {
                                saveSession()
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(Color.blue)
                            .cornerRadius(25)
                        }
                        .padding(.bottom, 40)
                    } else {
                        // Spacer to maintain layout when no notes section
                        Spacer()
                            .frame(height: 120)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button("Close") {
                            stopTimer()
                            dismiss()
                        }
                        .foregroundColor(.white)
                        
                        Button {
                            showingHistory = true
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingHistory) {
            SkinToSkinHistoryView()
        }
    }
    
    private func toggleTimer() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
        isTimerRunning.toggle()
    }
    
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func saveSession() {
        stopTimer()
        dismiss()
    }
}
