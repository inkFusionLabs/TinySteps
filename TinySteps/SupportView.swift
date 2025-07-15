//
//  SupportView.swift
//  TinySteps
//
//  Created by inkLabs on 08/07/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct SupportView: View {
    @State private var selectedSection: SupportSection = .healthVisitor
    @State private var showNewReminder = false
    @State private var showNewAppointment = false
    @State private var showNewMilestone = false
    
    enum SupportSection: String, CaseIterable {
        case healthVisitor = "Health Visitor"
        case appointments = "Appointments"
        case reminders = "Reminders"
        case tips = "Parenting Tips"
        case milestones = "Milestones"
        case healthcareMap = "Hospital Map"
        
        var icon: String {
            switch self {
            case .healthVisitor: return "cross.case.fill"
            case .appointments: return "calendar"
            case .reminders: return "bell.fill"
            case .tips: return "lightbulb.fill"
            case .milestones: return "star.fill"
            case .healthcareMap: return "map.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .healthVisitor: return .blue
            case .appointments: return .green
            case .reminders: return .orange
            case .tips: return .yellow
            case .milestones: return .purple
            case .healthcareMap: return .red
            }
        }
    }
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Support & Care")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Everything you need to support your baby's journey")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Compact Section Picker
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                        ForEach(SupportSection.allCases, id: \.self) { section in
                            Button(action: {
                                selectedSection = section
                            }) {
                                VStack(spacing: 6) {
                                    Image(systemName: section.icon)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(selectedSection == section ? .white : .white.opacity(0.8))
                                    
                                    Text(section.rawValue)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(selectedSection == section ? .white : .white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(height: 70)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedSection == section ? section.color : Color.white.opacity(0.1))
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedSection {
                        case .healthVisitor:
                            HealthVisitorSection()
                        case .appointments:
                            AppointmentsSection(showNewAppointment: $showNewAppointment)
                        case .reminders:
                            RemindersSection(showNewReminder: $showNewReminder)
                        case .tips:
                            TipsSection()
                        case .milestones:
                            MilestonesSection(showNewMilestone: $showNewMilestone)
                        case .healthcareMap:
                            HealthcareMapSection()
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showNewReminder) {
            NavigationView {
                NewReminderView()
            }
        }
        .sheet(isPresented: $showNewAppointment) {
            NavigationView {
                NewAppointmentView()
            }
        }
        .sheet(isPresented: $showNewMilestone) {
            NavigationView {
                NewMilestoneView()
            }
        }
    }
}

// MARK: - Section Views

struct HealthVisitorSection: View {
    var body: some View {
        VStack(spacing: 20) {
            // Health Visitor Card
            VStack(spacing: 15) {
                ProfileInfoRow(
                    icon: "cross.case.fill",
                    title: "Health Visitor",
                    value: "0800 123 4567",
                    color: .blue
                )
                
                ProfileInfoRow(
                    icon: "envelope.fill",
                    title: "Email",
                    value: "healthvisitor@nhs.uk",
                    color: .blue
                )
                
                ProfileInfoRow(
                    icon: "clock.fill",
                    title: "Hours",
                    value: "Mon-Fri 9AM-5PM",
                    color: .blue
                )
                
                Button(action: {
                    // Call health visitor
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call Health Visitor")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Recent Notes
            VStack(alignment: .leading, spacing: 15) {
                Text("Recent Notes")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                ForEach(1...3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Visit \(index)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(index) day\(index == 1 ? "" : "s") ago")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Text("Baby is progressing well. Weight gain is on track.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct AppointmentsSection: View {
    @Binding var showNewAppointment: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Appointments")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    showNewAppointment = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            
            // Upcoming Appointments
            VStack(spacing: 15) {
                ForEach(1...3, id: \.self) { index in
                    VStack(spacing: 15) {
                        ProfileInfoRow(
                            icon: "calendar",
                            title: "Check-up \(index)",
                            value: "Dec \(index + 15), 2024",
                            color: .green
                        )
                        
                        ProfileInfoRow(
                            icon: "clock",
                            title: "Time",
                            value: "\(9 + index):00 AM",
                            color: .green
                        )
                        
                        ProfileInfoRow(
                            icon: "location",
                            title: "Location",
                            value: "Neonatal Unit",
                            color: .green
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct RemindersSection: View {
    @Binding var showNewReminder: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Reminders")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    showNewReminder = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            
            // Active Reminders
            VStack(spacing: 15) {
                ForEach(1...3, id: \.self) { index in
                    VStack(spacing: 15) {
                        ProfileInfoRow(
                            icon: "bell.fill",
                            title: "Feed Baby",
                            value: "Every \(2 + index) hours",
                            color: .orange
                        )
                        
                        ProfileInfoRow(
                            icon: "checkmark.circle.fill",
                            title: "Status",
                            value: "Active",
                            color: .green
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TipsSection: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Parenting Tips")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(spacing: 15) {
                ForEach(1...5, id: \.self) { index in
                    VStack(spacing: 15) {
                        ProfileInfoRow(
                            icon: "lightbulb.fill",
                            title: "Tip \(index)",
                            value: ["Bonding", "Care", "Support", "Health", "Wellbeing"][index % 5],
                            color: .yellow
                        )
                        
                        Text("This is a helpful parenting tip for dads with babies in neonatal care.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct MilestonesSection: View {
    @Binding var showNewMilestone: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Milestones")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    showNewMilestone = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
            }
            
            // Milestone Progress
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    ProfileInfoRow(
                        icon: "scalemass.fill",
                        title: "Weight Gain",
                        value: "2.1kg / 2.5kg",
                        color: .purple
                    )
                    
                    ProgressView(value: 0.84)
                        .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 15) {
                    ProfileInfoRow(
                        icon: "drop.fill",
                        title: "Feeding",
                        value: "45ml / 60ml",
                        color: .purple
                    )
                    
                    ProgressView(value: 0.75)
                        .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 15) {
                    ProfileInfoRow(
                        icon: "lungs.fill",
                        title: "Breathing",
                        value: "Stable / Independent",
                        color: .purple
                    )
                    
                    ProgressView(value: 0.9)
                        .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
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

struct AppointmentCard: View {
    let title: String
    let date: String
    let time: String
    let location: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.green)
                Text(time)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "location")
                    .foregroundColor(.green)
                Text(location)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
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
        .background(Color.white.opacity(0.1))
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
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.white.opacity(0.1))
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
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Placeholder Views for Sheets

struct NewReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("New Reminder")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle("New Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct NewAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("New Appointment")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle("New Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct NewMilestoneView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("New Milestone")
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle("New Milestone")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct HealthcareMapSection: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // London default
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var healthcarePlaces: [HealthcarePlace] = []
    @State private var showingLocationPermission = false
    @State private var isLoading = false
    @State private var selectedHospital: HealthcarePlace?
    @State private var showingHospitalDetail = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hospital Map")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Find nearby hospitals & medical centers")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    // Location Status Indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(locationManager.locationStatus == .authorizedWhenInUse ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(locationManager.locationStatus == .authorizedWhenInUse ? "Location Active" : "Location Needed")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Button(action: {
                        locationManager.requestLocationPermission()
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
            }
            
            // Map View
            ZStack {
                Map(position: .constant(.region(region))) {
                    ForEach(healthcarePlaces) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            Button(action: {
                                selectedHospital = place
                                showingHospitalDetail = true
                            }) {
                                VStack(spacing: 2) {
                                    Image(systemName: place.icon)
                                        .foregroundColor(.red)
                                        .background(Circle().fill(.white).frame(width: 30, height: 30))
                                        .font(.title2)
                                    Text(place.name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .cornerRadius(15)
                .frame(height: 300)
                
                // Loading indicator
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Searching for healthcare facilities...")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                }
                
                // Location permission overlay
                if locationManager.locationStatus == .denied || locationManager.locationStatus == .restricted {
                    VStack(spacing: 16) {
                        Image(systemName: "location.slash")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Location Access Required")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Please enable location access in Settings to find nearby healthcare facilities")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Open Settings") {
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsUrl)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(15)
                } else if locationManager.locationStatus == .notDetermined {
                    VStack(spacing: 16) {
                        Image(systemName: "location")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                        Text("Location Permission Needed")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Tap the location button above to enable location access")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(15)
                }
            }
            
            // Healthcare Places List
            VStack(alignment: .leading, spacing: 15) {
                Text("Nearby Hospitals")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if healthcarePlaces.isEmpty {
                    VStack {
                        Image(systemName: "building.2")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                        Text("No hospitals found nearby")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(healthcarePlaces.prefix(5), id: \.id) { place in
                        HealthcarePlaceCard(place: place)
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocationPermission()
        }
        .onReceive(locationManager.$currentLocation) { location in
            if let location = location {
                region.center = location.coordinate
                searchNearbyHealthcarePlaces(near: location.coordinate)
            }
        }
        .sheet(isPresented: $showingHospitalDetail) {
            if let hospital = selectedHospital {
                HospitalDetailView(hospital: hospital)
            }
        }
    }
    
    private func searchNearbyHealthcarePlaces(near coordinate: CLLocationCoordinate2D) {
        isLoading = true
        
        // Search specifically for hospitals
        let hospitalRequest = MKLocalSearch.Request()
        hospitalRequest.naturalLanguageQuery = "hospital"
        hospitalRequest.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        let hospitalSearch = MKLocalSearch(request: hospitalRequest)
        hospitalSearch.start { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Hospital search error: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                guard let response = response else {
                    print("No hospital search response")
                    self.isLoading = false
                    return
                }
                
                let hospitals = response.mapItems.map { item in
                    HealthcarePlace(
                        id: UUID(),
                        name: item.name ?? "Unknown Hospital",
                        address: self.formatAddress(item.placemark),
                        coordinate: item.placemark.coordinate,
                        type: .hospital,
                        distance: self.calculateDistance(from: coordinate, to: item.placemark.coordinate)
                    )
                }.sorted { $0.distance < $1.distance }
                
                // Also search for major medical centers
                let medicalRequest = MKLocalSearch.Request()
                medicalRequest.naturalLanguageQuery = "medical center"
                medicalRequest.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                )
                
                let medicalSearch = MKLocalSearch(request: medicalRequest)
                medicalSearch.start { medicalResponse, medicalError in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        var allPlaces = hospitals
                        
                        if let medicalResponse = medicalResponse {
                            let medicalCenters = medicalResponse.mapItems.map { item in
                                HealthcarePlace(
                                    id: UUID(),
                                    name: item.name ?? "Unknown Medical Center",
                                    address: self.formatAddress(item.placemark),
                                    coordinate: item.placemark.coordinate,
                                    type: .hospital,
                                    distance: self.calculateDistance(from: coordinate, to: item.placemark.coordinate)
                                )
                            }
                            
                            // Combine and remove duplicates
                            allPlaces.append(contentsOf: medicalCenters)
                            allPlaces = Array(Set(allPlaces)).sorted { $0.distance < $1.distance }
                        }
                        
                        self.healthcarePlaces = allPlaces
                        print("Found \(self.healthcarePlaces.count) hospitals and medical centers")
                    }
                }
            }
        }
    }
    
    private func formatAddress(_ placemark: MKPlacemark) -> String {
        var addressComponents: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        if let postalCode = placemark.postalCode {
            addressComponents.append(postalCode)
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    private func determineHealthcareType(from name: String) -> HealthcareType {
        let lowercased = name.lowercased()
        if lowercased.contains("hospital") {
            return .hospital
        } else if lowercased.contains("clinic") {
            return .clinic
        } else if lowercased.contains("pharmacy") {
            return .pharmacy
        } else if lowercased.contains("gp") || lowercased.contains("doctor") {
            return .gp
        } else {
            return .medical
        }
    }
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1000 // Convert to kilometers
    }
}

struct HealthcarePlace: Identifiable, Hashable {
    let id: UUID
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let type: HealthcareType
    let distance: Double
    
    var icon: String {
        switch type {
        case .hospital: return "cross.case.fill"
        case .clinic: return "building.2.fill"
        case .pharmacy: return "pills.fill"
        case .gp: return "person.fill"
        case .medical: return "cross.fill"
        }
    }
    
    // Hashable conformance for deduplication
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
    static func == (lhs: HealthcarePlace, rhs: HealthcarePlace) -> Bool {
        return lhs.name == rhs.name && 
               lhs.coordinate.latitude == rhs.coordinate.latitude && 
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

enum HealthcareType {
    case hospital, clinic, pharmacy, gp, medical
}

struct HealthcarePlaceCard: View {
    let place: HealthcarePlace
    
    var body: some View {
        VStack(spacing: 15) {
            ProfileInfoRow(
                icon: place.icon,
                title: place.name,
                value: String(format: "%.1f km", place.distance),
                color: .red
            )
            
            ProfileInfoRow(
                icon: "location.fill",
                title: "Address",
                value: place.address,
                color: .red
            )
            
            Button(action: {
                openInMaps(coordinate: place.coordinate, name: place.name)
            }) {
                HStack {
                    Image(systemName: "arrow.up.right.square")
                    Text("Navigate")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.red)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func openInMaps(coordinate: CLLocationCoordinate2D, name: String) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("LocationManager initialized")
    }
    
    func requestLocationPermission() {
        print("Requesting location permission...")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print("Location updated: \(locations.last?.coordinate.latitude ?? 0), \(locations.last?.coordinate.longitude ?? 0)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location authorization changed to: \(status.rawValue)")
        locationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Starting location updates...")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

struct HospitalDetailView: View {
    let hospital: HealthcarePlace
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                TinyStepsDesign.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 15) {
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                                .background(Circle().fill(.white).frame(width: 80, height: 80))
                            
                            Text(hospital.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(hospital.address)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        // Distance Info
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.red)
                                Text("Distance")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(String(format: "%.1f km", hospital.distance))
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            // Navigate Button
                            Button(action: {
                                openInMaps(coordinate: hospital.coordinate, name: hospital.name)
                            }) {
                                HStack {
                                    Image(systemName: "arrow.up.right.square")
                                        .font(.title2)
                                    Text("Navigate to Hospital")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                            }
                            
                            // Call Button (if available)
                            Button(action: {
                                // This would typically open phone app with hospital number
                                // For now, we'll show an alert
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .font(.title2)
                                    Text("Call Hospital")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            // Emergency Services Info
                            VStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                    Text("Emergency Services Available")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                Text("This hospital provides emergency care and neonatal services. In case of emergency, call 999 or go directly to the emergency department.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                        }
                        
                        // Additional Information
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Hospital Information")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            InfoRow(icon: "clock.fill", title: "Emergency Department", value: "24/7")
                            InfoRow(icon: "cross.case.fill", title: "Neonatal Unit", value: "Available")
                            InfoRow(icon: "car.fill", title: "Parking", value: "Available")
                            InfoRow(icon: "wifi", title: "WiFi", value: "Free")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .navigationTitle("Hospital Details")
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
    
    private func openInMaps(coordinate: CLLocationCoordinate2D, name: String) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}

#Preview {
    SupportView()
}
