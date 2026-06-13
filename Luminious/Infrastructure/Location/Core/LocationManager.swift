import Combine
import CoreLocation

final class LocationManager: NSObject, LocationProviding {
    
    @Published private var location: CLLocation = .init(
        latitude: 39.8283,
        longitude: -98.5795
    )
    
    public var currentLocation: CLLocation {
        location
    }
    
    public var currentLocationPublisher: AnyPublisher<CLLocation, Never> {
        $location.eraseToAnyPublisher()
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
}
extension LocationManager {
    
    public var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    public func isLocationEnabled() -> Bool {
        switch authorizationStatus {
        case .notDetermined, .denied, .restricted:
            return false
        default:
            return true
        }
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let locations = locations.last
        else {
            return
        }
        
        location = locations
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard isLocationEnabled()
        else {
            return
        }

        locationManager.requestLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        
        #if DEBUG
        print("LocationManager Error:", error.localizedDescription)
        #endif
    }
}
