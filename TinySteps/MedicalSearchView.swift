import SwiftUI

struct MedicalSearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [MedicalTerm] = []
    @State private var predictiveSuggestions: [String] = []
    @State private var isSearching = false
    @State private var showPredictiveSuggestions = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // Comprehensive medical terms database with predictive text support
    private let medicalTerms: [MedicalTerm] = [
        // Respiratory System
        MedicalTerm(term: "NICU", definition: "Neonatal Intensive Care Unit - Specialized unit for premature or sick newborns", category: "Medical Unit", synonyms: ["Neonatal ICU", "Intensive Care", "NICU Unit"]),
        MedicalTerm(term: "Apnea", definition: "Temporary cessation of breathing, common in premature infants", category: "Respiratory", synonyms: ["Breathing Pause", "Respiratory Pause", "Apnea of Prematurity"]),
        MedicalTerm(term: "Bradycardia", definition: "Slow heart rate, often seen in premature babies", category: "Cardiac", synonyms: ["Slow Heart Rate", "Low Heart Rate", "Brady"]),
        MedicalTerm(term: "CPAP", definition: "Continuous Positive Airway Pressure - breathing support", category: "Respiratory", synonyms: ["Continuous Positive Airway Pressure", "Breathing Support", "CPAP Machine"]),
        MedicalTerm(term: "Ventilator", definition: "Machine that helps baby breathe", category: "Respiratory", synonyms: ["Breathing Machine", "Respirator", "Mechanical Ventilation"]),
        MedicalTerm(term: "Oxygen Saturation", definition: "Percentage of oxygen in blood, monitored continuously", category: "Monitoring", synonyms: ["O2 Sat", "SpO2", "Oxygen Level", "Blood Oxygen"]),
        MedicalTerm(term: "Surfactant", definition: "Substance that helps lungs expand, often given to premature babies", category: "Respiratory", synonyms: ["Lung Surfactant", "Pulmonary Surfactant", "Lung Development"]),
        MedicalTerm(term: "Respiratory Distress Syndrome", definition: "Lung condition where premature babies struggle to breathe", category: "Respiratory", synonyms: ["RDS", "Lung Disease", "Breathing Difficulty"]),
        
        // Cardiac System
        MedicalTerm(term: "Patent Ductus Arteriosus", definition: "Heart condition where blood vessel doesn't close", category: "Cardiac", synonyms: ["PDA", "Heart Defect", "Blood Vessel", "Heart Condition"]),
        MedicalTerm(term: "Tachycardia", definition: "Fast heart rate, can be normal or indicate problems", category: "Cardiac", synonyms: ["Fast Heart Rate", "High Heart Rate", "Tachy"]),
        MedicalTerm(term: "Heart Murmur", definition: "Extra sound in heartbeat, common in newborns", category: "Cardiac", synonyms: ["Murmur", "Heart Sound", "Cardiac Murmur"]),
        
        // Liver & Digestive
        MedicalTerm(term: "Jaundice", definition: "Yellowing of skin due to high bilirubin levels", category: "Liver", synonyms: ["Yellow Skin", "Bilirubin", "Hyperbilirubinemia", "Neonatal Jaundice"]),
        MedicalTerm(term: "Bilirubin", definition: "Substance causing jaundice, measured in blood tests", category: "Liver", synonyms: ["Liver Enzyme", "Yellow Pigment", "Blood Test"]),
        MedicalTerm(term: "Phototherapy", definition: "Light treatment for jaundice", category: "Treatment", synonyms: ["Light Therapy", "Bili Light", "Jaundice Treatment"]),
        MedicalTerm(term: "Necrotizing Enterocolitis", definition: "Serious intestinal condition in premature babies", category: "Digestive", synonyms: ["NEC", "Intestinal Disease", "Bowel Condition", "Digestive Problem"]),
        MedicalTerm(term: "Feeding Intolerance", definition: "Baby cannot tolerate normal feeding amounts", category: "Digestive", synonyms: ["Feeding Problem", "Digestive Issue", "Feeding Difficulty"]),
        
        // Nutrition & Feeding
        MedicalTerm(term: "Feeding Tube", definition: "Tube inserted through nose or mouth to provide nutrition", category: "Nutrition", synonyms: ["NG Tube", "Nasogastric Tube", "Feeding Line", "Nutrition Tube"]),
        MedicalTerm(term: "Total Parenteral Nutrition", definition: "IV nutrition when baby cannot eat normally", category: "Nutrition", synonyms: ["TPN", "IV Nutrition", "Parenteral Feeding"]),
        MedicalTerm(term: "Breast Milk", definition: "Mother's milk, best nutrition for premature babies", category: "Nutrition", synonyms: ["Mother's Milk", "Human Milk", "Breastfeeding"]),
        MedicalTerm(term: "Formula", definition: "Artificial milk substitute for babies", category: "Nutrition", synonyms: ["Baby Formula", "Artificial Milk", "Milk Substitute"]),
        
        // Development & Growth
        MedicalTerm(term: "Premature", definition: "Born before 37 weeks of pregnancy", category: "Development", synonyms: ["Preterm", "Early Birth", "Premature Birth"]),
        MedicalTerm(term: "Low Birth Weight", definition: "Weighing less than 2.5kg at birth", category: "Development", synonyms: ["Small Baby", "Underweight", "LBW"]),
        MedicalTerm(term: "Very Low Birth Weight", definition: "Weighing less than 1.5kg at birth", category: "Development", synonyms: ["VLBW", "Extremely Small", "Very Small Baby"]),
        MedicalTerm(term: "Extremely Low Birth Weight", definition: "Weighing less than 1kg at birth", category: "Development", synonyms: ["ELBW", "Extremely Small", "Micro Preemie"]),
        MedicalTerm(term: "Gestational Age", definition: "Age based on weeks of pregnancy", category: "Development", synonyms: ["Pregnancy Age", "Weeks Gestation", "Fetal Age"]),
        MedicalTerm(term: "Corrected Age", definition: "Age adjusted for prematurity", category: "Development", synonyms: ["Adjusted Age", "Corrected Gestational Age", "Prematurity Adjustment"]),
        
        // Care & Treatment
        MedicalTerm(term: "Kangaroo Care", definition: "Skin-to-skin contact between parent and baby", category: "Care", synonyms: ["Skin to Skin", "Kangaroo Mother Care", "Parent Care"]),
        MedicalTerm(term: "IV", definition: "Intravenous - medication or fluids given through vein", category: "Treatment", synonyms: ["Intravenous", "IV Line", "Vein Access", "Medication Line"]),
        MedicalTerm(term: "Central Line", definition: "IV line in major blood vessel for long-term access", category: "Treatment", synonyms: ["Central Venous Catheter", "CVC", "Major Vein Access"]),
        MedicalTerm(term: "Umbilical Catheter", definition: "IV line through umbilical cord vessels", category: "Treatment", synonyms: ["UAC", "UVC", "Umbilical Line", "Cord Access"]),
        MedicalTerm(term: "Antibiotics", definition: "Medication to treat bacterial infections", category: "Treatment", synonyms: ["Anti-infection", "Bacterial Treatment", "Infection Medicine"]),
        
        // Monitoring & Equipment
        MedicalTerm(term: "Pulse Oximeter", definition: "Device that measures oxygen levels in blood", category: "Monitoring", synonyms: ["Oximeter", "O2 Monitor", "Oxygen Monitor", "SpO2 Monitor"]),
        MedicalTerm(term: "Cardiac Monitor", definition: "Machine that tracks heart rate and rhythm", category: "Monitoring", synonyms: ["Heart Monitor", "ECG Monitor", "Cardiac Tracing"]),
        MedicalTerm(term: "Temperature Probe", definition: "Device that continuously measures body temperature", category: "Monitoring", synonyms: ["Temp Probe", "Temperature Monitor", "Body Temperature"]),
        MedicalTerm(term: "Blood Pressure Monitor", definition: "Device that measures blood pressure", category: "Monitoring", synonyms: ["BP Monitor", "Pressure Monitor", "Blood Pressure"]),
        MedicalTerm(term: "Incubator", definition: "Warm, enclosed bed for premature babies", category: "Equipment", synonyms: ["Isolette", "Warm Bed", "Baby Bed", "NICU Bed"]),
        MedicalTerm(term: "Radiant Warmer", definition: "Open bed with overhead heat for procedures", category: "Equipment", synonyms: ["Warmer Bed", "Open Bed", "Procedure Bed"]),
        
        // Infections & Complications
        MedicalTerm(term: "Sepsis", definition: "Serious infection affecting the whole body", category: "Infection", synonyms: ["Blood Infection", "Systemic Infection", "Bacterial Infection"]),
        MedicalTerm(term: "Meningitis", definition: "Infection of the brain and spinal cord", category: "Infection", synonyms: ["Brain Infection", "Spinal Cord Infection", "Central Nervous System Infection"]),
        MedicalTerm(term: "Pneumonia", definition: "Infection in the lungs", category: "Infection", synonyms: ["Lung Infection", "Respiratory Infection", "Pulmonary Infection"]),
        MedicalTerm(term: "Urinary Tract Infection", definition: "Infection in bladder or kidneys", category: "Infection", synonyms: ["UTI", "Bladder Infection", "Kidney Infection"]),
        
        // Neurological & Vision
        MedicalTerm(term: "Intraventricular Hemorrhage", definition: "Bleeding in brain, common in very premature babies", category: "Neurological", synonyms: ["IVH", "Brain Bleed", "Cerebral Hemorrhage", "Brain Hemorrhage"]),
        MedicalTerm(term: "Retinopathy of Prematurity", definition: "Eye condition affecting premature babies", category: "Vision", synonyms: ["ROP", "Eye Disease", "Retinal Disease", "Vision Problem"]),
        MedicalTerm(term: "Hydrocephalus", definition: "Build-up of fluid in brain", category: "Neurological", synonyms: ["Water on Brain", "Brain Fluid", "Cerebral Fluid"]),
        MedicalTerm(term: "Seizure", definition: "Abnormal electrical activity in brain", category: "Neurological", synonyms: ["Convulsion", "Brain Seizure", "Neurological Event"]),
        
        // Procedures & Tests
        MedicalTerm(term: "Lumbar Puncture", definition: "Spinal tap to test for infection", category: "Procedure", synonyms: ["Spinal Tap", "LP", "Cerebrospinal Fluid Test"]),
        MedicalTerm(term: "Blood Gas", definition: "Blood test to measure oxygen and acid levels", category: "Test", synonyms: ["ABG", "Arterial Blood Gas", "Oxygen Test"]),
        MedicalTerm(term: "Chest X-Ray", definition: "X-ray image of lungs and heart", category: "Test", synonyms: ["CXR", "Lung X-Ray", "Chest Imaging"]),
        MedicalTerm(term: "Ultrasound", definition: "Sound wave imaging of internal organs", category: "Test", synonyms: ["Sonogram", "Echo", "Sound Imaging"]),
        MedicalTerm(term: "Echocardiogram", definition: "Ultrasound of the heart", category: "Test", synonyms: ["Echo", "Heart Ultrasound", "Cardiac Ultrasound"]),
        
        // Medications
        MedicalTerm(term: "Caffeine", definition: "Medication to treat apnea in premature babies", category: "Medication", synonyms: ["Caffeine Citrate", "Apnea Treatment", "Stimulant"]),
        MedicalTerm(term: "Dexamethasone", definition: "Steroid medication to help lung development", category: "Medication", synonyms: ["Dex", "Steroid", "Lung Medication"]),
        MedicalTerm(term: "Indomethacin", definition: "Medication to close patent ductus arteriosus", category: "Medication", synonyms: ["Indo", "PDA Medication", "Heart Medication"]),
        MedicalTerm(term: "Vancomycin", definition: "Antibiotic for serious infections", category: "Medication", synonyms: ["Vanc", "Antibiotic", "Infection Treatment"]),
        
        // Support & Care
        MedicalTerm(term: "Occupational Therapy", definition: "Therapy to help with feeding and development", category: "Therapy", synonyms: ["OT", "Feeding Therapy", "Development Therapy"]),
        MedicalTerm(term: "Physical Therapy", definition: "Therapy to help with movement and strength", category: "Therapy", synonyms: ["PT", "Movement Therapy", "Strength Therapy"]),
        MedicalTerm(term: "Speech Therapy", definition: "Therapy to help with feeding and swallowing", category: "Therapy", synonyms: ["ST", "Feeding Therapy", "Swallowing Therapy"]),
        MedicalTerm(term: "Social Worker", definition: "Professional who helps with family support and resources", category: "Support", synonyms: ["Case Worker", "Family Support", "Resource Coordinator"]),
        MedicalTerm(term: "Child Life Specialist", definition: "Professional who helps with baby's development and family support", category: "Support", synonyms: ["Development Specialist", "Family Support", "Child Development"])
    ]
    
    var body: some View {
        ZStack {
            // Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: horizontalSizeClass == .regular ? 24 : 16) {
                // Header
                VStack(spacing: horizontalSizeClass == .regular ? 12 : 8) {
                    Text("Medical Search")
                        .font(horizontalSizeClass == .regular ? .largeTitle : .title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Search for medical terms and conditions")
                        .font(horizontalSizeClass == .regular ? .body : .subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                
                // Search Bar with Predictive Text
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.title2)
                        
                        TextField("Search medical terms...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.body)
                            .onChange(of: searchText) { _, newValue in
                                performSearch(query: newValue)
                                generatePredictiveSuggestions(query: newValue)
                            }
                            .onTapGesture {
                                if !searchText.isEmpty {
                                    showPredictiveSuggestions = true
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = []
                                predictiveSuggestions = []
                                showPredictiveSuggestions = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.horizontal, horizontalSizeClass == .regular ? 20 : 16)
                    .padding(.vertical, horizontalSizeClass == .regular ? 16 : 12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Predictive Suggestions
                    if showPredictiveSuggestions && !predictiveSuggestions.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(predictiveSuggestions.prefix(5), id: \.self) { suggestion in
                                Button(action: {
                                    searchText = suggestion
                                    performSearch(query: suggestion)
                                    showPredictiveSuggestions = false
                                }) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.blue)
                                            .font(.caption)
                                        
                                        Text(suggestion)
                                            .font(.body)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, horizontalSizeClass == .regular ? 20 : 16)
                                    .padding(.vertical, horizontalSizeClass == .regular ? 12 : 8)
                                    .background(Color.white.opacity(0.05))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if suggestion != predictiveSuggestions.prefix(5).last {
                                    Divider()
                                        .background(Color.white.opacity(0.2))
                                        .padding(.leading, horizontalSizeClass == .regular ? 40 : 36)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.top, 1)
                    }
                }
                .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                
                // Search Results or Popular Terms
                if searchText.isEmpty {
                    // Show popular terms
                    VStack(alignment: .leading, spacing: horizontalSizeClass == .regular ? 16 : 12) {
                        Text("Popular Medical Terms")
                            .font(horizontalSizeClass == .regular ? .title2 : .headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: horizontalSizeClass == .regular ? 16 : 12) {
                            ForEach(Array(medicalTerms.prefix(8)), id: \.term) { term in
                                Button(action: {
                                    searchText = term.term
                                    performSearch(query: term.term)
                                }) {
                                    VStack(alignment: .leading, spacing: horizontalSizeClass == .regular ? 8 : 6) {
                                        Text(term.term)
                                            .font(horizontalSizeClass == .regular ? .body : .subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        
                                        Text(term.category)
                                            .font(horizontalSizeClass == .regular ? .caption : .caption2)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(horizontalSizeClass == .regular ? 16 : 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                    }
                } else {
                    // Show search results
                    VStack(alignment: .leading, spacing: horizontalSizeClass == .regular ? 16 : 12) {
                        HStack {
                            Text("Search Results")
                                .font(horizontalSizeClass == .regular ? .title2 : .headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                        }
                        .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                        
                        if searchResults.isEmpty && !isSearching {
                            VStack(spacing: horizontalSizeClass == .regular ? 16 : 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("No results found")
                                    .font(horizontalSizeClass == .regular ? .body : .subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Try searching for different terms")
                                    .font(horizontalSizeClass == .regular ? .caption : .caption2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, horizontalSizeClass == .regular ? 40 : 30)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: horizontalSizeClass == .regular ? 16 : 12) {
                                    ForEach(searchResults, id: \.term) { term in
                                        MedicalTermCard(term: term)
                                    }
                                }
                                .padding(.horizontal, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top, horizontalSizeClass == .regular ? TinyStepsDesign.Spacing.xl : TinyStepsDesign.Spacing.md)
        }
        .navigationTitle("Medical Search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        // Simulate search delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let filteredTerms = medicalTerms.filter { term in
                // Search in term name
                term.term.localizedCaseInsensitiveContains(query) ||
                // Search in definition
                term.definition.localizedCaseInsensitiveContains(query) ||
                // Search in category
                term.category.localizedCaseInsensitiveContains(query) ||
                // Search in synonyms
                term.synonyms.contains { synonym in
                    synonym.localizedCaseInsensitiveContains(query)
                }
            }
            
            // Sort results by relevance (exact matches first, then partial matches)
            let sortedResults = filteredTerms.sorted { term1, term2 in
                let queryLower = query.lowercased()
                let term1Lower = term1.term.lowercased()
                let term2Lower = term2.term.lowercased()
                
                // Exact matches first
                if term1Lower == queryLower && term2Lower != queryLower {
                    return true
                }
                if term2Lower == queryLower && term1Lower != queryLower {
                    return false
                }
                
                // Starts with matches second
                if term1Lower.hasPrefix(queryLower) && !term2Lower.hasPrefix(queryLower) {
                    return true
                }
                if term2Lower.hasPrefix(queryLower) && !term1Lower.hasPrefix(queryLower) {
                    return false
                }
                
                // Then by alphabetical order
                return term1.term < term2.term
            }
            
            searchResults = sortedResults
            isSearching = false
        }
    }
    
    private func generatePredictiveSuggestions(query: String) {
        guard !query.isEmpty else {
            predictiveSuggestions = []
            showPredictiveSuggestions = false
            return
        }
        
        let queryLower = query.lowercased()
        var suggestions: Set<String> = []
        
        // Find suggestions from terms, definitions, and synonyms
        for term in medicalTerms {
            // Add term if it matches
            if term.term.localizedCaseInsensitiveContains(query) {
                suggestions.insert(term.term)
            }
            
            // Add synonyms that match
            for synonym in term.synonyms {
                if synonym.localizedCaseInsensitiveContains(query) {
                    suggestions.insert(synonym)
                }
            }
            
            // Add category if it matches
            if term.category.localizedCaseInsensitiveContains(query) {
                suggestions.insert(term.category)
            }
        }
        
        // Convert to array and sort by relevance
        let sortedSuggestions = Array(suggestions).sorted { suggestion1, suggestion2 in
            let suggestion1Lower = suggestion1.lowercased()
            let suggestion2Lower = suggestion2.lowercased()
            
            // Exact matches first
            if suggestion1Lower == queryLower && suggestion2Lower != queryLower {
                return true
            }
            if suggestion2Lower == queryLower && suggestion1Lower != queryLower {
                return false
            }
            
            // Starts with matches second
            if suggestion1Lower.hasPrefix(queryLower) && !suggestion2Lower.hasPrefix(queryLower) {
                return true
            }
            if suggestion2Lower.hasPrefix(queryLower) && !suggestion1Lower.hasPrefix(queryLower) {
                return false
            }
            
            // Then by length (shorter first)
            if suggestion1.count != suggestion2.count {
                return suggestion1.count < suggestion2.count
            }
            
            // Finally alphabetical
            return suggestion1 < suggestion2
        }
        
        predictiveSuggestions = sortedSuggestions
        showPredictiveSuggestions = !sortedSuggestions.isEmpty
    }
}

struct MedicalTerm: Identifiable {
    let id = UUID()
    let term: String
    let definition: String
    let category: String
    let synonyms: [String]
}

struct MedicalTermCard: View {
    let term: MedicalTerm
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showSynonyms = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: horizontalSizeClass == .regular ? 12 : 8) {
            HStack {
                Text(term.term)
                    .font(horizontalSizeClass == .regular ? .title3 : .headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(term.category)
                    .font(horizontalSizeClass == .regular ? .caption : .caption2)
                    .foregroundColor(.blue)
                    .padding(.horizontal, horizontalSizeClass == .regular ? 12 : 8)
                    .padding(.vertical, horizontalSizeClass == .regular ? 4 : 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(horizontalSizeClass == .regular ? 8 : 6)
            }
            
            Text(term.definition)
                .font(horizontalSizeClass == .regular ? .body : .subheadline)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
            
            // Synonyms section
            if !term.synonyms.isEmpty {
                VStack(alignment: .leading, spacing: horizontalSizeClass == .regular ? 8 : 6) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSynonyms.toggle()
                        }
                    }) {
                        HStack {
                            Text("Synonyms (\(term.synonyms.count))")
                                .font(horizontalSizeClass == .regular ? .caption : .caption2)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Image(systemName: showSynonyms ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showSynonyms {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: horizontalSizeClass == .regular ? 8 : 6) {
                            ForEach(term.synonyms, id: \.self) { synonym in
                                Text(synonym)
                                    .font(horizontalSizeClass == .regular ? .caption : .caption2)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, horizontalSizeClass == .regular ? 8 : 6)
                                    .padding(.vertical, horizontalSizeClass == .regular ? 4 : 2)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
        }
        .padding(horizontalSizeClass == .regular ? 20 : 16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        MedicalSearchView()
    }
}
