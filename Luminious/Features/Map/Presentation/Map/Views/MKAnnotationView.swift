import MapKit

final class VehicleAnnotation:
    NSObject,
    MKAnnotation
{

    let vehicleId: UUID
    var vehicle: Vehicle

    dynamic var coordinate: CLLocationCoordinate2D

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
