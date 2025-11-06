import Foundation
#if canImport(CoreLocation)
import CoreLocation
#endif
#if canImport(MapKit)
import MapKit
#endif

class CountryHealthServicesManager: NSObject, ObservableObject {
    @Published var currentCountry: String = "Unknown"
    @Published var currentCountryCode: String = "GB"
    @Published var healthServices: [NeonatalService] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let geocoder = CLGeocoder()
    
    // Country-specific health services database
    private var countryServices: [String: [NeonatalService]] = [
        "GB": [ // United Kingdom
            // Core Support Organizations
            NeonatalService(name: "Bliss Charity", type: "Premature Baby Support", contact: "0808 801 0322", website: "www.bliss.org.uk", country: "GB"),
            NeonatalService(name: "DadPad", type: "Father Support", contact: "", website: "www.dadpad.co.uk", country: "GB"),
            NeonatalService(name: "Mush", type: "Parent Communities", contact: "", website: "www.letsmush.com", country: "GB"),
            NeonatalService(name: "NICU Parent Network UK", type: "Online Community", contact: "", website: "", country: "GB"),
            
            // NHS Services
            NeonatalService(name: "NHS 111", type: "Health Advice", contact: "111", website: "www.nhs.uk", country: "GB"),
            NeonatalService(name: "NHS Healthier Together", type: "Health Information", contact: "", website: "www.healthiertogether.nhs.uk", country: "GB"),
            NeonatalService(name: "NHS IAPT Services", type: "Mental Health Therapy", contact: "", website: "www.nhs.uk/mental-health", country: "GB"),
            
            // Mental Health & Crisis Support
            NeonatalService(name: "Samaritans", type: "Crisis Support", contact: "116 123", website: "www.samaritans.org", country: "GB"),
            NeonatalService(name: "SHOUT Crisis Text", type: "Text Support", contact: "85258", website: "www.giveusashout.org", country: "GB"),
            NeonatalService(name: "Mind", type: "Mental Health", contact: "0300 123 3393", website: "www.mind.org.uk", country: "GB"),
            NeonatalService(name: "PANDAS Foundation", type: "Perinatal Mental Health", contact: "0808 1961 776", website: "www.pandasfoundation.org.uk", country: "GB"),
            
            // Research & Information
            NeonatalService(name: "Tommy's", type: "Research & Support", contact: "0800 0147 800", website: "www.tommys.org", country: "GB"),
            NeonatalService(name: "Sands", type: "Bereavement Support", contact: "0808 164 3332", website: "www.sands.org.uk", country: "GB"),
            
            // Hospital Networks
            NeonatalService(name: "Basingstoke & North Hampshire Hospital", type: "Level 2 NICU", contact: "01256 473202", website: "www.hampshirehospitals.nhs.uk", country: "GB"),
            NeonatalService(name: "Royal Berkshire Hospital", type: "Level 3 NICU", contact: "0118 322 5111", website: "www.royalberkshire.nhs.uk", country: "GB"),
            NeonatalService(name: "Southampton General Hospital", type: "Level 3 NICU", contact: "023 8077 7222", website: "www.uhs.nhs.uk", country: "GB"),
            NeonatalService(name: "John Radcliffe Hospital", type: "Level 3 NICU", contact: "01865 741166", website: "www.ouh.nhs.uk", country: "GB")
        ],
        "US": [ // United States
            NeonatalService(name: "March of Dimes", type: "Support", contact: "1-888-663-4637", website: "www.marchofdimes.org", country: "US"),
            NeonatalService(name: "NICU Parent Network", type: "Support", contact: "1-800-665-2433", website: "www.nicuparentnetwork.org", country: "US"),
            NeonatalService(name: "Hand to Hold", type: "Support", contact: "1-512-439-0099", website: "www.handtohold.org", country: "US"),
            NeonatalService(name: "Graham's Foundation", type: "Support", contact: "1-412-235-7555", website: "www.grahamsfoundation.org", country: "US"),
            NeonatalService(name: "PreemieWorld", type: "Information", contact: "", website: "www.preemieworld.com", country: "US")
        ],
        "CA": [ // Canada
            NeonatalService(name: "Canadian Premature Babies Foundation", type: "Support", contact: "1-855-5-PREEMIE", website: "www.cpbf-fbpc.org", country: "CA"),
            NeonatalService(name: "Canadian Neonatal Network", type: "Medical", contact: "", website: "www.canadianneonatalnetwork.org", country: "CA"),
            NeonatalService(name: "Preemie Parent Alliance", type: "Support", contact: "", website: "www.preemieparentalliance.org", country: "CA")
        ],
        "AU": [ // Australia
            NeonatalService(name: "Life's Little Treasures Foundation", type: "Support", contact: "1300 697 736", website: "www.lifeslittletreasures.org.au", country: "AU"),
            NeonatalService(name: "Miracle Babies Foundation", type: "Support", contact: "1300 622 243", website: "www.miraclebabies.org.au", country: "AU"),
            NeonatalService(name: "Australian Neonatal Network", type: "Medical", contact: "", website: "www.neonatal.com.au", country: "AU")
        ],
        "DE": [ // Germany
            NeonatalService(name: "Bundesverband Das frühgeborene Kind", type: "Support", contact: "+49 30 280 40 50", website: "www.fruehgeborene.de", country: "DE"),
            NeonatalService(name: "Deutsche Gesellschaft für Neonatologie", type: "Medical", contact: "", website: "www.neonatologie-gesellschaft.de", country: "DE")
        ],
        "FR": [ // France
            NeonatalService(name: "SOS Préma", type: "Support", contact: "01 45 35 63 70", website: "www.sosprema.com", country: "FR"),
            NeonatalService(name: "Société Française de Néonatologie", type: "Medical", contact: "", website: "www.neonatologie-francaise.com", country: "FR")
        ],
        "ES": [ // Spain
            NeonatalService(name: "APREM", type: "Support", contact: "+34 91 574 02 00", website: "www.aprem-e.org", country: "ES"),
            NeonatalService(name: "Sociedad Española de Neonatología", type: "Medical", contact: "", website: "www.neonatologia.com", country: "ES")
        ],
        "IT": [ // Italy
            NeonatalService(name: "Vivere Onlus", type: "Support", contact: "+39 02 8951 3867", website: "www.vivereonlus.com", country: "IT"),
            NeonatalService(name: "Società Italiana di Neonatologia", type: "Medical", contact: "", website: "www.neonatologia.it", country: "IT")
        ],
        "NL": [ // Netherlands
            NeonatalService(name: "Vereniging van Ouders van Couveusekinderen", type: "Support", contact: "+31 30 234 0021", website: "www.couveuseouders.nl", country: "NL"),
            NeonatalService(name: "Nederlandse Vereniging voor Kindergeneeskunde", type: "Medical", contact: "", website: "www.nvk.nl", country: "NL")
        ],
        "SE": [ // Sweden
            NeonatalService(name: "Prematurförbundet", type: "Support", contact: "+46 8 556 109 00", website: "www.prematurforbundet.se", country: "SE"),
            NeonatalService(name: "Svenska Neonatalföreningen", type: "Medical", contact: "", website: "www.neonatal.se", country: "SE")
        ],
        "NO": [ // Norway
            NeonatalService(name: "Prematurforeningen", type: "Support", contact: "+47 22 59 88 00", website: "www.prematurforeningen.no", country: "NO"),
            NeonatalService(name: "Norsk Neonatologisk Forening", type: "Medical", contact: "", website: "www.neonatal.no", country: "NO")
        ],
        "DK": [ // Denmark
            NeonatalService(name: "Prematurforeningen", type: "Support", contact: "+45 33 15 47 00", website: "www.prematurforeningen.dk", country: "DK"),
            NeonatalService(name: "Dansk Neonatologisk Selskab", type: "Medical", contact: "", website: "www.neonatal.dk", country: "DK")
        ],
        "FI": [ // Finland
            NeonatalService(name: "Ensiaskel ry", type: "Support", contact: "+358 9 454 2070", website: "www.ensiaskel.fi", country: "FI"),
            NeonatalService(name: "Suomen Neonatologiyhdistys", type: "Medical", contact: "", website: "www.neonatal.fi", country: "FI")
        ],
        "JP": [ // Japan
            NeonatalService(name: "Nihon Shouni Igakkai", type: "Medical", contact: "", website: "www.jpeds.or.jp", country: "JP"),
            NeonatalService(name: "Premature Baby Support Japan", type: "Support", contact: "", website: "www.premature.jp", country: "JP")
        ],
        "KR": [ // South Korea
            NeonatalService(name: "Korean Society of Neonatology", type: "Medical", contact: "", website: "www.neonatal.or.kr", country: "KR"),
            NeonatalService(name: "Premature Baby Support Korea", type: "Support", contact: "", website: "www.premature.kr", country: "KR")
        ],
        "CN": [ // China
            NeonatalService(name: "Chinese Society of Neonatology", type: "Medical", contact: "", website: "www.neonatal.cn", country: "CN"),
            NeonatalService(name: "Premature Baby Support China", type: "Support", contact: "", website: "www.premature.cn", country: "CN")
        ],
        "IN": [ // India
            NeonatalService(name: "National Neonatology Forum", type: "Medical", contact: "+91 11 2658 8500", website: "www.nnfi.org", country: "IN"),
            NeonatalService(name: "Premature Baby Support India", type: "Support", contact: "", website: "www.premature.in", country: "IN")
        ],
        "BR": [ // Brazil
            NeonatalService(name: "Sociedade Brasileira de Pediatria", type: "Medical", contact: "+55 21 2105 0300", website: "www.sbp.com.br", country: "BR"),
            NeonatalService(name: "Premature Baby Support Brazil", type: "Support", contact: "", website: "www.premature.br", country: "BR")
        ],
        "MX": [ // Mexico
            NeonatalService(name: "Sociedad Mexicana de Pediatría", type: "Medical", contact: "+52 55 5606 5757", website: "www.smp.org.mx", country: "MX"),
            NeonatalService(name: "Premature Baby Support Mexico", type: "Support", contact: "", website: "www.premature.mx", country: "MX")
        ],
        "AR": [ // Argentina
            NeonatalService(name: "Sociedad Argentina de Pediatría", type: "Medical", contact: "+54 11 4821 8612", website: "www.sap.org.ar", country: "AR"),
            NeonatalService(name: "Premature Baby Support Argentina", type: "Support", contact: "", website: "www.premature.ar", country: "AR")
        ],
        "ZA": [ // South Africa
            NeonatalService(name: "South African Paediatric Association", type: "Medical", contact: "+27 11 484 5209", website: "www.sapa.org.za", country: "ZA"),
            NeonatalService(name: "Premature Baby Support South Africa", type: "Support", contact: "", website: "www.premature.za", country: "ZA")
        ]
    ]
    
    // Country names mapping
    private var countryNames: [String: String] = [
        "GB": "United Kingdom",
        "US": "United States",
        "CA": "Canada",
        "AU": "Australia",
        "DE": "Germany",
        "FR": "France",
        "ES": "Spain",
        "IT": "Italy",
        "NL": "Netherlands",
        "SE": "Sweden",
        "NO": "Norway",
        "DK": "Denmark",
        "FI": "Finland",
        "JP": "Japan",
        "KR": "South Korea",
        "CN": "China",
        "IN": "India",
        "BR": "Brazil",
        "MX": "Mexico",
        "AR": "Argentina",
        "ZA": "South Africa"
    ]
    
    // Emergency numbers by country
    private var emergencyNumbers: [String: String] = [
        "GB": "999",
        "US": "911",
        "CA": "911",
        "AU": "000",
        "DE": "112",
        "FR": "112",
        "ES": "112",
        "IT": "112",
        "NL": "112",
        "SE": "112",
        "NO": "112",
        "DK": "112",
        "FI": "112",
        "JP": "119",
        "KR": "119",
        "CN": "120",
        "IN": "102",
        "BR": "192",
        "MX": "911",
        "AR": "911",
        "ZA": "10111"
    ]
    
    override init() {
        super.init()
        // Set default to UK services as primary focus
        self.currentCountryCode = "GB"
        self.currentCountry = "United Kingdom"
        self.healthServices = countryServices["GB"] ?? []
    }
    
    func detectCountryFromLocation(_ location: CLLocation) {
        isLoading = true
        errorMessage = nil
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Location detection failed: \(error.localizedDescription)"
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let countryCode = placemark.isoCountryCode else {
                    self?.errorMessage = "Could not determine country from location"
                    return
                }
                
                self?.updateCountryServices(countryCode: countryCode)
            }
        }
    }
    
    func updateCountryServices(countryCode: String) {
        let upperCountryCode = countryCode.uppercased()
        currentCountryCode = upperCountryCode
        currentCountry = countryNames[upperCountryCode] ?? "Unknown"
        
        if let services = countryServices[upperCountryCode] {
            healthServices = services
        } else {
            // Always fallback to UK services as primary focus
            healthServices = countryServices["GB"] ?? []
            currentCountryCode = "GB"
            currentCountry = "United Kingdom"
            errorMessage = "Services for \(currentCountry) are not yet available. Showing UK services as default."
        }
    }
    
    func getEmergencyNumber() -> String {
        return emergencyNumbers[currentCountryCode] ?? "999"
    }
    
    func getCountryName() -> String {
        return currentCountry
    }
    
    func getCountryCode() -> String {
        return currentCountryCode
    }
    
    func isCountrySupported() -> Bool {
        return countryServices[currentCountryCode] != nil
    }
    
    func getSupportedCountries() -> [String] {
        return Array(countryServices.keys).sorted()
    }
    
    func getCountryName(for code: String) -> String {
        return countryNames[code.uppercased()] ?? "Unknown"
    }
}

 