import SwiftUI
#if canImport(CoreLocation)
import CoreLocation
#endif

struct CountryHealthInfoView: View {
    @StateObject private var countryManager = CountryHealthServicesManager()
    @StateObject private var healthInfoManager = CountryHealthInfoManager()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    @State private var showingCountrySelector = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Health Information")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(healthInfoManager.currentCountry)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Country Selector Button
                        Button(action: {
                            showingCountrySelector = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "globe")
                                    .font(.caption)
                                Text("Change")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Location Status
                    HStack(spacing: 4) {
                        Circle()
                            .fill(locationManager.locationStatus == .authorizedWhenInUse ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(locationManager.locationStatus == .authorizedWhenInUse ? "Location Active" : "Location Needed")
                            .font(.caption2)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Tab Selector
                HStack(spacing: 0) {
                    TabButton(title: "Vaccinations", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabButton(title: "Growth", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    TabButton(title: "Guidelines", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    TabButton(title: "Emergency", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                }
                .padding(.horizontal)
                
                // Content
                TabView(selection: $selectedTab) {
                    VaccinationScheduleView(healthInfoManager: healthInfoManager)
                        .tag(0)
                    
                    GrowthStandardsView(healthInfoManager: healthInfoManager)
                        .tag(1)
                    
                    HealthGuidelinesView(healthInfoManager: healthInfoManager)
                        .tag(2)
                    
                    EmergencyInfoView(healthInfoManager: healthInfoManager)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .navigationTitle("Health Information")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            locationManager.requestLocationPermission()
        }
        .onReceive(locationManager.$currentLocation) { location in
            if let location = location {
                countryManager.detectCountryFromLocation(location)
                // Update health info manager with the same country
                healthInfoManager.updateCountry(countryCode: countryManager.currentCountryCode)
            }
        }
        .sheet(isPresented: $showingCountrySelector) {
            CountrySelectorView(countryManager: countryManager, healthInfoManager: healthInfoManager)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.blue : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VaccinationScheduleView: View {
    @ObservedObject var healthInfoManager: CountryHealthInfoManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "syringe")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text("Vaccination Schedule")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Based on \(healthInfoManager.currentCountry) guidelines")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                
                // Vaccination Schedule
                LazyVStack(spacing: 15) {
                    ForEach(healthInfoManager.getVaccinationSchedule()) { schedule in
                        VaccinationCard(schedule: schedule)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct VaccinationCard: View {
    let schedule: VaccinationSchedule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(schedule.age)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(schedule.notes)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "syringe")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Vaccines:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                ForEach(schedule.vaccines, id: \.self) { vaccine in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text(vaccine)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct GrowthStandardsView: View {
    @ObservedObject var healthInfoManager: CountryHealthInfoManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    
                    Text("Growth Standards")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let standards = healthInfoManager.getGrowthStandards() {
                        Text("Based on \(standards.organization)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
                
                // Growth Standards Info
                if let standards = healthInfoManager.getGrowthStandards() {
                    VStack(spacing: 15) {
                        GrowthInfoCard(title: "Weight Unit", value: standards.weightUnit, icon: "scalemass")
                        GrowthInfoCard(title: "Height Unit", value: standards.heightUnit, icon: "ruler")
                        GrowthInfoCard(title: "Organization", value: standards.organization, icon: "building.2")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text(standards.notes)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                        Text("Growth standards not available")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Growth standards for this country are not yet available in the app")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
        }
    }
}

struct GrowthInfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct HealthGuidelinesView: View {
    @ObservedObject var healthInfoManager: CountryHealthInfoManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("Health Guidelines")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Based on \(healthInfoManager.currentCountry) healthcare system")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                
                // Health Guidelines
                LazyVStack(spacing: 15) {
                    ForEach(healthInfoManager.getHealthGuidelines()) { guideline in
                        GuidelineCard(guideline: guideline)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct GuidelineCard: View {
    let guideline: HealthGuideline
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(guideline.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(guideline.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "checkmark.shield")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Frequency:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(guideline.frequency)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct EmergencyInfoView: View {
    @ObservedObject var healthInfoManager: CountryHealthInfoManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    Text("Emergency Information")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Emergency services for \(healthInfoManager.currentCountry)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                
                // Emergency Information
                if let emergencyInfo = healthInfoManager.getEmergencyInfo() {
                    VStack(spacing: 15) {
                        EmergencyInfoCard(title: "Emergency Number", value: emergencyInfo.emergencyNumber, icon: "phone.fill", color: .red)
                        EmergencyInfoCard(title: "Non-Emergency", value: emergencyInfo.nonEmergencyNumber, icon: "phone", color: .blue)
                        EmergencyInfoCard(title: "Ambulance Service", value: emergencyInfo.ambulanceService, icon: "cross.case.fill", color: .red)
                        EmergencyInfoCard(title: "Hospital Finder", value: emergencyInfo.hospitalFinder, icon: "building.2.fill", color: .blue)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Important Notes:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text(emergencyInfo.notes)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                        Text("Emergency info not available")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Emergency information for this country is not yet available")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
        }
    }
}

struct EmergencyInfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}



#Preview {
    CountryHealthInfoView()
} 