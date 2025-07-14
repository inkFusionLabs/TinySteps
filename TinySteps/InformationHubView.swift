import SwiftUI

#if os(iOS)
import UIKit
#endif

struct InformationHubView: View {
    let topics = [
        ("Understanding NICU", "What to expect in the neonatal intensive care unit"),
        ("Medical Equipment", "Guide to tubes, monitors and machines"),
        ("Feeding Support", "Breastfeeding and bottle feeding premature babies"),
        ("Formula Milk Guide", "Complete guide to formula feeding and preparation"),
        ("Mixed Feeding Guide", "How to combine breast milk and formula feeding"),
        ("Developmental Care", "How to support your baby's development"),
        ("Going Home", "Preparing for the transition home")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            dadInfoBanner
            ScrollView {
                VStack(spacing: 20) {
                    dadFocusedArticlesSection
                    understandingNeonatalSection
                    careTopicsSection
                    ukGuidelinesSection
                    lifeAfterNICUSection
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .navigationTitle("Information Hub")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var dadInfoBanner: some View {
        HStack {
            TinyStepsDesign.DadIcon(symbol: TinyStepsDesign.Icons.dad, color: TinyStepsDesign.Colors.accent)
            Text("Dad's Info Hub")
                .font(TinyStepsDesign.Typography.header)
                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(TinyStepsDesign.Colors.primary)
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    private var dadFocusedArticlesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("For Dads")
                .font(TinyStepsDesign.Typography.subheader)
                .foregroundColor(TinyStepsDesign.Colors.accent)
            // Example dad-focused article
            Link(destination: URL(string: "https://fatherly.com")!) {
                HStack {
                    Image(systemName: "figure.and.child.holdinghands")
                        .foregroundColor(TinyStepsDesign.Colors.accent)
                    Text("Fatherly: Tips for New Dads")
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .background(.ultraThinMaterial)
            )
            // ... add more dad-specific articles/resources ...
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
        )
    }
    
    private var understandingNeonatalSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Understanding Neonatal",
                icon: "heart.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            NavigationLink(destination: TopicDetailView(topic: "Understanding NICU")) {
                TinyStepsCard {
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        HStack {
                            Image(systemName: "building.2.fill")
                                .font(.title2)
                                .foregroundColor(TinyStepsDesign.Colors.success)
                            
                            Text("Understanding NICU")
                                .font(TinyStepsDesign.Typography.body)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        Text("What to expect in the neonatal intensive care unit")
                            .font(TinyStepsDesign.Typography.body)
                            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
    }
    
    private var careTopicsSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Care Topics",
                icon: "cross.case.fill",
                color: TinyStepsDesign.Colors.highlight
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: TinyStepsDesign.Spacing.md) {
                ForEach(topics.dropFirst(), id: \.0) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic.0)) {
                        TinyStepsCard {
                            VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                                HStack {
                                    Image(systemName: getIconForTopic(topic.0))
                                        .font(.title2)
                                        .foregroundColor(getColorForTopic(topic.0))
                                    
                                    Text(topic.0)
                                        .font(TinyStepsDesign.Typography.body)
                                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                                }
                                
                                Text(topic.1)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
    }
    
    private var ukGuidelinesSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "UK Guidelines & Resources",
                icon: "flag.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: TinyStepsDesign.Spacing.sm) {
                ForEach(Array(UKGuidelines2025.emergencyContacts.enumerated()), id: \.offset) { _, contact in
                    if let url = getURLForContact(contact.0) {
                        Link(destination: url) {
                            TinyStepsCard {
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(TinyStepsDesign.Colors.accent)
                                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.xs) {
                                        Text(contact.0)
                                            .font(TinyStepsDesign.Typography.body)
                                            .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                                        Text(contact.1)
                                            .font(TinyStepsDesign.Typography.caption)
                                            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
    }
    
    private var lifeAfterNICUSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Life After NICU",
                icon: "house.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            NavigationLink(destination: TopicDetailView(topic: "Growing at Home")) {
                TinyStepsCard {
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.title2)
                                .foregroundColor(TinyStepsDesign.Colors.success)
                            
                            Text("Growing at Home")
                                .font(TinyStepsDesign.Typography.body)
                                .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                        
                        Text("Tips and resources for caring for your baby after discharge")
                            .font(TinyStepsDesign.Typography.body)
                            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
    }
    
    // Helper functions
    private func getIconForTopic(_ topic: String) -> String {
        switch topic {
        case "Medical Equipment": return "stethoscope"
        case "Feeding Support": return "drop.fill"
        case "Formula Milk Guide": return "bottle.fill"
        case "Mixed Feeding Guide": return "drop"
        case "Developmental Care": return "brain.head.profile"
        case "Going Home": return "house.fill"
        default: return "info.circle"
        }
    }
    
    private func getColorForTopic(_ topic: String) -> Color {
        switch topic {
        case "Understanding NICU": return TinyStepsDesign.Colors.success
        case "Medical Equipment": return TinyStepsDesign.Colors.success
        case "Feeding Support": return TinyStepsDesign.Colors.accent
        case "Formula Milk Guide": return TinyStepsDesign.Colors.accent
        case "Mixed Feeding Guide": return TinyStepsDesign.Colors.accent
        case "Developmental Care": return TinyStepsDesign.Colors.highlight
        case "Going Home": return TinyStepsDesign.Colors.success
        case "Growing at Home": return TinyStepsDesign.Colors.success
        default: return TinyStepsDesign.Colors.accent
        }
    }
    
    private func getURLForContact(_ contact: String) -> URL? {
        switch contact {
        case "NHS 111": return URL(string: "tel:111")
        case "NHS 999": return URL(string: "tel:999")
        case "Bliss Helpline": return URL(string: "tel:08088010322")
        case "NCT Helpline": return URL(string: "tel:03003300700")
        case "Samaritans": return URL(string: "tel:116123")
        case "CALM": return URL(string: "tel:0800585858")
        default: return nil
        }
    }
}

struct TopicDetailView: View {
    let topic: String
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
                    // Header
                    TinyStepsSectionHeader(
                        title: topic,
                        icon: getIconForTopic(topic),
                        color: getColorForTopic(topic)
                    )
                    
                    // Content based on topic
                    Group {
                        switch topic {
                        case "Understanding NICU":
                            UnderstandingNICUView()
                        case "Medical Equipment":
                            MedicalEquipmentView()
                        case "Feeding Support":
                            FeedingSupportView()
                        case "Formula Milk Guide":
                            FormulaMilkGuideView()
                        case "Mixed Feeding Guide":
                            MixedFeedingGuideView()
                        case "Developmental Care":
                            DevelopmentalCareView()
                        case "Going Home":
                            GoingHomeView()
                        case "Growing at Home":
                            GrowingAtHomeView()
                        default:
                            Text("Content coming soon...")
                                .font(TinyStepsDesign.Typography.body)
                                .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal, TinyStepsDesign.Spacing.md)
                }
                .padding(.vertical, TinyStepsDesign.Spacing.lg)
            }
        }
        .navigationTitle(topic)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func getIconForTopic(_ topic: String) -> String {
        switch topic {
        case "Understanding NICU": return "building.2.fill"
        case "Medical Equipment": return "stethoscope"
        case "Feeding Support": return "drop.fill"
        case "Formula Milk Guide": return "bottle.fill"
        case "Mixed Feeding Guide": return "drop"
        case "Developmental Care": return "brain.head.profile"
        case "Going Home": return "house.fill"
        case "Growing at Home": return "house.fill"
        default: return "info.circle"
        }
    }
    
    private func getColorForTopic(_ topic: String) -> Color {
        switch topic {
        case "Understanding NICU": return TinyStepsDesign.Colors.success
        case "Medical Equipment": return TinyStepsDesign.Colors.success
        case "Feeding Support": return TinyStepsDesign.Colors.accent
        case "Formula Milk Guide": return TinyStepsDesign.Colors.accent
        case "Mixed Feeding Guide": return TinyStepsDesign.Colors.accent
        case "Developmental Care": return TinyStepsDesign.Colors.highlight
        case "Going Home": return TinyStepsDesign.Colors.success
        case "Growing at Home": return TinyStepsDesign.Colors.success
        default: return TinyStepsDesign.Colors.accent
        }
    }
}

// MARK: - Topic Detail Views
struct UnderstandingNICUView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "What is NICU?",
                content: "The Neonatal Intensive Care Unit (NICU) provides specialist care for premature and sick babies. You can expect a team of doctors, nurses, and support staff to care for your baby. Parents are encouraged to be involved in care as much as possible.",
                icon: "building.2.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Key Points")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Parents are welcome 24/7 in most NICUs",
                            "Staff will explain equipment and procedures",
                            "Skin-to-skin contact (kangaroo care) is encouraged",
                            "Ask questions and seek support when needed"
                        ], id: \.self) { point in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(point)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // UK Resources
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("UK Resources")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        Link("NHS Neonatal Care", destination: URL(string: "https://www.nhs.uk/conditions/baby/caring-for-a-newborn/neonatal-care/")!)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        
                        Link("Bliss Charity Resources", destination: URL(string: "https://www.bliss.org.uk")!)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                        
                        Link("NHS Healthier Together", destination: URL(string: "https://what0-18.nhs.uk/")!)
                            .foregroundColor(TinyStepsDesign.Colors.accent)
                    }
                }
            }
        }
    }
}

// Additional topic views would follow the same pattern...
struct MedicalEquipmentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Common Equipment",
                content: "Babies in the NICU may need special equipment to help them grow and recover. Staff will explain what each piece of equipment does and answer your questions.",
                icon: "stethoscope",
                color: TinyStepsDesign.Colors.success
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Key Equipment")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Incubator: Keeps baby warm and protected",
                            "Monitors: Track heart rate, breathing, and oxygen levels",
                            "Feeding tubes: Provide nutrition if baby can't feed by mouth",
                            "IV lines: Deliver fluids and medicines"
                        ], id: \.self) { equipment in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(equipment)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

// Placeholder views for other topics
struct FeedingSupportView: View {
    var body: some View {
        Text("Feeding Support content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}

struct FormulaMilkGuideView: View {
    var body: some View {
        Text("Formula Milk Guide content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}

struct MixedFeedingGuideView: View {
    var body: some View {
        Text("Mixed Feeding Guide content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}

struct DevelopmentalCareView: View {
    var body: some View {
        Text("Developmental Care content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}

struct GoingHomeView: View {
    var body: some View {
        Text("Going Home content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}

struct GrowingAtHomeView: View {
    var body: some View {
        Text("Growing at Home content...")
            .foregroundColor(TinyStepsDesign.Colors.textSecondary)
    }
}
