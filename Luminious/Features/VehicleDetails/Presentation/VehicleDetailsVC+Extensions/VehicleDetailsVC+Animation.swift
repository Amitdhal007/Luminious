import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC {
    
    @MainActor
    internal func animateVehicle(
        to coordinate:
        CLLocationCoordinate2D
    ) async {
        
        guard let annotation =
                vehicleAnnotation
        else {
            return
        }
        
        animatedCoordinates
            .append(
                coordinate
            )
        
        let current =
        annotation.coordinate
        
        let steps =
        25
        
        for step in 0...steps {
            
            guard !Task.isCancelled
            else {
                return
            }
            
            guard viewIfLoaded?.window != nil
            else {
                return
            }
            
            let progress =
            Double(step)
            / Double(steps)
            
            let latitude =
            current.latitude
            +
            (
                coordinate.latitude
                -
                current.latitude
            )
            *
            progress
            
            let longitude =
            current.longitude
            +
            (
                coordinate.longitude
                -
                current.longitude
            )
            *
            progress
            
            annotation.coordinate =
            CLLocationCoordinate2D(
                latitude:
                    latitude,
                
                longitude:
                    longitude
            )
            
            if step % 4 == 0 {
                
                updateProgressRoute()
            }
            
            playbackMapView.setCenter(
                annotation.coordinate,
                animated: false
            )
            
            do {
                
                try await Task.sleep(
                    for:
                            .milliseconds(
                                25
                            )
                )
                
            } catch {
                
                return
            }
        }
        
        updateProgressRoute()
    }
    
    internal func updateProgressRoute() {
        
        guard
            animatedCoordinates.count > 1
        else {
            return
        }
        
        playbackMapView
            .removeOverlays(
                playbackMapView
                    .overlays
                    .filter {
                        $0 !== fullRouteOverlay
                    }
            )
        
        let progress =
        MKPolyline(
            coordinates:
                animatedCoordinates,
            count:
                animatedCoordinates.count
        )
        
        progressOverlay =
        progress
        
        guard let fullRouteOverlay = fullRouteOverlay
        else {
            return
        }
        
        playbackMapView.insertOverlay(
            progress,
            above:
                fullRouteOverlay
        )
    }
}
