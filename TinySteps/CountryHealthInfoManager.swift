import Foundation
import SwiftUI

class CountryHealthInfoManager: ObservableObject {
    @Published var currentCountry: String = "United Kingdom"
    @Published var currentCountryCode: String = "GB"
    
    // Country-specific vaccination schedules
    private var vaccinationSchedules: [String: [VaccinationSchedule]] = [
        "GB": [ // United Kingdom (NHS Schedule)
            VaccinationSchedule(age: "8 weeks", vaccines: ["6-in-1 vaccine", "Rotavirus vaccine", "MenB vaccine"], notes: "First routine vaccinations"),
            VaccinationSchedule(age: "12 weeks", vaccines: ["6-in-1 vaccine (2nd dose)", "Rotavirus vaccine (2nd dose)", "PCV vaccine"], notes: "Second round of vaccinations"),
            VaccinationSchedule(age: "16 weeks", vaccines: ["6-in-1 vaccine (3rd dose)", "MenB vaccine (2nd dose)"], notes: "Third round of vaccinations"),
            VaccinationSchedule(age: "12 months", vaccines: ["Hib/MenC vaccine", "MMR vaccine", "PCV vaccine (2nd dose)", "MenB vaccine (3rd dose)"], notes: "One year vaccinations"),
            VaccinationSchedule(age: "2-15 years", vaccines: ["Annual flu vaccine"], notes: "Annual flu vaccination")
        ],
        "US": [ // United States (CDC Schedule)
            VaccinationSchedule(age: "Birth", vaccines: ["Hepatitis B"], notes: "First dose at birth"),
            VaccinationSchedule(age: "1-2 months", vaccines: ["Hepatitis B (2nd dose)"], notes: "Second dose"),
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus"], notes: "First major vaccination round"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus"], notes: "Second major vaccination round"),
            VaccinationSchedule(age: "6 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus", "Hepatitis B"], notes: "Third major vaccination round"),
            VaccinationSchedule(age: "12-15 months", vaccines: ["MMR", "Varicella", "Hib", "PCV13"], notes: "One year vaccinations"),
            VaccinationSchedule(age: "4-6 years", vaccines: ["DTaP", "IPV", "MMR", "Varicella"], notes: "School entry vaccinations")
        ],
        "CA": [ // Canada
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP-IPV-Hib", "PCV13", "Rotavirus"], notes: "First vaccination round"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP-IPV-Hib", "PCV13", "Rotavirus"], notes: "Second vaccination round"),
            VaccinationSchedule(age: "6 months", vaccines: ["DTaP-IPV-Hib", "PCV13", "Rotavirus"], notes: "Third vaccination round"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "Varicella", "MenC"], notes: "One year vaccinations"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP-IPV-Hib", "PCV13"], notes: "18-month boosters")
        ],
        "AU": [ // Australia
            VaccinationSchedule(age: "Birth", vaccines: ["Hepatitis B"], notes: "Birth dose"),
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "Hib", "IPV", "Hepatitis B", "PCV13", "Rotavirus"], notes: "First vaccination round"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "Hib", "IPV", "Hepatitis B", "PCV13", "Rotavirus"], notes: "Second vaccination round"),
            VaccinationSchedule(age: "6 months", vaccines: ["DTaP", "Hib", "IPV", "Hepatitis B", "PCV13", "Rotavirus"], notes: "Third vaccination round"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "Varicella", "MenC", "Hib"], notes: "One year vaccinations"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP", "IPV", "MMR", "Varicella"], notes: "18-month boosters")
        ],
        "DE": [ // Germany
            VaccinationSchedule(age: "6 weeks", vaccines: ["Rotavirus"], notes: "Early rotavirus protection"),
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus"], notes: "First vaccination round"),
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus"], notes: "Second vaccination round"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "Hib", "IPV", "PCV13", "Rotavirus"], notes: "Third vaccination round"),
            VaccinationSchedule(age: "11-14 months", vaccines: ["MMR", "Varicella", "MenC"], notes: "One year vaccinations"),
            VaccinationSchedule(age: "15-23 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Toddler boosters")
        ]
    ]
    
    // Country-specific growth standards
    private var growthStandards: [String: GrowthStandards] = [
        "GB": GrowthStandards(
            country: "United Kingdom",
            organization: "WHO/UK Growth Charts",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Based on WHO growth standards adapted for UK population"
        ),
        "US": GrowthStandards(
            country: "United States",
            organization: "CDC Growth Charts",
            weightUnit: "lbs",
            heightUnit: "inches",
            notes: "CDC growth reference data for US children"
        ),
        "CA": GrowthStandards(
            country: "Canada",
            organization: "WHO Growth Standards",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "WHO growth standards used in Canada"
        ),
        "AU": GrowthStandards(
            country: "Australia",
            organization: "WHO Growth Standards",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "WHO growth standards adapted for Australian children"
        ),
        "DE": GrowthStandards(
            country: "Germany",
            organization: "KiGGS Study",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "German health survey growth reference data"
        )
    ]
    
    // Country-specific health guidelines
    private var healthGuidelines: [String: [HealthGuideline]] = [
        "GB": [
            HealthGuideline(title: "NHS Health Visitor Visits", description: "Regular visits from birth to 5 years", frequency: "Birth, 5-8 days, 10-14 days, 6-8 weeks, 3-4 months, 8-12 months, 2-2.5 years, 3-4 years"),
            HealthGuideline(title: "Breastfeeding Support", description: "Free breastfeeding support through NHS", frequency: "Available 24/7"),
            HealthGuideline(title: "Mental Health Support", description: "Perinatal mental health services", frequency: "Available throughout pregnancy and postnatal period"),
            HealthGuideline(title: "Emergency Services", description: "NHS 111 for non-emergency, 999 for emergency", frequency: "24/7 availability")
        ],
        "US": [
            HealthGuideline(title: "Well-Child Visits", description: "Regular pediatric check-ups", frequency: "Birth, 1, 2, 4, 6, 9, 12, 15, 18, 24, 30, 36 months"),
            HealthGuideline(title: "WIC Program", description: "Nutrition support for women, infants, and children", frequency: "Monthly benefits"),
            HealthGuideline(title: "Early Intervention", description: "Developmental screening and support", frequency: "Available from birth to 3 years"),
            HealthGuideline(title: "Emergency Services", description: "911 for emergency services", frequency: "24/7 availability")
        ],
        "CA": [
            HealthGuideline(title: "Public Health Nurse Visits", description: "Home visits for new families", frequency: "Birth, 2 weeks, 2 months, 4 months, 6 months, 12 months"),
            HealthGuideline(title: "Breastfeeding Support", description: "Provincial breastfeeding programs", frequency: "Available through public health"),
            HealthGuideline(title: "Child Development", description: "Early childhood development programs", frequency: "Available from birth to 6 years"),
            HealthGuideline(title: "Emergency Services", description: "911 for emergency services", frequency: "24/7 availability")
        ],
        "AU": [
            HealthGuideline(title: "Maternal and Child Health", description: "Free health checks and support", frequency: "Birth, 1-4 weeks, 8 weeks, 4 months, 8 months, 12 months, 18 months, 2 years, 3.5 years"),
            HealthGuideline(title: "Breastfeeding Support", description: "Australian Breastfeeding Association", frequency: "24/7 helpline available"),
            HealthGuideline(title: "Parenting Support", description: "Triple P Positive Parenting Program", frequency: "Available through community health"),
            HealthGuideline(title: "Emergency Services", description: "000 for emergency services", frequency: "24/7 availability")
        ],
        "DE": [
            HealthGuideline(title: "U-Untersuchungen", description: "Regular pediatric check-ups", frequency: "U1-U9 from birth to 5 years"),
            HealthGuideline(title: "Stillberatung", description: "Breastfeeding consultation", frequency: "Available through midwives and clinics"),
            HealthGuideline(title: "Früherkennung", description: "Early detection and intervention", frequency: "Available from birth"),
            HealthGuideline(title: "Emergency Services", description: "112 for emergency services", frequency: "24/7 availability")
        ]
    ]
    
    // Country-specific emergency information
    private var emergencyInfo: [String: EmergencyInfo] = [
        "GB": EmergencyInfo(
            emergencyNumber: "999",
            nonEmergencyNumber: "111",
            ambulanceService: "NHS Ambulance Service",
            hospitalFinder: "NHS Choices",
            notes: "Call 999 for life-threatening emergencies, 111 for non-emergency advice"
        ),
        "US": EmergencyInfo(
            emergencyNumber: "911",
            nonEmergencyNumber: "Varies by state",
            ambulanceService: "Local EMS",
            hospitalFinder: "Hospital directories vary by state",
            notes: "Call 911 for all emergencies, check local numbers for non-emergency"
        ),
        "CA": EmergencyInfo(
            emergencyNumber: "911",
            nonEmergencyNumber: "Varies by province",
            ambulanceService: "Provincial ambulance services",
            hospitalFinder: "Provincial health directories",
            notes: "Call 911 for emergencies, check provincial health lines for non-emergency"
        ),
        "AU": EmergencyInfo(
            emergencyNumber: "000",
            nonEmergencyNumber: "13 HEALTH (QLD), Nurse-on-Call (VIC), etc.",
            ambulanceService: "State ambulance services",
            hospitalFinder: "State health directories",
            notes: "Call 000 for emergencies, state-specific numbers for non-emergency advice"
        ),
        "DE": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "116 117",
            ambulanceService: "Rettungsdienst",
            hospitalFinder: "Krankenhausverzeichnis",
            notes: "Call 112 for emergencies, 116 117 for non-emergency medical advice"
        )
    ]
    
    func updateCountry(countryCode: String) {
        let upperCountryCode = countryCode.uppercased()
        currentCountryCode = upperCountryCode
        
        switch upperCountryCode {
        case "GB": currentCountry = "United Kingdom"
        case "US": currentCountry = "United States"
        case "CA": currentCountry = "Canada"
        case "AU": currentCountry = "Australia"
        case "DE": currentCountry = "Germany"
        case "FR": currentCountry = "France"
        case "ES": currentCountry = "Spain"
        case "IT": currentCountry = "Italy"
        case "NL": currentCountry = "Netherlands"
        case "SE": currentCountry = "Sweden"
        case "NO": currentCountry = "Norway"
        case "DK": currentCountry = "Denmark"
        case "FI": currentCountry = "Finland"
        case "JP": currentCountry = "Japan"
        case "KR": currentCountry = "South Korea"
        case "CN": currentCountry = "China"
        case "IN": currentCountry = "India"
        case "BR": currentCountry = "Brazil"
        case "MX": currentCountry = "Mexico"
        case "AR": currentCountry = "Argentina"
        case "ZA": currentCountry = "South Africa"
        default: currentCountry = "Unknown"
        }
    }
    
    func getVaccinationSchedule() -> [VaccinationSchedule] {
        return vaccinationSchedules[currentCountryCode] ?? vaccinationSchedules["GB"] ?? []
    }
    
    func getGrowthStandards() -> GrowthStandards? {
        return growthStandards[currentCountryCode] ?? growthStandards["GB"]
    }
    
    func getHealthGuidelines() -> [HealthGuideline] {
        return healthGuidelines[currentCountryCode] ?? healthGuidelines["GB"] ?? []
    }
    
    func getEmergencyInfo() -> EmergencyInfo? {
        return emergencyInfo[currentCountryCode] ?? emergencyInfo["GB"]
    }
    
    func isCountrySupported() -> Bool {
        return vaccinationSchedules[currentCountryCode] != nil
    }
    
    func getSupportedCountries() -> [String] {
        return Array(vaccinationSchedules.keys).sorted()
    }
}

// Data Models
struct VaccinationSchedule: Identifiable, Codable {
    var id = UUID()
    let age: String
    let vaccines: [String]
    let notes: String
}

struct GrowthStandards: Codable {
    let country: String
    let organization: String
    let weightUnit: String
    let heightUnit: String
    let notes: String
}

struct HealthGuideline: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let frequency: String
}

struct EmergencyInfo: Codable {
    let emergencyNumber: String
    let nonEmergencyNumber: String
    let ambulanceService: String
    let hospitalFinder: String
    let notes: String
} 