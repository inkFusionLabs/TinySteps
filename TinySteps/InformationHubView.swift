import SwiftUI

#if canImport(UIKit)
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
        ZStack {
            // Background
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                dadInfoBanner
                ScrollView {
                    VStack(spacing: 20) {
                        dadFocusedArticlesSection
                        dadsGuidesSection
                        understandingNeonatalSection
                        careTopicsSection
                        ukGuidelinesSection
                        lifeAfterNICUSection
                        supportResourcesSection
                        dadWellnessSection
                        chatSupportSection
                    }
                    .padding()
                }
            }
        }
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
        .background(Color.clear)
    }
    
    private var dadsGuidesSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Dad's Guides",
                icon: "book.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            VStack(spacing: 15) {
                NavigationLink(destination: TopicDetailView(topic: "NICU Survival Guide")) {
                    ProfileInfoRow(
                        icon: "shield.fill",
                        title: "NICU Survival Guide",
                        value: "Essential tips",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: TopicDetailView(topic: "Bonding with Your Baby")) {
                    ProfileInfoRow(
                        icon: "heart.fill",
                        title: "Bonding with Your Baby",
                        value: "Connection tips",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: TopicDetailView(topic: "Supporting Your Partner")) {
                    ProfileInfoRow(
                        icon: "person.2.fill",
                        title: "Supporting Your Partner",
                        value: "Relationship guide",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: TopicDetailView(topic: "Managing Work & NICU")) {
                    ProfileInfoRow(
                        icon: "briefcase.fill",
                        title: "Managing Work & NICU",
                        value: "Balance guide",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: TopicDetailView(topic: "Self-Care for Dads")) {
                    ProfileInfoRow(
                        icon: "figure.walk",
                        title: "Self-Care for Dads",
                        value: "Wellness tips",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: TopicDetailView(topic: "Financial Planning")) {
                    ProfileInfoRow(
                        icon: "creditcard.fill",
                        title: "Financial Planning",
                        value: "Money matters",
                        color: TinyStepsDesign.Colors.accent
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(Color.clear)
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
        .background(Color.clear)
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
        .background(Color.clear)
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
        .background(Color.clear)
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
        .background(Color.clear)
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
        .background(Color.clear)
    }
    
    private var dadWellnessSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Dad's Wellness",
                icon: "heart.fill",
                color: .orange
            )
            
            VStack(spacing: 15) {
                NavigationLink(destination: DadWellnessView()) {
                    ProfileInfoRow(
                        icon: "heart.fill",
                        title: "Mental Health Support",
                        value: "Access support",
                        color: .orange
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://www.mind.org.uk")!) {
                    ProfileInfoRow(
                        icon: "brain.head.profile",
                        title: "Mind - Mental Health Charity",
                        value: "Visit site",
                        color: .blue
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://www.samaritans.org")!) {
                    ProfileInfoRow(
                        icon: "phone.fill",
                        title: "Samaritans - 24/7 Support",
                        value: "Call 116 123",
                        color: .green
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, TinyStepsDesign.Spacing.md)
        .padding(.vertical, 15)
        .background(Color.clear)
    }
    
    private var chatSupportSection: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
            TinyStepsSectionHeader(
                title: "Chat Support",
                icon: "message.fill",
                color: .blue
            )
            
            VStack(spacing: 15) {
                Link(destination: URL(string: "https://www.bliss.org.uk/contact-us")!) {
                    ProfileInfoRow(
                        icon: "phone.fill",
                        title: "Bliss Helpline",
                        value: "0808 801 0322",
                        color: .pink
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://www.nhs.uk/using-the-nhs/nhs-services/mental-health-services/")!) {
                    ProfileInfoRow(
                        icon: "cross.fill",
                        title: "NHS Mental Health Services",
                        value: "Find support",
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
        case "Emergency Services": return URL(string: "tel:999") // Default to UK emergency
        case "Non-Emergency Medical": return URL(string: "tel:111") // Default to UK non-emergency
        case "Bliss Helpline": return URL(string: "tel:08088010322")
        case "NCT Helpline": return URL(string: "tel:03003300700")
        case "Samaritans": return URL(string: "tel:116123")
        case "CALM": return URL(string: "tel:0800585858")
        case "March of Dimes": return URL(string: "tel:18886634637")
        case "NICU Parent Support": return nil // No direct phone number, would link to local resources
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
                        case "NICU Survival Guide":
                            NICUSurvivalGuideView()
                        case "Bonding with Your Baby":
                            BondingWithBabyView()
                        case "Supporting Your Partner":
                            SupportingPartnerView()
                        case "Managing Work & NICU":
                            ManagingWorkNICUView()
                        case "Self-Care for Dads":
                            SelfCareForDadsView()
                        case "Financial Planning":
                            FinancialPlanningView()
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

// Comprehensive guide views
struct FeedingSupportView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Feeding Support for Premature Babies",
                content: "Premature babies may need special feeding support. They might tire easily during feeds and need smaller, more frequent meals. Your NICU team will guide you through the best feeding approach for your baby.",
                icon: "drop.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Breastfeeding Tips")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Start with skin-to-skin contact to encourage feeding",
                            "Premature babies may need help latching initially",
                            "Use a nipple shield if recommended by staff",
                            "Express milk regularly to maintain supply",
                            "Don't worry if baby tires quickly - this is normal"
                        ], id: \.self) { tip in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(tip)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Bottle Feeding Tips")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Use slow-flow teats designed for premature babies",
                            "Hold baby upright during feeds",
                            "Take breaks if baby shows signs of tiring",
                            "Burp frequently during and after feeds",
                            "Follow the feeding schedule recommended by staff"
                        ], id: \.self) { tip in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "bottle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(tip)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Signs Baby is Getting Enough")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Steady weight gain",
                            "6-8 wet nappies per day",
                            "Content after feeds",
                            "Good skin color and tone",
                            "Regular bowel movements"
                        ], id: \.self) { sign in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(sign)
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

struct FormulaMilkGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Formula Feeding Guide",
                content: "Formula feeding can be a good option for premature babies. Always follow the guidance of your NICU team and use the formula they recommend.",
                icon: "bottle.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Safe Preparation")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Wash hands thoroughly before preparation",
                            "Use boiled water that has cooled for 30 minutes",
                            "Follow the exact measurements on the formula tin",
                            "Make up feeds one at a time",
                            "Discard any unused formula after 2 hours"
                        ], id: \.self) { step in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(step)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Equipment Needed")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Sterilizer for bottles and teats",
                            "Bottles with slow-flow teats",
                            "Formula powder (as recommended)",
                            "Bottle brush for cleaning",
                            "Thermometer for checking temperature"
                        ], id: \.self) { item in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(item)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Feeding Schedule")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Feed every 2-3 hours initially",
                            "Let baby guide the amount they take",
                            "Don't force baby to finish the bottle",
                            "Watch for signs of hunger and fullness",
                            "Consult staff about any feeding concerns"
                        ], id: \.self) { schedule in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(schedule)
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

struct MixedFeedingGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Combining Breast and Formula",
                content: "Mixed feeding can work well for many families. You can combine breast milk and formula in a way that suits your situation and your baby's needs.",
                icon: "drop",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Benefits of Mixed Feeding")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Baby gets benefits of breast milk",
                            "More flexibility for parents",
                            "Others can help with feeding",
                            "Can supplement if supply is low",
                            "Easier transition when returning to work"
                        ], id: \.self) { benefit in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(benefit)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Start Mixed Feeding")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Establish breastfeeding first (if possible)",
                            "Introduce one formula feed at a time",
                            "Start with the feed you find most challenging",
                            "Express milk to maintain supply",
                            "Be patient - it may take time to adjust"
                        ], id: \.self) { step in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(step)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Tips for Success")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Keep breastfeeding regularly to maintain supply",
                            "Use the same formula consistently",
                            "Allow time for baby to adjust to different tastes",
                            "Don't worry about exact proportions",
                            "Focus on what works for your family"
                        ], id: \.self) { tip in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(tip)
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

struct DevelopmentalCareView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Supporting Your Baby's Development",
                content: "Premature babies may develop at their own pace. Developmental care focuses on creating the best environment for your baby's growth and development.",
                icon: "brain.head.profile",
                color: TinyStepsDesign.Colors.highlight
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Key Developmental Areas")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Physical development: movement and strength",
                            "Cognitive development: learning and thinking",
                            "Social development: interaction and communication",
                            "Emotional development: feelings and relationships",
                            "Language development: understanding and speaking"
                        ], id: \.self) { area in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(area)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Support Development")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Talk and sing to your baby regularly",
                            "Provide gentle touch and skin-to-skin contact",
                            "Respond to your baby's cues and signals",
                            "Create a calm, low-stimulation environment",
                            "Follow your baby's lead - don't force interaction"
                        ], id: \.self) { support in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(support)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Seek Help")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Not reaching expected milestones",
                            "Concerns about movement or muscle tone",
                            "Limited eye contact or social interaction",
                            "Delayed speech or communication",
                            "Unusual behavior or development patterns"
                        ], id: \.self) { concern in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(concern)
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

struct GoingHomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Preparing for Home",
                content: "Going home with your baby is an exciting but sometimes overwhelming time. Preparation and support can help make the transition smoother.",
                icon: "house.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Before Going Home")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Learn to care for your baby's specific needs",
                            "Practice feeding, changing, and bathing",
                            "Understand any medical equipment needed",
                            "Arrange follow-up appointments",
                            "Prepare your home environment"
                        ], id: \.self) { preparation in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "checklist")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(preparation)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Essential Items")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Car seat suitable for premature babies",
                            "Basic baby care items (nappies, clothes)",
                            "Feeding equipment if needed",
                            "Medical supplies if required",
                            "Contact numbers for support"
                        ], id: \.self) { item in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "bag.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(item)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Coping with the Transition")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "It's normal to feel anxious - this is common",
                            "Take it one day at a time",
                            "Ask for help from family and friends",
                            "Keep in touch with NICU staff initially",
                            "Trust your instincts as a parent"
                        ], id: \.self) { coping in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(coping)
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

// MARK: - Dad's Guides Views
struct NICUSurvivalGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "NICU Survival Guide",
                content: "The NICU journey can be overwhelming. This guide helps you navigate the challenges and find your strength as a dad.",
                icon: "shield.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("First Steps in NICU")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Take time to process your emotions",
                            "Ask questions - no question is too small",
                            "Learn your baby's routine and schedule",
                            "Get to know the medical team",
                            "Find your role in your baby's care"
                        ], id: \.self) { step in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(step)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Building Confidence")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Start with simple tasks like changing nappies",
                            "Practice skin-to-skin contact when possible",
                            "Learn to read your baby's cues",
                            "Take photos and keep a journal",
                            "Celebrate small victories"
                        ], id: \.self) { confidence in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(confidence)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Coping Strategies")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Talk to other NICU dads",
                            "Take breaks when you need them",
                            "Focus on what you can control",
                            "Practice self-compassion",
                            "Seek professional help if needed"
                        ], id: \.self) { strategy in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(strategy)
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

struct BondingWithBabyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Bonding with Your Baby",
                content: "Building a strong connection with your premature baby takes time and patience. Here are ways to strengthen your bond.",
                icon: "heart.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Skin-to-Skin Contact")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Ask staff about kangaroo care opportunities",
                            "Start with short sessions and build up",
                            "Wear a button-up shirt for easy access",
                            "Stay calm and relaxed during sessions",
                            "Talk or sing softly to your baby"
                        ], id: \.self) { tip in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(tip)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Communication")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Talk to your baby regularly",
                            "Read books or sing songs",
                            "Use a gentle, soothing voice",
                            "Make eye contact when possible",
                            "Respond to your baby's cues"
                        ], id: \.self) { communication in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "message.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(communication)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Involvement in Care")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Help with nappy changes when possible",
                            "Learn to feed your baby",
                            "Participate in bath time",
                            "Take photos and videos",
                            "Keep a journal of milestones"
                        ], id: \.self) { involvement in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(involvement)
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

struct SupportingPartnerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Supporting Your Partner",
                content: "Your partner is going through a challenging time too. Here's how to support each other through the NICU journey.",
                icon: "person.2.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Emotional Support")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Listen without trying to fix everything",
                            "Validate her feelings and experiences",
                            "Share your own emotions openly",
                            "Be patient with mood changes",
                            "Encourage her to seek help if needed"
                        ], id: \.self) { support in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(support)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Practical Support")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Take on household responsibilities",
                            "Help with pumping and milk storage",
                            "Coordinate visits and schedules",
                            "Handle communication with family",
                            "Ensure she gets rest and nutrition"
                        ], id: \.self) { practical in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "checklist")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(practical)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Communication")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Check in regularly about her needs",
                            "Share your feelings and concerns",
                            "Make decisions together",
                            "Celebrate small victories together",
                            "Plan for the future together"
                        ], id: \.self) { communication in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "message.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(communication)
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

struct ManagingWorkNICUView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Managing Work & NICU",
                content: "Balancing work responsibilities with NICU visits can be challenging. Here are strategies to help you manage both.",
                icon: "briefcase.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Work Arrangements")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Discuss flexible working arrangements",
                            "Consider paternity leave options",
                            "Use annual leave strategically",
                            "Explore remote work possibilities",
                            "Plan your schedule around visits"
                        ], id: \.self) { arrangement in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "calendar")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(arrangement)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Communication with Work")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Be honest about your situation",
                            "Keep your manager informed",
                            "Set realistic expectations",
                            "Use technology to stay connected",
                            "Ask for support when needed"
                        ], id: \.self) { communication in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "message.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(communication)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Self-Care at Work")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Take regular breaks",
                            "Stay connected with family",
                            "Use lunch breaks for calls",
                            "Practice stress management",
                            "Maintain healthy boundaries"
                        ], id: \.self) { selfcare in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(selfcare)
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

struct SelfCareForDadsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Self-Care for Dads",
                content: "Taking care of yourself is essential to being there for your family. Here are practical ways to maintain your wellbeing.",
                icon: "figure.walk",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Physical Health")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Try to get adequate sleep",
                            "Eat regular, nutritious meals",
                            "Exercise when possible",
                            "Take short walks",
                            "Stay hydrated"
                        ], id: \.self) { health in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(health)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Mental Health")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Talk to friends and family",
                            "Consider professional counseling",
                            "Practice mindfulness or meditation",
                            "Write in a journal",
                            "Take time for hobbies"
                        ], id: \.self) { mental in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(mental)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Emotional Support")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Connect with other NICU dads",
                            "Join support groups",
                            "Share your feelings openly",
                            "Be kind to yourself",
                            "Celebrate small wins"
                        ], id: \.self) { support in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(support)
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

struct FinancialPlanningView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Financial Planning",
                content: "NICU stays can be expensive. Planning ahead and knowing your options can help reduce financial stress.",
                icon: "creditcard.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Understanding Costs")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "NHS care is free in the UK",
                            "Private care costs vary significantly",
                            "Additional costs for travel and parking",
                            "Potential loss of income",
                            "Future medical expenses"
                        ], id: \.self) { cost in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "pound.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(cost)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Financial Support")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Check eligibility for benefits",
                            "Apply for Universal Credit if needed",
                            "Look into charitable grants",
                            "Consider crowdfunding options",
                            "Ask about hospital financial assistance"
                        ], id: \.self) { support in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(support)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Planning Ahead")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Create a budget for the coming months",
                            "Set aside emergency funds",
                            "Plan for return to work",
                            "Consider insurance options",
                            "Track all medical expenses"
                        ], id: \.self) { planning in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "calendar")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(planning)
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

struct GrowingAtHomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Growing at Home",
                content: "Your baby's development journey continues at home. Here's what to expect and how to support their growth in the first year.",
                icon: "house.fill",
                color: TinyStepsDesign.Colors.success
            )
            
            // Physical Development
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Physical Development")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "0-3 months: Lifting head, following objects with eyes",
                            "3-6 months: Rolling over, reaching for objects",
                            "6-9 months: Sitting up, crawling, first teeth",
                            "9-12 months: Standing, cruising, first steps"
                        ], id: \.self) { milestone in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(milestone)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // Feeding Milestones
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Feeding Milestones")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "0-6 months: Breast milk or formula only",
                            "6 months: Start introducing solid foods",
                            "7-9 months: Finger foods, more variety",
                            "10-12 months: Family meals, self-feeding"
                        ], id: \.self) { feeding in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(feeding)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // Sleep Patterns
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Sleep Development")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "0-3 months: 14-17 hours total, frequent waking",
                            "3-6 months: 12-15 hours, longer night sleep",
                            "6-12 months: 11-14 hours, 2-3 naps daily",
                            "12+ months: 11-14 hours, 1-2 naps daily"
                        ], id: \.self) { sleep in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(sleep)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // Communication Development
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Communication & Social")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "0-3 months: Cooing, smiling, eye contact",
                            "3-6 months: Babbling, laughing, responding to voices",
                            "6-9 months: Understanding simple words, pointing",
                            "9-12 months: First words, waving, following simple commands"
                        ], id: \.self) { communication in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.info)
                                    .font(.caption)
                                
                                Text(communication)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // Safety Tips
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("Home Safety Tips")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Baby-proof your home: cover sockets, secure furniture",
                            "Keep small objects out of reach (choking hazard)",
                            "Install stair gates and cupboard locks",
                            "Set water heater to max 50°C to prevent scalding",
                            "Never leave baby alone on changing table or bed"
                        ], id: \.self) { safety in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.success)
                                    .font(.caption)
                                
                                Text(safety)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            // When to Seek Help
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Contact Your Health Visitor")
                        .font(TinyStepsDesign.Typography.subheader)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Not reaching expected milestones",
                            "Concerns about feeding or weight gain",
                            "Unusual behavior or development",
                            "Questions about weaning or nutrition",
                            "Sleep concerns affecting family wellbeing"
                        ], id: \.self) { concern in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(concern)
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

// MARK: - Health Info Views
struct TeethingInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Teething",
                content: "Teething usually starts around 6 months, but can begin earlier or later. Signs include drooling, chewing, and irritability.",
                icon: "tooth",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Help")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Offer a clean, cool teething ring or damp washcloth to chew on",
                            "Gently rub baby's gums with a clean finger",
                            "Wipe drool to prevent rash",
                            "If needed, use infant paracetamol (consult your GP first)",
                            "Avoid teething gels with sugar or aspirin"
                        ], id: \.self) { help in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(help)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Call the Doctor")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "High fever",
                            "Refusal to feed",
                            "Severe discomfort or swelling"
                        ], id: \.self) { warning in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(warning)
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

struct ColicInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Colic",
                content: "Colic is frequent, prolonged crying in an otherwise healthy baby, often in the evenings. It usually resolves by 3-4 months.",
                icon: "face.smiling",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Help")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Hold and comfort your baby",
                            "Try gentle rocking or white noise",
                            "Offer a dummy (pacifier)",
                            "Check for hunger, wind, or dirty nappy",
                            "Take breaks and ask for support"
                        ], id: \.self) { help in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(help)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Call the Doctor")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Vomiting",
                            "Blood in stool",
                            "Poor weight gain",
                            "Fever"
                        ], id: \.self) { warning in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(warning)
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

struct ConstipationInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Constipation",
                content: "Constipation is when a baby has hard, infrequent stools. It's common during weaning or formula changes.",
                icon: "exclamationmark.triangle",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Help")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Offer extra water (if over 6 months)",
                            "Gently move baby's legs in a cycling motion",
                            "Give a warm bath",
                            "For older babies, offer pureed fruit (prunes, pears, apples)"
                        ], id: \.self) { help in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(help)
                                    .font(TinyStepsDesign.Typography.body)
                                    .foregroundColor(TinyStepsDesign.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Call the Doctor")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Blood in stool",
                            "Severe pain",
                            "Vomiting",
                            "No improvement after a few days"
                        ], id: \.self) { warning in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(warning)
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

struct RefluxInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Reflux",
                content: "Reflux (spit-up) is common in babies and usually improves by 12 months.",
                icon: "arrow.up.arrow.down",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("How to Help")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "Feed baby upright and keep upright after feeds",
                            "Burp baby frequently",
                            "Avoid overfeeding",
                            "Raise head of cot slightly (never use pillows for babies)",
                            "See your GP if baby is not gaining weight or seems distressed"
                        ], id: \.self) { help in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.accent)
                                    .font(.caption)
                                
                                Text(help)
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

struct CommonIllnessesInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.lg) {
            TinyStepsInfoCard(
                title: "Common Illnesses",
                content: "Babies often get minor illnesses like colds, coughs, and mild fevers.",
                icon: "cross.fill",
                color: TinyStepsDesign.Colors.accent
            )
            
            TinyStepsCard {
                VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.md) {
                    Text("When to Call the Doctor")
                        .font(TinyStepsDesign.Typography.body)
                        .foregroundColor(TinyStepsDesign.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: TinyStepsDesign.Spacing.sm) {
                        ForEach([
                            "High fever (over 38°C under 3 months, over 39°C over 3 months)",
                            "Difficulty breathing",
                            "Poor feeding or dehydration",
                            "Seizures",
                            "Rash that doesn't fade with pressure"
                        ], id: \.self) { warning in
                            HStack(alignment: .top, spacing: TinyStepsDesign.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(TinyStepsDesign.Colors.highlight)
                                    .font(.caption)
                                
                                Text(warning)
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


