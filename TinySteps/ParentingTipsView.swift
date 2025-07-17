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
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TipCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedCategory == category ? category.color : Color.white.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
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
                .background(Color.white.opacity(0.1))
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
        title: "Tip 1",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .care
    ),
    ParentingTip(
        title: "Tip 2",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .support
    ),
    ParentingTip(
        title: "Tip 3",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .health
    ),
    ParentingTip(
        title: "Tip 4",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .development
    ),
    ParentingTip(
        title: "Tip 5",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .care
    ),
    ParentingTip(
        title: "Tip 6",
        description: "This is a helpful parenting tip for dads with babies in neonatal care.",
        category: .support
    )
]

#Preview {
    NavigationView {
        ParentingTipsView()
    }
} 