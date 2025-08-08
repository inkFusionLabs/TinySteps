//
//  BabyData.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import SwiftUI

// MARK: - Date Formatters
let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    return df
}()

// MARK: - Enums

enum MilestoneCategory: String, CaseIterable, Codable {
    case all = "All"
    case physical = "Physical"
    case cognitive = "Cognitive"
    case social = "Social"
    case language = "Language"
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .physical: return "figure.walk"
        case .cognitive: return "brain.head.profile"
        case .social: return "person.2.fill"
        case .language: return "message.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .physical: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
        case .cognitive: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
        case .social: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
        case .language: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
        }
    }
}

enum ReminderCategory: String, CaseIterable, Codable {
    case all = "All"
    case feeding = "Feeding"
    case nappy = "Nappy"
    case sleep = "Sleep"
    case medical = "Medical"
    case personal = "Personal"
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .feeding: return "drop.fill"
        case .nappy: return "drop"
        case .sleep: return "bed.double.fill"
        case .medical: return "cross.fill"
        case .personal: return "person.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .feeding: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
        case .nappy: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
        case .sleep: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
        case .medical: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
        case .personal: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
        }
    }
}

// Enhanced Baby Data Models
struct Baby: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var birthDate: Date
    var weight: Double?
    var height: Double?
    var dueDate: Date?
    var gender: Gender
    var photoURL: String?
    var feedingMethod: String?
    var weightHistory: [WeightEntry] = []
    var heightHistory: [MeasurementEntry] = []
    var headCircumferenceHistory: [MeasurementEntry] = []
    // Add health visitor visits
    var healthVisitorVisits: [HealthVisitorVisit] = []
    
    enum Gender: String, CaseIterable, Codable {
        case boy = "Boy"
        case girl = "Girl"
        case unknown = "Unknown"
    }
    
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var ageInWeeks: Int {
        Calendar.current.dateComponents([.weekOfYear], from: birthDate, to: Date()).weekOfYear ?? 0
    }
    
    var isPremature: Bool {
        guard let dueDate = dueDate else { return false }
        return birthDate < dueDate
    }
    
    var adjustedAgeInDays: Int {
        guard let dueDate = dueDate else { return ageInDays }
        return Calendar.current.dateComponents([.day], from: dueDate, to: Date()).day ?? 0
    }
}

// Vaccination Record
struct VaccinationRecord: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let date: Date
    var isCompleted: Bool
    let notes: String?
}

// Solid Food Record
struct SolidFoodRecord: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let foodName: String
    let reaction: FoodReaction
    let notes: String?
    
    enum FoodReaction: String, CaseIterable, Codable {
        case loved = "Loved it"
        case liked = "Liked it"
        case neutral = "Neutral"
        case disliked = "Disliked it"
        case allergic = "Allergic reaction"
        
        var icon: String {
            switch self {
            case .loved: return "heart.fill"
            case .liked: return "heart"
            case .neutral: return "face.neutral"
            case .disliked: return "face.dashed"
            case .allergic: return "exclamationmark.triangle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .loved: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .liked: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .neutral: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .disliked: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .allergic: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            }
        }
    }
}

// Measurement Entry for height and head circumference
struct MeasurementEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var value: Double
    var notes: String?
}

// Enhanced Feeding Records
struct FeedingRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let date: Date
    let type: FeedingType
    let amount: Double? // in ml
    let duration: Double? // in minutes
    let notes: String?
    let side: BreastSide?
    
    enum FeedingType: String, CaseIterable, Codable {
        case breast = "Breast"
        case bottle = "Bottle"
        case mixed = "Mixed"
        
        var icon: String {
            switch self {
            case .breast: return "drop.fill"
            case .bottle: return "bottle.fill"
            case .mixed: return "drop"
            }
        }
        
        var color: Color {
            switch self {
            case .breast: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .bottle: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .mixed: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            }
        }
    }
    
    enum BreastSide: String, CaseIterable, Codable {
        case left = "Left"
        case right = "Right"
        case both = "Both"
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FeedingRecord, rhs: FeedingRecord) -> Bool {
        return lhs.id == rhs.id
    }
}

// Enhanced Nappy Records
struct NappyRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let date: Date
    let type: NappyType
    let notes: String?
    
    enum NappyType: String, CaseIterable, Codable {
        case wet = "Wet"
        case dirty = "Dirty"
        case both = "Both"
        
        var icon: String {
            switch self {
            case .wet: return "drop"
            case .dirty: return "drop.fill"
            case .both: return "drop"
            }
        }
        
        var color: Color {
            switch self {
            case .wet: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .dirty: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .both: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            }
        }
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NappyRecord, rhs: NappyRecord) -> Bool {
        return lhs.id == rhs.id
    }
}

// New Sleep Records
struct SleepRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let startTime: Date
    let endTime: Date?
    let duration: Double? // in minutes
    let location: SleepLocation
    let notes: String?
    let sleepQuality: SleepQuality?
    
    enum SleepQuality: String, CaseIterable, Codable {
        case excellent = "Excellent"
        case good = "Good"
        case fair = "Fair"
        case poor = "Poor"
        
        var icon: String {
            switch self {
            case .excellent: return "star.fill"
            case .good: return "star"
            case .fair: return "star.leadinghalf.filled"
            case .poor: return "star.slash"
            }
        }
        
        var color: Color {
            switch self {
            case .excellent: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .good: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .fair: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .poor: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            }
        }
    }
    
    enum SleepLocation: String, CaseIterable, Codable {
        case crib = "Crib"
        case bassinet = "Bassinet"
        case parentBed = "Parent Bed"
        case car = "Car"
        case stroller = "Stroller"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .crib: return "bed.double.fill"
            case .bassinet: return "bed.double"
            case .parentBed: return "bed.double.fill"
            case .car: return "car.fill"
            case .stroller: return "figure.walk"
            case .other: return "bed.double"
            }
        }
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SleepRecord, rhs: SleepRecord) -> Bool {
        return lhs.id == rhs.id
    }
}

// New Milestone Tracking
// Add a period enum for filtering
enum MilestonePeriod: Codable, Equatable {
    case months(Int)
    case years(Int)
    
    var description: String {
        switch self {
        case .months(let m): return "\(m) months"
        case .years(let y): return "\(y) years"
        }
    }
}

// Update Milestone struct to include period
struct Milestone: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    let category: MilestoneCategory
    var achievedDate: Date?
    let expectedAge: Int // in weeks
    var isAchieved: Bool
    let notes: String?
    let ageRange: String
    let period: MilestonePeriod // new
    
    init(title: String, description: String, category: MilestoneCategory, achievedDate: Date?, expectedAge: Int, isAchieved: Bool, notes: String?, ageRange: String, period: MilestonePeriod) {
        self.title = title
        self.description = description
        self.category = category
        self.achievedDate = achievedDate
        self.expectedAge = expectedAge
        self.isAchieved = isAchieved
        self.notes = notes
        self.ageRange = ageRange
        self.period = period
    }
}

// New Dad Achievement System
struct DadAchievement: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    let icon: String
    let category: AchievementCategory
    var achievedDate: Date?
    var isAchieved: Bool
    var progress: Double // 0.0 to 1.0
    let targetValue: Int
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case firsts = "Firsts"
        case bonding = "Bonding"
        case care = "Care"
        case support = "Support"
        case learning = "Learning"
        
        var color: Color {
            switch self {
            case .firsts: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .bonding: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .care: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .support: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .learning: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            }
        }
    }
}

// New Reminder System
struct Reminder: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String?
    let date: Date
    var isCompleted: Bool
    let category: ReminderCategory
    let repeatType: RepeatType
    let time: String
    let notes: String?
    
    init(title: String, description: String?, date: Date, isCompleted: Bool, category: ReminderCategory, repeatType: RepeatType, time: String, notes: String?) {
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
        self.category = category
        self.repeatType = repeatType
        self.time = time
        self.notes = notes
    }
    
    enum RepeatType: String, CaseIterable, Codable {
        case none = "None"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
}

// New Photo Gallery & Memory System
struct PhotoMemory: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let imageData: Data
    let caption: String?
    let tags: [String]
    let location: String?
    let milestone: String?
    
    enum MemoryType: String, CaseIterable, Codable {
        case firstPhoto = "First Photo"
        case hospital = "Hospital"
        case homecoming = "Homecoming"
        case milestone = "Milestone"
        case daily = "Daily"
        case special = "Special"
        
        var icon: String {
            switch self {
            case .firstPhoto: return "camera.fill"
            case .hospital: return "cross.fill"
            case .homecoming: return "house.fill"
            case .milestone: return "star.fill"
            case .daily: return "calendar"
            case .special: return "heart.fill"
            }
        }
    }
}

// Dad's Wellness Tracker
struct WellnessEntry: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let sleepHours: Double
    let stressLevel: StressLevel
    let energyLevel: EnergyLevel
    let mood: Mood
    let notes: String?
    let activities: [WellnessActivity]
    
    enum StressLevel: String, CaseIterable, Codable {
        case low = "Low"
        case moderate = "Moderate"
        case high = "High"
        case veryHigh = "Very High"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .moderate: return .yellow
            case .high: return .orange
            case .veryHigh: return .red
            }
        }
    }
    
    enum EnergyLevel: String, CaseIterable, Codable {
        case veryLow = "Very Low"
        case low = "Low"
        case moderate = "Moderate"
        case high = "High"
        case veryHigh = "Very High"
        
        var color: Color {
            switch self {
            case .veryLow: return .red
            case .low: return .orange
            case .moderate: return .yellow
            case .high: return .lightGreen
            case .veryHigh: return .green
            }
        }
    }
    
    enum Mood: String, CaseIterable, Codable {
        case excited = "Excited"
        case happy = "Happy"
        case content = "Content"
        case tired = "Tired"
        case stressed = "Stressed"
        case overwhelmed = "Overwhelmed"
        
        var emoji: String {
            switch self {
            case .excited: return "🤗"
            case .happy: return "😊"
            case .content: return "😌"
            case .tired: return "😴"
            case .stressed: return "😟"
            case .overwhelmed: return "😰"
            }
        }
    }
    
    enum WellnessActivity: String, CaseIterable, Codable {
        case exercise = "Exercise"
        case meditation = "Meditation"
        case reading = "Reading"
        case socializing = "Socializing"
        case rest = "Rest"
        case selfCare = "Self Care"
        
        var icon: String {
            switch self {
            case .exercise: return "figure.walk"
            case .meditation: return "brain.head.profile"
            case .reading: return "book.fill"
            case .socializing: return "person.2.fill"
            case .rest: return "bed.double.fill"
            case .selfCare: return "heart.fill"
            }
        }
    }
}

// Partner Support Hub
struct PartnerSupport: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let type: SupportType
    let description: String
    let duration: Double? // in minutes
    let notes: String?
    let partnerMood: PartnerMood?
    
    enum SupportType: String, CaseIterable, Codable {
        case emotional = "Emotional Support"
        case practical = "Practical Help"
        case decisionMaking = "Decision Making"
        case rest = "Rest Support"
        case feeding = "Feeding Support"
        case medical = "Medical Support"
        
        var icon: String {
            switch self {
            case .emotional: return "heart.fill"
            case .practical: return "hand.raised.fill"
            case .decisionMaking: return "brain.head.profile"
            case .rest: return "bed.double.fill"
            case .feeding: return "drop.fill"
            case .medical: return "cross.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .emotional: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .practical: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .decisionMaking: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .rest: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .feeding: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            case .medical: return Color(red: 0.1, green: 0.2, blue: 0.7) // Medium-dark blue
            }
        }
    }
    
    enum PartnerMood: String, CaseIterable, Codable {
        case grateful = "Grateful"
        case supported = "Supported"
        case tired = "Tired"
        case stressed = "Stressed"
        case happy = "Happy"
        case overwhelmed = "Overwhelmed"
        
        var emoji: String {
            switch self {
            case .grateful: return "🙏"
            case .supported: return "🤗"
            case .tired: return "😴"
            case .stressed: return "😟"
            case .happy: return "😊"
            case .overwhelmed: return "😰"
            }
        }
    }
}

// Emergency Contacts & Quick Actions
struct EmergencyContact: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var relationship: String
    var phoneNumber: String
    var isEmergency: Bool
    var canPickup: Bool
    var notes: String?
    
    enum ContactType: String, CaseIterable, Codable {
        case partner = "Partner"
        case family = "Family"
        case friend = "Friend"
        case medical = "Medical"
        case childcare = "Childcare"
        
        var icon: String {
            switch self {
            case .partner: return "heart.fill"
            case .family: return "person.3.fill"
            case .friend: return "person.2.fill"
            case .medical: return "cross.fill"
            case .childcare: return "baby.fill"
            }
        }
    }
}

struct QuickAction: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    let actionType: ActionType
    let isEnabled: Bool
    var lastUsed: Date?
    
    enum ActionType: String, CaseIterable, Codable {
        case callPartner = "Call Partner"
        case callHospital = "Call Hospital"
        case callPediatrician = "Call Pediatrician"
        case emergencyServices = "Emergency Services"
        case lactationConsultant = "Lactation Consultant"
        case mentalHealth = "Mental Health Support"
        
        var icon: String {
            switch self {
            case .callPartner: return "phone.fill"
            case .callHospital: return "cross.fill"
            case .callPediatrician: return "stethoscope"
            case .emergencyServices: return "exclamationmark.triangle.fill"
            case .lactationConsultant: return "drop.fill"
            case .mentalHealth: return "brain.head.profile"
            }
        }
        
        var color: Color {
            switch self {
            case .callPartner: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .callHospital: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .callPediatrician: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .emergencyServices: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .lactationConsultant: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            case .mentalHealth: return Color(red: 0.1, green: 0.2, blue: 0.7) // Medium-dark blue
            }
        }
    }
}

// Growth Predictions & Development Tracking
struct GrowthPrediction: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let predictedWeight: Double
    let predictedHeight: Double
    let predictedHeadCircumference: Double
    let confidence: Double // 0.0 to 1.0
    let notes: String?
}

struct DevelopmentChecklist: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    let category: DevelopmentCategory
    let expectedAge: Int // in weeks
    var isCompleted: Bool
    var completedDate: Date?
    let notes: String?
    
    enum DevelopmentCategory: String, CaseIterable, Codable {
        case neonatal = "Neonatal"
        case earlyInfancy = "Early Infancy"
        case lateInfancy = "Late Infancy"
        case toddler = "Toddler"
        
        var icon: String {
            switch self {
            case .neonatal: return "baby.fill"
            case .earlyInfancy: return "figure.and.child.holdinghands"
            case .lateInfancy: return "figure.walk"
            case .toddler: return "figure.run"
            }
        }
    }
}

// Enhanced Baby Data Models
struct WeightEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var weight: Double // in kg
    var location: String? // Hospital, Home, Clinic
    var notes: String?
}

// Health Visitor Visit Record
struct HealthVisitorVisit: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let date: Date
    let notes: String?
    let weight: Double? // in kg
    let height: Double? // in cm
    let headCircumference: Double? // in cm
}

// Enhanced Data Manager
class BabyDataManager: ObservableObject {
    @Published var baby: Baby?
    @Published var feedingRecords: [FeedingRecord] = []
    @Published var nappyRecords: [NappyRecord] = []
    @Published var sleepRecords: [SleepRecord] = []
    @Published var milestones: [Milestone] = []
    @Published var achievements: [DadAchievement] = []
    @Published var reminders: [Reminder] = []
    @Published var vaccinations: [VaccinationRecord] = []
    @Published var solidFoodRecords: [SolidFoodRecord] = []
    @Published var wellnessEntries: [WellnessEntry] = []
    @Published var partnerSupports: [PartnerSupport] = []
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var quickActions: [QuickAction] = []
    @Published var growthPredictions: [GrowthPrediction] = []
    @Published var developmentChecklists: [DevelopmentChecklist] = []
    @Published var appointments: [Appointment] = []
    @Published var healthVisitorVisits: [HealthVisitorVisit] = []
    
    // Performance optimizations
    private let userDefaults = UserDefaults.standard
    private var isDataLoaded = false
    private var lastSaveTime: Date = Date()
    private let saveDebounceInterval: TimeInterval = 1.0 // Save only once per second
    private var saveTimer: Timer?
    
    // Cached computed values
    private var cachedTodayFeedingCount: Int?
    private var cachedTodayNappyCount: Int?
    private var cachedTodaySleepHours: Double?
    private var cachedLastFeeding: FeedingRecord?
    private var lastCacheUpdate: Date = Date()
    private let cacheValidityDuration: TimeInterval = 300 // 5 minutes
    
    // Lazy loading support
    private var isInitialized = false
    
    init() {
        loadData()
        setupDefaultMilestones()
        setupDefaultAchievements()
        isInitialized = true
    }
    
    // MARK: - Data Recovery
    
    func clearAllData() {
        // Clear all UserDefaults data
        let keys = ["baby", "feedingRecords", "nappyRecords", "sleepRecords", "milestones", "achievements", "reminders", "vaccinations", "solidFoodRecords", "wellnessEntries", "partnerSupports", "emergencyContacts", "quickActions", "growthPredictions", "developmentChecklists", "appointments"]
        
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
        
        // Reset in-memory data
        setDefaultData()
        isDataLoaded = true
    }
    
    // MARK: - Performance Optimized Data Loading
    
    private func loadData() {
        guard !isDataLoaded else { return }
        
        // Load data in background to avoid blocking UI
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let loadedData = self.loadDataFromStorage()
            
            DispatchQueue.main.async {
                self.applyLoadedData(loadedData)
                self.isDataLoaded = true
            }
        }
    }
    
    private func setDefaultData() {
        // Set empty arrays for all data types to prevent crashes
        feedingRecords = []
        nappyRecords = []
        sleepRecords = []
        milestones = []
        achievements = []
        reminders = []
        vaccinations = []
        solidFoodRecords = []
        wellnessEntries = []
        partnerSupports = []
        emergencyContacts = []
        quickActions = []
        growthPredictions = []
        developmentChecklists = []
        appointments = []
        healthVisitorVisits = []
        
        // Setup default data
        setupDefaultMilestones()
        setupDefaultAchievements()
    }
    
    private func loadDataFromStorage() -> [String: Any] {
        var data: [String: Any] = [:]
        
        // Load all data sequentially to avoid race conditions
        // Baby data
        if let babyData = self.userDefaults.data(forKey: "baby") {
            do {
                let baby = try JSONDecoder().decode(Baby.self, from: babyData)
                data["baby"] = baby
            } catch {
                print("Error decoding baby data: \(error)")
            }
        }
        
        // Feeding records
        if let feedingData = self.userDefaults.data(forKey: "feedingRecords") {
            do {
                let feedings = try JSONDecoder().decode([FeedingRecord].self, from: feedingData)
                data["feedingRecords"] = feedings
            } catch {
                print("Error decoding feeding records: \(error)")
            }
        }
        
        // Nappy records
        if let nappyData = self.userDefaults.data(forKey: "nappyRecords") {
            do {
                let nappies = try JSONDecoder().decode([NappyRecord].self, from: nappyData)
                data["nappyRecords"] = nappies
            } catch {
                print("Error decoding nappy records: \(error)")
            }
        }
        
        // Sleep records
        if let sleepData = self.userDefaults.data(forKey: "sleepRecords") {
            do {
                let sleeps = try JSONDecoder().decode([SleepRecord].self, from: sleepData)
                data["sleepRecords"] = sleeps
            } catch {
                print("Error decoding sleep records: \(error)")
            }
        }
        
        // Milestones
        if let milestoneData = self.userDefaults.data(forKey: "milestones") {
            do {
                let milestones = try JSONDecoder().decode([Milestone].self, from: milestoneData)
                data["milestones"] = milestones
            } catch {
                print("Error decoding milestones: \(error)")
            }
        }
        
        // Achievements
        if let achievementData = self.userDefaults.data(forKey: "achievements") {
            do {
                let achievements = try JSONDecoder().decode([DadAchievement].self, from: achievementData)
                data["achievements"] = achievements
            } catch {
                print("Error decoding achievements: \(error)")
            }
        }
        
        // Reminders
        if let reminderData = self.userDefaults.data(forKey: "reminders") {
            do {
                let reminders = try JSONDecoder().decode([Reminder].self, from: reminderData)
                data["reminders"] = reminders
            } catch {
                print("Error decoding reminders: \(error)")
            }
        }
        
        // Vaccinations
        if let vaccinationData = self.userDefaults.data(forKey: "vaccinations") {
            do {
                let vaccinations = try JSONDecoder().decode([VaccinationRecord].self, from: vaccinationData)
                data["vaccinations"] = vaccinations
            } catch {
                print("Error decoding vaccinations: \(error)")
            }
        }
        
        // Solid food records
        if let solidFoodData = self.userDefaults.data(forKey: "solidFoodRecords") {
            do {
                let solidFoodRecords = try JSONDecoder().decode([SolidFoodRecord].self, from: solidFoodData)
                data["solidFoodRecords"] = solidFoodRecords
            } catch {
                print("Error decoding solid food records: \(error)")
            }
        }
        
        // Wellness entries
        if let wellnessData = self.userDefaults.data(forKey: "wellnessEntries") {
            do {
                let wellnessEntries = try JSONDecoder().decode([WellnessEntry].self, from: wellnessData)
                data["wellnessEntries"] = wellnessEntries
            } catch {
                print("Error decoding wellness entries: \(error)")
            }
        }
        
        // Partner supports
        if let partnerData = self.userDefaults.data(forKey: "partnerSupports") {
            do {
                let partnerSupports = try JSONDecoder().decode([PartnerSupport].self, from: partnerData)
                data["partnerSupports"] = partnerSupports
            } catch {
                print("Error decoding partner supports: \(error)")
            }
        }
        
        // Emergency contacts
        if let contactData = self.userDefaults.data(forKey: "emergencyContacts") {
            do {
                let emergencyContacts = try JSONDecoder().decode([EmergencyContact].self, from: contactData)
                data["emergencyContacts"] = emergencyContacts
            } catch {
                print("Error decoding emergency contacts: \(error)")
            }
        }
        
        // Quick actions
        if let quickActionData = self.userDefaults.data(forKey: "quickActions") {
            do {
                let quickActions = try JSONDecoder().decode([QuickAction].self, from: quickActionData)
                data["quickActions"] = quickActions
            } catch {
                print("Error decoding quick actions: \(error)")
            }
        }
        
        // Growth predictions
        if let growthData = self.userDefaults.data(forKey: "growthPredictions") {
            do {
                let growthPredictions = try JSONDecoder().decode([GrowthPrediction].self, from: growthData)
                data["growthPredictions"] = growthPredictions
            } catch {
                print("Error decoding growth predictions: \(error)")
            }
        }
        
        // Development checklists
        if let checklistData = self.userDefaults.data(forKey: "developmentChecklists") {
            do {
                let developmentChecklists = try JSONDecoder().decode([DevelopmentChecklist].self, from: checklistData)
                data["developmentChecklists"] = developmentChecklists
            } catch {
                print("Error decoding development checklists: \(error)")
            }
        }
        
        // Appointments
        if let appointmentData = self.userDefaults.data(forKey: "appointments") {
            do {
                let appointments = try JSONDecoder().decode([Appointment].self, from: appointmentData)
                data["appointments"] = appointments
            } catch {
                print("Error decoding appointments: \(error)")
            }
        }
        
        // Health visitor visits
        if let visitData = self.userDefaults.data(forKey: "healthVisitorVisits") {
            do {
                let healthVisitorVisits = try JSONDecoder().decode([HealthVisitorVisit].self, from: visitData)
                data["healthVisitorVisits"] = healthVisitorVisits
            } catch {
                print("Error decoding health visitor visits: \(error)")
            }
        }
        
        return data
    }
    
    private func applyLoadedData(_ data: [String: Any]) {
        baby = data["baby"] as? Baby
        feedingRecords = data["feedingRecords"] as? [FeedingRecord] ?? []
        nappyRecords = data["nappyRecords"] as? [NappyRecord] ?? []
        sleepRecords = data["sleepRecords"] as? [SleepRecord] ?? []
        milestones = data["milestones"] as? [Milestone] ?? []
        achievements = data["achievements"] as? [DadAchievement] ?? []
        reminders = data["reminders"] as? [Reminder] ?? []
        vaccinations = data["vaccinations"] as? [VaccinationRecord] ?? []
        solidFoodRecords = data["solidFoodRecords"] as? [SolidFoodRecord] ?? []
        wellnessEntries = data["wellnessEntries"] as? [WellnessEntry] ?? []
        partnerSupports = data["partnerSupports"] as? [PartnerSupport] ?? []
        emergencyContacts = data["emergencyContacts"] as? [EmergencyContact] ?? []
        quickActions = data["quickActions"] as? [QuickAction] ?? []
        growthPredictions = data["growthPredictions"] as? [GrowthPrediction] ?? []
        developmentChecklists = data["developmentChecklists"] as? [DevelopmentChecklist] ?? []
        appointments = data["appointments"] as? [Appointment] ?? []
        healthVisitorVisits = data["healthVisitorVisits"] as? [HealthVisitorVisit] ?? []
    }
    
    // MARK: - Optimized Save Data
    
    func saveData() {
        // Debounce saves to avoid excessive I/O
        saveTimer?.invalidate()
        saveTimer = Timer.scheduledTimer(withTimeInterval: saveDebounceInterval, repeats: false) { [weak self] _ in
            self?.performSave()
        }
    }
    
    private func performSave() {
        // Invalidate cache when data changes
        invalidateCache()
        
        // Save in background to avoid blocking UI
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            self.saveDataToStorage()
        }
    }
    
    private func saveDataToStorage() {
        let encoder = JSONEncoder()
        
        // Save data in parallel
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.tinysteps.datasaving", attributes: .concurrent)
        
        // Baby data
        if let baby = baby {
            group.enter()
            queue.async {
                if let babyData = try? encoder.encode(baby) {
                    self.userDefaults.set(babyData, forKey: "baby")
                }
                group.leave()
            }
        }
        
        // Records data - encode each type separately
        // Feeding records
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.feedingRecords) {
                self.userDefaults.set(data, forKey: "feedingRecords")
            }
            group.leave()
        }
        
        // Nappy records
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.nappyRecords) {
                self.userDefaults.set(data, forKey: "nappyRecords")
            }
            group.leave()
        }
        
        // Sleep records
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.sleepRecords) {
                self.userDefaults.set(data, forKey: "sleepRecords")
            }
            group.leave()
        }
        
        // Milestones
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.milestones) {
                self.userDefaults.set(data, forKey: "milestones")
            }
            group.leave()
        }
        
        // Achievements
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.achievements) {
                self.userDefaults.set(data, forKey: "achievements")
            }
            group.leave()
        }
        
        // Reminders
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.reminders) {
                self.userDefaults.set(data, forKey: "reminders")
            }
            group.leave()
        }
        
        // Vaccinations
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.vaccinations) {
                self.userDefaults.set(data, forKey: "vaccinations")
            }
            group.leave()
        }
        
        // Solid food records
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.solidFoodRecords) {
                self.userDefaults.set(data, forKey: "solidFoodRecords")
            }
            group.leave()
        }
        
        // Wellness entries
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.wellnessEntries) {
                self.userDefaults.set(data, forKey: "wellnessEntries")
            }
            group.leave()
        }
        
        // Partner supports
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.partnerSupports) {
                self.userDefaults.set(data, forKey: "partnerSupports")
            }
            group.leave()
        }
        
        // Emergency contacts
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.emergencyContacts) {
                self.userDefaults.set(data, forKey: "emergencyContacts")
            }
            group.leave()
        }
        
        // Quick actions
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.quickActions) {
                self.userDefaults.set(data, forKey: "quickActions")
            }
            group.leave()
        }
        
        // Growth predictions
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.growthPredictions) {
                self.userDefaults.set(data, forKey: "growthPredictions")
            }
            group.leave()
        }
        
        // Development checklists
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.developmentChecklists) {
                self.userDefaults.set(data, forKey: "developmentChecklists")
            }
            group.leave()
        }
        
        // Appointments
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.appointments) {
                self.userDefaults.set(data, forKey: "appointments")
            }
            group.leave()
        }
        
        // Health visitor visits
        group.enter()
        queue.async {
            if let data = try? encoder.encode(self.healthVisitorVisits) {
                self.userDefaults.set(data, forKey: "healthVisitorVisits")
            }
            group.leave()
        }
        
        group.wait()
        lastSaveTime = Date()
    }
    
    // MARK: - Cache Management
    
    private func invalidateCache() {
        cachedTodayFeedingCount = nil
        cachedTodayNappyCount = nil
        cachedTodaySleepHours = nil
        cachedLastFeeding = nil
        lastCacheUpdate = Date()
    }
    
    private func shouldUpdateCache() -> Bool {
        return Date().timeIntervalSince(lastCacheUpdate) > cacheValidityDuration
    }
    
    private func updateCache() {
        let today = Calendar.current.startOfDay(for: Date())
        
        cachedTodayFeedingCount = feedingRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
        cachedTodayNappyCount = nappyRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
        
        let todaySleeps = sleepRecords.filter { Calendar.current.isDate($0.startTime, inSameDayAs: today) }
        cachedTodaySleepHours = todaySleeps.reduce(0) { total, sleep in
            if let endTime = sleep.endTime {
                return total + endTime.timeIntervalSince(sleep.startTime) / 3600
            }
            return total
        }
        
        cachedLastFeeding = feedingRecords.last
        lastCacheUpdate = Date()
    }
    
    // MARK: - Optimized Data Methods
    
    func addFeedingRecord(_ record: FeedingRecord) {
        feedingRecords.append(record)
        invalidateCache()
        saveData()
        checkAchievements()
    }
    
    func getTodayFeedingCount() -> Int {
        if shouldUpdateCache() {
            updateCache()
        }
        return cachedTodayFeedingCount ?? 0
    }
    
    func getTodayNappyCount() -> Int {
        if shouldUpdateCache() {
            updateCache()
        }
        return cachedTodayNappyCount ?? 0
    }
    
    func getTodaySleepHours() -> Double {
        if shouldUpdateCache() {
            updateCache()
        }
        return cachedTodaySleepHours ?? 0.0
    }
    
    func getTodaySleepCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sleepRecords.filter { Calendar.current.isDate($0.startTime, inSameDayAs: today) }.count
    }
    
    func getNextFeedingTime() -> Date? {
        if shouldUpdateCache() {
            updateCache()
        }
        guard let lastFeeding = cachedLastFeeding else { return nil }
        return Calendar.current.date(byAdding: .hour, value: 3, to: lastFeeding.date)
    }
    
    func addNappyRecord(_ record: NappyRecord) {
        nappyRecords.append(record)
        invalidateCache()
        saveData()
        checkAchievements()
    }
    
    func addSleepRecord(_ record: SleepRecord) {
        sleepRecords.append(record)
        invalidateCache()
        saveData()
        checkAchievements()
    }
    
    // MARK: - Optimized Data Queries
    
    func getRecentRecords(limit: Int = 10) -> [RecordType] {
        var recentRecords: [RecordType] = []
        
        // Get recent feedings
        let recentFeedings = Array(feedingRecords.suffix(limit))
        recentRecords.append(contentsOf: recentFeedings.map { .feeding($0) })
        
        // Get recent sleep records
        let recentSleeps = Array(sleepRecords.suffix(limit))
        recentRecords.append(contentsOf: recentSleeps.map { .sleep($0) })
        
        // Get recent nappy records
        let recentNappies = Array(nappyRecords.suffix(limit))
        recentRecords.append(contentsOf: recentNappies.map { .nappy($0) })
        
        // Sort by date and return limited results
        return recentRecords.sorted { $0.recordDate > $1.recordDate }.prefix(limit).map { $0 }
    }
    
    func getRecordsForDate(_ date: Date) -> [RecordType] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        
        var dayRecords: [RecordType] = []
        
        // Get feedings for the day
        let dayFeedings = feedingRecords.filter { record in
            record.date >= startOfDay && record.date < endOfDay
        }
        dayRecords.append(contentsOf: dayFeedings.map { .feeding($0) })
        
        // Get sleep records for the day
        let daySleeps = sleepRecords.filter { record in
            record.startTime >= startOfDay && record.startTime < endOfDay
        }
        dayRecords.append(contentsOf: daySleeps.map { .sleep($0) })
        
        // Get nappy records for the day
        let dayNappies = nappyRecords.filter { record in
            record.date >= startOfDay && record.date < endOfDay
        }
        dayRecords.append(contentsOf: dayNappies.map { .nappy($0) })
        
        return dayRecords.sorted { $0.recordDate > $1.recordDate }
    }
    
    // MARK: - Performance Monitoring
    
    func getPerformanceStats() -> [String: Any] {
        return [
            "totalRecords": feedingRecords.count + nappyRecords.count + sleepRecords.count,
            "lastSaveTime": lastSaveTime,
            "cacheAge": Date().timeIntervalSince(lastCacheUpdate),
            "isDataLoaded": isDataLoaded,
            "isInitialized": isInitialized
        ]
    }
    
    // MARK: - Memory Management
    
    func cleanupOldRecords() {
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        
        // Keep only records from the last year
        feedingRecords = feedingRecords.filter { $0.date > oneYearAgo }
        nappyRecords = nappyRecords.filter { $0.date > oneYearAgo }
        sleepRecords = sleepRecords.filter { $0.startTime > oneYearAgo }
        
        invalidateCache()
        saveData()
    }
    
    func optimizeStorage() {
        // Remove duplicate records
        feedingRecords = Array(Set(feedingRecords))
        nappyRecords = Array(Set(nappyRecords))
        sleepRecords = Array(Set(sleepRecords))
        
        // Sort records for better performance
        feedingRecords.sort { $0.date > $1.date }
        nappyRecords.sort { $0.date > $1.date }
        sleepRecords.sort { $0.startTime > $1.startTime }
        
        invalidateCache()
        saveData()
    }
    
    // MARK: - Milestone Methods
    private func setupDefaultMilestones() {
        // Always ensure premade milestones are present
        let premade: [Milestone] = [
            // 0-3 Months
            Milestone(title: "Lifts head when on tummy", description: "Baby can lift their head briefly when placed on their tummy", category: .physical, achievedDate: nil, expectedAge: 4, isAchieved: false, notes: nil, ageRange: "0-1 months", period: .months(1)),
            Milestone(title: "Smiles socially", description: "Baby smiles in response to social interaction and faces", category: .social, achievedDate: nil, expectedAge: 6, isAchieved: false, notes: nil, ageRange: "1-2 months", period: .months(2)),
            Milestone(title: "Follows objects with eyes", description: "Baby follows moving objects with their eyes", category: .cognitive, achievedDate: nil, expectedAge: 8, isAchieved: false, notes: nil, ageRange: "1-2 months", period: .months(2)),
            Milestone(title: "Makes cooing sounds", description: "Baby makes cooing and gurgling sounds", category: .language, achievedDate: nil, expectedAge: 8, isAchieved: false, notes: nil, ageRange: "1-2 months", period: .months(2)),
            Milestone(title: "Rolls from tummy to back", description: "Baby can roll from tummy to back position", category: .physical, achievedDate: nil, expectedAge: 12, isAchieved: false, notes: nil, ageRange: "2-3 months", period: .months(3)),
            Milestone(title: "Reaches for objects", description: "Baby reaches for and tries to grab objects", category: .physical, achievedDate: nil, expectedAge: 12, isAchieved: false, notes: nil, ageRange: "2-3 months", period: .months(3)),
            
            // 3-6 Months
            Milestone(title: "Rolls from back to tummy", description: "Baby can roll from back to tummy position", category: .physical, achievedDate: nil, expectedAge: 16, isAchieved: false, notes: nil, ageRange: "3-4 months", period: .months(4)),
            Milestone(title: "Sits with support", description: "Baby can sit with support and hold head steady", category: .physical, achievedDate: nil, expectedAge: 20, isAchieved: false, notes: nil, ageRange: "4-5 months", period: .months(5)),
            Milestone(title: "Babbles and coos", description: "Baby makes babbling sounds and coos", category: .language, achievedDate: nil, expectedAge: 16, isAchieved: false, notes: nil, ageRange: "3-4 months", period: .months(4)),
            Milestone(title: "Laughs out loud", description: "Baby laughs out loud in response to play", category: .social, achievedDate: nil, expectedAge: 20, isAchieved: false, notes: nil, ageRange: "4-5 months", period: .months(5)),
            Milestone(title: "Recognizes familiar faces", description: "Baby recognizes and responds to familiar faces", category: .cognitive, achievedDate: nil, expectedAge: 20, isAchieved: false, notes: nil, ageRange: "4-5 months", period: .months(5)),
            Milestone(title: "Brings objects to mouth", description: "Baby brings objects to mouth to explore", category: .physical, achievedDate: nil, expectedAge: 24, isAchieved: false, notes: nil, ageRange: "5-6 months", period: .months(6)),
            
            // 6-9 Months
            Milestone(title: "Sits without support", description: "Baby can sit independently for short periods", category: .physical, achievedDate: nil, expectedAge: 24, isAchieved: false, notes: nil, ageRange: "6-7 months", period: .months(7)),
            Milestone(title: "Crawls on hands and knees", description: "Baby crawls using hands and knees", category: .physical, achievedDate: nil, expectedAge: 28, isAchieved: false, notes: nil, ageRange: "7-8 months", period: .months(8)),
            Milestone(title: "Responds to name", description: "Baby turns head when name is called", category: .language, achievedDate: nil, expectedAge: 28, isAchieved: false, notes: nil, ageRange: "7-8 months", period: .months(8)),
            Milestone(title: "Says 'mama' or 'dada'", description: "Baby says first words like mama or dada", category: .language, achievedDate: nil, expectedAge: 32, isAchieved: false, notes: nil, ageRange: "8-9 months", period: .months(9)),
            Milestone(title: "Shows stranger anxiety", description: "Baby shows anxiety around strangers", category: .social, achievedDate: nil, expectedAge: 32, isAchieved: false, notes: nil, ageRange: "8-9 months", period: .months(9)),
            Milestone(title: "Uses pincer grasp", description: "Baby picks up small objects with thumb and finger", category: .physical, achievedDate: nil, expectedAge: 36, isAchieved: false, notes: nil, ageRange: "8-9 months", period: .months(9)),
            
            // 9-12 Months
            Milestone(title: "Pulls to stand", description: "Baby pulls themselves up to standing position", category: .physical, achievedDate: nil, expectedAge: 36, isAchieved: false, notes: nil, ageRange: "9-10 months", period: .months(10)),
            Milestone(title: "Waves goodbye", description: "Baby waves goodbye when someone leaves", category: .social, achievedDate: nil, expectedAge: 36, isAchieved: false, notes: nil, ageRange: "9-10 months", period: .months(10)),
            Milestone(title: "Understands 'no'", description: "Baby understands and responds to 'no'", category: .language, achievedDate: nil, expectedAge: 40, isAchieved: false, notes: nil, ageRange: "10-11 months", period: .months(11)),
            Milestone(title: "Says 2-3 words", description: "Baby can say 2-3 words clearly", category: .language, achievedDate: nil, expectedAge: 44, isAchieved: false, notes: nil, ageRange: "11-12 months", period: .months(12)),
            Milestone(title: "Walks with support", description: "Baby walks while holding onto furniture", category: .physical, achievedDate: nil, expectedAge: 44, isAchieved: false, notes: nil, ageRange: "11-12 months", period: .months(12)),
            Milestone(title: "Plays peek-a-boo", description: "Baby enjoys and participates in peek-a-boo", category: .social, achievedDate: nil, expectedAge: 48, isAchieved: false, notes: nil, ageRange: "12 months", period: .months(12)),
            
            // 12-18 Months
            Milestone(title: "Walks independently", description: "Baby takes first steps without support", category: .physical, achievedDate: nil, expectedAge: 52, isAchieved: false, notes: nil, ageRange: "12-14 months", period: .months(14)),
            Milestone(title: "Says 5-10 words", description: "Baby can say 5-10 words clearly", category: .language, achievedDate: nil, expectedAge: 60, isAchieved: false, notes: nil, ageRange: "15-18 months", period: .months(18)),
            Milestone(title: "Points to objects", description: "Baby points to objects they want or recognize", category: .language, achievedDate: nil, expectedAge: 56, isAchieved: false, notes: nil, ageRange: "14-16 months", period: .months(16)),
            Milestone(title: "Follows simple commands", description: "Baby follows simple commands like 'come here'", category: .cognitive, achievedDate: nil, expectedAge: 60, isAchieved: false, notes: nil, ageRange: "15-18 months", period: .months(18)),
            Milestone(title: "Shows affection", description: "Baby shows affection with hugs and kisses", category: .social, achievedDate: nil, expectedAge: 60, isAchieved: false, notes: nil, ageRange: "15-18 months", period: .months(18)),
            Milestone(title: "Climbs stairs", description: "Baby can climb stairs with help", category: .physical, achievedDate: nil, expectedAge: 64, isAchieved: false, notes: nil, ageRange: "16-18 months", period: .months(18)),
            
            // 18-24 Months
            Milestone(title: "Runs and climbs", description: "Baby can run and climb on furniture", category: .physical, achievedDate: nil, expectedAge: 78, isAchieved: false, notes: nil, ageRange: "18-24 months", period: .months(24)),
            Milestone(title: "Combines 2 words", description: "Baby combines two words together", category: .language, achievedDate: nil, expectedAge: 78, isAchieved: false, notes: nil, ageRange: "18-24 months", period: .months(24)),
            Milestone(title: "Shows independence", description: "Baby shows desire to do things independently", category: .social, achievedDate: nil, expectedAge: 78, isAchieved: false, notes: nil, ageRange: "18-24 months", period: .months(24)),
            Milestone(title: "Understands 200+ words", description: "Baby understands 200+ words", category: .language, achievedDate: nil, expectedAge: 82, isAchieved: false, notes: nil, ageRange: "20-24 months", period: .months(24)),
            Milestone(title: "Plays pretend", description: "Baby engages in pretend play", category: .cognitive, achievedDate: nil, expectedAge: 82, isAchieved: false, notes: nil, ageRange: "20-24 months", period: .months(24)),
            Milestone(title: "Kicks a ball", description: "Baby can kick a ball forward", category: .physical, achievedDate: nil, expectedAge: 86, isAchieved: false, notes: nil, ageRange: "22-24 months", period: .months(24)),
            
            // 2-3 Years
            Milestone(title: "Speaks in sentences", description: "Baby speaks in 2-3 word sentences", category: .language, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3)),
            Milestone(title: "Jumps with both feet", description: "Baby can jump with both feet off the ground", category: .physical, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3)),
            Milestone(title: "Shares with others", description: "Baby shares toys and objects with others", category: .social, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3)),
            Milestone(title: "Recognizes colors", description: "Baby can identify and name basic colors", category: .cognitive, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3)),
            Milestone(title: "Uses toilet", description: "Baby shows interest in using the toilet", category: .physical, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3)),
            Milestone(title: "Follows 2-step instructions", description: "Baby can follow 2-step instructions", category: .cognitive, achievedDate: nil, expectedAge: 104, isAchieved: false, notes: nil, ageRange: "2-3 years", period: .years(3))
        ]
        var didAdd = false
        
        // If milestones array is empty, add all premade milestones
        if milestones.isEmpty {
            milestones = premade
            didAdd = true
        } else {
            // Otherwise, only add missing ones
            for pre in premade {
                if !milestones.contains(where: { $0.title == pre.title }) {
                    milestones.append(pre)
                    didAdd = true
                }
            }
        }
        
        if didAdd {
            saveData()
        }
    }
    
    // Force load default milestones if none exist
    func ensureDefaultMilestones() {
        if milestones.isEmpty {
            setupDefaultMilestones()
        }
    }
    
    // Milestone badge system: unlock badge if all milestones in a category are achieved
    func achievedBadgeCategories() -> [MilestoneCategory] {
        var unlocked: [MilestoneCategory] = []
        for category in MilestoneCategory.allCases where category != .all {
            let milestonesInCategory = milestones.filter { $0.category == category }
            if !milestonesInCategory.isEmpty && milestonesInCategory.allSatisfy({ $0.isAchieved }) {
                unlocked.append(category)
            }
        }
        return unlocked
    }
    
    private func setupDefaultAchievements() {
        if achievements.isEmpty {
            // Updated achievements for 2025
            achievements = [
                // Firsts
                DadAchievement(title: "First Nappy Change", description: "Changed your first nappy", icon: "drop", category: .firsts, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                DadAchievement(title: "First Feed", description: "Gave your baby their first feed", icon: "drop.fill", category: .firsts, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                DadAchievement(title: "First Bath", description: "Gave your baby their first bath", icon: "shower", category: .firsts, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                DadAchievement(title: "First Outing", description: "Took your baby on their first outing", icon: "car", category: .firsts, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                DadAchievement(title: "First Smile", description: "Saw your baby's first smile", icon: "face.smiling", category: .firsts, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                
                // Bonding
                DadAchievement(title: "Skin-to-Skin Time", description: "Spent time doing skin-to-skin contact", icon: "heart.fill", category: .bonding, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 10),
                DadAchievement(title: "Bedtime Stories", description: "Read bedtime stories to your baby", icon: "book", category: .bonding, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 20),
                DadAchievement(title: "Playtime Sessions", description: "Engaged in playtime activities", icon: "gamecontroller", category: .bonding, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 30),
                DadAchievement(title: "Lullabies Sung", description: "Sang lullabies to your baby", icon: "music.note", category: .bonding, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 15),
                
                // Care
                DadAchievement(title: "Nappy Changes", description: "Changed nappies", icon: "drop", category: .care, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 50),
                DadAchievement(title: "Feeding Sessions", description: "Fed your baby", icon: "drop.fill", category: .care, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 100),
                DadAchievement(title: "Bath Times", description: "Gave baths", icon: "shower", category: .care, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 20),
                DadAchievement(title: "Sleep Sessions", description: "Put baby to sleep", icon: "bed.double", category: .care, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 30),
                
                // Support
                DadAchievement(title: "Night Shifts", description: "Handled night-time care", icon: "moon", category: .support, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 10),
                DadAchievement(title: "Doctor Visits", description: "Attended medical appointments", icon: "cross", category: .support, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 5),
                DadAchievement(title: "Shopping Trips", description: "Bought baby supplies", icon: "cart", category: .support, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 15),
                DadAchievement(title: "Research Hours", description: "Researched parenting topics", icon: "magnifyingglass", category: .support, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 20),
                
                // Learning
                DadAchievement(title: "Parenting Books", description: "Read parenting books", icon: "book.fill", category: .learning, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 3),
                DadAchievement(title: "Online Courses", description: "Completed online parenting courses", icon: "laptopcomputer", category: .learning, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 2),
                DadAchievement(title: "Support Groups", description: "Joined parenting support groups", icon: "person.3", category: .learning, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1),
                DadAchievement(title: "First Aid Training", description: "Completed baby first aid training", icon: "cross.case", category: .learning, achievedDate: nil, isAchieved: false, progress: 0.0, targetValue: 1)
            ]
        }
    }
    
    // Updated vaccination schedule for 2025
    private func setupDefaultVaccinations() {
        if vaccinations.isEmpty {
            vaccinations = [
                VaccinationRecord(title: "8 weeks - 6-in-1 vaccine", date: Calendar.current.date(byAdding: .weekOfYear, value: 8, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "8 weeks - Rotavirus vaccine", date: Calendar.current.date(byAdding: .weekOfYear, value: 8, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "8 weeks - MenB vaccine", date: Calendar.current.date(byAdding: .weekOfYear, value: 8, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "12 weeks - 6-in-1 vaccine (2nd dose)", date: Calendar.current.date(byAdding: .weekOfYear, value: 12, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "12 weeks - Rotavirus vaccine (2nd dose)", date: Calendar.current.date(byAdding: .weekOfYear, value: 12, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "12 weeks - PCV vaccine", date: Calendar.current.date(byAdding: .weekOfYear, value: 12, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "16 weeks - 6-in-1 vaccine (3rd dose)", date: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "16 weeks - MenB vaccine (2nd dose)", date: Calendar.current.date(byAdding: .weekOfYear, value: 16, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "1 year - Hib/MenC vaccine", date: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "1 year - MMR vaccine", date: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "1 year - PCV vaccine (2nd dose)", date: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(), isCompleted: false, notes: nil),
                VaccinationRecord(title: "1 year - MenB vaccine (3rd dose)", date: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(), isCompleted: false, notes: nil)
            ]
        }
    }
    
    private func checkAchievements() {
        // Check First Feed
        if let firstFeed = achievements.first(where: { $0.title == "First Feed" && !$0.isAchieved }) {
            if !feedingRecords.isEmpty {
                achieveAchievement(firstFeed)
            }
        }
        
        // Check Nappy Master
        if let nappyMaster = achievements.first(where: { $0.title == "Nappy Master" && !$0.isAchieved }) {
            let progress = min(Double(nappyRecords.count) / Double(nappyMaster.targetValue), 1.0)
            updateAchievementProgress(nappyMaster, progress: progress)
            if progress >= 1.0 {
                achieveAchievement(nappyMaster)
            }
        }
    }
    
    private func achieveAchievement(_ achievement: DadAchievement) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            achievements[index].achievedDate = Date()
            achievements[index].isAchieved = true
            achievements[index].progress = 1.0
            saveData()
        }
    }
    
    private func updateAchievementProgress(_ achievement: DadAchievement, progress: Double) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            achievements[index].progress = progress
            saveData()
        }
    }
    
    // MARK: - Reminder Methods
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveData()
    }
    
    // MARK: - Milestone Methods
    func addMilestone(_ milestone: Milestone) {
        milestones.append(milestone)
        saveData()
    }
    
    func completeReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted = true
            saveData()
        }
    }
    
    func getUpcomingReminders() -> [Reminder] {
        let now = Date()
        return reminders.filter { !$0.isCompleted && $0.date > now }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Wellness Methods
    func addWellnessEntry(_ entry: WellnessEntry) {
        wellnessEntries.append(entry)
        saveData()
    }
    
    func getTodayWellness() -> WellnessEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return wellnessEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func getWeeklyWellnessTrend() -> [WellnessEntry] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return wellnessEntries.filter { $0.date >= weekAgo }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Partner Support Methods
    func addPartnerSupport(_ support: PartnerSupport) {
        partnerSupports.append(support)
        saveData()
    }
    
    func getTodaySupport() -> [PartnerSupport] {
        let today = Calendar.current.startOfDay(for: Date())
        return partnerSupports.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - Emergency Contact Methods
    func addEmergencyContact(_ contact: EmergencyContact) {
        emergencyContacts.append(contact)
        saveData()
    }
    
    func getEmergencyContacts() -> [EmergencyContact] {
        return emergencyContacts.filter { $0.isEmergency }.sorted { $0.name < $1.name }
    }
    
    func getPickupContacts() -> [EmergencyContact] {
        return emergencyContacts.filter { $0.canPickup }.sorted { $0.name < $1.name }
    }
    
    // MARK: - Quick Action Methods
    func addQuickAction(_ action: QuickAction) {
        quickActions.append(action)
        saveData()
    }
    
    func updateQuickActionUsage(_ action: QuickAction) {
        if let index = quickActions.firstIndex(where: { $0.id == action.id }) {
            quickActions[index].lastUsed = Date()
            saveData()
        }
    }
    
    // MARK: - Growth Prediction Methods
    func addGrowthPrediction(_ prediction: GrowthPrediction) {
        growthPredictions.append(prediction)
        saveData()
    }
    
    func getLatestPrediction() -> GrowthPrediction? {
        return growthPredictions.sorted { $0.date > $1.date }.first
    }
    
    // MARK: - Development Checklist Methods
    func addDevelopmentChecklist(_ checklist: DevelopmentChecklist) {
        developmentChecklists.append(checklist)
        saveData()
    }
    
    func completeChecklist(_ checklist: DevelopmentChecklist) {
        if let index = developmentChecklists.firstIndex(where: { $0.id == checklist.id }) {
            developmentChecklists[index].isCompleted = true
            developmentChecklists[index].completedDate = Date()
            saveData()
        }
    }
    
    func getUpcomingChecklists() -> [DevelopmentChecklist] {
        let babyAge = baby?.ageInWeeks ?? 0
        return developmentChecklists.filter { !$0.isCompleted && $0.expectedAge <= babyAge + 4 }
    }
    
    // MARK: - Appointment Methods
    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
        saveData()
    }
    
    func updateAppointment(_ appointment: Appointment) {
        if let idx = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[idx] = appointment
            saveData()
        }
    }
    
    func deleteAppointment(_ appointment: Appointment) {
        appointments.removeAll { $0.id == appointment.id }
        saveData()
    }
    
    func getUpcomingAppointments() -> [Appointment] {
        let now = Date()
        return appointments.filter { !$0.isAllDay && $0.startDate > now }.sorted { $0.startDate < $1.startDate }
    }
    
    func getDailyAppointments() -> [Appointment] {
        let today = Calendar.current.startOfDay(for: Date())
        return appointments.filter { Calendar.current.isDate($0.startDate, inSameDayAs: today) }
    }
    
    // MARK: - Health Visitor Methods
    func addHealthVisitorVisit(_ visit: HealthVisitorVisit) {
        healthVisitorVisits.append(visit)
        saveData()
    }
    
    func updateHealthVisitorVisit(_ visit: HealthVisitorVisit) {
        if let idx = healthVisitorVisits.firstIndex(where: { $0.id == visit.id }) {
            healthVisitorVisits[idx] = visit
            saveData()
        }
    }
    
    func deleteHealthVisitorVisit(_ visit: HealthVisitorVisit) {
        healthVisitorVisits.removeAll { $0.id == visit.id }
        saveData()
    }
    
    func markHealthVisitorVisitCompleted(_ visit: HealthVisitorVisit) {
        // For now, we'll just update the visit to today's date to mark it as completed
        if let idx = healthVisitorVisits.firstIndex(where: { $0.id == visit.id }) {
            // Since date is let, we'll need to create a new visit with today's date
            let completedVisit = HealthVisitorVisit(
                title: visit.title,
                date: Date(),
                notes: visit.notes,
                weight: visit.weight,
                height: visit.height,
                headCircumference: visit.headCircumference
            )
            healthVisitorVisits[idx] = completedVisit
            saveData()
        }
    }
    
    func getUpcomingHealthVisitorVisits() -> [HealthVisitorVisit] {
        return healthVisitorVisits.filter { $0.date > Date() }.sorted { $0.date < $1.date }
    }
    
    func getCompletedHealthVisitorVisits() -> [HealthVisitorVisit] {
        return healthVisitorVisits.filter { $0.date <= Date() }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Neonatal Specific Methods
    func isInNeonatalPeriod() -> Bool {
        guard let baby = baby else { return false }
        return baby.ageInDays <= 28
    }
    
    func getNeonatalAlerts() -> [String] {
        var alerts: [String] = []
        
        if isInNeonatalPeriod() {
            if let baby = baby {
                if baby.ageInDays <= 7 {
                    alerts.append("Critical neonatal period - monitor closely")
                }
                if baby.isPremature {
                    alerts.append("Premature baby - use adjusted age for milestones")
                }
            }
        }
        
        return alerts
    }
    
    // MARK: - Post-Discharge Methods
    func getPostDischargeChecklist() -> [String] {
        var checklist: [String] = []
        
        if !isInNeonatalPeriod() {
            checklist.append("Schedule first pediatrician visit")
            checklist.append("Set up home monitoring")
            checklist.append("Plan follow-up appointments")
            checklist.append("Review discharge instructions")
        }
        
        return checklist
    }
}

// MARK: - Color Extensions
extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let lightGreen = Color(red: 0.4, green: 0.8, blue: 0.4)
} 

// MARK: - Record Type Protocol and Extensions
// Protocol for record types that have a date
protocol DateRecord {
    var recordDate: Date { get }
}

// Extensions to make our record types conform to DateRecord
extension FeedingRecord: DateRecord {
    var recordDate: Date { date }
}

extension SleepRecord: DateRecord {
    var recordDate: Date { startTime }
}

extension NappyRecord: DateRecord {
    var recordDate: Date { date }
}

// Union type for different record types
enum RecordType {
    case feeding(FeedingRecord)
    case sleep(SleepRecord)
    case nappy(NappyRecord)
    
    var recordDate: Date {
        switch self {
        case .feeding(let record): return record.date
        case .sleep(let record): return record.startTime
        case .nappy(let record): return record.date
        }
    }
} 

struct Appointment: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var location: String
    var isAllDay: Bool
    var startDate: Date
    var endDate: Date
    var notes: String?
    var reminderMinutes: Int
    var type: AppointmentType
    var time: String
    
    enum AppointmentType: String, CaseIterable, Codable {
        case checkup = "Check-up"
        case vaccination = "Vaccination"
        case specialist = "Specialist"
        case emergency = "Emergency"
        case followup = "Follow-up"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .checkup: return "stethoscope"
            case .vaccination: return "syringe"
            case .specialist: return "person.2.fill"
            case .emergency: return "exclamationmark.triangle.fill"
            case .followup: return "arrow.clockwise"
            case .other: return "calendar"
            }
        }
        
        var color: Color {
            switch self {
            case .checkup: return .blue
            case .vaccination: return .green
            case .specialist: return .purple
            case .emergency: return .red
            case .followup: return .orange
            case .other: return .gray
            }
        }
    }
    
    init(title: String, date: Date, time: String, location: String, notes: String?, type: AppointmentType) {
        self.title = title
        self.location = location
        self.isAllDay = false
        self.startDate = date
        self.endDate = date
        self.notes = notes
        self.reminderMinutes = 30
        self.type = type
        self.time = time
    }
    
    init(title: String, location: String, isAllDay: Bool, startDate: Date, endDate: Date, notes: String?, reminderMinutes: Int) {
        self.title = title
        self.location = location
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.reminderMinutes = reminderMinutes
        self.type = .other
        self.time = timeFormatter.string(from: startDate)
    }
} 