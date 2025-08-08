import SwiftUI

struct NewMilestoneView: View {
    @EnvironmentObject var dataManager: BabyDataManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var category: MilestoneCategory = .physical
    @State private var ageRange = ""
    @State private var notes = ""
    @State private var periodType: String = "Months"
    @State private var periodValue: String = "1"
    
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
                            Text("New Milestone")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Track your baby's development")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 15) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., First smile", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Describe the milestone...", text: $description, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    // Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.white)
                        Picker("Category", selection: $category) {
                            ForEach(MilestoneCategory.allCases, id: \.self) { cat in
                                if cat != .all {
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Age Range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expected Age Range")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("e.g., 2-3 months", text: $ageRange)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    // Period Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Milestone Period")
                            .font(.headline)
                            .foregroundColor(.white)
                        HStack {
                            Picker("Type", selection: $periodType) {
                                Text("Months").tag("Months")
                                Text("Years").tag("Years")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            TextField("Value", text: $periodValue)
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Add any additional notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                

            }
            }
            .navigationTitle("New Milestone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMilestone()
                    }
                    .foregroundColor(.white)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveMilestone() {
        let period: MilestonePeriod = {
            if periodType == "Years", let val = Int(periodValue) {
                return .years(val)
            } else if let val = Int(periodValue) {
                return .months(val)
            } else {
                return .months(1)
            }
        }()
        let milestone = Milestone(
            title: title,
            description: description,
            category: category,
            achievedDate: nil,
            expectedAge: 12, // Default to 12 weeks
            isAchieved: false,
            notes: notes.isEmpty ? nil : notes,
            ageRange: ageRange.isEmpty ? "2-3 months" : ageRange,
            period: period
        )
        dataManager.addMilestone(milestone)
        dismiss()
    }
}

#Preview {
    NavigationView {
        NewMilestoneView()
            .environmentObject(BabyDataManager())
    }
} 