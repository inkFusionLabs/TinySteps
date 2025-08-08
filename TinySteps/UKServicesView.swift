import SwiftUI
#if canImport(CoreLocation)
import CoreLocation
#endif

struct UKServicesView: View {
    @StateObject private var countryManager = CountryHealthServicesManager()
    @StateObject private var locationManager = LocationManager()
    @State private var postcode: String = ""
    @State private var services: [NeonatalService] = []
    @State private var showingCountrySelector = false
    @State private var showingLocationPermission = false
    
    var body: some View {
        ZStack {
            // Background gradient
            Color.clear
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Country Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Health Services")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(countryManager.currentCountry)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Location Status and Country Selector
                        VStack(spacing: 8) {
                            // Location Status
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(locationManager.locationStatus == .authorizedWhenInUse ? Color.green : Color.red)
                                    .frame(width: 8, height: 8)
                                Text(locationManager.locationStatus == .authorizedWhenInUse ? "Location Active" : "Location Needed")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                            
                            // Country Selector Button
                            Button(action: {
                                showingCountrySelector = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "globe")
                                        .font(.caption)
                                    Text("Change Country")
                                        .font(.caption)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Emergency Number Display
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
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding()
                
                // Location Detection Section
                if locationManager.locationStatus != .authorizedWhenInUse {
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                        
                        Text("Enable Location Access")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Allow location access to automatically detect your country and show relevant health services")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            locationManager.requestLocationPermission()
                        }) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Enable Location")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Error Message
                if let errorMessage = countryManager.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.yellow)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Loading Indicator
                if countryManager.isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                        Text("Detecting your location...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                
                // Services List
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
                    .padding(.horizontal)
                    
                    if countryManager.healthServices.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "cross.case")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("No services available for your location")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("Try enabling location access or selecting a different country")
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
                                    ServiceRow(service: service)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationTitle("Health Services")
        .onAppear {
            locationManager.requestLocationPermission()
        }
        .onReceive(locationManager.$currentLocation) { location in
            if let location = location {
                countryManager.detectCountryFromLocation(location)
            }
        }
        .sheet(isPresented: $showingCountrySelector) {
            CountrySelectorView(countryManager: countryManager, healthInfoManager: CountryHealthInfoManager())
        }
    }
}

struct CountrySelectorView: View {
    @ObservedObject var countryManager: CountryHealthServicesManager
    var healthInfoManager: CountryHealthInfoManager? // Not @ObservedObject, just a plain optional
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Your Country")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    Text("Choose your country to see relevant health services and emergency information")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(countryManager.getSupportedCountries(), id: \.self) { countryCode in
                                CountryCard(
                                    countryCode: countryCode,
                                    countryName: countryManager.getCountryName(for: countryCode),
                                    isSelected: countryCode == countryManager.currentCountryCode,
                                    action: {
                                        countryManager.updateCountryServices(countryCode: countryCode)
                                        healthInfoManager?.updateCountry(countryCode: countryCode)
                                        dismiss()
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct CountryCard: View {
    let countryCode: String
    let countryName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(countryCode)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(countryName)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ServiceRow: View {
    let service: NeonatalService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Service Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(service.type)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.3))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 8) {
                    if service.isContactAvailable {
                        if let contactURL = service.contactURL {
                            Link(destination: contactURL) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .font(.title3)
                            }
                        }
                    }
                    
                    if service.isWebsiteAvailable {
                        if let websiteURL = service.websiteURL {
                            Link(destination: websiteURL) {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            
            // Contact and Website Info
            if service.isContactAvailable || service.isWebsiteAvailable {
                VStack(alignment: .leading, spacing: 6) {
                    if service.isContactAvailable {
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text(service.contact)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    if service.isWebsiteAvailable {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text(service.website)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
}

#Preview {
    UKServicesView()
}
