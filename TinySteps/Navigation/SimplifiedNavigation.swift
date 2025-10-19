//
//  SimplifiedNavigation.swift
//  TinySteps
//
//  Created by inkfusionlabs on 21/09/2025.
//

import SwiftUI

// MARK: - Navigation Manager
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var currentTab: Tab = .home
    @Published var navigationPath = NavigationPath()
    @Published var isPresentingSheet = false
    @Published var isPresentingFullScreen = false
    @Published var isPresentingAlert = false
    @Published var alertMessage = ""
    
    private init() {}
    
    // MARK: - Tab Navigation
    func selectTab(_ tab: Tab) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTab = tab
        }
    }
    
    // MARK: - Sheet Presentation
    func presentSheet() {
        isPresentingSheet = true
    }
    
    func dismissSheet() {
        isPresentingSheet = false
    }
    
    // MARK: - Full Screen Presentation
    func presentFullScreen() {
        isPresentingFullScreen = true
    }
    
    func dismissFullScreen() {
        isPresentingFullScreen = false
    }
    
    // MARK: - Alert Presentation
    func showAlert(_ message: String) {
        alertMessage = message
        isPresentingAlert = true
    }
    
    func dismissAlert() {
        isPresentingAlert = false
        alertMessage = ""
    }
    
    // MARK: - Navigation Path
    func navigateTo(_ destination: NavigationDestination) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}

// MARK: - Tab Enum
enum Tab: String, CaseIterable {
    case home = "house"
    case settings = "gear"
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .settings:
            return "Settings"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .home:
            return "Home tab"
        case .settings:
            return "Settings tab"
        }
    }
}

// MARK: - Navigation Destination
enum NavigationDestination: Hashable {
    case babyForm
    case editBaby(Baby)
    case emergencyContacts
    case dataBackup
    case dataRestore
    case about
    case help
    case privacy
    case terms
    
    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.babyForm, .babyForm), (.emergencyContacts, .emergencyContacts), (.dataBackup, .dataBackup), 
             (.dataRestore, .dataRestore), (.about, .about), (.help, .help), (.privacy, .privacy), (.terms, .terms):
            return true
        case (.editBaby(let lhsBaby), .editBaby(let rhsBaby)):
            return lhsBaby.id == rhsBaby.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .babyForm, .emergencyContacts, .dataBackup, .dataRestore, .about, .help, .privacy, .terms:
            hasher.combine(String(describing: self))
        case .editBaby(let baby):
            hasher.combine("editBaby")
            hasher.combine(baby.id)
        }
    }
}

// MARK: - Simplified Tab View
struct SimplifiedTabView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        TabView(selection: $navigationManager.currentTab) {
            HomeView()
                .tabItem {
                    Image(systemName: Tab.home.rawValue)
                    Text(Tab.home.title)
                }
                .tag(Tab.home)
                .accessibilityLabel(Tab.home.accessibilityLabel)
            
            
            SettingsView()
                .tabItem {
                    Image(systemName: Tab.settings.rawValue)
                    Text(Tab.settings.title)
                }
                .tag(Tab.settings)
                .accessibilityLabel(Tab.settings.accessibilityLabel)
        }
        .accentColor(DesignSystem.Colors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Navigation Coordinator
struct NavigationCoordinator: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @EnvironmentObject var dataManager: BabyDataManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            SimplifiedTabView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    destinationView(for: destination)
                }
        }
        .sheet(isPresented: $navigationManager.isPresentingSheet) {
            sheetContent
        }
        .fullScreenCover(isPresented: $navigationManager.isPresentingFullScreen) {
            fullScreenContent
        }
        .alert("Alert", isPresented: $navigationManager.isPresentingAlert) {
            Button("OK") {
                navigationManager.dismissAlert()
            }
        } message: {
            Text(navigationManager.alertMessage)
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .babyForm:
            BabyFormView()
        case .editBaby(let baby):
            BabyFormView(babyToEdit: baby)
        case .emergencyContacts:
            EmergencyContactsView()
        case .dataBackup:
            DataBackupView()
        case .dataRestore:
            DataRestoreView()
        case .about:
            Text("About TinySteps")
        case .help:
            HelpView()
        case .privacy:
            Text("Privacy Policy")
        case .terms:
            TermsOfServiceView()
        }
    }
    
    @ViewBuilder
    private var sheetContent: some View {
        // This would be populated based on what sheet needs to be presented
        EmptyView()
    }
    
    @ViewBuilder
    private var fullScreenContent: some View {
        // This would be populated based on what full screen content needs to be presented
        EmptyView()
    }
}

// MARK: - Navigation Helper Views
struct NavigationButton<Destination: View>: View {
    let destination: Destination
    let title: String
    let icon: String?
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case small
    }
    
    init(
        destination: Destination,
        title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary
    ) {
        self.destination = destination
        self.title = title
        self.icon = icon
        self.style = style
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
            }
            
            Text(title)
                .font(buttonFont)
                .fontWeight(.medium)
        }
        .foregroundColor(buttonForegroundColor)
        .frame(maxWidth: .infinity)
        .padding(.vertical, buttonVerticalPadding)
        .padding(.horizontal, buttonHorizontalPadding)
        .background(buttonBackgroundColor)
        .cornerRadius(buttonCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .stroke(buttonBorderColor, lineWidth: buttonBorderWidth)
        )
    }
    
    private var buttonFont: Font {
        switch style {
        case .primary, .secondary, .outline:
            return DesignSystem.Typography.button
        case .small:
            return DesignSystem.Typography.smallButton
        }
    }
    
    private var buttonForegroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary, .outline, .small:
            return DesignSystem.Colors.primary
        }
    }
    
    private var buttonBackgroundColor: Color {
        switch style {
        case .primary:
            return DesignSystem.Colors.primary
        case .secondary:
            return DesignSystem.Colors.primaryLight
        case .outline, .small:
            return Color.clear
        }
    }
    
    private var buttonBorderColor: Color {
        switch style {
        case .primary, .secondary:
            return Color.clear
        case .outline, .small:
            return DesignSystem.Colors.primary
        }
    }
    
    private var buttonBorderWidth: CGFloat {
        switch style {
        case .primary, .secondary:
            return 0
        case .outline, .small:
            return 1
        }
    }
    
    private var buttonCornerRadius: CGFloat {
        switch style {
        case .primary, .secondary, .outline:
            return DesignSystem.CornerRadius.button
        case .small:
            return DesignSystem.CornerRadius.sm
        }
    }
    
    private var buttonVerticalPadding: CGFloat {
        switch style {
        case .primary, .secondary, .outline:
            return DesignSystem.Spacing.md
        case .small:
            return DesignSystem.Spacing.sm
        }
    }
    
    private var buttonHorizontalPadding: CGFloat {
        switch style {
        case .primary, .secondary, .outline:
            return DesignSystem.Spacing.lg
        case .small:
            return DesignSystem.Spacing.md
        }
    }
}

// MARK: - Navigation Extensions
extension View {
    func navigationButton<Destination: View>(
        destination: Destination,
        title: String,
        icon: String? = nil,
        style: NavigationButton<Destination>.ButtonStyle = .primary
    ) -> some View {
        NavigationButton(
            destination: destination,
            title: title,
            icon: icon,
            style: style
        )
    }
}

// MARK: - Placeholder Views (to be implemented)
// MilestonesView moved to MilestonesView.swift

struct DataBackupView: View {
    var body: some View {
        Text("Data Backup View")
            .navigationTitle("Backup Data")
    }
}

struct HelpView: View {
    var body: some View {
        Text("Help View")
            .navigationTitle("Help")
    }
}

// PrivacyPolicyView moved to SettingsView.swift

struct TermsOfServiceView: View {
    var body: some View {
        Text("Terms of Service View")
            .navigationTitle("Terms of Service")
    }
}
