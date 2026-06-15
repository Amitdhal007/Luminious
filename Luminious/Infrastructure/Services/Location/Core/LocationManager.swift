import Combine
import CoreLocation

@MainActor
final class LocationManager:
    NSObject,
    LocationProviding
{
    
    // MARK: Published
    
    @Published
    private var location: CLLocation?
    
    @Published
    private var authStatus: CLAuthorizationStatus
    
    // MARK: Public
    
    var currentLocation: CLLocation? {
        location
    }
    
    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
        
        $location
            .eraseToAnyPublisher()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        
        authStatus
    }
    
    var authorizationStatusPublisher:
    AnyPublisher<
        CLAuthorizationStatus,
        Never
    >
    {
        
        $authStatus
            .eraseToAnyPublisher()
    }
    
    // MARK: Private
    
    private let locationManager =
    CLLocationManager()
    
    private var continuations:
    [CheckedContinuation<
     CLLocation,
     Error
     >] = []
    
    // MARK: Init
    
    override init() {
        
        authStatus =
        locationManager
            .authorizationStatus
        
        super.init()
        
        configure()
    }
}

// MARK: Setup

extension LocationManager {
    
    private func configure() {
        
        locationManager.delegate =
        self
        
        locationManager.desiredAccuracy =
        kCLLocationAccuracyBestForNavigation
        
        locationManager.distanceFilter =
        5
        
        locationManager
            .pausesLocationUpdatesAutomatically =
        false
    }
}

// MARK: Authorization

extension LocationManager {
    
    func requestWhenInUseAuthorization() {
        
        locationManager
            .requestWhenInUseAuthorization()
    }
    
    func isLocationEnabled()
    -> Bool
    {
        
        switch authStatus {
            
        case .authorizedAlways,
                .authorizedWhenInUse:
            
            return true
            
        default:
            
            return false
        }
    }
}

// MARK: Actions

extension LocationManager {
    
    func requestLocation() {
        
        guard isLocationEnabled()
        else {
            
            requestWhenInUseAuthorization()
            
            return
        }
        
        locationManager
            .requestLocation()
    }
    
    func startUpdatingLocation() {
        
        guard isLocationEnabled()
        else {
            
            requestWhenInUseAuthorization()
            
            return
        }
        
        locationManager
            .startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        
        locationManager
            .stopUpdatingLocation()
    }
    
    func getCurrentLocation()
    async throws
    -> CLLocation
    {
        
        if let location {
            return location
        }
        
        return try await withCheckedThrowingContinuation {
            continuation in
            
            continuations
                .append(
                    continuation
                )
            
            switch authStatus {
                
            case .authorizedAlways,
                    .authorizedWhenInUse:
                
                locationManager
                    .requestLocation()
                
            case .notDetermined:
                
                locationManager
                    .requestWhenInUseAuthorization()
                
            case .denied,
                    .restricted:
                
                continuation
                    .resume(
                        throwing:
                            LocationError
                            .permissionDenied
                    )
                
                continuations
                    .removeAll {
                        $0 as AnyObject
                        === continuation
                        as AnyObject
                    }
                
            @unknown default:
                
                continuation
                    .resume(
                        throwing:
                            LocationError
                            .locationUnavailable
                    )
                
                continuations
                    .removeAll {
                        $0 as AnyObject
                        === continuation
                        as AnyObject
                    }
            }
        }
    }
}

// MARK: Delegate

extension LocationManager:
    CLLocationManagerDelegate
{
    
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations:
        [CLLocation]
    ) {
        
        guard
            let latest =
                locations.last
        else {
            return
        }
        
        Task { @MainActor in
            
            self.location =
            latest
            
            let continuations =
            self.continuations
            
            self.continuations
                .removeAll()
            
            continuations
                .forEach {
                    $0.resume(
                        returning:
                            latest
                    )
                }
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        
        let status =
        manager.authorizationStatus
        
        Task { @MainActor in
            
            self.authStatus =
            status
            
            switch status {
                
            case .authorizedAlways,
                    .authorizedWhenInUse:
                
                if !self.continuations
                    .isEmpty
                {
                    
                    manager
                        .requestLocation()
                }
                
            case .denied,
                    .restricted:
                
                let continuations =
                self.continuations
                
                self.continuations
                    .removeAll()
                
                continuations
                    .forEach {
                        $0.resume(
                            throwing:
                                LocationError
                                .permissionDenied
                        )
                    }
                
            case .notDetermined:
                break
                
            @unknown default:
                
                let continuations =
                self.continuations
                
                self.continuations
                    .removeAll()
                
                continuations
                    .forEach {
                        $0.resume(
                            throwing:
                                LocationError
                                .locationUnavailable
                        )
                    }
            }
        }
    }
    
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        
        Task { @MainActor in
            
            let continuations =
            self.continuations
            
            self.continuations
                .removeAll()
            
            continuations
                .forEach {
                    $0.resume(
                        throwing:
                            error
                    )
                }
        }
        
#if DEBUG
        print("📍", error)
#endif
    }
}
