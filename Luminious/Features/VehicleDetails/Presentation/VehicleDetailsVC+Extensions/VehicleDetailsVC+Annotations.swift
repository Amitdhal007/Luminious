import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC {
    
    internal func addMarkers(
        _ coordinates: [CLLocationCoordinate2D]
    ) {
        
        guard
            let first = coordinates.first,
            let last = coordinates.last
        else {
            return
        }
        
        let start =
        StartAnnotation()
        
        start.coordinate =
        first
        
        let end =
        EndAnnotation()
        
        end.coordinate =
        last
        
        playbackMapView.addAnnotations(
            [
                start,
                end
            ]
        )
        
        startAnnotation =
        start
        
        endAnnotation =
        end
        
        createVehicleMarker(
            first
        )
    }
    
    internal func createVehicleMarker(
        _ coordinate: CLLocationCoordinate2D
    ) {
        
        let vehicle =
        PlayBackVehicleAnnotation()
        
        vehicle.coordinate =
        coordinate
        
        playbackMapView.addAnnotation(
            vehicle
        )
        
        vehicleAnnotation =
        vehicle
    }
}
