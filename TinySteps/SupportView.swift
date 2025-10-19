//
//  SupportView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
#if canImport(MapKit)
import MapKit
#endif
#if canImport(CoreLocation)
import CoreLocation
#endif

struct SupportView: View {
    @State private var selectedSection: SupportSection = .healthVisitor
    @State private var showHealthInfo = false
    @State private var showHealthVisitor = false
    @State private var showParentingTips = false
    @State private var showHospitalMap = false
    @State private var showSupportServices = false
    @EnvironmentObject var themeManager: ThemeManager
    
    enum SupportSection: String, CaseIterable {
        case healthVisitor = "Health Visitor"
        case tips = "Parenting Tips"
        case healthcareMap = "Hospital Map"
        case healthInfo = "Health Info"
        case supportServices = "Support"
        
        var icon: String {
            switch self {
            case .healthVisitor: return "cross.case.fill"
            case .tips: return "lightbulb.fill"
            case .healthcareMap: return "map.fill"
            case .healthInfo: return "heart.text.square"
            case .supportServices: return "heart.fill"
            }
        }
        
        var color: Color {
            let theme = ThemeManager.shared.currentTheme.colors
            switch self {
            case .healthVisitor: return theme.primary
            case .tips: return theme.warning
            case .healthcareMap: return theme.error
            case .healthInfo: return theme.secondary
            case .supportServices: return theme.success
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            themeManager.currentTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Support & Care")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .themedText(style: .primary)
                            
                            Text("Everything you need to support your baby's journey")
                                .font(.subheadline)
                                .themedText(style: .secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                
                // Compact Section Picker
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(SupportSection.allCases, id: \.self) { section in
                        Button(action: {
                            switch section {
                            case .healthVisitor:
                                showHealthVisitor = true
                            case .tips:
                                showParentingTips = true
                            case .healthcareMap:
                                showHospitalMap = true
                            case .healthInfo:
                                showHealthInfo = true
                            case .supportServices:
                                showSupportServices = true
                            }
                        }) {
                            VStack(spacing: 8) {
                                // Colored circular icon background
                                ZStack {
                                    Circle()
                                        .fill(section.color)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: section.icon)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Text(section.rawValue)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            // Content - Show a welcome message since all sections now open as modals
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Support & Care")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Tap any card above to access specific support services and information for your baby's journey.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 40)
                
                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $showHealthInfo) {
            NavigationView {
                CountryHealthInfoView()
            }
        }
        .sheet(isPresented: $showHealthVisitor) {
            NavigationView {
                HealthVisitorView()
            }
        }

        .sheet(isPresented: $showParentingTips) {
            NavigationView {
                ParentingTipsView()
            }
        }

        .sheet(isPresented: $showHospitalMap) {
            NavigationView {
                HealthcareMapView()
            }
        }
        .sheet(isPresented: $showSupportServices) {
            NavigationView {
                SupportServicesView()
            }
        }

    }
}

// MARK: - Helper Views

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct SupportReminderCard: View {
    let title: String
    let time: String
    let isActive: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Circle()
                .fill(isActive ? Color.orange : Color.gray)
                .frame(width: 12, height: 12)
        }
        .padding()
        
        .cornerRadius(12)
    }
}

struct SupportTipCard: View {
    let title: String
    let description: String
    let category: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(category)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        
        .cornerRadius(12)
    }
}

struct MilestoneProgressCard: View {
    let title: String
    let current: String
    let target: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.purple)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Current: \(current)")
                        .font(.subheadline)
                    Spacer()
                    Text("Target: \(target)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
            }
        }
        .padding()
        
        .cornerRadius(12)
    }
}

struct SupportServicesView: View {
    @StateObject private var countryManager = CountryHealthServicesManager()
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Support Services")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(countryManager.currentCountry)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Location Status
                        HStack(spacing: 4) {
                            Circle()
                                .fill(locationManager.locationStatus == .authorizedWhenInUse ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                            Text(locationManager.locationStatus == .authorizedWhenInUse ? "Location Active" : "Location Needed")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Emergency Number
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Emergency: \(countryManager.getEmergencyNumber())")
                            .font(.headline)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    .cornerRadius(8)
                }
                .padding()
                
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Health Services List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Available Services")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(countryManager.healthServices.count) services")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if countryManager.healthServices.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "cross.case")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("No services available")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("Enable location access to see services for your area")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(countryManager.healthServices) { service in
                                    ServiceRowCompact(service: service)
                                }
                            }
                        }
                    }
                }
                .padding()
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Support Services")
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
            }
        }
    }
}

}

struct ServiceRowCompact: View {
    let service: NeonatalService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(service.type)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Contact Button
                if !service.contact.isEmpty {
                    Button(action: {
                        if let url = URL(string: "tel:\(service.contact)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                }
            }
            
            if !service.contact.isEmpty {
                Text(service.contact)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            if !service.website.isEmpty {
                Button(action: {
                    if let url = URL(string: "https://\(service.website)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text(service.website)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
        .padding()
        .cornerRadius(8)
    }
}

#Preview {
    SupportView()
}
