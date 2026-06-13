import CoreLocation

final class DefaultSessionBootstrapService:
    SessionBootstrapService {

    private let vehicleRepository:
        VehicleRepository

    private let driverGenerator:
        DriverGenerationService

    private let routeGenerator:
        RouteGenerationService

    private let routeRepository:
        RouteRepository

    init(
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        driverGenerator: DriverGenerationService,
        routeGenerator: RouteGenerationService
    ) {

        self.vehicleRepository =
            vehicleRepository

        self.routeRepository =
            routeRepository

        self.driverGenerator =
            driverGenerator

        self.routeGenerator =
            routeGenerator
    }

    func bootstrap(
        session: Session,
        userLocation: CLLocationCoordinate2D
    ) async throws {

        let vehicles =
            driverGenerator.generateVehicles(
                count: session.vehicleCount
            )

        for vehicle in vehicles {

            let route =
                try await routeGenerator
                    .generateRoute(
                        near: userLocation
                    )

            guard let firstPoint =
                route.routePoints.first
            else {
                continue
            }

            let initializedVehicle =
                Vehicle(
                    id: vehicle.id,
                    driverName:
                        vehicle.driverName,
                    vehicleNumber:
                        vehicle.vehicleNumber,
                    vehicleType:
                        vehicle.vehicleType,
                    rating:
                        vehicle.rating,
                    currentLatitude:
                        firstPoint.latitude,
                    currentLongitude:
                        firstPoint.longitude,
                    currentHeading:
                        firstPoint.heading,
                    currentRouteIndex: 0,
                    isActive: true,
                    updatedAt: .now
                )

            try await vehicleRepository
                .create(
                    vehicle:
                        initializedVehicle,
                    sessionId:
                        session.id
                )

            try await routeRepository
                .create(
                    route: route,
                    vehicleId:
                        initializedVehicle.id
                )
        }
    }
}
