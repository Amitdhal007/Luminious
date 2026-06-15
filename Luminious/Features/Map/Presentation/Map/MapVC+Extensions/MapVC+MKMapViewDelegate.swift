import MapKit
import UIKit

extension MapVC: MKMapViewDelegate {

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {

        guard
            annotation is VehicleAnnotation
        else {
            return nil
        }

        let identifier =
            "VehicleAnnotation"

        var view =
            mapView
            .dequeueReusableAnnotationView(
                withIdentifier:
                    identifier
            )

        if view == nil {

            view =
                MKAnnotationView(
                    annotation:
                        annotation,

                    reuseIdentifier:
                        identifier
                )

            view?.canShowCallout =
                false

        } else {

            view?.annotation =
                annotation
        }
        
        if let vehicleAnnotation = annotation as? VehicleAnnotation {
            view?.image =
            UIImage(named: vehicleAnnotation.vehicle.vehicleType.rawValue)
        }
            
        return view
    }

    func mapView(
        _ mapView: MKMapView,
        didSelect view: MKAnnotationView
    ) {

        guard
            let annotation =
                view.annotation
                as? VehicleAnnotation
        else {
            return
        }
        
        guard let session = viewModel.currentSession
        else {
            return
        }

        coordinator?
            .mapDidRequestVehicleDetails(
                session: session,
                vehicle: annotation.vehicle
            )
        
        mapView.deselectAnnotation(
            annotation,
            animated: false
        )
    }
}
