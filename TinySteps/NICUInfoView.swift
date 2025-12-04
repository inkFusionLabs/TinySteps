//
//  NICUInfoView.swift
//  TinySteps
//
//  Created by inkFusionLabs on 08/07/2025.
//

import SwiftUI
import UIKit

struct NICUInfoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var performanceManager = DevicePerformanceManager.shared
    @State private var selectedCategory = NICUCategory.breathing
    @State private var searchText = ""
    @State private var debouncedSearchText = ""
    @State private var searchTask: DispatchWorkItem?
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum NICUCategory: String, CaseIterable {
        case breathing = "Breathing"
        case feeding = "Feeding"
        case monitoring = "Monitoring"
        case procedures = "Procedures"
        case general = "General"
        case support = "Support"
        
        var icon: String {
            switch self {
            case .breathing: return "lungs.fill"
            case .feeding: return "drop.fill"
            case .monitoring: return "heart.fill"
            case .procedures: return "cross.fill"
            case .general: return "info.circle.fill"
            case .support: return "heart.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .breathing: return .blue
            case .feeding: return .orange
            case .monitoring: return .red
            case .procedures: return .purple
            case .general: return .gray
            case .support: return .green
            }
        }
    }
    
    var filteredTerms: [NICUTerm] {
        let terms = NICUTerm.allTerms(for: selectedCategory)
        if debouncedSearchText.isEmpty {
            return terms
        } else {
            return terms.filter { term in
                term.term.localizedCaseInsensitiveContains(debouncedSearchText) ||
                term.definition.localizedCaseInsensitiveContains(debouncedSearchText)
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
                            Text("NICU Glossary")
                                .font(isIPad ? .largeTitle : .title2)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Medical terms explained for dads")
                                .font(isIPad ? .headline : .subheadline)
                                .themedText(style: .secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, isIPad ? 28 : 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search terms...", text: $searchText)
                            .font(isIPad ? .headline : .body)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onChange(of: searchText) { _, newValue in
                                // Debounce search input
                                searchTask?.cancel()
                                let task = DispatchWorkItem {
                                    debouncedSearchText = newValue
                                }
                                searchTask = task
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
                            }
                    }
                    .padding(isIPad ? 18 : 14)
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
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(NICUCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                // Prevent rapid category switching
                                guard selectedCategory != category else { return }
                                // Immediate state change, animation follows
                                selectedCategory = category
                                searchText = ""
                                debouncedSearchText = ""
                                // Smooth animation after state change - optimized for device
                                withAnimation(performanceManager.optimizedAnimation(duration: 0.15)) {
                                    // Animation handled by state change
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, isIPad ? 20 : 16)
                
                // Terms List
                ScrollView {
                    LazyVStack(spacing: isIPad ? 16 : 12) {
                        ForEach(filteredTerms, id: \.term) { term in
                            NICUTermCard(term: term, color: selectedCategory.color)
                                .performanceOptimized()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, isIPad ? 120 : 100) // Space for tab bar
                }
                .onDisappear {
                    // Clean up search task when view disappears
                    searchTask?.cancel()
                }
            }
        }
        .errorHandling()
}

// MARK: - Category Button
struct CategoryButton: View {
    let category: NICUInfoView.NICUCategory
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: {
            // Immediate action execution
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(isIPad ? .subheadline : .caption)
                
                Text(category.rawValue)
                    .font(isIPad ? .headline : .subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, isIPad ? 20 : 16)
            .padding(.vertical, isIPad ? 10 : 8)
            .frame(minHeight: isIPad ? 48 : 44)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                    .fill(isSelected ? color : color.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 24 : 20)
                    .stroke(color, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(Text("Category: \(category.rawValue)"))
    }
}

// MARK: - NICU Term Card
struct NICUTermCard: View, Equatable {
    let term: NICUTerm
    let color: Color
    @StateObject private var performanceManager = DevicePerformanceManager.shared
    @State private var isExpanded = false
    @State private var isPressed = false
    
    static func == (lhs: NICUTermCard, rhs: NICUTermCard) -> Bool {
        lhs.term.term == rhs.term.term
    }
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                // Immediate haptic feedback
                HapticFeedback.light()
                // Execute action immediately
                isExpanded.toggle()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(isIPad ? .title3 : .headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        if !isExpanded {
                            Text(term.shortDefinition)
                                .font(isIPad ? .body : .subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(isIPad ? .subheadline : .caption)
                        .foregroundColor(color)
                }
                .padding(isIPad ? 18 : 14)
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .opacity(isPressed ? 0.9 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            withAnimation(performanceManager.optimizedAnimation(duration: 0.1)) {
                                isPressed = true
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation(performanceManager.optimizedAnimation(duration: 0.1)) {
                            isPressed = false
                        }
                    }
            )
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(isIPad ? .headline : .subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(term.definition)
                            .font(isIPad ? .body : .body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(4)
                    }
                    
                    if !term.dadTip.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dad Tip")
                                .font(isIPad ? .headline : .subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(color)
                            
                            Text(term.dadTip)
                                .font(isIPad ? .body : .body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .padding(isIPad ? 16 : 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.2))
                        )
                    }
                }
                .padding(.horizontal, isIPad ? 18 : 14)
                .padding(.bottom, isIPad ? 16 : 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
}

// MARK: - NICU Term Model
struct NICUTerm {
    let term: String
    let shortDefinition: String
    let definition: String
    let dadTip: String
    let category: NICUInfoView.NICUCategory
    
    static func allTerms(for category: NICUInfoView.NICUCategory) -> [NICUTerm] {
        switch category {
        case .breathing:
            return [
                NICUTerm(
                    term: "CPAP",
                    shortDefinition: "Continuous Positive Airway Pressure",
                    definition: "A breathing support that delivers air pressure through a mask or nasal prongs to help keep your baby's airways open. It's like a gentle breeze that helps your baby breathe easier.",
                    dadTip: "You might hear beeping - this is normal! The machine is just making sure your baby is getting the right amount of air pressure.",
                    category: .breathing
                ),
                NICUTerm(
                    term: "Ventilator",
                    shortDefinition: "A machine that breathes for your baby",
                    definition: "A machine that takes over your baby's breathing completely. It's connected to a tube in your baby's windpipe and delivers oxygen and air pressure to help your baby's lungs work.",
                    dadTip: "This might look scary, but it's actually helping your baby rest and grow stronger. The medical team is constantly monitoring to make sure everything is working perfectly.",
                    category: .breathing
                ),
                NICUTerm(
                    term: "Oxygen Saturation",
                    shortDefinition: "How much oxygen is in your baby's blood",
                    definition: "A measurement that shows how well your baby's body is getting oxygen. It's measured with a small sensor on your baby's hand or foot and shows as a percentage.",
                    dadTip: "Normal is usually 95-100%. If it's lower, don't panic - the medical team will adjust the breathing support to help your baby get more oxygen.",
                    category: .breathing
                ),
                NICUTerm(
                    term: "Apnea",
                    shortDefinition: "When your baby stops breathing briefly",
                    definition: "A pause in breathing that lasts longer than 20 seconds. This is common in premature babies because their breathing control isn't fully developed yet.",
                    dadTip: "The monitors will alert the nurses if this happens. They'll gently stimulate your baby to start breathing again - it's usually just a matter of reminding them to breathe.",
                    category: .breathing
                )
            ]
        case .feeding:
            return [
                NICUTerm(
                    term: "NG Tube",
                    shortDefinition: "Nasogastric tube - feeding tube through the nose",
                    definition: "A thin, flexible tube that goes through your baby's nose down to their stomach. It's used to deliver milk and medications when your baby isn't ready to feed by mouth yet.",
                    dadTip: "This might look uncomfortable, but babies usually don't mind it. It's actually helping your baby get the nutrition they need to grow strong.",
                    category: .feeding
                ),
                NICUTerm(
                    term: "Gavage Feeding",
                    shortDefinition: "Feeding through a tube",
                    definition: "When milk is given through the NG tube instead of by bottle or breast. This is done when your baby isn't strong enough to suck and swallow safely yet.",
                    dadTip: "This is temporary! As your baby gets stronger, they'll gradually learn to feed by mouth. Every small step forward is progress.",
                    category: .feeding
                ),
                NICUTerm(
                    term: "NPO",
                    shortDefinition: "Nothing by mouth",
                    definition: "A medical order that means your baby can't have anything to eat or drink by mouth. This is usually temporary and used when there are concerns about feeding safety.",
                    dadTip: "This can be frustrating, but it's for your baby's safety. The medical team will let you know when it's safe to start feeding again.",
                    category: .feeding
                )
            ]
        case .monitoring:
            return [
                NICUTerm(
                    term: "Heart Rate",
                    shortDefinition: "How fast your baby's heart is beating",
                    definition: "The number of times your baby's heart beats per minute. Normal for babies is usually between 120-160 beats per minute.",
                    dadTip: "The monitors will beep if the heart rate goes too high or too low. This is normal - the medical team is always watching and will respond quickly if needed.",
                    category: .monitoring
                ),
                NICUTerm(
                    term: "Blood Pressure",
                    shortDefinition: "The force of blood against artery walls",
                    definition: "A measurement of how hard your baby's heart is working to pump blood through their body. It's measured with a small cuff around your baby's arm or leg.",
                    dadTip: "Don't worry if the numbers seem different from adult blood pressure - babies have much lower numbers, and that's completely normal.",
                    category: .monitoring
                ),
                NICUTerm(
                    term: "Temperature",
                    shortDefinition: "Your baby's body temperature",
                    definition: "A measurement of how warm your baby's body is. Normal temperature for babies is around 36.5-37.5°C (97.7-99.5°F).",
                    dadTip: "Premature babies have trouble regulating their temperature, so they're kept in warm incubators. This helps them save energy for growing instead of staying warm.",
                    category: .monitoring
                )
            ]
        case .procedures:
            return [
                NICUTerm(
                    term: "IV",
                    shortDefinition: "Intravenous - needle in a vein",
                    definition: "A small needle or tube placed in your baby's vein to give fluids, medications, or nutrition directly into the bloodstream.",
                    dadTip: "The medical team is very skilled at placing these. Your baby might cry briefly, but they usually settle down quickly once it's in place.",
                    category: .procedures
                ),
                NICUTerm(
                    term: "Heel Stick",
                    shortDefinition: "Blood test from the heel",
                    definition: "A small prick on your baby's heel to get a few drops of blood for testing. This is done regularly to check blood sugar, oxygen levels, and other important values.",
                    dadTip: "This might make your baby cry, but it's over quickly. You can comfort them by talking softly or gently holding their hand.",
                    category: .procedures
                ),
                NICUTerm(
                    term: "X-ray",
                    shortDefinition: "Picture of the inside of your baby's body",
                    definition: "A special photograph that shows the inside of your baby's body, especially the lungs and heart. It helps the medical team see how your baby is doing.",
                    dadTip: "The radiation from one X-ray is very small and safe for your baby. The medical team only does these when necessary to help your baby.",
                    category: .procedures
                )
            ]
        case .general:
            return [
                NICUTerm(
                    term: "NICU",
                    shortDefinition: "Neonatal Intensive Care Unit",
                    definition: "A special hospital unit designed specifically for newborn babies who need extra medical care. It has specialized equipment and staff trained to care for the tiniest patients.",
                    dadTip: "The NICU can feel overwhelming at first, but remember - this is the best place for your baby right now. The staff are experts at caring for babies just like yours.",
                    category: .general
                ),
                NICUTerm(
                    term: "Premature",
                    shortDefinition: "Born before 37 weeks of pregnancy",
                    definition: "A baby born before 37 weeks of pregnancy. Premature babies often need extra help with breathing, feeding, and staying warm because they haven't had enough time to fully develop.",
                    dadTip: "Every day your baby spends in the NICU is like getting extra time to grow and develop. They're working hard to catch up!",
                    category: .general
                ),
                NICUTerm(
                    term: "Incubator",
                    shortDefinition: "A warm, protective bed for your baby",
                    definition: "A special bed that keeps your baby warm and protected. It has clear sides so you can see your baby, and it helps maintain the perfect temperature and humidity.",
                    dadTip: "Think of it as a cozy, high-tech nest. Your baby is safe and comfortable inside, and you can still touch and talk to them through the openings.",
                    category: .general
                )
            ]
        case .support:
            return [
                NICUTerm(
                    term: "Bliss Charity",
                    shortDefinition: "UK's leading premature baby charity",
                    definition: "Bliss is the UK's leading charity for babies born premature or sick. They provide emotional support, information, and advocacy for families throughout the NICU journey.",
                    dadTip: "Call their free helpline at 0808 801 0322 anytime. They understand what you're going through and can connect you with other NICU dads.",
                    category: .support
                ),
                NICUTerm(
                    term: "NHS 111",
                    shortDefinition: "Non-emergency health advice",
                    definition: "NHS 111 is a free service that provides health advice and information 24/7. Call 111 for non-emergency medical concerns about your baby or yourself.",
                    dadTip: "Don't hesitate to call if you're worried about your baby or your own mental health. It's better to ask than to worry alone.",
                    category: .support
                ),
                NICUTerm(
                    term: "Samaritans",
                    shortDefinition: "24/7 emotional support",
                    definition: "Samaritans provides free, confidential emotional support 24/7 for anyone in distress. They're there to listen without judgment.",
                    dadTip: "Call 116 123 anytime you need to talk. Being a NICU dad is emotionally challenging - it's okay to need support.",
                    category: .support
                ),
                NICUTerm(
                    term: "DadPad",
                    shortDefinition: "Father-focused support resources",
                    definition: "DadPad provides specialized resources and support specifically designed for new fathers, including NICU dads. They understand the unique challenges dads face.",
                    dadTip: "Visit dadpad.co.uk for dad-specific resources and connect with other fathers who understand your journey.",
                    category: .support
                ),
                NICUTerm(
                    term: "Mind",
                    shortDefinition: "Mental health charity",
                    definition: "Mind is a mental health charity providing information, advice, and support for anyone experiencing mental health problems, including NICU parents.",
                    dadTip: "Call 0300 123 3393 for mental health support. NICU dads often experience anxiety and depression - you're not alone.",
                    category: .support
                )
            ]
        }
    }
}