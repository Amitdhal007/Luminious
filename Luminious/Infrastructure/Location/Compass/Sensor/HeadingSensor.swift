import CoreLocation

final class HeadingSensor: NSObject, HeadingSensoring {
    
    weak var delegate: HeadingSensorDelegate?
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        guard CLLocationManager.headingAvailable() else { return }
        manager.startUpdatingHeading()
    }
    
    func stop() {
        manager.stopUpdatingHeading()
    }
}

extension HeadingSensor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.didUpdateRawHeading(CGFloat(newHeading.trueHeading))
    }
}
