import MapKit

final class VehicleAnnotation:
    NSObject,
    MKAnnotation {

    let vehicleId: UUID
    var vehicle: Vehicle

    dynamic var coordinate:
        CLLocationCoordinate2D

    var title: String? {
        vehicle.driverName
    }

    var subtitle: String? {
        vehicle.vehicleNumber
    }

    init(vehicle: Vehicle) {

        self.vehicleId = vehicle.id
        self.vehicle = vehicle

        self.coordinate =
            CLLocationCoordinate2D(
                latitude: vehicle.currentLatitude,
                longitude: vehicle.currentLongitude
            )

        super.init()
    }
}


final class StartAnnotation: MKPointAnnotation { }

final class EndAnnotation: MKPointAnnotation { }

final class PlayBackVehicleAnnotation: MKPointAnnotation { }

final class PlayBackVehicleAnnotationView:
    MKAnnotationView
{

    static let reuseIdentifier =
        "VehicleAnnotationView"

    override var annotation: MKAnnotation? {

        didSet {

            image =
                UIImage.sedan

            canShowCallout =
                false
        }
    }

    func updateHeading(
        _ heading: CLLocationDirection,
        mapHeading: CLLocationDirection
    ) {

        let adjustedHeading =
            heading - mapHeading

        let radians =
            adjustedHeading * .pi / 180

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [
                .beginFromCurrentState,
                .curveLinear
            ]
        ) {

            self.transform =
                CGAffineTransform(
                    rotationAngle:
                        CGFloat(radians)
                )
        }
    }
}
