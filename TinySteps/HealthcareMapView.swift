import SwiftUI
#if canImport(MapKit)
import MapKit
#endif
#if canImport(CoreLocation)
import CoreLocation
#endif

struct HealthcareMapView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var countryManager = CountryHealthServicesManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // London default
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedPlace: HealthcarePlace?
    @State private var showingPlaceDetail = false
    
    var body: some View {
        ZStack {
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Healthcare Map")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Find nearby healthcare facilities")
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
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Map
                ZStack {
                    Map(position: .constant(.region(region))) {
                        ForEach(healthcarePlaces) { place in
                            Annotation(place.name, coordinate: place.coordinate) {
                                Button(action: {
                                    selectedPlace = place
                                    showingPlaceDetail = true
                                }) {
                                    VStack(spacing: 2) {
                                        Image(systemName: place.type.icon)
                                            .font(.title2)
                                            .foregroundColor(place.type.color)
                                            .background(
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 30, height: 30)
                                            )
                                            .shadow(radius: 2)
                                        
                                        Text(place.name)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(4)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Map Controls
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Button(action: {
                                    if let location = locationManager.currentLocation {
                                        region.center = location.coordinate
                                    }
                                }) {
                                    Image(systemName: "location.fill")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.blue.opacity(0.8))
                                        .clipShape(Circle())
                                }
                                
                                Button(action: {
                                    region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                }) {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.blue.opacity(0.8))
                                        .clipShape(Circle())
                                }
                                
                                Button(action: {
                                    region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                }) {
                                    Image(systemName: "minus")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.blue.opacity(0.8))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.trailing)
                        }
                        .padding(.bottom)
                    }
                }
                
                // Places List
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Nearby Facilities")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(healthcarePlaces.count) places")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(healthcarePlaces) { place in
                                HealthcarePlaceCard(place: place) {
                                    selectedPlace = place
                                    showingPlaceDetail = true
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Healthcare Map")
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
                region.center = location.coordinate
                countryManager.detectCountryFromLocation(location)
            }
        }
        .sheet(isPresented: $showingPlaceDetail) {
            if let place = selectedPlace {
                NavigationView {
                    HospitalDetailView(place: place)
                }
            }
        }
    }
    
    var healthcarePlaces: [HealthcarePlace] {
        // Sample healthcare places - in a real app, this would come from an API
        return [
            HealthcarePlace(
                name: "St. Thomas' Hospital",
                type: .hospital,
                coordinate: CLLocationCoordinate2D(latitude: 51.4994, longitude: -0.1195),
                address: "Westminster Bridge Road, London SE1 7EH",
                phone: "020 7188 7188",
                website: "www.guysandstthomas.nhs.uk"
            ),
            HealthcarePlace(
                name: "Guy's Hospital",
                type: .hospital,
                coordinate: CLLocationCoordinate2D(latitude: 51.5033, longitude: -0.0876),
                address: "Great Maze Pond, London SE1 9RT",
                phone: "020 7188 7188",
                website: "www.guysandstthomas.nhs.uk"
            ),
            HealthcarePlace(
                name: "Evelina London Children's Hospital",
                type: .childrensHospital,
                coordinate: CLLocationCoordinate2D(latitude: 51.4994, longitude: -0.1195),
                address: "Westminster Bridge Road, London SE1 7EH",
                phone: "020 7188 7188",
                website: "www.evelinalondon.nhs.uk"
            ),
            HealthcarePlace(
                name: "Boots Pharmacy",
                type: .pharmacy,
                coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
                address: "123 Oxford Street, London W1D 1AB",
                phone: "020 7123 4567",
                website: "www.boots.com"
            )
        ]
    }
}



struct HealthcarePlaceCard: View {
    let place: HealthcarePlace
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: place.type.icon)
                    .font(.title2)
                    .foregroundColor(place.type.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(place.address)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                    
                    Text(place.type.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(place.type.color.opacity(0.3))
                        .foregroundColor(place.type.color)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct HospitalDetailView: View {
    let place: HealthcarePlace
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
                            Text(place.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(place.type.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Image(systemName: place.type.icon)
                            .font(.title)
                            .foregroundColor(place.type.color)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Details
                VStack(spacing: 15) {
                    DetailRow(icon: "location.fill", title: "Address", value: place.address, color: .blue)
                    DetailRow(icon: "phone.fill", title: "Phone", value: place.phone, color: .green)
                    DetailRow(icon: "globe", title: "Website", value: place.website, color: .orange)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Hospital Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        HealthcareMapView()
    }
} 