//
//  NICUSupportView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI

struct NICUSupportView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = SupportTab.equipment
    @State private var searchText = ""
    
    enum SupportTab: String, CaseIterable {
        case equipment = "Equipment"
        case resources = "Resources"
        case community = "Community"
        case questions = "Questions"
        case activities = "Activities"
        
        var icon: String {
            switch self {
            case .equipment: return "gear"
            case .resources: return "book.fill"
            case .community: return "person.2.fill"
            case .questions: return "questionmark.circle.fill"
            case .activities: return "heart.fill"
            }
        }
    }
    
    var filteredEquipment: [NICUEquipment] {
        if searchText.isEmpty {
            return NICUEquipment.allEquipment
        } else {
            return NICUEquipment.allEquipment.filter { equipment in
                equipment.name.localizedCaseInsensitiveContains(searchText) ||
                equipment.description.localizedCaseInsensitiveContains(searchText) ||
                equipment.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NICU Support")
                                .font(.title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Equipment, resources, and community")
                                .font(.subheadline)
                                .themedText(style: .secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Tab Picker
                    HStack(spacing: 0) {
                        ForEach(SupportTab.allCases, id: \.self) { tab in
                            Button(action: { selectedTab = tab }) {
                                VStack(spacing: 4) {
                                    Image(systemName: tab.icon)
                                        .font(.title3)
                                    
                                    Text(tab.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(selectedTab == tab ? themeManager.currentTheme.colors.accent : themeManager.currentTheme.colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.6)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        switch selectedTab {
                        case .equipment:
                            EquipmentGuideView(searchText: $searchText, filteredEquipment: filteredEquipment)
                        case .resources:
                            SupportResourcesView()
                        case .community:
                            CommunitySupportView()
                        case .questions:
                            DailyQuestionsView()
                        case .activities:
                            BondingActivitiesView()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
    }
}

// MARK: - Equipment Guide View
struct EquipmentGuideView: View {
    @Binding var searchText: String
    let filteredEquipment: [NICUEquipment]
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search equipment...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .opacity(0.6)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            
            // Equipment List
            ForEach(filteredEquipment) { equipment in
                EquipmentCard(equipment: equipment)
            }
        }
    }
}

// MARK: - Equipment Card
struct EquipmentCard: View {
    let equipment: NICUEquipment
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: equipment.icon)
                                .font(.title2)
                                .foregroundColor(equipment.color)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(equipment.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .themedText(style: .primary)
                                
                                Text(equipment.category)
                                    .font(.caption)
                                    .themedText(style: .secondary)
                            }
                        }
                        
                        if !isExpanded {
                            Text(equipment.shortDescription)
                                .font(.body)
                                .themedText(style: .secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(equipment.color)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What it does:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                        
                        Text(equipment.description)
                            .font(.body)
                            .themedText(style: .secondary)
                            .lineSpacing(4)
                    }
                    
                    if !equipment.dadTips.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dad Tips:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            ForEach(equipment.dadTips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(equipment.color)
                                    Text(tip)
                                        .font(.body)
                                        .themedText(style: .secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(equipment.color.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .themedCard()
    }
}

// MARK: - Support Resources View
struct SupportResourcesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(SupportResource.allResources, id: \.id) { resource in
                SupportResourceCard(resource: resource)
            }
        }
    }
}

// MARK: - Support Resource Card
struct SupportResourceCard: View {
    let resource: SupportResource
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: resource.icon)
                    .font(.title2)
                    .foregroundColor(resource.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(resource.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(resource.category)
                        .font(.caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
            }
            
            Text(resource.description)
                .font(.body)
                .themedText(style: .secondary)
                .lineSpacing(4)
            
            if !resource.contactInfo.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(resource.contactInfo)
                        .font(.body)
                        .themedText(style: .secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(resource.color.opacity(0.1))
                )
            }
        }
        .padding()
        .themedCard()
    }
}

// MARK: - Community Support View
struct CommunitySupportView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(CommunityGroup.allGroups, id: \.id) { group in
                CommunityGroupCard(group: group)
            }
        }
    }
}

// MARK: - Community Group Card
struct CommunityGroupCard: View {
    let group: CommunityGroup
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: group.icon)
                    .font(.title2)
                    .foregroundColor(group.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(group.type)
                        .font(.caption)
                        .themedText(style: .secondary)
                }
                
                Spacer()
            }
            
            Text(group.description)
                .font(.body)
                .themedText(style: .secondary)
                .lineSpacing(4)
            
            if !group.meetingInfo.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Meeting Info:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .themedText(style: .primary)
                    
                    Text(group.meetingInfo)
                        .font(.body)
                        .themedText(style: .secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(group.color.opacity(0.1))
                )
            }
        }
        .padding()
        .themedCard()
    }
}

// MARK: - Data Models
struct NICUEquipment: Identifiable {
    let id = UUID()
    let name: String
    let shortDescription: String
    let description: String
    let category: String
    let icon: String
    let color: Color
    let dadTips: [String]
    
    static let allEquipment = [
        NICUEquipment(
            name: "Incubator",
            shortDescription: "A warm, protective bed for your baby",
            description: "An incubator is a clear, temperature-controlled bed that keeps your baby warm and protected. It maintains the perfect temperature and humidity for your baby's development, and has openings so you can touch and interact with your baby.",
            category: "Environment",
            icon: "bed.double.fill",
            color: .blue,
            dadTips: [
                "You can still touch your baby through the openings",
                "The temperature is carefully controlled - don't worry if it feels warm",
                "The clear sides let you see your baby at all times"
            ]
        ),
        NICUEquipment(
            name: "Ventilator",
            shortDescription: "A machine that helps your baby breathe",
            description: "A ventilator is a breathing machine that takes over your baby's breathing completely. It's connected to a tube in your baby's windpipe and delivers oxygen and air pressure to help your baby's lungs work properly.",
            category: "Breathing",
            icon: "lungs.fill",
            color: .red,
            dadTips: [
                "This might look scary, but it's actually helping your baby rest and grow",
                "The medical team monitors it constantly",
                "Your baby can't cry while on the ventilator, but they can still feel your touch"
            ]
        ),
        NICUEquipment(
            name: "CPAP Machine",
            shortDescription: "Gentle breathing support",
            description: "CPAP (Continuous Positive Airway Pressure) delivers air pressure through a mask or nasal prongs to help keep your baby's airways open. It's like a gentle breeze that helps your baby breathe easier without taking over completely.",
            category: "Breathing",
            icon: "wind",
            color: .green,
            dadTips: [
                "The beeping is normal - it's just monitoring the pressure",
                "Your baby can still cry and make sounds on CPAP",
                "This is a step down from the ventilator"
            ]
        ),
        NICUEquipment(
            name: "Heart Monitor",
            shortDescription: "Tracks your baby's heart rate and breathing",
            description: "This monitor continuously tracks your baby's heart rate, breathing rate, and oxygen levels. It has sensors attached to your baby's chest and alerts the medical team if anything needs attention.",
            category: "Monitoring",
            icon: "heart.fill",
            color: .pink,
            dadTips: [
                "The numbers change constantly - this is normal",
                "Alarms don't always mean something is wrong",
                "The medical team will explain what the numbers mean"
            ]
        ),
        NICUEquipment(
            name: "IV Pump",
            shortDescription: "Delivers fluids and medications",
            description: "An IV pump is a machine that delivers fluids, medications, and nutrition directly into your baby's bloodstream through a small tube. It's programmed to give the exact amount your baby needs at the right time.",
            category: "Medication",
            icon: "drop.fill",
            color: .orange,
            dadTips: [
                "The IV site might look red - this is usually normal",
                "The pump beeps when it needs attention",
                "Your baby gets nutrition even when they can't eat by mouth"
            ]
        ),
        NICUEquipment(
            name: "Phototherapy Light",
            shortDescription: "Special light to treat jaundice",
            description: "Phototherapy uses special blue lights to help break down bilirubin in your baby's blood, which treats jaundice. Your baby wears protective eye patches and lies under the lights for several hours.",
            category: "Treatment",
            icon: "sun.max.fill",
            color: .yellow,
            dadTips: [
                "The eye patches look scary but protect your baby's eyes",
                "You can still hold your baby during breaks from the lights",
                "This is a very common treatment and very effective"
            ]
        ),
        NICUEquipment(
            name: "Feeding Pump",
            shortDescription: "Delivers milk through a feeding tube",
            description: "A feeding pump delivers breast milk or formula through your baby's feeding tube at a controlled rate. It's programmed to give the right amount of nutrition over the right amount of time.",
            category: "Feeding",
            icon: "drop.circle.fill",
            color: .purple,
            dadTips: [
                "This helps your baby get nutrition even when they can't suck",
                "The pump can be paused for skin-to-skin time",
                "Your baby's stomach is very small, so feeding is slow"
            ]
        ),
        NICUEquipment(
            name: "Oxygen Hood",
            shortDescription: "Provides extra oxygen in a clear dome",
            description: "An oxygen hood is a clear plastic dome that fits over your baby's head and provides extra oxygen. It's less invasive than a breathing tube and allows your baby to breathe normally while getting extra oxygen.",
            category: "Breathing",
            icon: "circle.fill",
            color: .cyan,
            dadTips: [
                "You can still see your baby's face clearly",
                "The hood can be lifted for skin-to-skin time",
                "This is a gentler form of breathing support"
            ]
        )
    ]
}

struct SupportResource: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    let icon: String
    let color: Color
    let contactInfo: String
    
    static let allResources = [
        SupportResource(
            title: "NICU Dad Support Group",
            description: "Weekly support group specifically for NICU dads. Share experiences, get advice, and connect with other fathers going through similar journeys.",
            category: "Support Group",
            icon: "person.2.fill",
            color: .blue,
            contactInfo: "Meets every Tuesday 7:00 PM\nHospital Conference Room B\nContact: John Smith (555) 123-4567"
        ),
        SupportResource(
            title: "Mental Health Counselor",
            description: "Professional counseling services available for NICU parents. Individual and family sessions to help process emotions and develop coping strategies.",
            category: "Mental Health",
            icon: "brain.head.profile",
            color: .green,
            contactInfo: "Dr. Sarah Johnson\n(555) 987-6543\nAvailable 24/7 for emergencies"
        ),
        SupportResource(
            title: "Financial Assistance",
            description: "Resources and programs to help with medical bills, transportation, and other expenses related to your baby's NICU stay.",
            category: "Financial",
            icon: "dollarsign.circle.fill",
            color: .orange,
            contactInfo: "Social Work Department\n(555) 456-7890\nRoom 201, 2nd Floor"
        ),
        SupportResource(
            title: "Parent Education Classes",
            description: "Classes on infant care, CPR, feeding techniques, and what to expect when your baby comes home.",
            category: "Education",
            icon: "book.fill",
            color: .purple,
            contactInfo: "Every Saturday 10:00 AM\nEducation Center\nRegister at front desk"
        )
    ]
}

struct CommunityGroup: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let type: String
    let icon: String
    let color: Color
    let meetingInfo: String
    
    static let allGroups = [
        CommunityGroup(
            name: "NICU Dads United",
            description: "Online community of NICU dads sharing experiences, advice, and support. Active 24/7 with members from around the world.",
            type: "Online Community",
            icon: "globe",
            color: .blue,
            meetingInfo: "Facebook Group: NICU Dads United\nDiscord Server: Available 24/7\nWebsite: nicudadsunited.com"
        ),
        CommunityGroup(
            name: "Preemie Parents Network",
            description: "Local support network for parents of premature babies. Regular meetups, resource sharing, and long-term support.",
            type: "Local Support",
            icon: "location.fill",
            color: .green,
            meetingInfo: "Monthly meetups at Community Center\nFirst Saturday of each month 2:00 PM\nContact: preemieparents@email.com"
        ),
        CommunityGroup(
            name: "Dad's Coffee Club",
            description: "Informal coffee meetups for NICU dads. Casual conversations, shared experiences, and mutual support over coffee.",
            type: "Social",
            icon: "cup.and.saucer.fill",
            color: .brown,
            meetingInfo: "Every Thursday 8:00 AM\nHospital Cafeteria\nNo registration required"
        )
    ]
}

// MARK: - Daily Questions View
struct DailyQuestionsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedCategory = QuestionCategory.general
    
    enum QuestionCategory: String, CaseIterable {
        case general = "General"
        case medical = "Medical"
        case feeding = "Feeding"
        case development = "Development"
        case discharge = "Discharge"
        
        var icon: String {
            switch self {
            case .general: return "questionmark.circle.fill"
            case .medical: return "stethoscope"
            case .feeding: return "drop.fill"
            case .development: return "chart.line.uptrend.xyaxis"
            case .discharge: return "house.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .general: return .blue
            case .medical: return .red
            case .feeding: return .orange
            case .development: return .green
            case .discharge: return .purple
            }
        }
    }
    
    var filteredQuestions: [DailyQuestion] {
        DailyQuestion.allQuestions.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(QuestionCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            HStack(spacing: 8) {
                                Image(systemName: category.icon)
                                    .font(.caption)
                                
                                Text(category.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(selectedCategory == category ? .white : category.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategory == category ? category.color : category.color.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(category.color, lineWidth: selectedCategory == category ? 0 : 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            // Questions List
            ForEach(filteredQuestions) { question in
                QuestionCard(question: question, color: selectedCategory.color)
            }
        }
    }
}

// MARK: - Question Card
struct QuestionCard: View {
    let question: DailyQuestion
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.question)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .multilineTextAlignment(.leading)
                        
                        if !isExpanded {
                            Text(question.context)
                                .font(.body)
                                .themedText(style: .secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(color)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why ask this:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                        
                        Text(question.context)
                            .font(.body)
                            .themedText(style: .secondary)
                            .lineSpacing(4)
                    }
                    
                    if !question.followUpQuestions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Follow-up questions:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            ForEach(question.followUpQuestions, id: \.self) { followUp in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(color)
                                    Text(followUp)
                                        .font(.body)
                                        .themedText(style: .secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .themedCard()
    }
}

// MARK: - Bonding Activities View
struct BondingActivitiesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedCategory = ActivityCategory.touch
    
    enum ActivityCategory: String, CaseIterable {
        case touch = "Touch"
        case voice = "Voice"
        case presence = "Presence"
        case memory = "Memory"
        case future = "Future"
        
        var icon: String {
            switch self {
            case .touch: return "hand.point.up.left.fill"
            case .voice: return "waveform.path.ecg"
            case .presence: return "person.fill"
            case .memory: return "camera.fill"
            case .future: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .touch: return .pink
            case .voice: return .blue
            case .presence: return .green
            case .memory: return .purple
            case .future: return .orange
            }
        }
    }
    
    var filteredActivities: [BondingActivity] {
        BondingActivity.allActivities.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ActivityCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            HStack(spacing: 8) {
                                Image(systemName: category.icon)
                                    .font(.caption)
                                
                                Text(category.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(selectedCategory == category ? .white : category.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategory == category ? category.color : category.color.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(category.color, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            // Activities List
            ForEach(filteredActivities) { activity in
                BondingActivityCard(activity: activity, color: selectedCategory.color)
            }
        }
    }
}

// MARK: - Bonding Activity Card
struct BondingActivityCard: View {
    let activity: BondingActivity
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                            .multilineTextAlignment(.leading)
                        
                        if !isExpanded {
                            Text(activity.shortDescription)
                                .font(.body)
                                .themedText(style: .secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(color)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to do it:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .themedText(style: .primary)
                        
                        Text(activity.description)
                            .font(.body)
                            .themedText(style: .secondary)
                            .lineSpacing(4)
                    }
                    
                    if !activity.benefits.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Benefits:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .themedText(style: .primary)
                            
                            ForEach(activity.benefits, id: \.self) { benefit in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(color)
                                    Text(benefit)
                                        .font(.body)
                                        .themedText(style: .secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .themedCard()
    }
}

// MARK: - Data Models for Questions and Activities
struct DailyQuestion: Identifiable {
    let id = UUID()
    let question: String
    let context: String
    let category: DailyQuestionsView.QuestionCategory
    let followUpQuestions: [String]
    
    static let allQuestions = [
        // General Questions
        DailyQuestion(
            question: "How is my baby doing today overall?",
            context: "This gives you a general overview of your baby's progress and helps you understand the big picture of their NICU journey.",
            category: .general,
            followUpQuestions: [
                "What improvements have you noticed?",
                "Are there any concerns I should know about?",
                "How does this compare to yesterday?"
            ]
        ),
        DailyQuestion(
            question: "What can I do to help my baby today?",
            context: "This empowers you to be an active participant in your baby's care and shows the medical team that you want to be involved.",
            category: .general,
            followUpQuestions: [
                "Is there a good time for skin-to-skin?",
                "Can I help with feeding or changing?",
                "What should I watch for today?"
            ]
        ),
        
        // Medical Questions
        DailyQuestion(
            question: "What medications is my baby receiving and why?",
            context: "Understanding medications helps you feel more informed and less anxious about what's happening to your baby.",
            category: .medical,
            followUpQuestions: [
                "Are there any side effects I should watch for?",
                "How long will they need this medication?",
                "Can I be present when it's given?"
            ]
        ),
        DailyQuestion(
            question: "What do the monitor numbers mean?",
            context: "Understanding the monitors helps reduce anxiety about all the beeping and numbers you see around your baby.",
            category: .medical,
            followUpQuestions: [
                "What numbers are normal for my baby's age?",
                "When should I be concerned about the alarms?",
                "Can you show me how to read the display?"
            ]
        ),
        
        // Feeding Questions
        DailyQuestion(
            question: "How is my baby's feeding progressing?",
            context: "Feeding is a major milestone in NICU development and understanding progress helps you feel more confident about your baby's growth.",
            category: .feeding,
            followUpQuestions: [
                "When might they be ready for bottle feeding?",
                "How much are they taking?",
                "What signs should I look for?"
            ]
        ),
        DailyQuestion(
            question: "Can I provide breast milk and how?",
            context: "Many dads want to support their partner's breastfeeding journey and understand how they can help with milk provision.",
            category: .feeding,
            followUpQuestions: [
                "How should the milk be stored?",
                "When is the best time to bring it?",
                "How much does my baby need?"
            ]
        ),
        
        // Development Questions
        DailyQuestion(
            question: "What developmental milestones is my baby reaching?",
            context: "Understanding developmental progress helps you celebrate small victories and feel more connected to your baby's growth.",
            category: .development,
            followUpQuestions: [
                "What should I expect next?",
                "How can I support their development?",
                "Are there any concerns about delays?"
            ]
        ),
        DailyQuestion(
            question: "How is my baby's weight gain?",
            context: "Weight gain is a key indicator of your baby's health and growth, and understanding it helps you track progress.",
            category: .development,
            followUpQuestions: [
                "Is this normal for their age?",
                "What factors affect weight gain?",
                "When might they reach their target weight?"
            ]
        ),
        
        // Discharge Questions
        DailyQuestion(
            question: "What needs to happen before my baby can go home?",
            context: "Understanding discharge criteria helps you prepare for the transition home and gives you goals to work toward.",
            category: .discharge,
            followUpQuestions: [
                "What skills does my baby need to master?",
                "What equipment will we need at home?",
                "How can I prepare for their homecoming?"
            ]
        ),
        DailyQuestion(
            question: "What should I know about caring for my baby at home?",
            context: "Preparing for home care helps reduce anxiety about the transition and ensures you feel confident in your abilities.",
            category: .discharge,
            followUpQuestions: [
                "What special care will they need?",
                "Who can I call if I have questions?",
                "What follow-up appointments are needed?"
            ]
        )
    ]
}

struct BondingActivity: Identifiable {
    let id = UUID()
    let title: String
    let shortDescription: String
    let description: String
    let category: BondingActivitiesView.ActivityCategory
    let benefits: [String]
    
    static let allActivities = [
        // Touch Activities
        BondingActivity(
            title: "Gentle Hand Holding",
            shortDescription: "Hold your baby's tiny hand through the incubator opening",
            description: "Gently place your finger in your baby's palm and let them grasp it. Even if they're very small, they can feel your touch and warmth. Talk softly while you do this.",
            category: .touch,
            benefits: [
                "Helps with neurological development",
                "Provides comfort and security",
                "Strengthens the parent-baby bond",
                "Can help regulate your baby's heart rate"
            ]
        ),
        BondingActivity(
            title: "Skin-to-Skin (Kangaroo Care)",
            shortDescription: "Hold your baby against your bare chest when medically appropriate",
            description: "When your baby is stable enough, you can hold them against your bare chest. This provides warmth, comfort, and helps with bonding. The medical team will let you know when it's safe to do this.",
            category: .touch,
            benefits: [
                "Regulates baby's temperature and heart rate",
                "Promotes weight gain and development",
                "Reduces stress for both parent and baby",
                "Helps with breastfeeding success"
            ]
        ),
        
        // Voice Activities
        BondingActivity(
            title: "Reading Aloud",
            shortDescription: "Read books, stories, or even your thoughts to your baby",
            description: "Read children's books, tell stories, or simply talk about your day. Your baby can hear your voice and it helps them get used to your sound patterns and rhythm.",
            category: .voice,
            benefits: [
                "Develops language recognition",
                "Provides comfort and familiarity",
                "Helps with future language development",
                "Creates positive associations with your voice"
            ]
        ),
        BondingActivity(
            title: "Singing Lullabies",
            shortDescription: "Sing gentle songs to your baby",
            description: "Sing lullabies, nursery rhymes, or even your favorite songs. The rhythm and melody can be very soothing for your baby, even if you don't consider yourself a good singer.",
            category: .voice,
            benefits: [
                "Provides auditory stimulation",
                "Creates calming, rhythmic sounds",
                "Helps with emotional regulation",
                "Builds positive memories"
            ]
        ),
        
        // Presence Activities
        BondingActivity(
            title: "Quiet Presence",
            shortDescription: "Simply be present with your baby, even if you can't touch them",
            description: "Sometimes just being there is enough. Sit quietly by your baby's incubator, watch them, and let them know you're there. Your presence alone can be very comforting.",
            category: .presence,
            benefits: [
                "Provides emotional security",
                "Shows your baby they're not alone",
                "Helps you feel connected even when you can't touch",
                "Reduces your own anxiety"
            ]
        ),
        BondingActivity(
            title: "Bedside Vigil",
            shortDescription: "Spend time at your baby's bedside during medical procedures",
            description: "When possible, be present during routine procedures like weight checks or temperature taking. Your presence can help comfort your baby and shows the medical team your involvement.",
            category: .presence,
            benefits: [
                "Provides comfort during procedures",
                "Shows medical team your involvement",
                "Helps you understand what's happening",
                "Builds confidence in your parenting role"
            ]
        ),
        
        // Memory Activities
        BondingActivity(
            title: "Photo Documentation",
            shortDescription: "Take photos and videos to document your baby's journey",
            description: "With permission, take photos and videos of your baby's progress. This helps you see how much they're growing and changing, and creates precious memories for the future.",
            category: .memory,
            benefits: [
                "Documents your baby's growth and progress",
                "Creates lasting memories",
                "Helps you see positive changes over time",
                "Provides comfort when you're not at the hospital"
            ]
        ),
        BondingActivity(
            title: "Journaling Together",
            shortDescription: "Write letters or journal entries to your baby",
            description: "Write letters to your baby about your hopes, dreams, and daily experiences. You can read these aloud to them or save them for when they're older.",
            category: .memory,
            benefits: [
                "Creates a written record of your journey",
                "Helps process emotions and thoughts",
                "Provides something to share with your baby later",
                "Offers a creative outlet for your feelings"
            ]
        ),
        
        // Future Activities
        BondingActivity(
            title: "Dream Planning",
            shortDescription: "Talk about future plans and dreams for your baby",
            description: "Share your hopes and dreams for your baby's future. Talk about what you'll do together when they come home, places you'll visit, and experiences you'll share.",
            category: .future,
            benefits: [
                "Provides hope and positive focus",
                "Helps you visualize a positive future",
                "Creates excitement about bringing baby home",
                "Strengthens your emotional connection"
            ]
        ),
        BondingActivity(
            title: "Home Preparation",
            shortDescription: "Involve your baby in preparing for their homecoming",
            description: "Talk to your baby about their nursery, the things you're preparing for them, and what life will be like at home. This helps you feel more prepared and connected.",
            category: .future,
            benefits: [
                "Helps you prepare for the transition home",
                "Creates excitement about the future",
                "Makes your baby feel included in family planning",
                "Reduces anxiety about bringing baby home"
            ]
        )
    ]
}

#Preview {
    NICUSupportView()
        .environmentObject(ThemeManager.shared)
}