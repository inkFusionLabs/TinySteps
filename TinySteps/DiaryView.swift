import SwiftUI

struct DiaryView: View {
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var showingAddEntry = false
    
    var body: some View {
        ZStack {
            // Background gradient
            Color.clear
                .ignoresSafeArea()
            
            NavigationView {
                List {
                    ForEach(diaryEntries) { entry in
                        DiaryEntryView(entry: entry)
                    }
                    .onDelete(perform: deleteEntry)
                }
                .navigationTitle("Baby's Diary")
                .toolbar {
                    // ToolbarItem(placement: .navigationBarTrailing) {
                    //     Button(action: { showingAddEntry = true }) {
                    //         Image(systemName: "plus")
                    //     }
                    // }
                }
                .sheet(isPresented: $showingAddEntry) {
                    AddDiaryEntryView(entries: $diaryEntries)
                }
            }
        }
    }
    
    func deleteEntry(at offsets: IndexSet) {
        diaryEntries.remove(atOffsets: offsets)
    }
}

struct DiaryEntry: Identifiable, Codable {
    var id: UUID = UUID()
    let date: Date
    let title: String
    let notes: String
    let weight: Double?
    let milestone: String?
}

struct DiaryEntryView: View {
    let entry: DiaryEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.title)
                    .font(.headline)
                Spacer()
                Text(entry.date, style: .date)
                    .font(.caption)
            }
            
            if let milestone = entry.milestone {
                Text(milestone)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text(entry.notes)
                .font(.body)
            
            if let weight = entry.weight {
                HStack {
                    Image(systemName: "scalemass")
                    Text("\(weight, specifier: "%.2f") kg")
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}

struct AddDiaryEntryView: View {
    @Binding var entries: [DiaryEntry]
    @State private var title = ""
    @State private var notes = ""
    @State private var weight = ""
    @State private var milestone = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Today's Update")) {
                    TextField("Title (e.g., 'Day 5 in NICU')", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                }
                
                Section(header: Text("Measurements")) {
                    TextField("Weight (kg)", text: $weight)
                }
                
                Section(header: Text("Milestones")) {
                    TextField("Reached any milestones?", text: $milestone)
                }
            }
            .navigationTitle("New Entry")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newEntry = DiaryEntry(
                            date: Date(),
                            title: title,
                            notes: notes,
                            weight: Double(weight),
                            milestone: milestone.isEmpty ? nil : milestone
                        )
                        entries.append(newEntry)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                #endif
            }
        }
    }
}
