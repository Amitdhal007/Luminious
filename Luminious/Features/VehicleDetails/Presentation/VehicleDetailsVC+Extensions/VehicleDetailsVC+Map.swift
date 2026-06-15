import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation)
        else {
            return nil
        }
        
        // MARK: - Start
        
        if annotation is StartAnnotation {
            
            let identifier =
            "StartAnnotation"
            
            let view: MKMarkerAnnotationView
            
            if let reused =
                mapView.dequeueReusableAnnotationView(
                    withIdentifier:
                        identifier
                ) as? MKMarkerAnnotationView {
                
                view = reused
                
            } else {
                
                view =
                MKMarkerAnnotationView(
                    annotation:
                        annotation,
                    
                    reuseIdentifier:
                        identifier
                )
            }
            
            view.annotation =
            annotation
            
            view.glyphText =
            "S"
            
            view.markerTintColor =
                .systemGreen
            
            view.displayPriority =
                .required
            
            return view
        }
        
        // MARK: - End
        
        if annotation is EndAnnotation {
            
            let identifier =
            "EndAnnotation"
            
            let view: MKMarkerAnnotationView
            
            if let reused =
                mapView.dequeueReusableAnnotationView(
                    withIdentifier:
                        identifier
                ) as? MKMarkerAnnotationView {
                
                view = reused
                
            } else {
                
                view =
                MKMarkerAnnotationView(
                    annotation:
                        annotation,
                    
                    reuseIdentifier:
                        identifier
                )
            }
            
            view.annotation =
            annotation
            
            view.glyphText =
            "E"
            
            view.markerTintColor =
                .systemRed
            
            view.displayPriority =
                .required
            
            return view
        }
        
        // MARK: - Vehicle
        
        if annotation is PlayBackVehicleAnnotation {
            
            let view =
            mapView.dequeueReusableAnnotationView(
                withIdentifier:
                    PlayBackVehicleAnnotationView
                    .reuseIdentifier
            ) as? PlayBackVehicleAnnotationView
            ??
            PlayBackVehicleAnnotationView(
                annotation: annotation,
                reuseIdentifier:
                    PlayBackVehicleAnnotationView
                    .reuseIdentifier
            )
            
            view.annotation =
            annotation
            
            return view
        }
        
        return nil
    }
    
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        
        guard let polyline =
                overlay as? MKPolyline
        else {
            return MKOverlayRenderer()
        }
        
        let renderer =
        MKPolylineRenderer(
            polyline: polyline
        )
        
        if overlay === fullRouteOverlay {
            
            renderer.strokeColor =
            UIColor.red
                .withAlphaComponent(
                    0.7
                )
            
            renderer.lineWidth = 6
            
        } else {
            
            renderer.strokeColor =
            UIColor(
                red: 0.22,
                green: 0.70,
                blue: 1,
                alpha: 1
            )
            
            renderer.lineWidth = 8
            
            renderer.lineCap =
                .round
            
            renderer.lineJoin =
                .round
        }
        
        return renderer
    }
}
