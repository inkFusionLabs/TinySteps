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
        ],
        "FR": [ // France
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB", "Rotavirus"], notes: "Primary vaccination series"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB", "Rotavirus"], notes: "Second routine visit"),
            VaccinationSchedule(age: "5 months", vaccines: ["MenC"], notes: "Meningococcal C protection"),
            VaccinationSchedule(age: "11 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Booster of infant vaccines"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "MenC"], notes: "First MMR and MenC booster"),
            VaccinationSchedule(age: "16-18 months", vaccines: ["MMR"], notes: "Second MMR dose")
        ],
        "ES": [ // Spain
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB", "Rotavirus"], notes: "Initial infant vaccinations"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB", "Rotavirus"], notes: "Second routine visit"),
            VaccinationSchedule(age: "11 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Infant booster"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "MenACWY"], notes: "Measles and meningococcal protection"),
            VaccinationSchedule(age: "15 months", vaccines: ["Varicella"], notes: "Varicella first dose"),
            VaccinationSchedule(age: "3-4 years", vaccines: ["DTaP", "IPV", "MMR", "Varicella"], notes: "Preschool boosters")
        ],
        "IT": [ // Italy
            VaccinationSchedule(age: "2 months", vaccines: ["Esavalente", "PCV13", "Rotavirus"], notes: "Hexavalent combo vaccine"),
            VaccinationSchedule(age: "3 months", vaccines: ["Esavalente", "PCV13", "Rotavirus"], notes: "Second round"),
            VaccinationSchedule(age: "4 months", vaccines: ["Esavalente", "PCV13", "Rotavirus"], notes: "Third round"),
            VaccinationSchedule(age: "6 months", vaccines: ["MenB"], notes: "Meningococcal B dose"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "Varicella", "MenB"], notes: "Measles, mumps, rubella, varicella"),
            VaccinationSchedule(age: "13-15 months", vaccines: ["MenC"], notes: "Meningococcal C booster"),
            VaccinationSchedule(age: "5-6 years", vaccines: ["DTaP", "IPV", "MMR", "Varicella"], notes: "School entry boosters")
        ],
        "NL": [ // Netherlands
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "RVP program start"),
            VaccinationSchedule(age: "5 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Second round"),
            VaccinationSchedule(age: "11 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Infant booster"),
            VaccinationSchedule(age: "14 months", vaccines: ["MMR", "MenACWY"], notes: "Measles and meningococcal protection"),
            VaccinationSchedule(age: "4 years", vaccines: ["DTaP", "IPV"], notes: "Preschool booster"),
            VaccinationSchedule(age: "9 years", vaccines: ["DTaP", "IPV"], notes: "School-age booster")
        ],
        "SE": [ // Sweden
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Primary infant vaccines"),
            VaccinationSchedule(age: "5 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Second infant visit"),
            VaccinationSchedule(age: "12 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Third infant visit"),
            VaccinationSchedule(age: "18 months", vaccines: ["MMR"], notes: "First MMR"),
            VaccinationSchedule(age: "5-6 years", vaccines: ["DTaP", "IPV", "MMR"], notes: "Preschool boosters"),
            VaccinationSchedule(age: "14-16 years", vaccines: ["Tdap"], notes: "Adolescent booster")
        ],
        "NO": [ // Norway
            VaccinationSchedule(age: "6 weeks", vaccines: ["Rotavirus"], notes: "Rotavirus first dose"),
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13", "Rotavirus"], notes: "Norwegian Childhood Immunization Program"),
            VaccinationSchedule(age: "5 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13", "Rotavirus"], notes: "Second round"),
            VaccinationSchedule(age: "12 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Third infant visit"),
            VaccinationSchedule(age: "15 months", vaccines: ["MMR"], notes: "First MMR"),
            VaccinationSchedule(age: "7 years", vaccines: ["DTaP"], notes: "School booster"),
            VaccinationSchedule(age: "11 years", vaccines: ["MMR", "HPV"], notes: "Adolescent boosters")
        ],
        "DK": [ // Denmark
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Primary vaccination"),
            VaccinationSchedule(age: "5 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Second vaccination"),
            VaccinationSchedule(age: "12 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13"], notes: "Third vaccination"),
            VaccinationSchedule(age: "15 months", vaccines: ["MMR"], notes: "First MMR"),
            VaccinationSchedule(age: "4 years", vaccines: ["MMR"], notes: "Second MMR"),
            VaccinationSchedule(age: "5 years", vaccines: ["DTaP", "IPV"], notes: "Preschool booster")
        ],
        "FI": [ // Finland
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13", "Rotavirus"], notes: "National vaccination program"),
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13", "Rotavirus"], notes: "Second round"),
            VaccinationSchedule(age: "5 months", vaccines: ["DTaP", "IPV", "Hib", "HepB", "PCV13", "Rotavirus"], notes: "Third round"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "PCV13"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP", "IPV", "Hib", "HepB"], notes: "Booster"),
            VaccinationSchedule(age: "6 years", vaccines: ["DTaP", "IPV", "MMR"], notes: "Preschool booster")
        ],
        "JP": [ // Japan
            VaccinationSchedule(age: "2 months", vaccines: ["Hib", "PCV13", "HepB"], notes: "Initial infant vaccines"),
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB"], notes: "Second round"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Third round"),
            VaccinationSchedule(age: "6 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13"], notes: "Fourth round"),
            VaccinationSchedule(age: "12 months", vaccines: ["MR", "Varicella"], notes: "Measles and rubella"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP", "IPV"], notes: "Booster doses"),
            VaccinationSchedule(age: "3 years", vaccines: ["DTaP"], notes: "Additional booster")
        ],
        "KR": [ // South Korea
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "HepB"], notes: "Neonatal vaccinations"),
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "Rotavirus"], notes: "First infant visit"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "Rotavirus"], notes: "Second infant visit"),
            VaccinationSchedule(age: "6 months", vaccines: ["DTaP", "IPV", "Hib", "PCV13", "HepB", "Rotavirus"], notes: "Third infant visit"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "Varicella"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "15 months", vaccines: ["Hib", "PCV13"], notes: "Boosters"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP"], notes: "Additional booster"),
            VaccinationSchedule(age: "4-6 years", vaccines: ["DTaP", "IPV", "MMR", "Varicella"], notes: "School entry vaccines")
        ],
        "CN": [ // China
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "HepB"], notes: "National Immunization Program"),
            VaccinationSchedule(age: "2 months", vaccines: ["DTaP", "IPV", "Hib", "HepB"], notes: "Infant series"),
            VaccinationSchedule(age: "3 months", vaccines: ["DTaP", "IPV", "Hib"], notes: "Second dose"),
            VaccinationSchedule(age: "4 months", vaccines: ["DTaP", "IPV", "Hib"], notes: "Third dose"),
            VaccinationSchedule(age: "6 months", vaccines: ["HepB", "BCG (booster)"], notes: "Booster doses"),
            VaccinationSchedule(age: "8 months", vaccines: ["MMR"], notes: "First MMR"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP", "IPV", "Hib", "MMR"], notes: "Toddler boosters"),
            VaccinationSchedule(age: "4 years", vaccines: ["DTaP", "IPV", "MMR"], notes: "Preschool booster")
        ],
        "IN": [ // India
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "OPV", "HepB"], notes: "Universal Immunization Programme"),
            VaccinationSchedule(age: "6 weeks", vaccines: ["Pentavalent", "OPV", "Rotavirus", "IPV"], notes: "First infant visit"),
            VaccinationSchedule(age: "10 weeks", vaccines: ["Pentavalent", "OPV", "Rotavirus", "IPV"], notes: "Second infant visit"),
            VaccinationSchedule(age: "14 weeks", vaccines: ["Pentavalent", "OPV", "Rotavirus", "IPV"], notes: "Third infant visit"),
            VaccinationSchedule(age: "9 months", vaccines: ["MR", "JE (endemic areas)"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "16-24 months", vaccines: ["DTaP", "OPV", "MR"], notes: "Booster schedule"),
            VaccinationSchedule(age: "5 years", vaccines: ["DTaP", "OPV"], notes: "School entry boosters")
        ],
        "BR": [ // Brazil
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "HepB"], notes: "National Immunization Program"),
            VaccinationSchedule(age: "2 months", vaccines: ["Pentavalent", "IPV", "PCV13", "Rotavirus"], notes: "Primary infant vaccines"),
            VaccinationSchedule(age: "3 months", vaccines: ["MenC"], notes: "Meningococcal C first dose"),
            VaccinationSchedule(age: "4 months", vaccines: ["Pentavalent", "IPV", "PCV13", "Rotavirus"], notes: "Second round"),
            VaccinationSchedule(age: "5 months", vaccines: ["MenC"], notes: "Meningococcal C second dose"),
            VaccinationSchedule(age: "6 months", vaccines: ["Pentavalent", "IPV"], notes: "Third round"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "MenC", "PCV13"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "15 months", vaccines: ["DTaP", "Hib", "HepA", "Varicella"], notes: "Booster schedule"),
            VaccinationSchedule(age: "4-6 years", vaccines: ["DTaP", "IPV", "MMR"], notes: "School entry boosters")
        ],
        "MX": [ // Mexico
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "HepB"], notes: "Cartilla Nacional de Vacunación"),
            VaccinationSchedule(age: "2 months", vaccines: ["Pentavalent", "Rotavirus", "PCV13", "HepB"], notes: "Primary infant vaccines"),
            VaccinationSchedule(age: "4 months", vaccines: ["Pentavalent", "Rotavirus", "PCV13"], notes: "Second infant visit"),
            VaccinationSchedule(age: "6 months", vaccines: ["Pentavalent", "Rotavirus", "PCV13", "Influenza"], notes: "Third infant visit"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "HepA"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "18 months", vaccines: ["Pentavalent"], notes: "Booster"),
            VaccinationSchedule(age: "4 years", vaccines: ["DTaP", "IPV"], notes: "Preschool boosters")
        ],
        "AR": [ // Argentina
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "HepB"], notes: "Calendario Nacional de Vacunación"),
            VaccinationSchedule(age: "2 months", vaccines: ["Pentavalent", "IPV", "Rotavirus", "PCV13"], notes: "Primary infant vaccines"),
            VaccinationSchedule(age: "4 months", vaccines: ["Pentavalent", "IPV", "Rotavirus", "PCV13"], notes: "Second infant visit"),
            VaccinationSchedule(age: "6 months", vaccines: ["Pentavalent", "IPV", "Rotavirus"], notes: "Third infant visit"),
            VaccinationSchedule(age: "12 months", vaccines: ["MMR", "HepA", "PCV13"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "15 months", vaccines: ["Varicella"], notes: "Varicella first dose"),
            VaccinationSchedule(age: "5-6 years", vaccines: ["DTaP", "IPV", "MMR"], notes: "School entry boosters")
        ],
        "ZA": [ // South Africa
            VaccinationSchedule(age: "Birth", vaccines: ["BCG", "OPV"], notes: "Expanded Programme on Immunisation"),
            VaccinationSchedule(age: "6 weeks", vaccines: ["Hexaxim", "Rotavirus", "PCV13"], notes: "Primary infant vaccines"),
            VaccinationSchedule(age: "10 weeks", vaccines: ["Hexaxim", "Rotavirus", "PCV13"], notes: "Second infant visit"),
            VaccinationSchedule(age: "14 weeks", vaccines: ["Hexaxim", "Rotavirus", "PCV13"], notes: "Third infant visit"),
            VaccinationSchedule(age: "6 months", vaccines: ["Measles"], notes: "First measles vaccine"),
            VaccinationSchedule(age: "9 months", vaccines: ["Measles"], notes: "Second measles dose"),
            VaccinationSchedule(age: "12 months", vaccines: ["PCV13", "HepA"], notes: "Toddler vaccines"),
            VaccinationSchedule(age: "18 months", vaccines: ["DTaP", "IPV", "Hib"], notes: "Booster vaccines"),
            VaccinationSchedule(age: "5-6 years", vaccines: ["DTaP", "IPV"], notes: "School boosters")
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
        ),
        "FR": GrowthStandards(
            country: "France",
            organization: "Santé Publique France",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "French public health growth references"
        ),
        "ES": GrowthStandards(
            country: "Spain",
            organization: "Ministerio de Sanidad",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Spanish national growth reference data"
        ),
        "IT": GrowthStandards(
            country: "Italy",
            organization: "Istituto Superiore di Sanità",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Italian growth standards based on WHO curves"
        ),
        "NL": GrowthStandards(
            country: "Netherlands",
            organization: "TNO Growth Atlas",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Dutch growth references for children"
        ),
        "SE": GrowthStandards(
            country: "Sweden",
            organization: "Swedish National Board of Health",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Swedish paediatric growth references"
        ),
        "NO": GrowthStandards(
            country: "Norway",
            organization: "Norwegian Institute of Public Health",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Norwegian child growth standards"
        ),
        "DK": GrowthStandards(
            country: "Denmark",
            organization: "Danish Health Authority",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Danish growth charts aligned with WHO"
        ),
        "FI": GrowthStandards(
            country: "Finland",
            organization: "Finnish Institute for Health and Welfare",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Finnish child welfare clinic growth references"
        ),
        "JP": GrowthStandards(
            country: "Japan",
            organization: "Japanese Society of Pediatrics",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Japanese national growth charts"
        ),
        "KR": GrowthStandards(
            country: "South Korea",
            organization: "Korean Pediatrics Society",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Korean child growth standards"
        ),
        "CN": GrowthStandards(
            country: "China",
            organization: "Chinese CDC",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Chinese national growth reference curves"
        ),
        "IN": GrowthStandards(
            country: "India",
            organization: "ICMR/National Institute of Nutrition",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Indian growth standards aligned to WHO"
        ),
        "BR": GrowthStandards(
            country: "Brazil",
            organization: "Ministério da Saúde",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Brazilian child growth monitoring guidelines"
        ),
        "MX": GrowthStandards(
            country: "Mexico",
            organization: "Secretaría de Salud",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Mexican national growth charts"
        ),
        "AR": GrowthStandards(
            country: "Argentina",
            organization: "Ministerio de Salud",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Argentinian child growth references"
        ),
        "ZA": GrowthStandards(
            country: "South Africa",
            organization: "South African Department of Health",
            weightUnit: "kg",
            heightUnit: "cm",
            notes: "Road-to-Health growth standards"
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
            HealthGuideline(title: "Well-Child Visits", description: "Regular paediatric check-ups", frequency: "Birth, 1, 2, 4, 6, 9, 12, 15, 18, 24, 30, 36 months"),
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
        ],
        "FR": [
            HealthGuideline(title: "PMI Visits", description: "Protection Maternelle et Infantile follow-ups", frequency: "Birth, 1 month, 4 months, 9 months"),
            HealthGuideline(title: "Allaitement Support", description: "Breastfeeding support via PMI centers", frequency: "Available weekdays"),
            HealthGuideline(title: "Carnet de Santé", description: "Child health record checks", frequency: "Brought to every medical visit"),
            HealthGuideline(title: "Emergency Services", description: "15 SAMU medical emergencies", frequency: "24/7 availability")
        ],
        "ES": [
            HealthGuideline(title: "Revisiones del Niño Sano", description: "Well-child pediatric exams", frequency: "Birth, 1, 2, 4, 6, 12, 15, 18, 24 months"),
            HealthGuideline(title: "Apoyo a la Lactancia", description: "Breastfeeding counseling through primary care", frequency: "Clinic hours"),
            HealthGuideline(title: "Programa de Vacunación", description: "Regional vaccination follow-up", frequency: "According to regional schedule"),
            HealthGuideline(title: "Emergencias", description: "112 for emergency services", frequency: "24/7 availability")
        ],
        "IT": [
            HealthGuideline(title: "Bilanci di Salute", description: "Pediatric wellness visits", frequency: "Birth, 1, 3, 6, 9, 12 months"),
            HealthGuideline(title: "Consultori Familiari", description: "Family counselling and breastfeeding support", frequency: "Available through regional clinics"),
            HealthGuideline(title: "Percorso Nascita", description: "Postnatal follow-up program", frequency: "Scheduled via ASL"),
            HealthGuideline(title: "Emergenza", description: "118 for medical emergencies", frequency: "24/7 availability")
        ],
        "NL": [
            HealthGuideline(title: "Consultatiebureau", description: "Youth health clinic visits", frequency: "Birth, 2, 4, 8, 12 weeks then quarterly"),
            HealthGuideline(title: "Kraamzorg", description: "Postnatal maternity care", frequency: "Daily during first week"),
            HealthGuideline(title: "JGZ Checks", description: "Preventive youth healthcare", frequency: "Following Dutch child health schedule"),
            HealthGuideline(title: "Spoed", description: "112 for emergency services", frequency: "24/7 availability")
        ],
        "SE": [
            HealthGuideline(title: "Barnavårdscentral", description: "Child health centre visits", frequency: "Birth, 1 week, 6 weeks, 3, 6, 12 months"),
            HealthGuideline(title: "Föräldrastöd", description: "Parental support groups", frequency: "Weekly sessions"),
            HealthGuideline(title: "Vaccinationsprogram", description: "National immunisation follow-up", frequency: "According to Swedish schedule"),
            HealthGuideline(title: "Akut Hjälp", description: "112 for emergencies", frequency: "24/7 availability")
        ],
        "NO": [
            HealthGuideline(title: "Helsestasjon", description: "Municipal child health clinic visits", frequency: "Birth, 6 weeks, 3, 4, 5, 8, 12 months"),
            HealthGuideline(title: "Ammehjelpen", description: "Breastfeeding support network", frequency: "Hotline daily"),
            HealthGuideline(title: "Foreldrekurs", description: "Parenting classes", frequency: "Scheduled by municipality"),
            HealthGuideline(title: "Nødnummer", description: "113 medical emergencies", frequency: "24/7 availability")
        ],
        "DK": [
            HealthGuideline(title: "Sundhedsplejen", description: "Home visits by public health nurse", frequency: "Birth, 4-5 days, 1, 2, 3, 6 months"),
            HealthGuideline(title: "Ammevejledning", description: "Breastfeeding counselling", frequency: "By appointment"),
            HealthGuideline(title: "Barn undersøgelse", description: "GP-led child examinations", frequency: "Key milestones up to 5 years"),
            HealthGuideline(title: "Alarm", description: "112 emergency services", frequency: "24/7 availability")
        ],
        "FI": [
            HealthGuideline(title: "Neuvola", description: "Maternity and child health clinic visits", frequency: "Birth, 1-4 weeks, 2, 3, 4, 6, 8, 12 months"),
            HealthGuideline(title: "Perhevalmennus", description: "Family coaching sessions", frequency: "Prenatal and early postnatal"),
            HealthGuideline(title: "Imetystuki", description: "Breastfeeding support via clinics", frequency: "Clinic hours"),
            HealthGuideline(title: "Hätäpalvelu", description: "112 emergency services", frequency: "24/7 availability")
        ],
        "JP": [
            HealthGuideline(title: "Boshi Kenko Techo", description: "Maternal and child health handbook follow-ups", frequency: "All checkups recorded"),
            HealthGuideline(title: "Jidō Hoken Center", description: "Community child health center visits", frequency: "Scheduled by municipality"),
            HealthGuideline(title: "Sango Kango", description: "Postnatal home visits by public health nurse", frequency: "Within first month"),
            HealthGuideline(title: "Kyūkyū", description: "119 emergency medical service", frequency: "24/7 availability")
        ],
        "KR": [
            HealthGuideline(title: "Infant Health Check-ups", description: "National developmental screening", frequency: "4, 9, 18, 30, 42 months"),
            HealthGuideline(title: "Breastfeeding Clinics", description: "Support via public health centers", frequency: "Weekday clinics"),
            HealthGuideline(title: "Healthy Mom Program", description: "Postnatal care support", frequency: "First 6 months"),
            HealthGuideline(title: "Emergency", description: "119 emergency services", frequency: "24/7 availability")
        ],
        "CN": [
            HealthGuideline(title: "Child Health Management", description: "Community health center visits", frequency: "Birth, 1, 3, 6, 8, 12 months"),
            HealthGuideline(title: "Breastfeeding Clinics", description: "Maternal-child health hospital support", frequency: "Clinic hours"),
            HealthGuideline(title: "Early Development", description: "Growth and developmental screening", frequency: "Every visit"),
            HealthGuideline(title: "Emergency", description: "120 medical emergencies", frequency: "24/7 availability")
        ],
        "IN": [
            HealthGuideline(title: "VHND", description: "Village health and nutrition days", frequency: "Monthly"),
            HealthGuideline(title: "ANM Visits", description: "Auxiliary nurse midwife home visits", frequency: "Within 48 hours, 7, 14, 21, 28 days"),
            HealthGuideline(title: "Mother and Child Protection Card", description: "Track immunisation and growth", frequency: "At every health contact"),
            HealthGuideline(title: "Emergency", description: "108 for medical emergencies", frequency: "24/7 availability")
        ],
        "BR": [
            HealthGuideline(title: "Programa Saúde da Criança", description: "Primary care well-baby visits", frequency: "Birth, 1, 2, 4, 6, 12 months"),
            HealthGuideline(title: "Rede Cegonha", description: "Maternal and neonatal care network", frequency: "Throughout pregnancy and first year"),
            HealthGuideline(title: "Cartão da Criança", description: "Child health booklet tracking", frequency: "At all visits"),
            HealthGuideline(title: "Emergência", description: "192 SAMU medical emergencies", frequency: "24/7 availability")
        ],
        "MX": [
            HealthGuideline(title: "Control del Niño Sano", description: "IMSS/ISSSTE well-child clinics", frequency: "Birth, 1, 2, 4, 6, 9, 12 months"),
            HealthGuideline(title: "Promoción de Lactancia", description: "Breastfeeding support at centros de salud", frequency: "Clinic hours"),
            HealthGuideline(title: "Prospera Nutrition", description: "Nutritional supplements for families", frequency: "Monthly distribution"),
            HealthGuideline(title: "Emergencias", description: "911 medical emergencies", frequency: "24/7 availability")
        ],
        "AR": [
            HealthGuideline(title: "Controles Pediátricos", description: "Pediatric follow-up in public hospitals", frequency: "Birth, 1, 2, 4, 6, 9, 12 months"),
            HealthGuideline(title: "Consejerías de Lactancia", description: "Breastfeeding counselling", frequency: "Available at hospitals and CAPS"),
            HealthGuideline(title: "Plan Sumar", description: "Maternal-child health coverage", frequency: "Checkpoints through age 6"),
            HealthGuideline(title: "Emergencias", description: "911 for emergencies", frequency: "24/7 availability")
        ],
        "ZA": [
            HealthGuideline(title: "Road-to-Health Clinic", description: "Well-baby visits and growth monitoring", frequency: "Birth, 3 days, 6 weeks, 10 weeks, 14 weeks, 6, 9, 12 months"),
            HealthGuideline(title: "Ward-based Outreach", description: "Community health worker visits", frequency: "Monthly in first year"),
            HealthGuideline(title: "MomConnect", description: "Mobile maternal health messaging", frequency: "SMS guidance through pregnancy and infancy"),
            HealthGuideline(title: "Emergency", description: "10177 ambulance services", frequency: "24/7 availability")
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
        ),
        "FR": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "15 (SAMU)",
            ambulanceService: "SAMU / Service Mobile d'Urgence",
            hospitalFinder: "Ameli.fr",
            notes: "112 or 15 for medical emergencies; 116 117 for non-urgent care"
        ),
        "ES": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "061",
            ambulanceService: "Servicios de Emergencias Sanitarias",
            hospitalFinder: "Ministerio de Sanidad",
            notes: "Call 112 nationwide; 061 connects to regional health emergencies"
        ),
        "IT": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "118",
            ambulanceService: "Servizio Sanitario Nazionale",
            hospitalFinder: "Portale Salute",
            notes: "112 for emergencies; 118 for medical ambulance dispatch"
        ),
        "NL": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "0900 8844",
            ambulanceService: "Ambulancezorg Nederland",
            hospitalFinder: "ZorgkaartNederland",
            notes: "112 for life-threatening emergencies; 0900 8844 for police/medical advice"
        ),
        "SE": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "1177",
            ambulanceService: "Regionernas Ambulans",
            hospitalFinder: "1177.se",
            notes: "112 for emergencies; 1177 for medical advice"
        ),
        "NO": EmergencyInfo(
            emergencyNumber: "113",
            nonEmergencyNumber: "116 117",
            ambulanceService: "Ambulanse Norge",
            hospitalFinder: "Helsenorge",
            notes: "113 for medical emergencies; 116 117 for urgent care"
        ),
        "DK": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "1813",
            ambulanceService: "Akutberedskabet",
            hospitalFinder: "Sundhed.dk",
            notes: "112 for emergencies; 1813 for out-of-hours medical advice"
        ),
        "FI": EmergencyInfo(
            emergencyNumber: "112",
            nonEmergencyNumber: "116 117",
            ambulanceService: "Finnish EMS",
            hospitalFinder: "Suunta.fi",
            notes: "112 for emergencies; 116 117 for non-urgent care"
        ),
        "JP": EmergencyInfo(
            emergencyNumber: "119",
            nonEmergencyNumber: "#7119",
            ambulanceService: "Fire and Disaster Management Agency",
            hospitalFinder: "Japan Saisei Medical Net",
            notes: "119 for ambulance/fire; #7119 connects to emergency consultation"
        ),
        "KR": EmergencyInfo(
            emergencyNumber: "119",
            nonEmergencyNumber: "129",
            ambulanceService: "National Emergency Management",
            hospitalFinder: "Health Insurance Review & Assessment",
            notes: "119 for emergencies; 129 for health consultation"
        ),
        "CN": EmergencyInfo(
            emergencyNumber: "120",
            nonEmergencyNumber: "12320",
            ambulanceService: "China EMS",
            hospitalFinder: "National Health Commission",
            notes: "120 for medical emergencies; 12320 for health hotline"
        ),
        "IN": EmergencyInfo(
            emergencyNumber: "108",
            nonEmergencyNumber: "104",
            ambulanceService: "National Ambulance Service",
            hospitalFinder: "National Health Portal",
            notes: "108 for emergency ambulance; 104 for health advice"
        ),
        "BR": EmergencyInfo(
            emergencyNumber: "192",
            nonEmergencyNumber: "136",
            ambulanceService: "SAMU",
            hospitalFinder: "DATASUS",
            notes: "192 for medical emergencies; 136 for health hotline"
        ),
        "MX": EmergencyInfo(
            emergencyNumber: "911",
            nonEmergencyNumber: "800 0044 800",
            ambulanceService: "Cruz Roja Mexicana",
            hospitalFinder: "Secretaría de Salud",
            notes: "911 for emergencies; 800 0044 800 for health guidance"
        ),
        "AR": EmergencyInfo(
            emergencyNumber: "107",
            nonEmergencyNumber: "911",
            ambulanceService: "Sistema de Atención Médica de Emergencia",
            hospitalFinder: "Ministerio de Salud",
            notes: "107 for medical emergencies; 911 for general emergencies"
        ),
        "ZA": EmergencyInfo(
            emergencyNumber: "10177",
            nonEmergencyNumber: "112",
            ambulanceService: "Emergency Medical Services",
            hospitalFinder: "National Department of Health",
            notes: "10177 for public ambulance; 112 connects via mobile networks"
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