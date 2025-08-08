import SwiftUI
#if canImport(CoreLocation)
import CoreLocation
#endif

struct HealthVisitorView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddVisit = false
    @State private var selectedFilter: VisitFilter = .all
    
    enum VisitFilter: String, CaseIterable {
        case all = "All"
        case upcoming = "Upcoming"
        case completed = "Completed"
        
        var icon: String {
            switch self {
            case .all: return "list.bullet"
            case .upcoming: return "calendar"
            case .completed: return "checkmark.circle"
            }
        }
    }
    
    var filteredVisits: [HealthVisitorVisit] {
        switch selectedFilter {
        case .all:
            return dataManager.healthVisitorVisits
        case .upcoming:
            return dataManager.healthVisitorVisits.filter { $0.date > Date() }
        case .completed:
            return dataManager.healthVisitorVisits.filter { $0.date <= Date() }
        }
    }
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Health Visitor")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Track your health visitor appointments")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Button(action: { showingAddVisit = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Filter Picker
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(VisitFilter.allCases, id: \.self) { filter in
                        HStack {
                            Image(systemName: filter.icon)
                            Text(filter.rawValue)
                        }
                        .tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Visits List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Visits")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(filteredVisits.count) visits")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal)
                    
                    if filteredVisits.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.2.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("No visits scheduled")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("Tap the + button to add your first health visitor appointment")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredVisits) { visit in
                                    HealthVisitorVisitCard(visit: visit)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Health Visitor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingAddVisit) {
            AddHealthVisitorVisitView()
        }
    }
}

struct HealthVisitorVisitCard: View {
    let visit: HealthVisitorVisit
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(visit.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(visit.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Status indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(visit.date > Date() ? Color.yellow : Color.green)
                        .frame(width: 8, height: 8)
                    Text(visit.date > Date() ? "Upcoming" : "Completed")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            if let notes = visit.notes, !notes.isEmpty {
                Text(notes)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 4)
            }
            
            // Action buttons
            HStack {
                Button(action: {
                    // Edit visit
                }) {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if visit.date > Date() {
                    Button(action: {
                        // Mark as completed
                        dataManager.markHealthVisitorVisitCompleted(visit)
                    }) {
                        Label("Mark Complete", systemImage: "checkmark.circle")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AddHealthVisitorVisitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Form {
                        Section(header: Text("Visit Details")) {
                            TextField("Visit Title", text: $title)
                            
                            DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            
                            TextEditor(text: $notes)
                                .frame(minHeight: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .navigationTitle("Add Visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let visit = HealthVisitorVisit(
                            title: title,
                            date: date,
                            notes: notes.isEmpty ? nil : notes,
                            weight: nil,
                            height: nil,
                            headCircumference: nil
                        )
                        dataManager.addHealthVisitorVisit(visit)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        HealthVisitorView()
    }
}
