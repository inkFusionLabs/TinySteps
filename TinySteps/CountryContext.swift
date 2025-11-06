import Foundation
import SwiftUI
#if canImport(CoreLocation)
import CoreLocation
#endif

final class CountryContext: NSObject, ObservableObject {
    @Published var currentCountryCode: String = "GB"
    @Published var currentCountryName: String = "United Kingdom"
    @Published var emergencyNumber: String = "999"

    @Published var healthInfoManager = CountryHealthInfoManager()
    @Published var servicesManager = CountryHealthServicesManager()

    private let locationManager = LocationManager()

    override init() {
        super.init()
        // Seed with device locale if available, fallback to GB
        let localeCode = Locale.current.region?.identifier.uppercased() ?? "GB"
        updateCountry(to: localeCode)

        // Request location to refine detection when available
        locationManager.requestLocationPermission()

        // Observe location updates to refine country selection
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                self.servicesManager.detectCountryFromLocation(location)
                // After servicesManager resolves, sync codes/names across
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateCountry(to: self.servicesManager.getCountryCode())
                }
            }
            .store(in: &cancellables)
    }

    func updateCountry(to countryCode: String) {
        let upper = countryCode.uppercased()
        currentCountryCode = upper
        servicesManager.updateCountryServices(countryCode: upper)
        healthInfoManager.updateCountry(countryCode: upper)
        currentCountryName = servicesManager.getCountryName()
        emergencyNumber = servicesManager.getEmergencyNumber()
    }

    private var cancellables: Set<AnyCancellable> = []
}

import Combine








