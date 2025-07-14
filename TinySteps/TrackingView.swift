//
//  TrackingView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
import Charts // Add this import if available (iOS 16+)

struct TrackingView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingFeedingSheet = false
    @State private var showingSleepSheet = false
    @State private var showingNappySheet = false
    @State private var animateContent = false
    @State private var selectedAction: String?
    @State private var showingBabyForm = false
    // Add state for showing milk estimate
    @State private var showMilkEstimate: Bool = false
    @State private var milkEstimate: Double? = nil
    @State private var perFeedEstimate: Double? = nil
    @State private var showingWeightSheet = false
    @State private var weightDate = Date()
    @State private var weightValue = ""
    @State private var editingWeight: WeightEntry? = nil
    @State private var showingVaccinationSheet = false
    @State private var vaccinationTitle = ""
    @State private var vaccinationDate = Date()
    @State private var vaccinationNotes = ""
    @State private var editingVaccination: VaccinationRecord? = nil
    @State private var showingHeightSheet = false
    @State private var heightDate = Date()
    @State private var heightValue = ""
    @State private var editingHeight: MeasurementEntry? = nil
    @State private var showingHeadSheet = false
    @State private var headDate = Date()
    @State private var headValue = ""
    @State private var editingHead: MeasurementEntry? = nil
    @State private var showingSolidFoodSheet = false
    @State private var foodName = ""
    @State private var foodDate = Date()
    @State private var foodReaction: SolidFoodRecord.FoodReaction = .neutral
    @State private var foodNotes = ""
    @State private var showingSleepPatternSheet = false
    @State private var sleepStartTime = Date()
    @State private var sleepEndTime = Date()
    @State private var sleepLocation: SleepRecord.SleepLocation = .crib
    @State private var sleepQuality: SleepRecord.SleepQuality = .good
    @State private var sleepNotes = ""
    @State private var showingDataExport = false
    @State private var showingGrowthChartsSheet = false
    @State private var showingMeasurementOptionsSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Achievement Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.sports, color: TinyStepsDesign.Colors.success)
                Text("Dad's Progress")
                    .font(TinyStepsDesign.Typography.header)
                    .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                Spacer()
            }
            .padding()
            .background(TinyStepsDesign.Colors.primary)
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top, 12)
            // Main Content
            ScrollView {
                VStack(spacing: 20) {
                    // Add Baby Section
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: 50, height: 50)
                                )
                        }
                        .scaleEffect(animateContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateContent)
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    
                    // Baby Information Section
                    if let baby = dataManager.baby {
                        BabyInfoCard(baby: baby) {
                            showingBabyForm = true
                        }
                        .offset(y: animateContent ? 0 : 100)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateContent)
                        .padding(.horizontal)
                        // Show milk estimate if bottle-fed or both
                        if let feedingMethod = baby.feedingMethod, (feedingMethod == "Bottle-fed" || feedingMethod == "Both"), let weight = baby.weight {
                            let daily = weight * 150
                            let perFeed = daily / 8.0
                            VStack(spacing: 10) {
                                Text("Estimated Daily Milk Requirement")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("~ \(Int(daily)) ml per day")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("~ \(Int(perFeed)) ml per feed (assuming 8 feeds per day)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Text("This is an estimate based on 150ml per kg of body weight per day. Always consult your healthcare provider for feeding advice.")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        // --- UNIFIED GROWTH, HEALTH & ACTIVITY CARD ---
                        VStack(alignment: .leading, spacing: 24) {
                            // Growth Charts Header
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.blue)
                                Text("Growth, Health & Activity")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                            // Vaccination & Health Check Reminders
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "cross.case.fill")
                                        .foregroundColor(.green)
                                    Text("Vaccination & Health Check Reminders")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: {
                                        editingVaccination = nil
                                        vaccinationTitle = ""
                                        vaccinationDate = Date()
                                        vaccinationNotes = ""
                                        showingVaccinationSheet = true
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.horizontal)
                                if dataManager.vaccinations.isEmpty {
                                    Text("No reminders yet. Tap + to add.")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal)
                                } else {
                                    VStack(alignment: .leading, spacing: 6) {
                                        ForEach(dataManager.vaccinations.sorted { $0.date < $1.date }) { record in
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(record.title)
                                                        .font(.headline)
                                                        .foregroundColor(record.isCompleted ? .gray : .white)
                                                    Text(record.date, style: .date)
                                                        .font(.caption)
                                                        .foregroundColor(.blue)
                                                    if let notes = record.notes, !notes.isEmpty {
                                                        Text(notes)
                                                            .font(.caption2)
                                                            .foregroundColor(.white.opacity(0.7))
                                                    }
                                                }
                                                Spacer()
                                                if record.isCompleted {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                } else {
                                                    Button(action: {
                                                        markVaccinationComplete(record)
                                                    }) {
                                                        Image(systemName: "checkmark.circle")
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                Button(action: {
                                                    editingVaccination = record
                                                    vaccinationTitle = record.title
                                                    vaccinationDate = record.date
                                                    vaccinationNotes = record.notes ?? ""
                                                    showingVaccinationSheet = true
                                                }) {
                                                    Image(systemName: "pencil")
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            // Solid Food Tracker
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "fork.knife")
                                        .foregroundColor(.pink)
                                    Text("Solid Food Tracker")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: {
                                        foodName = ""
                                        foodDate = Date()
                                        foodReaction = .neutral
                                        foodNotes = ""
                                        showingSolidFoodSheet = true
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.pink)
                                    }
                                }
                                .padding(.horizontal)
                                if dataManager.solidFoodRecords.isEmpty {
                                    Text("No solid foods logged yet. Tap + to add.")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal)
                                } else {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(dataManager.solidFoodRecords.sorted { $0.date > $1.date }) { record in
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(record.foodName)
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                    Text(record.date, style: .date)
                                                        .font(.caption)
                                                        .foregroundColor(.blue)
                                                    if let notes = record.notes, !notes.isEmpty {
                                                        Text(notes)
                                                            .font(.caption2)
                                                            .foregroundColor(.white.opacity(0.7))
                                                    }
                                                }
                                                Spacer()
                                                Image(systemName: record.reaction.icon)
                                                    .foregroundColor(record.reaction.color)
                                                    .font(.title3)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            // Sleep Pattern Tracker
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "bed.double.fill")
                                        .foregroundColor(.indigo)
                                    Text("Sleep Pattern Tracker")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: {
                                        sleepStartTime = Date()
                                        sleepEndTime = Date()
                                        sleepLocation = .crib
                                        sleepQuality = .good
                                        sleepNotes = ""
                                        showingSleepPatternSheet = true
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.indigo)
                                    }
                                }
                                .padding(.horizontal)
                                if dataManager.sleepRecords.isEmpty {
                                    Text("No sleep data yet. Tap + to add.")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal)
                                } else {
                                    // Sleep summary
                                    let todaySleeps = dataManager.sleepRecords.filter { 
                                        Calendar.current.isDateInToday($0.startTime) 
                                    }
                                    let totalHours = todaySleeps.reduce(0.0) { total, sleep in
                                        if let endTime = sleep.endTime {
                                            return total + endTime.timeIntervalSince(sleep.startTime) / 3600
                                        }
                                        return total
                                    }
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Today's Sleep: \(formatDuration(hours: totalHours))")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(todaySleeps.count) sleep sessions")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal)
                                    // Recent sleep records
                                    VStack(alignment: .leading, spacing: 6) {
                                        ForEach(dataManager.sleepRecords.sorted { $0.startTime > $1.startTime }.prefix(5)) { record in
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(record.startTime, style: .time)
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                    if let endTime = record.endTime {
                                                        let duration = endTime.timeIntervalSince(record.startTime) / 3600
                                                        Text(formatDuration(hours: duration))
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                    }
                                                    Text(record.location.rawValue)
                                                        .font(.caption2)
                                                        .foregroundColor(.white.opacity(0.7))
                                                }
                                                Spacer()
                                                if let quality = record.sleepQuality {
                                                    Image(systemName: quality.icon)
                                                        .foregroundColor(quality.color)
                                                        .font(.title3)
                                                }
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(18)
                        .padding(.horizontal)
                        // --- END UNIFIED CARD ---
                        // Data Export Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.cyan)
                                Text("Data Export")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    showingDataExport = true
                                }) {
                                    Image(systemName: "doc.text.fill")
                                        .font(.title2)
                                        .foregroundColor(.cyan)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Export your baby's data for backup or sharing with healthcare providers.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    showingDataExport = true
                                }) {
                                    Text("Export Data")
                                        .font(.caption)
                                        .foregroundColor(.cyan)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 10)
                    } else {
                        EmptyBabyCard {
                            showingBabyForm = true
                        }
                        .offset(y: animateContent ? 0 : 100)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateContent)
                        .padding(.horizontal)
                    }
                    
                    // Enhanced Today's Summary
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.cyan)
                                .font(.title2)
                            Text("Today's Summary")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.6), value: animateContent)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            SummaryCard(
                                title: "Feeds",
                                value: "\(dataManager.getTodayFeedingCount())",
                                icon: "drop.fill",
                                color: TinyStepsDesign.Colors.accent
                            )
                            .offset(x: animateContent ? 0 : -50)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateContent)
                            
                            SummaryCard(
                                title: "Nappies",
                                value: "\(dataManager.getTodayNappyCount())",
                                icon: "drop",
                                color: TinyStepsDesign.Colors.success
                            )
                            .offset(x: animateContent ? 0 : 50)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateContent)
                            
                            SummaryCard(
                                title: "Sleep",
                                value: formatDuration(hours: dataManager.getTodaySleepHours()),
                                icon: "bed.double.fill",
                                color: TinyStepsDesign.Colors.highlight
                            )
                            .offset(x: animateContent ? 0 : -50)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: animateContent)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Enhanced Recent Activity
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            Text("Recent Activity")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(1.0), value: animateContent)
                        
                        VStack(spacing: 15) {
                            ForEach(Array(getRecentActivity().enumerated()), id: \.element.id) { index, activity in
                                ActivityRow(item: activity)
                                    .offset(x: animateContent ? 0 : (index % 2 == 0 ? -100 : 100))
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.1 + Double(index) * 0.1), value: animateContent)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Tracking")
            .onAppear {
                withAnimation {
                    animateContent = true
                }
            }
            .sheet(isPresented: $showingBabyForm) {
                if let baby = dataManager.baby {
                    BabyFormView(babyToEdit: baby)
                        .environmentObject(dataManager)
                } else {
                    BabyFormView()
                        .environmentObject(dataManager)
                }
            }
        }
        .sheet(isPresented: $showingFeedingSheet) {
            FeedingLogView()
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingSleepSheet) {
            SleepLogView()
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingNappySheet) {
            NappyLogView()
                .environmentObject(dataManager)
        }
        // Sheet for adding/editing weight
        .sheet(isPresented: $showingWeightSheet) {
            NavigationView {
                Form {
                    DatePicker("Date", selection: $weightDate, displayedComponents: .date)
                    TextField("Weight (kg)", text: $weightValue)
                        .keyboardType(.decimalPad)
                }
                .navigationTitle(editingWeight == nil ? "Add Weight" : "Edit Weight")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingWeightSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            guard let baby = dataManager.baby, let weight = Double(weightValue) else { return }
                            var updatedBaby = baby
                            var history = baby.weightHistory
                            if let editing = editingWeight, let idx = history.firstIndex(where: { $0.id == editing.id }) {
                                history[idx] = WeightEntry(id: editing.id, date: weightDate, weight: weight)
                            } else {
                                history.append(WeightEntry(date: weightDate, weight: weight))
                            }
                            updatedBaby.weightHistory = history
                            // Optionally update current weight if date is today or future
                            if Calendar.current.isDateInToday(weightDate) || weightDate > Date() {
                                updatedBaby.weight = weight
                            }
                            dataManager.baby = updatedBaby
                            dataManager.saveData()
                            showingWeightSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for adding/editing vaccination
        .sheet(isPresented: $showingVaccinationSheet) {
            NavigationView {
                Form {
                    TextField("Title (e.g., 8-week Vaccination)", text: $vaccinationTitle)
                    DatePicker("Date", selection: $vaccinationDate, displayedComponents: .date)
                    TextField("Notes (optional)", text: $vaccinationNotes)
                }
                .navigationTitle(editingVaccination == nil ? "Add Reminder" : "Edit Reminder")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingVaccinationSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveVaccination()
                            showingVaccinationSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for adding/editing height
        .sheet(isPresented: $showingHeightSheet) {
            NavigationView {
                Form {
                    DatePicker("Date", selection: $heightDate, displayedComponents: .date)
                    TextField("Height/Length (cm)", text: $heightValue)
                        .keyboardType(.decimalPad)
                }
                .navigationTitle(editingHeight == nil ? "Add Height" : "Edit Height")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingHeightSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveHeight()
                            showingHeightSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for adding/editing head circumference
        .sheet(isPresented: $showingHeadSheet) {
            NavigationView {
                Form {
                    DatePicker("Date", selection: $headDate, displayedComponents: .date)
                    TextField("Head Circumference (cm)", text: $headValue)
                        .keyboardType(.decimalPad)
                }
                .navigationTitle(editingHead == nil ? "Add Head Circumference" : "Edit Head Circumference")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingHeadSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveHeadCircumference()
                            showingHeadSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for adding solid food
        .sheet(isPresented: $showingSolidFoodSheet) {
            NavigationView {
                Form {
                    TextField("Food Name", text: $foodName)
                    DatePicker("Date", selection: $foodDate, displayedComponents: .date)
                    Picker("Reaction", selection: $foodReaction) {
                        ForEach(SolidFoodRecord.FoodReaction.allCases, id: \.self) { reaction in
                            HStack {
                                Image(systemName: reaction.icon)
                                    .foregroundColor(reaction.color)
                                Text(reaction.rawValue)
                            }
                            .tag(reaction)
                        }
                    }
                    TextField("Notes (optional)", text: $foodNotes)
                }
                .navigationTitle("Add Solid Food")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingSolidFoodSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveSolidFood()
                            showingSolidFoodSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for adding sleep pattern
        .sheet(isPresented: $showingSleepPatternSheet) {
            NavigationView {
                Form {
                    DatePicker("Start Time", selection: $sleepStartTime)
                    DatePicker("End Time", selection: $sleepEndTime)
                    Picker("Location", selection: $sleepLocation) {
                        ForEach(SleepRecord.SleepLocation.allCases, id: \.self) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }
                    Picker("Sleep Quality", selection: $sleepQuality) {
                        ForEach(SleepRecord.SleepQuality.allCases, id: \.self) { quality in
                            HStack {
                                Image(systemName: quality.icon)
                                    .foregroundColor(quality.color)
                                Text(quality.rawValue)
                            }
                            .tag(quality)
                        }
                    }
                    TextField("Notes (optional)", text: $sleepNotes)
                }
                .navigationTitle("Add Sleep Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingSleepPatternSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveSleepPattern()
                            showingSleepPatternSheet = false
                        }
                    }
                }
            }
        }
        // Sheet for data export
        .sheet(isPresented: $showingDataExport) {
            DataExportView()
                .environmentObject(dataManager)
        }
        // Sheet for growth charts
        .sheet(isPresented: $showingGrowthChartsSheet) {
            GrowthChartsView()
                .environmentObject(dataManager)
        }
        // Sheet for measurement options
        .sheet(isPresented: $showingMeasurementOptionsSheet) {
            MeasurementOptionsView()
                .environmentObject(dataManager)
        }
    }
    
    private func getRecentActivity() -> [ActivityItem] {
        var activities: [ActivityItem] = []
        
        // Add recent feedings
        for record in dataManager.feedingRecords.prefix(3) {
            activities.append(ActivityItem(
                icon: "drop.fill",
                title: "\(record.type.rawValue) Feed",
                description: record.amount != nil ? "\(Int(record.amount!))ml" : "\(Int(record.duration ?? 0))min",
                date: record.date,
                color: TinyStepsDesign.Colors.accent
            ))
        }
        
        // Add recent sleep records
        for record in dataManager.sleepRecords.prefix(3) {
            var description = record.location.rawValue
            if let endTime = record.endTime {
                let duration = endTime.timeIntervalSince(record.startTime) / 3600
                description = "\(formatDuration(hours: duration)) • \(record.location.rawValue)"
            }
            activities.append(ActivityItem(
                icon: "bed.double.fill",
                title: "Sleep Session",
                description: description,
                date: record.startTime,
                color: TinyStepsDesign.Colors.highlight
            ))
        }
        
        // Add recent nappy changes
        for record in dataManager.nappyRecords.prefix(3) {
            activities.append(ActivityItem(
                icon: "drop",
                title: "\(record.type.rawValue) Nappy",
                description: record.notes ?? "",
                date: record.date,
                color: TinyStepsDesign.Colors.success
            ))
        }
        
        return activities.sorted { $0.date > $1.date }.prefix(5).map { $0 }
    }
    
    // Helper functions
    private func saveVaccination() {
        guard !vaccinationTitle.isEmpty else { return }
        var newRecord = VaccinationRecord(
            title: vaccinationTitle,
            date: vaccinationDate,
            isCompleted: editingVaccination?.isCompleted ?? false,
            notes: vaccinationNotes.isEmpty ? nil : vaccinationNotes
        )
        if let editing = editingVaccination, let idx = dataManager.vaccinations.firstIndex(where: { $0.id == editing.id }) {
            newRecord.id = editing.id
            dataManager.vaccinations[idx] = newRecord
        } else {
            dataManager.vaccinations.append(newRecord)
        }
        dataManager.saveData()
    }
    private func markVaccinationComplete(_ record: VaccinationRecord) {
        if let idx = dataManager.vaccinations.firstIndex(where: { $0.id == record.id }) {
            dataManager.vaccinations[idx].isCompleted = true
            dataManager.saveData()
        }
    }
    private func saveHeight() {
        guard let baby = dataManager.baby, let value = Double(heightValue) else { return }
        var updatedBaby = baby
        var history = baby.heightHistory
        if let editing = editingHeight, let idx = history.firstIndex(where: { $0.id == editing.id }) {
            history[idx] = MeasurementEntry(id: editing.id, date: heightDate, value: value)
        } else {
            history.append(MeasurementEntry(date: heightDate, value: value))
        }
        updatedBaby.heightHistory = history
        // Optionally update current height if date is today or future
        if Calendar.current.isDateInToday(heightDate) || heightDate > Date() {
            updatedBaby.height = value
        }
        dataManager.baby = updatedBaby
        dataManager.saveData()
    }
    private func saveHeadCircumference() {
        guard let baby = dataManager.baby, let value = Double(headValue) else { return }
        var updatedBaby = baby
        var history = baby.headCircumferenceHistory
        if let editing = editingHead, let idx = history.firstIndex(where: { $0.id == editing.id }) {
            history[idx] = MeasurementEntry(id: editing.id, date: headDate, value: value)
        } else {
            history.append(MeasurementEntry(date: headDate, value: value))
        }
        updatedBaby.headCircumferenceHistory = history
        // Optionally update current head circumference if date is today or future
        if Calendar.current.isDateInToday(headDate) || headDate > Date() {
            // No direct property, but could be added if needed
        }
        dataManager.baby = updatedBaby
        dataManager.saveData()
    }
    private func saveSolidFood() {
        guard !foodName.isEmpty else { return }
        let newRecord = SolidFoodRecord(
            date: foodDate,
            foodName: foodName,
            reaction: foodReaction,
            notes: foodNotes.isEmpty ? nil : foodNotes
        )
        dataManager.solidFoodRecords.append(newRecord)
        dataManager.saveData()
    }
    private func saveSleepPattern() {
        let newRecord = SleepRecord(
            startTime: sleepStartTime,
            endTime: sleepEndTime,
            duration: sleepEndTime.timeIntervalSince(sleepStartTime) / 60,
            location: sleepLocation,
            notes: sleepNotes.isEmpty ? nil : sleepNotes,
            sleepQuality: sleepQuality
        )
        dataManager.sleepRecords.append(newRecord)
        dataManager.saveData()
    }
    
    // Helper to format duration as hours and minutes
    private func formatDuration(hours: Double) -> String {
        let totalMinutes = Int(hours * 60)
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        if h > 0 && m > 0 {
            return "\(h)h \(m)m"
        } else if h > 0 {
            return "\(h)h"
        } else {
            return "\(m)m"
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [color, color.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .scaleEffect(isPressed ? 0.9 : (isHovered ? 1.1 : 1.0))
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
                    .animation(.easeInOut(duration: 0.2), value: isHovered)
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color.opacity(0.3) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? color : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: color.opacity(isSelected ? 0.5 : 0.3), radius: isHovered ? 15 : 10, x: 0, y: 5)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(isHovered ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovered)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .shadow(color: color.opacity(0.3), radius: isHovered ? 15 : 10, x: 0, y: 5)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Feeding Log View
struct FeedingLogView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedType: FeedingRecord.FeedingType = .bottle
    @State private var amount: String = ""
    @State private var duration: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Feeding Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(FeedingRecord.FeedingType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if selectedType == .bottle || selectedType == .mixed {
                    Section("Amount (ml)") {
                        TextField("Enter amount", text: $amount)
                    }
                }
                
                if selectedType == .breast || selectedType == .mixed {
                    Section("Duration (minutes)") {
                        TextField("Enter duration", text: $duration)
                    }
                }
                
                Section("Notes (Optional)") {
                    TextField("Add notes", text: $notes)
                }
            }
            .navigationTitle("Log Feeding")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFeeding()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func saveFeeding() {
        let record = FeedingRecord(
            date: Date(),
            type: selectedType,
            amount: Double(amount),
            duration: Double(duration).map { $0 * 60 }, // Convert to seconds
            notes: notes.isEmpty ? nil : notes,
            side: nil
        )
        
        dataManager.addFeedingRecord(record)
        dismiss()
    }
}

// MARK: - Sleep Log View
struct SleepLogView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedLocation: SleepRecord.SleepLocation = .crib
    @State private var notes: String = ""
    @State private var isCurrentlySleeping = true
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sleep Location") {
                    Picker("Location", selection: $selectedLocation) {
                        ForEach(SleepRecord.SleepLocation.allCases, id: \.self) { location in
                            HStack {
                                Image(systemName: location.icon)
                                Text(location.rawValue)
                            }
                            .tag(location)
                        }
                    }
                }
                
                Section("Notes (Optional)") {
                    TextField("Add notes", text: $notes)
                }
            }
            .navigationTitle("Log Sleep")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSleep()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func saveSleep() {
        let record = SleepRecord(
            startTime: Date(),
            endTime: nil,
            duration: nil,
            location: selectedLocation,
            notes: notes.isEmpty ? nil : notes,
            sleepQuality: nil
        )
        dataManager.addSleepRecord(record)
        dismiss()
    }
}

// MARK: - Nappy Log View
struct NappyLogView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedType: NappyRecord.NappyType = .wet
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Nappy Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(NappyRecord.NappyType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Notes (Optional)") {
                    TextField("Add notes", text: $notes)
                }
            }
            .navigationTitle("Log Nappy Change")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNappy()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func saveNappy() {
        let record = NappyRecord(
            date: Date(),
            type: selectedType,
            notes: notes.isEmpty ? nil : notes
        )
        
        dataManager.addNappyRecord(record)
        dismiss()
    }
}

// MARK: - Growth Charts View
struct GrowthChartsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let baby = dataManager.baby {
                        // Weight Chart
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.blue)
                                Text("Weight Chart")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if !baby.weightHistory.isEmpty {
                                Chart(baby.weightHistory.sorted { $0.date < $1.date }) { entry in
                                    LineMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Weight (kg)", entry.weight)
                                    )
                                    .foregroundStyle(.blue)
                                    PointMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Weight (kg)", entry.weight)
                                    )
                                    .foregroundStyle(.blue)
                                }
                                .frame(height: 200)
                                .padding(.horizontal)
                                // Show both units in a legend/summary
                                if let last = baby.weightHistory.sorted(by: { $0.date < $1.date }).last {
                                    Text(String(format: "Latest: %.2f kg (%.2f lbs)", last.weight, last.weight * 2.20462))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } else {
                                Text("No weight data available")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Height Chart
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "ruler")
                                    .foregroundColor(.purple)
                                Text("Height/Length Chart")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if !baby.heightHistory.isEmpty {
                                Chart(baby.heightHistory.sorted { $0.date < $1.date }) { entry in
                                    LineMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Height", entry.value)
                                    )
                                    .foregroundStyle(.purple)
                                    PointMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Height", entry.value)
                                    )
                                    .foregroundStyle(.purple)
                                }
                                .frame(height: 200)
                                .padding(.horizontal)
                            } else {
                                Text("No height data available")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Head Circumference Chart
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "circle.grid.cross")
                                    .foregroundColor(.orange)
                                Text("Head Circumference Chart")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if !baby.headCircumferenceHistory.isEmpty {
                                Chart(baby.headCircumferenceHistory.sorted { $0.date < $1.date }) { entry in
                                    LineMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Head Circumference", entry.value)
                                    )
                                    .foregroundStyle(.orange)
                                    PointMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Head Circumference", entry.value)
                                    )
                                    .foregroundStyle(.orange)
                                }
                                .frame(height: 200)
                                .padding(.horizontal)
                            } else {
                                Text("No head circumference data available")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        Text("No baby data available")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Growth Charts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Measurement Options View
struct MeasurementOptionsView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingWeightSheet = false
    @State private var showingHeightSheet = false
    @State private var showingHeadSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Add New Measurements") {
                    Button(action: {
                        showingWeightSheet = true
                    }) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text("Add Weight")
                                    .font(.headline)
                                Text("Record your baby's weight")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {
                        showingHeightSheet = true
                    }) {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundColor(.purple)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text("Add Height/Length")
                                    .font(.headline)
                                Text("Record your baby's height or length")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    Button(action: {
                        showingHeadSheet = true
                    }) {
                        HStack {
                            Image(systemName: "circle.grid.cross")
                                .foregroundColor(.orange)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text("Add Head Circumference")
                                    .font(.headline)
                                Text("Record your baby's head circumference")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle")
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                if let baby = dataManager.baby {
                    Section("Current Measurements") {
                        if let weight = baby.weight {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                VStack(alignment: .leading) {
                                    Text("Current Weight")
                                        .font(.headline)
                                    Text(String(format: "%.2f kg (%.2f lbs)", weight, weight * 2.20462))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                        
                        if let height = baby.height {
                            HStack {
                                Image(systemName: "ruler")
                                    .foregroundColor(.purple)
                                    .frame(width: 30)
                                VStack(alignment: .leading) {
                                    Text("Current Height")
                                        .font(.headline)
                                    Text("\(String(format: "%.2f", height)) cm")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Measurements")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingWeightSheet) {
            WeightEntryView()
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingHeightSheet) {
            HeightEntryView()
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingHeadSheet) {
            HeadCircumferenceEntryView()
                .environmentObject(dataManager)
        }
    }
}

// MARK: - Weight Entry View
struct WeightEntryView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var weightDate = Date()
    @State private var weightValue = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $weightDate, displayedComponents: .date)
                TextField("Weight (kg)", text: $weightValue)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Weight")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWeight()
                    }
                    .disabled(weightValue.isEmpty)
                }
            }
        }
    }
    
    private func saveWeight() {
        guard let baby = dataManager.baby, let weight = Double(weightValue) else { return }
        var updatedBaby = baby
        updatedBaby.weightHistory.append(WeightEntry(date: weightDate, weight: weight))
        if Calendar.current.isDateInToday(weightDate) || weightDate > Date() {
            updatedBaby.weight = weight
        }
        dataManager.baby = updatedBaby
        dataManager.saveData()
        dismiss()
    }
}

// MARK: - Height Entry View
struct HeightEntryView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var heightDate = Date()
    @State private var heightValue = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $heightDate, displayedComponents: .date)
                TextField("Height/Length (cm)", text: $heightValue)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Height")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHeight()
                    }
                    .disabled(heightValue.isEmpty)
                }
            }
        }
    }
    
    private func saveHeight() {
        guard let baby = dataManager.baby, let height = Double(heightValue) else { return }
        var updatedBaby = baby
        updatedBaby.heightHistory.append(MeasurementEntry(date: heightDate, value: height))
        if Calendar.current.isDateInToday(heightDate) || heightDate > Date() {
            updatedBaby.height = height
        }
        dataManager.baby = updatedBaby
        dataManager.saveData()
        dismiss()
    }
}

// MARK: - Head Circumference Entry View
struct HeadCircumferenceEntryView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var headDate = Date()
    @State private var headValue = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $headDate, displayedComponents: .date)
                TextField("Head Circumference (cm)", text: $headValue)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Head Circumference")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHeadCircumference()
                    }
                    .disabled(headValue.isEmpty)
                }
            }
        }
    }
    
    private func saveHeadCircumference() {
        guard let baby = dataManager.baby, let headCircumference = Double(headValue) else { return }
        var updatedBaby = baby
        updatedBaby.headCircumferenceHistory.append(MeasurementEntry(date: headDate, value: headCircumference))
        dataManager.baby = updatedBaby
        dataManager.saveData()
        dismiss()
    }
}

#Preview {
    TrackingView()
        .environmentObject(BabyDataManager())
} 
