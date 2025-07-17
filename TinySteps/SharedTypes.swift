import SwiftUI
#if canImport(CoreLocation)
import CoreLocation
#endif

// Enhanced NeonatalService model
struct NeonatalService: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let contact: String
    let website: String
    let country: String
    
    var isContactAvailable: Bool {
        return !contact.isEmpty
    }
    
    var isWebsiteAvailable: Bool {
        return !website.isEmpty
    }
    
    var contactURL: URL? {
        guard isContactAvailable else { return nil }
        return URL(string: "tel:\(contact)")
    }
    
    var websiteURL: URL? {
        guard isWebsiteAvailable else { return nil }
        let urlString = website.hasPrefix("http") ? website : "https://\(website)"
        return URL(string: urlString)
    }
}

// Healthcare Place types
struct HealthcarePlace: Identifiable {
    var id = UUID()
    let name: String
    let type: HealthcarePlaceType
    let coordinate: CLLocationCoordinate2D
    let address: String
    let phone: String
    let website: String
}

enum HealthcarePlaceType: String, CaseIterable {
    case hospital = "Hospital"
    case childrensHospital = "Children's Hospital"
    case clinic = "Clinic"
    case pharmacy = "Pharmacy"
    case gp = "GP Surgery"
    
    var icon: String {
        switch self {
        case .hospital: return "building.2.fill"
        case .childrensHospital: return "heart.fill"
        case .clinic: return "cross.case.fill"
        case .pharmacy: return "pills.fill"
        case .gp: return "stethoscope"
        }
    }
    
    var color: Color {
        switch self {
        case .hospital: return .red
        case .childrensHospital: return .pink
        case .clinic: return .blue
        case .pharmacy: return .green
        case .gp: return .orange
        }
    }
} 