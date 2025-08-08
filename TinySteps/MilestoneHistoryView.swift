import SwiftUI

struct MilestoneHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: BabyDataManager
    @State private var selectedCategory: MilestoneCategory = .all
    
    private var achievedMilestones: [Milestone] {
        let milestones = dataManager.milestones.filter { $0.isAchieved }
        if selectedCategory == .all {
            return milestones.sorted { ($0.achievedDate ?? Date()) > ($1.achievedDate ?? Date()) }
        }
        return milestones.filter { $0.category == selectedCategory }
            .sorted { ($0.achievedDate ?? Date()) > ($1.achievedDate ?? Date()) }
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
                                Text("Milestone History")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Track your baby's achievements")
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
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(MilestoneCategory.allCases, id: \.self) { category in
                                FilterButton(
                                    title: category.rawValue,
                                    icon: category.icon,
                                    color: category.color,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if achievedMilestones.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("No Achieved Milestones")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text(selectedCategory == .all ? "Complete milestones to see them here" : "No milestones achieved in this category")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(achievedMilestones) { milestone in
                                MilestoneHistoryRow(milestone: milestone)
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

struct MilestoneHistoryRow: View {
    let milestone: Milestone
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: milestone.category.icon)
                    .foregroundColor(.white)
                
                Text(milestone.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if let achievedDate = milestone.achievedDate {
                    Text(dateFormatter.string(from: achievedDate))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Text(milestone.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            HStack {
                Text("Category:")
                    .foregroundColor(.white.opacity(0.8))
                Text(milestone.category.rawValue)
                    .foregroundColor(milestone.category.color)
            }
            .font(.caption)
            
            if let notes = milestone.notes {
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

