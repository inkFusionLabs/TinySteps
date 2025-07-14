//
//  BabyData.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import SwiftUI

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
struct FeedingRecord: Identifiable, Codable {
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
}

// Enhanced Nappy Records
struct NappyRecord: Identifiable, Codable {
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
}

// New Sleep Records
struct SleepRecord: Identifiable, Codable {
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
}

// New Milestone Tracking
struct Milestone: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    let category: MilestoneCategory
    var achievedDate: Date?
    let expectedAge: Int // in weeks
    var isAchieved: Bool
    let notes: String?
    
    enum MilestoneCategory: String, CaseIterable, Codable {
        case physical = "Physical"
        case cognitive = "Cognitive"
        case social = "Social"
        case language = "Language"
        
        var icon: String {
            switch self {
            case .physical: return "figure.walk"
            case .cognitive: return "brain.head.profile"
            case .social: return "person.2.fill"
            case .language: return "message.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .physical: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .cognitive: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .social: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .language: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            }
        }
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
    
    enum ReminderCategory: String, CaseIterable, Codable {
        case feeding = "Feeding"
        case nappy = "Nappy"
        case sleep = "Sleep"
        case medical = "Medical"
        case personal = "Personal"
        
        var icon: String {
            switch self {
            case .feeding: return "drop.fill"
            case .nappy: return "drop"
            case .sleep: return "bed.double.fill"
            case .medical: return "cross.fill"
            case .personal: return "person.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .feeding: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .nappy: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .sleep: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .medical: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .personal: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            }
        }
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
    let name: String
    let relationship: String
    let phoneNumber: String
    let isEmergency: Bool
    let canPickup: Bool
    let notes: String?
    
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
    
    // New features
    @Published var wellnessEntries: [WellnessEntry] = []
    @Published var partnerSupports: [PartnerSupport] = []
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var quickActions: [QuickAction] = []
    @Published var growthPredictions: [GrowthPrediction] = []
    @Published var developmentChecklists: [DevelopmentChecklist] = []
    @Published var appointments: [Appointment] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        setupDefaultMilestones()
        setupDefaultAchievements()
        setupDefaultVaccinations()
    }
    
    // MARK: - Data Persistence
    private func loadData() {
        if let babyData = userDefaults.data(forKey: "baby"),
           let baby = try? JSONDecoder().decode(Baby.self, from: babyData) {
            self.baby = baby
        }
        
        if let feedingData = userDefaults.data(forKey: "feedingRecords"),
           let feedings = try? JSONDecoder().decode([FeedingRecord].self, from: feedingData) {
            self.feedingRecords = feedings
        }
        
        if let nappyData = userDefaults.data(forKey: "nappyRecords"),
           let nappies = try? JSONDecoder().decode([NappyRecord].self, from: nappyData) {
            self.nappyRecords = nappies
        }
        
        if let sleepData = userDefaults.data(forKey: "sleepRecords"),
           let sleeps = try? JSONDecoder().decode([SleepRecord].self, from: sleepData) {
            self.sleepRecords = sleeps
        }
        
        if let milestoneData = userDefaults.data(forKey: "milestones"),
           let milestones = try? JSONDecoder().decode([Milestone].self, from: milestoneData) {
            self.milestones = milestones
        }
        
        if let achievementData = userDefaults.data(forKey: "achievements"),
           let achievements = try? JSONDecoder().decode([DadAchievement].self, from: achievementData) {
            self.achievements = achievements
        }
        
        if let reminderData = userDefaults.data(forKey: "reminders"),
           let reminders = try? JSONDecoder().decode([Reminder].self, from: reminderData) {
            self.reminders = reminders
        }
        
        if let vaccinationData = userDefaults.data(forKey: "vaccinations"),
           let vaccinations = try? JSONDecoder().decode([VaccinationRecord].self, from: vaccinationData) {
            self.vaccinations = vaccinations
        }
        
        if let solidFoodData = userDefaults.data(forKey: "solidFoodRecords"),
           let solidFoods = try? JSONDecoder().decode([SolidFoodRecord].self, from: solidFoodData) {
            self.solidFoodRecords = solidFoods
        }
        
        // Load new features
        if let wellnessData = userDefaults.data(forKey: "wellnessEntries"),
           let wellness = try? JSONDecoder().decode([WellnessEntry].self, from: wellnessData) {
            self.wellnessEntries = wellness
        }
        
        if let supportData = userDefaults.data(forKey: "partnerSupports"),
           let supports = try? JSONDecoder().decode([PartnerSupport].self, from: supportData) {
            self.partnerSupports = supports
        }
        
        if let contactData = userDefaults.data(forKey: "emergencyContacts"),
           let contacts = try? JSONDecoder().decode([EmergencyContact].self, from: contactData) {
            self.emergencyContacts = contacts
        }
        
        if let actionData = userDefaults.data(forKey: "quickActions"),
           let actions = try? JSONDecoder().decode([QuickAction].self, from: actionData) {
            self.quickActions = actions
        }
        
        if let predictionData = userDefaults.data(forKey: "growthPredictions"),
           let predictions = try? JSONDecoder().decode([GrowthPrediction].self, from: predictionData) {
            self.growthPredictions = predictions
        }
        
        if let checklistData = userDefaults.data(forKey: "developmentChecklists"),
           let checklists = try? JSONDecoder().decode([DevelopmentChecklist].self, from: checklistData) {
            self.developmentChecklists = checklists
        }
        
        if let appointmentData = userDefaults.data(forKey: "appointments"),
           let appointments = try? JSONDecoder().decode([Appointment].self, from: appointmentData) {
            self.appointments = appointments
        }
    }
    
    func saveData() {
        if let baby = baby,
           let babyData = try? JSONEncoder().encode(baby) {
            userDefaults.set(babyData, forKey: "baby")
        }
        
        if let feedingData = try? JSONEncoder().encode(feedingRecords) {
            userDefaults.set(feedingData, forKey: "feedingRecords")
        }
        
        if let nappyData = try? JSONEncoder().encode(nappyRecords) {
            userDefaults.set(nappyData, forKey: "nappyRecords")
        }
        
        if let sleepData = try? JSONEncoder().encode(sleepRecords) {
            userDefaults.set(sleepData, forKey: "sleepRecords")
        }
        
        if let milestoneData = try? JSONEncoder().encode(milestones) {
            userDefaults.set(milestoneData, forKey: "milestones")
        }
        
        if let achievementData = try? JSONEncoder().encode(achievements) {
            userDefaults.set(achievementData, forKey: "achievements")
        }
        
        if let reminderData = try? JSONEncoder().encode(reminders) {
            userDefaults.set(reminderData, forKey: "reminders")
        }
        
        if let vaccinationData = try? JSONEncoder().encode(vaccinations) {
            userDefaults.set(vaccinationData, forKey: "vaccinations")
        }
        
        if let solidFoodData = try? JSONEncoder().encode(solidFoodRecords) {
            userDefaults.set(solidFoodData, forKey: "solidFoodRecords")
        }
        
        // Save new features
        if let wellnessData = try? JSONEncoder().encode(wellnessEntries) {
            userDefaults.set(wellnessData, forKey: "wellnessEntries")
        }
        
        if let supportData = try? JSONEncoder().encode(partnerSupports) {
            userDefaults.set(supportData, forKey: "partnerSupports")
        }
        
        if let contactData = try? JSONEncoder().encode(emergencyContacts) {
            userDefaults.set(contactData, forKey: "emergencyContacts")
        }
        
        if let actionData = try? JSONEncoder().encode(quickActions) {
            userDefaults.set(actionData, forKey: "quickActions")
        }
        
        if let predictionData = try? JSONEncoder().encode(growthPredictions) {
            userDefaults.set(predictionData, forKey: "growthPredictions")
        }
        
        if let checklistData = try? JSONEncoder().encode(developmentChecklists) {
            userDefaults.set(checklistData, forKey: "developmentChecklists")
        }
        
        if let appointmentData = try? JSONEncoder().encode(appointments) {
            userDefaults.set(appointmentData, forKey: "appointments")
        }
    }
    
    // MARK: - Feeding Methods
    func addFeedingRecord(_ record: FeedingRecord) {
        feedingRecords.append(record)
        saveData()
        checkAchievements()
    }
    
    func getTodayFeedingCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return feedingRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
    }
    
    func getNextFeedingTime() -> Date? {
        // Simple logic - could be enhanced with ML
        let lastFeeding = feedingRecords.last
        guard let lastFeeding = lastFeeding else { return nil }
        
        // Assume 3-4 hours between feedings
        return Calendar.current.date(byAdding: .hour, value: 3, to: lastFeeding.date)
    }
    
    // MARK: - Nappy Methods
    func addNappyRecord(_ record: NappyRecord) {
        nappyRecords.append(record)
        saveData()
        checkAchievements()
    }
    
    func getTodayNappyCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return nappyRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
    }
    
    // MARK: - Sleep Methods
    func addSleepRecord(_ record: SleepRecord) {
        sleepRecords.append(record)
        saveData()
        checkAchievements()
    }
    
    func getTodaySleepHours() -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        let todaySleeps = sleepRecords.filter { Calendar.current.isDate($0.startTime, inSameDayAs: today) }
        
        return todaySleeps.reduce(0) { total, sleep in
            if let endTime = sleep.endTime {
                return total + endTime.timeIntervalSince(sleep.startTime) / 3600
            }
            return total
        }
    }
    
    // MARK: - Milestone Methods
    private func setupDefaultMilestones() {
        if milestones.isEmpty {
            // Updated UK milestones for 2025
            milestones = [
                // Physical Development
                Milestone(title: "Lifts head when on tummy", description: "Baby can lift their head briefly when placed on their tummy", category: .physical, expectedAge: 4, isAchieved: false, notes: nil),
                Milestone(title: "Rolls from tummy to back", description: "Baby can roll from tummy to back position", category: .physical, expectedAge: 12, isAchieved: false, notes: nil),
                Milestone(title: "Sits without support", description: "Baby can sit independently for short periods", category: .physical, expectedAge: 24, isAchieved: false, notes: nil),
                Milestone(title: "Crawls or scoots", description: "Baby moves around by crawling or scooting", category: .physical, expectedAge: 28, isAchieved: false, notes: nil),
                Milestone(title: "Pulls to stand", description: "Baby pulls themselves up to standing position", category: .physical, expectedAge: 36, isAchieved: false, notes: nil),
                Milestone(title: "Walks independently", description: "Baby takes first steps without support", category: .physical, expectedAge: 52, isAchieved: false, notes: nil),
                
                // Cognitive Development
                Milestone(title: "Follows objects with eyes", description: "Baby tracks moving objects with their eyes", category: .cognitive, expectedAge: 4, isAchieved: false, notes: nil),
                Milestone(title: "Reaches for objects", description: "Baby reaches out to grab nearby objects", category: .cognitive, expectedAge: 12, isAchieved: false, notes: nil),
                Milestone(title: "Picks up small objects", description: "Baby can pick up small items using pincer grasp", category: .cognitive, expectedAge: 28, isAchieved: false, notes: nil),
                Milestone(title: "Points to objects", description: "Baby points to objects they want or find interesting", category: .cognitive, expectedAge: 40, isAchieved: false, notes: nil),
                Milestone(title: "Follows simple commands", description: "Baby understands and follows simple instructions", category: .cognitive, expectedAge: 52, isAchieved: false, notes: nil),
                
                // Social Development
                Milestone(title: "Smiles at people", description: "Baby responds with social smiles", category: .social, expectedAge: 6, isAchieved: false, notes: nil),
                Milestone(title: "Recognises familiar faces", description: "Baby shows recognition of parents and caregivers", category: .social, expectedAge: 12, isAchieved: false, notes: nil),
                Milestone(title: "Plays peek-a-boo", description: "Baby enjoys interactive games like peek-a-boo", category: .social, expectedAge: 24, isAchieved: false, notes: nil),
                Milestone(title: "Waves goodbye", description: "Baby waves goodbye when someone leaves", category: .social, expectedAge: 36, isAchieved: false, notes: nil),
                Milestone(title: "Shows independence", description: "Baby shows desire to do things independently", category: .social, expectedAge: 52, isAchieved: false, notes: nil),
                
                // Language Development
                Milestone(title: "Responds to sounds", description: "Baby turns head toward sounds and voices", category: .language, expectedAge: 4, isAchieved: false, notes: nil),
                Milestone(title: "Babbles and coos", description: "Baby makes babbling sounds and coos", category: .language, expectedAge: 12, isAchieved: false, notes: nil),
                Milestone(title: "Says 'mama' or 'dada'", description: "Baby says first words like mama or dada", category: .language, expectedAge: 28, isAchieved: false, notes: nil),
                Milestone(title: "Says first words", description: "Baby says several words beyond mama/dada", category: .language, expectedAge: 40, isAchieved: false, notes: nil),
                Milestone(title: "Combines 2 words", description: "Baby combines two words together", category: .language, expectedAge: 60, isAchieved: false, notes: nil)
            ]
        }
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

struct Appointment: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var location: String
    var isAllDay: Bool
    var startDate: Date
    var endDate: Date
    var notes: String?
    var reminderMinutes: Int
} 