import Foundation

extension VehicleDetailsViewModel {

    var driverName: String {
        vehicle.driverName
    }

    var rating: String {

        String(
            format: "%.1f",
            vehicle.rating
        )
    }

    var vehicleNumber: String {
        vehicle.vehicleNumber
    }

    var vehicleType: String {
        vehicle.vehicleType.rawValue
    }

    var locationText: String {

        let latitude =
            String(
                format: "%.5f",
                vehicle.currentLatitude
            )

        let longitude =
            String(
                format: "%.5f",
                vehicle.currentLongitude
            )

        let direction =
            DirectionMapper.compassDirection(
                from: vehicle.currentHeading
            )

        return "\(direction) • \(latitude), \(longitude)"
    }

    var fromLocation: String {
        route?.sourceAddress ?? "-"
    }

    var fromTime: String {

        route?.startedAt?
            .formatted(
                date: .omitted,
                time: .shortened
            ) ?? "-"
    }

    var toLocation: String {
        route?.destinationAddress ?? "-"
    }

    var toTime: String {

        route?.completedAt?
            .formatted(
                date: .omitted,
                time: .shortened
            ) ?? "-"
    }

    var tripDate: String {

        route?.createdAt
            .formatted(
                date: .abbreviated,
                time: .omitted
            ) ?? "-"
    }

    var totalDistance: String {

        guard let route
        else {
            return "-"
        }

        return String(
            format: "%.1f km",
            route.totalDistance / 1000
        )
    }

    var estimatedDuration: String {

        guard let route
        else {
            return "-"
        }

        let minutes =
            Int(
                route.estimatedDuration / 60
            )

        return "\(minutes) min"
    }
}
