import SwiftUI

struct FeedingHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var selectedFilter: FeedingRecord.FeedingType?
    
    var filteredRecords: [FeedingRecord] {
        let records = dataManager.feedingRecords.sorted { $0.date > $1.date }
        if let filter = selectedFilter {
            return records.filter { $0.type == filter }
        }
        return records
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Feeding History")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Track your baby's feeding patterns")
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
                    
                    // Filter Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterButton(title: "All", isSelected: selectedFilter == nil) {
                                selectedFilter = nil
                            }
                            
                            ForEach(FeedingRecord.FeedingType.allCases, id: \.self) { type in
                                FilterButton(
                                    title: type.rawValue,
                                    icon: type.icon,
                                    color: type.color,
                                    isSelected: selectedFilter == type
                                ) {
                                    selectedFilter = type
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if filteredRecords.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("No Feeding Records")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Add your first feeding record to start tracking")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredRecords) { record in
                                FeedingRecordRow(record: record)
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

struct FilterButton: View {
    let title: String
    var icon: String?
    var color: Color = .blue
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isSelected ? .white : color)
                }
                
                Text(title)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color.white.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct FeedingRecordRow: View {
    let record: FeedingRecord
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: record.type.icon)
                    .foregroundColor(record.type.color)
                
                Text(record.type.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(dateFormatter.string(from: record.date))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            if let amount = record.amount {
                HStack {
                    Text("Amount:")
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(Int(amount)) ml")
                        .foregroundColor(.white)
                }
            }
            
            if let duration = record.duration {
                HStack {
                    Text("Duration:")
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(Int(duration)) minutes")
                        .foregroundColor(.white)
                }
            }
            
            if let side = record.side {
                HStack {
                    Text("Side:")
                        .foregroundColor(.white.opacity(0.8))
                    Text(side.rawValue)
                        .foregroundColor(.white)
                }
            }
            
            if let notes = record.notes {
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

