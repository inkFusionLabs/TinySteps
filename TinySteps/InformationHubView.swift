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
        ("Going Home", "Preparing for the transition home"),
        // New health topics
        ("Teething", "How to help your baby through teething discomfort"),
        ("Colic", "Understanding and soothing colic in babies"),
        ("Constipation", "What to do if your baby is constipated"),
        ("Reflux", "Managing reflux and spit-up"),
        ("Common Illnesses", "Recognizing and responding to common baby illnesses")
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
                    supportResourcesSection
                }
                .padding()
            }
        }
        .background(TinyStepsDesign.Colors.background.ignoresSafeArea())
        .navigationTitle("Information Hub")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var dadInfoBanner: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Dad's Info Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            Text("Guidance, support & resources for NICU dads")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var dadFocusedArticlesSection: some View {
        VStack(spacing: 15) {
            Link(destination: URL(string: "https://fatherly.com")!) {
                ProfileInfoRow(
                    icon: "figure.and.child.holdinghands",
                    title: "Fatherly: Tips for New Dads",
                    value: "Visit site",
                    color: TinyStepsDesign.Colors.accent
                )
            }
            .buttonStyle(PlainButtonStyle())
            // ... add more dad-specific articles/resources ...
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
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
                ProfileInfoRow(
                    icon: "building.2.fill",
                    title: "Understanding NICU",
                    value: "Learn more",
                    color: TinyStepsDesign.Colors.success
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var careTopicsSection: some View {
        VStack(spacing: 15) {
            ForEach(topics, id: \.0) { topic, subtitle in
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    ProfileInfoRow(
                        icon: "heart.fill",
                        title: topic,
                        value: "View guide",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var ukGuidelinesSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "UK Guidelines & Resources",
                icon: "flag.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            VStack(spacing: 15) {
                ForEach(Array(UKGuidelines2025.emergencyContacts.enumerated()), id: \.offset) { _, contact in
                    if let url = getURLForContact(contact.0) {
                        Link(destination: url) {
                            ProfileInfoRow(
                                icon: "phone.fill",
                                title: contact.0,
                                value: contact.1,
                                color: TinyStepsDesign.Colors.accent
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var supportResourcesSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Support Resources",
                icon: "heart.fill",
                color: .pink
            )
            
            VStack(spacing: 15) {
                Link(destination: URL(string: "https://www.bliss.org.uk")!) {
                    ProfileInfoRow(
                        icon: "heart.fill",
                        title: "Bliss - Supporting Premature Babies",
                        value: "Visit site",
                        color: .pink
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://www.nhs.uk")!) {
                    ProfileInfoRow(
                        icon: "cross.fill",
                        title: "NHS - Health Information",
                        value: "Visit site",
                        color: .green
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    private var lifeAfterNICUSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Life After NICU",
                icon: "house.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            NavigationLink(destination: TopicDetailView(topic: "Growing at Home")) {
                ProfileInfoRow(
                    icon: "house.fill",
                    title: "Growing at Home",
                    value: "Learn more",
                    color: TinyStepsDesign.Colors.success
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
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
                        case "Teething":
                            TeethingInfoView()
                        case "Colic":
                            ColicInfoView()
                        case "Constipation":
                            ConstipationInfoView()
                        case "Reflux":
                            RefluxInfoView()
                        case "Common Illnesses":
                            CommonIllnessesInfoView()
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

// MARK: - Health Info Views
struct TeethingInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Teething")
                .font(.title2).fontWeight(.bold)
            Text("Teething usually starts around 6 months, but can begin earlier or later. Signs include drooling, chewing, and irritability.")
            Text("How to help:")
                .font(.headline)
            Text("• Offer a clean, cool teething ring or damp washcloth to chew on.\n• Gently rub baby's gums with a clean finger.\n• Wipe drool to prevent rash.\n• If needed, use infant paracetamol (consult your GP first).\n• Avoid teething gels with sugar or aspirin.")
            Text("When to call the doctor:")
                .font(.headline)
            Text("• High fever,\n• Refusal to feed,\n• Severe discomfort or swelling.")
        }
    }
}

struct ColicInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colic")
                .font(.title2).fontWeight(.bold)
            Text("Colic is frequent, prolonged crying in an otherwise healthy baby, often in the evenings. It usually resolves by 3-4 months.")
            Text("How to help:")
                .font(.headline)
            Text("• Hold and comfort your baby.\n• Try gentle rocking or white noise.\n• Offer a dummy (pacifier).\n• Check for hunger, wind, or dirty nappy.\n• Take breaks and ask for support.")
            Text("When to call the doctor:")
                .font(.headline)
            Text("• Vomiting,\n• Blood in stool,\n• Poor weight gain,\n• Fever.")
        }
    }
}

struct ConstipationInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Constipation")
                .font(.title2).fontWeight(.bold)
            Text("Constipation is when a baby has hard, infrequent stools. It's common during weaning or formula changes.")
            Text("How to help:")
                .font(.headline)
            Text("• Offer extra water (if over 6 months).\n• Gently move baby's legs in a cycling motion.\n• Give a warm bath.\n• For older babies, offer pureed fruit (prunes, pears, apples).")
            Text("When to call the doctor:")
                .font(.headline)
            Text("• Blood in stool,\n• Severe pain,\n• Vomiting,\n• No improvement after a few days.")
        }
    }
}

struct RefluxInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reflux")
                .font(.title2).fontWeight(.bold)
            Text("Reflux (spit-up) is common in babies and usually improves by 12 months.")
            Text("How to help:")
                .font(.headline)
            Text("• Feed baby upright and keep upright after feeds.\n• Burp baby frequently.\n• Avoid overfeeding.\n• Raise head of cot slightly (never use pillows for babies).\n• See your GP if baby is not gaining weight or seems distressed.")
        }
    }
}

struct CommonIllnessesInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Common Illnesses")
                .font(.title2).fontWeight(.bold)
            Text("Babies often get minor illnesses like colds, coughs, and mild fevers.")
            Text("When to call the doctor:")
                .font(.headline)
            Text("• High fever (over 38°C under 3 months, over 39°C over 3 months).\n• Difficulty breathing.\n• Poor feeding or dehydration.\n• Seizures.\n• Rash that doesn't fade with pressure.")
        }
    }
}
