import CoreLocation
import Foundation

extension CLLocation {
    
    public func formattedDistance(
        to coordinate: CLLocationCoordinate2D,
        unit: UnitLength = .nauticalMiles,
        fractionDigits: Int = 1
    ) -> String {
        
        let targetLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        let distanceInMeters =
        distance(from: targetLocation)
        
        let measurement = Measurement(
            value: distanceInMeters,
            unit: UnitLength.meters
        )
        .converted(to: unit)
        
        return String(
            format: "%.\(fractionDigits)f %@",
            measurement.value,
            unit.symbol
        )
    }
}
