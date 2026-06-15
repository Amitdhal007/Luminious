import MapKit
import UIKit

extension MapVC {

    public func setupMapView() {

        let mapView =
            MKMapView()

        mapView.translatesAutoresizingMaskIntoConstraints =
            false

        mapView.delegate =
            self

        mapView.showsUserLocation =
            true

        mapView.userTrackingMode =
            .none

        mapView.pointOfInterestFilter =
            .excludingAll

        mapView.showsCompass =
            false

        mapView.showsScale =
            false

        mapView.showsTraffic =
            false

        mapView.isRotateEnabled =
            true

        mapView.isPitchEnabled =
            true

        mapView.isZoomEnabled =
            true

        mapView.isScrollEnabled =
            true

        let configuration =
            MKStandardMapConfiguration(
                elevationStyle: .flat
            )

        configuration.pointOfInterestFilter =
            .excludingAll

        mapView.preferredConfiguration =
            configuration

        mapView.overrideUserInterfaceStyle =
            .dark

        mapView.cameraBoundary = nil
        mapView.cameraZoomRange =
            MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: 200,
                maxCenterCoordinateDistance: 50_000
            )

        mapView.layoutMargins.bottom = -100
        mapView.layoutMargins.top = -100

        mapContainerView
            .addSubview(
                mapView
            )

        NSLayoutConstraint.activate([

            mapView.topAnchor.constraint(
                equalTo:
                    mapContainerView.topAnchor
            ),

            mapView.leadingAnchor.constraint(
                equalTo:
                    mapContainerView.leadingAnchor
            ),

            mapView.trailingAnchor.constraint(
                equalTo:
                    mapContainerView.trailingAnchor
            ),

            mapView.bottomAnchor.constraint(
                equalTo:
                    mapContainerView.bottomAnchor
            ),
        ])

        self.mapView =
            mapView
    }

    public func centerOnUserLocation() {

       guard let coordinate =
            viewModel
        .locationManager
        .currentLocation?
        .coordinate
        else {
           
           showLocationPermissionAlert()
           
           return
       }

        let region =
            MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 2_000,
                longitudinalMeters: 2_000
            )

        mapView.setRegion(
            region,
            animated: true
        )
    }
}
