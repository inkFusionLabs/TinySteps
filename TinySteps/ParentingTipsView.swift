//
//  ParentingTipsView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI

struct ParentingTipsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: TipCategory = .general
    @State private var showingTipDetail = false
    @State private var selectedTip: ParentingTip?
    
    enum TipCategory: String, CaseIterable {
        case general = "General"
        case neonatal = "Neonatal"
        case feeding = "Feeding"
        case sleep = "Sleep"
        case bonding = "Bonding"
        case selfCare = "Self Care"
        
        var icon: String {
            switch self {
            case .general: return "lightbulb.fill"
            case .neonatal: return "baby.fill"
            case .feeding: return "drop.fill"
            case .sleep: return "bed.double.fill"
            case .bonding: return "heart.fill"
            case .selfCare: return "person.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .general: return Color(red: 0.1, green: 0.2, blue: 0.6) // Darker blue
            case .neonatal: return Color(red: 0.2, green: 0.3, blue: 0.8) // Lighter blue
            case .feeding: return Color(red: 0.3, green: 0.4, blue: 0.9) // Medium blue
            case .sleep: return Color(red: 0.4, green: 0.5, blue: 1.0) // Light blue
            case .bonding: return Color(red: 0.5, green: 0.6, blue: 1.0) // Very light blue
            case .selfCare: return Color(red: 0.1, green: 0.2, blue: 0.7) // Medium-dark blue
            }
        }
    }
    
    var filteredTips: [ParentingTip] {
        ParentingTip.allTips.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Dad Tips Banner
            HStack {
                TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.dad, color: TinyStepsDesign.Colors.highlight)
                Text("Dad's Tips")
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
                    // Example Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Tips")
                            .font(TinyStepsDesign.Typography.subheader)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        // ... existing tips content ...
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.clear)
                            .background(.ultraThinMaterial)
                    )
                    // ... repeat for other cards/buttons ...
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
    }
}

struct ParentingTipCategoryButton: View {
    let category: ParentingTipsView.TipCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color : TinyStepsDesign.Colors.cardBackground)
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct ParentingTipCard: View {
    let tip: ParentingTip
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: tip.category.icon)
                        .foregroundColor(tip.category.color)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text(tip.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(tip.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Text(tip.summary)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Text(tip.ageRange)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(TinyStepsDesign.Colors.cardBackground)
                        .foregroundColor(TinyStepsDesign.Colors.accent)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    if tip.isEssential {
                        Text("Essential")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(TinyStepsDesign.Colors.cardBackground)
                            .foregroundColor(TinyStepsDesign.Colors.error)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(TinyStepsDesign.Colors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TipDetailView: View {
    let tip: ParentingTip
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: tip.category.icon)
                                .foregroundColor(tip.category.color)
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text(tip.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(tip.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(tip.ageRange)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(TinyStepsDesign.Colors.cardBackground)
                                .foregroundColor(TinyStepsDesign.Colors.accent)
                                .cornerRadius(8)
                            
                            if tip.isEssential {
                                Text("Essential Tip")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(TinyStepsDesign.Colors.cardBackground)
                                    .foregroundColor(TinyStepsDesign.Colors.error)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Why This Matters")
                            .font(.headline)
                        Text(tip.explanation)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        if !tip.steps.isEmpty {
                            Text("How to Do It")
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(tip.steps.enumerated()), id: \.offset) { index, step in
                                    HStack(alignment: .top) {
                                        Text("\(index + 1).")
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(TinyStepsDesign.Colors.accent)
                                            .frame(width: 25, alignment: .leading)
                                        Text(step)
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        if !tip.warnings.isEmpty {
                            Text("Important Notes")
                                .font(.headline)
                                .foregroundColor(TinyStepsDesign.Colors.error)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(tip.warnings, id: \.self) { warning in
                                    HStack(alignment: .top) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(TinyStepsDesign.Colors.error)
                                            .font(.caption)
                                        Text(warning)
                                            .font(.body)
                                            .foregroundColor(TinyStepsDesign.Colors.error)
                                    }
                                }
                            }
                        }
                        
                        if !tip.additionalResources.isEmpty {
                            Text("Additional Resources")
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(tip.additionalResources, id: \.self) { resource in
                                    HStack {
                                        Image(systemName: "link")
                                            .foregroundColor(TinyStepsDesign.Colors.accent)
                                            .font(.caption)
                                        Text(resource)
                                            .font(.body)
                                            .foregroundColor(TinyStepsDesign.Colors.accent)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Tip Details")
            .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Parenting Tip Model
struct ParentingTip: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let explanation: String
    let category: ParentingTipsView.TipCategory
    let ageRange: String
    let isEssential: Bool
    let steps: [String]
    let warnings: [String]
    let additionalResources: [String]
    
    static let allTips: [ParentingTip] = [
        // General Tips
        ParentingTip(
            title: "Skin-to-Skin Contact",
            summary: "Hold your baby against your bare chest to regulate their temperature and heart rate.",
            explanation: "Skin-to-skin contact, also known as kangaroo care, helps regulate your baby's body temperature, heart rate, and breathing. It also promotes bonding and can help with breastfeeding.",
            category: .general,
            ageRange: "0-6 months",
            isEssential: true,
            steps: [
                "Remove your shirt and your baby's clothes (except diaper)",
                "Hold your baby against your chest",
                "Cover both of you with a blanket",
                "Aim for at least 1 hour per day"
            ],
            warnings: [
                "Never fall asleep while holding your baby",
                "Ensure the room is warm enough",
                "Stop if your baby seems uncomfortable"
            ],
            additionalResources: [
                "NHS: Skin-to-skin contact",
                "Bliss: Kangaroo care guide"
            ]
        ),
        
        // Neonatal Tips
        ParentingTip(
            title: "Monitor Feeding Cues",
            summary: "Learn to recognize when your baby is hungry before they start crying.",
            explanation: "Early feeding cues include rooting, sucking on hands, and making small sounds. Responding to these cues helps establish good feeding patterns and reduces stress.",
            category: .neonatal,
            ageRange: "0-3 months",
            isEssential: true,
            steps: [
                "Watch for rooting (turning head toward touch)",
                "Look for hand-to-mouth movements",
                "Listen for soft sucking sounds",
                "Respond before crying starts"
            ],
            warnings: [
                "Don't force feeding if baby refuses",
                "Consult healthcare provider if feeding concerns"
            ],
            additionalResources: [
                "UNICEF: Baby feeding cues",
                "NHS: Feeding your newborn"
            ]
        ),
        
        // Feeding Tips
        ParentingTip(
            title: "Burping Techniques",
            summary: "Help your baby release trapped air after feeding to prevent discomfort.",
            explanation: "Babies swallow air while feeding, which can cause discomfort and fussiness. Proper burping helps release this air and makes your baby more comfortable.",
            category: .feeding,
            ageRange: "0-12 months",
            isEssential: false,
            steps: [
                "Hold baby upright against your shoulder",
                "Gently pat or rub their back",
                "Try different positions if one doesn't work",
                "Burp after every 2-3 ounces (bottle) or when switching sides (breast)"
            ],
            warnings: [
                "Be gentle - don't pat too hard",
                "Some babies don't need to burp every time"
            ],
            additionalResources: [
                "NHS: Burping your baby",
                "La Leche League: Burping techniques"
            ]
        ),
        
        // Sleep Tips
        ParentingTip(
            title: "Safe Sleep Environment",
            summary: "Create a safe sleeping environment to reduce the risk of SIDS.",
            explanation: "Following safe sleep guidelines significantly reduces the risk of Sudden Infant Death Syndrome (SIDS). Always place your baby on their back to sleep.",
            category: .sleep,
            ageRange: "0-12 months",
            isEssential: true,
            steps: [
                "Always place baby on their back to sleep",
                "Use a firm, flat mattress",
                "Keep the crib free of toys, pillows, and blankets",
                "Room share but don't bed share",
                "Avoid overheating"
            ],
            warnings: [
                "Never place baby on their stomach or side",
                "Don't use sleep positioners or wedges",
                "Avoid soft bedding and loose blankets"
            ],
            additionalResources: [
                "Lullaby Trust: Safe sleep",
                "NHS: Reducing the risk of SIDS"
            ]
        ),
        
        // Bonding Tips
        ParentingTip(
            title: "Talk and Sing to Your Baby",
            summary: "Regular communication helps with language development and bonding.",
            explanation: "Even though your baby can't understand words yet, talking and singing to them helps with language development, creates a bond, and soothes them.",
            category: .bonding,
            ageRange: "0-12 months",
            isEssential: false,
            steps: [
                "Describe what you're doing throughout the day",
                "Sing lullabies and nursery rhymes",
                "Make eye contact while talking",
                "Use different tones and expressions",
                "Read books together"
            ],
            warnings: [
                "Keep the environment calm and quiet",
                "Don't overstimulate with too much noise"
            ],
            additionalResources: [
                "BookTrust: Reading with babies",
                "NHS: Talking to your baby"
            ]
        ),
        
        // Self Care Tips
        ParentingTip(
            title: "Take Care of Yourself",
            summary: "Your wellbeing is important for being the best parent you can be.",
            explanation: "Parenting is demanding, especially in the early months. Taking care of your physical and mental health helps you be more patient and present for your baby.",
            category: .selfCare,
            ageRange: "All ages",
            isEssential: true,
            steps: [
                "Sleep when your baby sleeps",
                "Ask for help from family and friends",
                "Eat nutritious meals",
                "Take short breaks when possible",
                "Stay connected with your partner"
            ],
            warnings: [
                "Don't ignore signs of depression or anxiety",
                "Seek professional help if needed",
                "It's okay to not be perfect"
            ],
            additionalResources: [
                "Mind: Mental health for new parents",
                "NHS: Postnatal depression"
            ]
        )
    ]
} 