import MapKit

extension MapVC {

    public func updateVehicleAnnotations(
        _ vehicles: [Vehicle]
    ) {

        let existingAnnotations =
            mapView.annotations.filter {
                !($0 is MKUserLocation)
            }

        mapView.removeAnnotations(
            existingAnnotations
        )

        viewModel.annotationMap = [:]

        for vehicle in vehicles {

            let annotation =
                VehicleAnnotation(
                    vehicle: vehicle
                )

            viewModel.annotationMap[vehicle.id] =
                annotation

            mapView.addAnnotation(
                annotation
            )
        }
    }

    public func animateVehicleUpdates(
        _ vehicles: [Vehicle]
    ) {

        for vehicle in vehicles {

            guard
                let annotation =
                    viewModel.annotationMap[vehicle.id]
            else {

                let newAnnotation =
                    VehicleAnnotation(
                        vehicle: vehicle
                    )

                viewModel.annotationMap[vehicle.id] =
                    newAnnotation

                mapView.addAnnotation(
                    newAnnotation
                )

                continue
            }

            annotation.vehicle = vehicle

            let newCoordinate =
                CLLocationCoordinate2D(
                    latitude: vehicle.currentLatitude,
                    longitude: vehicle.currentLongitude
                )

            let vehicleHeading =
                vehicle.currentHeading

            let annotationView =
                mapView.view(
                    for: annotation
                )

            UIView.animate(
                withDuration: 5.0,
                delay: 0,
                options: [
                    .beginFromCurrentState,
                    .allowUserInteraction,
                ]
            ) { [weak self] in

                guard let self
                else {
                    return
                }

                annotation.coordinate =
                    newCoordinate

                let mapHeading =
                    mapView.camera.heading

                let adjustedHeading =
                    vehicleHeading - mapHeading

                let radians =
                    CGFloat(
                        adjustedHeading * .pi / 180
                    )

                annotationView?.transform =
                    CGAffineTransform(
                        rotationAngle: radians
                    )
            }
        }
    }
}
