import Combine
import CoreLocation

protocol LocationProviding {

    var currentLocation: CLLocation? { get }

    var currentLocationPublisher:
        AnyPublisher<CLLocation?, Never> {
        get
    }

    var authorizationStatus:
        CLAuthorizationStatus {
        get
    }

    var authorizationStatusPublisher:
        AnyPublisher<
            CLAuthorizationStatus,
            Never
        > {
        get
    }

    func requestWhenInUseAuthorization()

    func requestLocation()

    func startUpdatingLocation()

    func stopUpdatingLocation()

    func isLocationEnabled() -> Bool

    func getCurrentLocation()
        async throws
        -> CLLocation
}
