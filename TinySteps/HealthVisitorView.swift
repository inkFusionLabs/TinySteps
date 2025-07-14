import SwiftUI
import Charts

struct HealthVisitorView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var showingAddEditSheet = false
    @State private var editingVisit: HealthVisitorVisit? = nil
    @State private var visitDate = Date()
    @State private var visitNotes = ""
    @State private var visitWeight = ""
    @State private var visitHeight = ""
    @State private var visitHeadCirc = ""
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack {
                // Percentile Chart Section
                if let baby = dataManager.baby, !baby.healthVisitorVisits.isEmpty {
                    let showLbs = false // Set to true if you want to display lbs as primary (add user preference logic if needed)
                    Chart {
                        // Weight line
                        ForEach(baby.healthVisitorVisits.sorted { $0.date < $1.date }) { visit in
                            if let weight = visit.weight {
                                LineMark(
                                    x: .value("Date", visit.date),
                                    y: .value(showLbs ? "Weight (lbs)" : "Weight (kg)", showLbs ? weight * 2.20462 : weight)
                                )
                                .foregroundStyle(.blue)
                                .symbol(by: .value("Type", "Weight"))
                                .annotation(position: .top) {
                                    Text(String(format: "%.2f kg (%.2f lbs)", weight, weight * 2.20462))
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        // Height line
                        ForEach(baby.healthVisitorVisits.sorted { $0.date < $1.date }) { visit in
                            if let height = visit.height {
                                LineMark(
                                    x: .value("Date", visit.date),
                                    y: .value("Height (cm)", height)
                                )
                                .foregroundStyle(.green)
                                .symbol(by: .value("Type", "Height"))
                            }
                        }
                        // Head Circumference line
                        ForEach(baby.healthVisitorVisits.sorted { $0.date < $1.date }) { visit in
                            if let head = visit.headCircumference {
                                LineMark(
                                    x: .value("Date", visit.date),
                                    y: .value("Head Circumference (cm)", head)
                                )
                                .foregroundStyle(.orange)
                                .symbol(by: .value("Type", "Head Circumference"))
                            }
                        }
                    }
                    .frame(height: 220)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(14)
                    .padding(.top)
                } else {
                    Text("No health visitor measurement data yet. Add a visit to see the chart.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                if let baby = dataManager.baby {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(baby.healthVisitorVisits.sorted { $0.date > $1.date }) { visit in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(visit.date, style: .date)
                                            .font(.headline)
                                        Spacer()
                                        Button(action: {
                                            editingVisit = visit
                                            visitDate = visit.date
                                            visitNotes = visit.notes ?? ""
                                            visitWeight = visit.weight != nil ? String(format: "%.2f", visit.weight!) : ""
                                            visitHeight = visit.height != nil ? String(format: "%.2f", visit.height!) : ""
                                            visitHeadCirc = visit.headCircumference != nil ? String(format: "%.2f", visit.headCircumference!) : ""
                                            showingAddEditSheet = true
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    if let weight = visit.weight {
                                        Text("Weight: " + String(format: "%.2f kg (%.2f lbs)", weight, weight * 2.20462))
                                            .font(.subheadline)
                                    }
                                    if let height = visit.height {
                                        Text("Height: \(String(format: "%.2f", height)) cm")
                                            .font(.subheadline)
                                    }
                                    if let head = visit.headCircumference {
                                        Text("Head Circumference: \(String(format: "%.2f", head)) cm")
                                            .font(.subheadline)
                                    }
                                    if let notes = visit.notes, !notes.isEmpty {
                                        Text(notes)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No baby profile found.")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Health Visitor Visits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingVisit = nil
                        visitDate = Date()
                        visitNotes = ""
                        visitWeight = ""
                        visitHeight = ""
                        visitHeadCirc = ""
                        showingAddEditSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddEditSheet) {
            NavigationView {
                Form {
                    DatePicker("Date", selection: $visitDate, displayedComponents: .date)
                    TextField("Weight (kg)", text: $visitWeight)
                        .keyboardType(.decimalPad)
                    TextField("Height (cm)", text: $visitHeight)
                        .keyboardType(.decimalPad)
                    TextField("Head Circumference (cm)", text: $visitHeadCirc)
                        .keyboardType(.decimalPad)
                    TextField("Notes", text: $visitNotes, axis: .vertical)
                }
                .navigationTitle(editingVisit == nil ? "Add Visit" : "Edit Visit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingAddEditSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { saveVisit() }
                            .disabled(visitWeight.isEmpty && visitHeight.isEmpty && visitHeadCirc.isEmpty)
                    }
                }
            }
        }
    }
    
    func saveVisit() {
        guard var baby = dataManager.baby else { return }
        let weight = Double(visitWeight)
        let height = Double(visitHeight)
        let head = Double(visitHeadCirc)
        let newVisit = HealthVisitorVisit(
            id: editingVisit?.id ?? UUID(),
            date: visitDate,
            notes: visitNotes.isEmpty ? nil : visitNotes,
            weight: weight,
            height: height,
            headCircumference: head
        )
        if let editing = editingVisit, let idx = baby.healthVisitorVisits.firstIndex(where: { $0.id == editing.id }) {
            baby.healthVisitorVisits[idx] = newVisit
        } else {
            baby.healthVisitorVisits.append(newVisit)
        }
        dataManager.baby = baby
        dataManager.saveData()
        showingAddEditSheet = false
    }
    
    func deleteVisit(at offsets: IndexSet) {
        guard var baby = dataManager.baby else { return }
        baby.healthVisitorVisits.remove(atOffsets: offsets)
        dataManager.baby = baby
        dataManager.saveData()
    }
}
