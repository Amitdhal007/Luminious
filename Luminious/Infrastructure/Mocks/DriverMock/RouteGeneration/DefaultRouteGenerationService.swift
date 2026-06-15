import CoreLocation
import MapKit

final class DefaultRouteGenerationService:
    RouteGenerationService {

    // MARK: - Dependencies

    private let geocodingService:
        GeocodingServiceing

    // MARK: - Init

    init(
        geocodingService: GeocodingServiceing
    ) {
        self.geocodingService =
            geocodingService
    }

    // MARK: - Public

    func generateRoute(
        near coordinate: CLLocationCoordinate2D
    ) async throws -> Route {

        let destination =
            coordinate.randomCoordinate(
                withinKilometers: 5
            )

        let sourceLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        let destinationLocation = CLLocation(
            latitude: destination.latitude,
            longitude: destination.longitude
        )

        let request =
            MKDirections.Request()

        request.source = MKMapItem(
            location: sourceLocation,
            address: nil
        )

        request.destination = MKMapItem(
            location: destinationLocation,
            address: nil
        )

        request.transportType =
            .automobile

        let response =
            try await MKDirections(
                request: request
            ).calculate()

        guard let mkRoute =
            response.routes.first
        else {
            throw RouteGenerationError
                .routeNotFound
        }

        let routePoints =
            mkRoute.polyline.routePoints()

        let startAddress =
            try? await geocodingService
            .reverseGeocodeShortAddress(
                sourceLocation
            )

        let destinationAddress =
            try? await geocodingService
            .reverseGeocodeShortAddress(
                destinationLocation
            )

        let routeName =
            makeRouteName(
                startAddress:
                    startAddress,
                destinationAddress:
                    destinationAddress
            )

        return Route(
            id: UUID(),

            routeName:
                routeName,

            totalDistance:
                mkRoute.distance,

            estimatedDuration:
                mkRoute.expectedTravelTime,

            createdAt:
                .now,

            sourceAddress:
                startAddress,

            destinationAddress:
                destinationAddress,

            status:
                    .running,

            startedAt:
                    .now,

            completedAt:
                nil,

            routePoints:
                routePoints
        )
    }
}

private extension DefaultRouteGenerationService {

    func makeRouteName(
        startAddress: String?,
        destinationAddress: String?
    ) -> String {

        switch (
            startAddress,
            destinationAddress
        ) {

        case let (
            start?,
            destination?
        ):

            return "\(start) → \(destination)"

        case let (
            start?,
            nil
        ):

            return "\(start) → Destination"

        case let (
            nil,
            destination?
        ):

            return "Origin → \(destination)"

        case (
            nil,
            nil
        ):

            return "Generated Route"
        }
    }
}
