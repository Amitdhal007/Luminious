import CoreLocation
import Combine

protocol LocationProviding {
    
    var currentLocation: CLLocation { get }
    var currentLocationPublisher: AnyPublisher<CLLocation, Never> { get }
    
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func requestLocation()
    func isLocationEnabled() -> Bool
}
