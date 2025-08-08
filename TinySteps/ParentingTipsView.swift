//
//  ParentingTipsView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI

struct ParentingTipsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: TipCategory = .all
    
    enum TipCategory: String, CaseIterable {
        case all = "All"
        case care = "Care"
        case support = "Support"
        case health = "Health"
        case development = "Development"
        
        var color: Color {
            switch self {
            case .all: return .blue
            case .care: return .green
            case .support: return .orange
            case .health: return .red
            case .development: return .purple
            }
        }
    }
    
    var filteredTips: [ParentingTip] {
        if selectedCategory == .all {
            return parentingTips
        } else {
            return parentingTips.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Parenting Tips")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Helpful advice for dads with babies in neonatal care")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Category Filter
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(TipCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedCategory == category ? category.color : Color.white.opacity(0.03))
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Tips List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Tips for Dads")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(filteredTips.count) tips")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTips) { tip in
                                TipCard(tip: tip)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Parenting Tips")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct TipCard: View {
    let tip: ParentingTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(tip.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(3)
                }
                
                Spacer()
                
                // Category indicator
                Text(tip.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(tip.category.color.opacity(0.3))
                    .foregroundColor(tip.category.color)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct ParentingTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: ParentingTipsView.TipCategory
}

let parentingTips: [ParentingTip] = [
    ParentingTip(
        title: "Skin-to-Skin Contact",
        description: "Practice kangaroo care by holding your baby skin-to-skin on your chest. This helps regulate their temperature, heart rate, and breathing while strengthening your bond. Even 15-20 minutes daily makes a significant difference.",
        category: .care
    ),
    ParentingTip(
        title: "Talk to Your Baby",
        description: "Your voice is familiar and comforting to your baby. Talk, sing, or read to them during visits. Describe what you're doing and share your feelings. Your baby recognizes your voice from before birth.",
        category: .development
    ),
    ParentingTip(
        title: "Learn the Equipment",
        description: "Familiarize yourself with the monitors, tubes, and equipment around your baby. Ask the nurses to explain what each machine does and what the numbers mean. This helps you understand your baby's condition.",
        category: .health
    ),
    ParentingTip(
        title: "Take Care of Yourself",
        description: "Your wellbeing matters too. Get enough sleep, eat well, and take breaks when needed. You can't help your baby if you're exhausted. Accept help from family and friends.",
        category: .support
    ),
    ParentingTip(
        title: "Be Present During Care",
        description: "Participate in your baby's care routine when possible - changing diapers, taking temperatures, or helping with feeding. This builds your confidence and strengthens your connection with your baby.",
        category: .care
    ),
    ParentingTip(
        title: "Connect with Other Dads",
        description: "Join support groups or online communities for NICU dads. Sharing experiences with others who understand can provide emotional support and practical advice during this challenging time.",
        category: .support
    ),
    ParentingTip(
        title: "Track Milestones",
        description: "Celebrate every small achievement - weight gains, breathing improvements, or feeding progress. Keep a journal or use apps to document these precious moments and your baby's journey.",
        category: .development
    ),
    ParentingTip(
        title: "Ask Questions",
        description: "Don't hesitate to ask the medical team questions about your baby's care, treatment plan, or what to expect. Being informed helps you feel more confident and involved in your baby's care.",
        category: .health
    ),
    ParentingTip(
        title: "Create a Routine",
        description: "Establish a consistent visiting schedule that works for your family. Regular visits help your baby recognize your presence and create a sense of stability during this uncertain time.",
        category: .care
    ),
    ParentingTip(
        title: "Express Your Feelings",
        description: "It's normal to feel overwhelmed, scared, or helpless. Talk to your partner, family, or a counselor about your emotions. Bottling up feelings can make the stress worse.",
        category: .support
    ),
    ParentingTip(
        title: "Learn About Prematurity",
        description: "Educate yourself about prematurity, common complications, and developmental milestones for preemies. Knowledge helps you understand what's happening and what to expect.",
        category: .health
    ),
    ParentingTip(
        title: "Prepare for Homecoming",
        description: "Start preparing for when your baby comes home. Learn about safe sleep practices, feeding schedules, and emergency procedures. The more prepared you are, the smoother the transition will be.",
        category: .development
    )
]

#Preview {
    NavigationView {
        ParentingTipsView()
    }
} 