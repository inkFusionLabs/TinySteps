import SwiftUI
import Charts

struct WeightHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    
    private var sortedEntries: [WeightEntry] {
        dataManager.baby?.weightHistory.sorted { $0.date > $1.date } ?? []
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Weight History")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Track your baby's growth")
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
                    
                    if sortedEntries.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("No Weight Records")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Add your first weight record to start tracking")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        // Growth Chart
                        VStack(alignment: .leading) {
                            Text("Growth Chart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            Chart {
                                ForEach(sortedEntries.reversed()) { entry in
                                    LineMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Weight", entry.weight)
                                    )
                                    .foregroundStyle(.blue)
                                    
                                    PointMark(
                                        x: .value("Date", entry.date),
                                        y: .value("Weight", entry.weight)
                                    )
                                    .foregroundStyle(.blue)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Weight History List
                        List {
                            ForEach(sortedEntries) { entry in
                                WeightEntryRow(entry: entry)
                            }
                        }
                        .scrollContentBackground(.hidden)
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
            }
        }
    }
}

struct WeightEntryRow: View {
    let entry: WeightEntry
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatter.string(from: entry.date))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(String(format: "%.1f kg", entry.weight))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            if let location = entry.location {
                HStack {
                    Text("Location:")
                        .foregroundColor(.white.opacity(0.8))
                    Text(location)
                        .foregroundColor(.white)
                }
            }
            
            if let notes = entry.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.white.opacity(0.1))
    }
}

