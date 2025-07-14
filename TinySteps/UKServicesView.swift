import SwiftUI
import CoreLocation

struct UKServicesView: View {
    @State private var postcode: String = ""
    @State private var services: [NeonatalService] = []
    
    let ukServices = [
        NeonatalService(name: "Bliss Charity", type: "Support", contact: "0808 801 0322", website: "www.bliss.org.uk"),
        NeonatalService(name: "Tommy's", type: "Research & Support", contact: "0800 0147 800", website: "www.tommys.org"),
        NeonatalService(name: "Sands", type: "Bereavement", contact: "0808 164 3332", website: "www.sands.org.uk"),
        NeonatalService(name: "NHS Neonatal Services", type: "Medical", contact: "111", website: "www.nhs.uk"),
        NeonatalService(name: "PANDAS Foundation", type: "Mental Health", contact: "0808 1961 776", website: "www.pandasfoundation.org.uk")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            TinyStepsDesign.Colors.background
                .ignoresSafeArea()
            
            VStack {
                // Postcode search
                HStack {
                    TextField("Enter UK postcode", text: $postcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: findServices) {
                        Text("Find")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Services list
                List(services.isEmpty ? ukServices : services) { service in
                    ServiceRow(service: service)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("UK Services")
    }
    
    func findServices() {
        // In a real app, this would query a database or API with the postcode
        // For now, we'll just filter our sample data
        if postcode.isEmpty {
            services = ukServices
        } else {
            services = ukServices.filter { $0.type == "Support" }
        }
    }
}

struct NeonatalService: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let contact: String
    let website: String
}

struct ServiceRow: View {
    let service: NeonatalService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(service.name)
                .font(.headline)
            
            HStack {
                Text(service.type)
                    .font(.caption)
                    .padding(4)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
                
                if !service.contact.isEmpty {
                    if let url = URL(string: "tel:\(service.contact)") {
                        Link(destination: url) {
                            Image(systemName: "phone")
                        }
                    }
                }
            }
            
            if !service.website.isEmpty {
                if let url = URL(string: "https://\(service.website)") {
                    Link(service.website, destination: url)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
