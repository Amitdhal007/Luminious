import CoreLocation
import Foundation

extension VehicleDetailsViewModel {

    func loadRoute() async throws {

        route =
            try await routeRepository
            .fetchRoute(
                for: vehicle.id
            )
    }

    func fetchRoute() async throws -> [CLLocationCoordinate2D] {

        if route == nil {

            try await loadRoute()
        }

        return route?
            .routePoints
            .map {

                CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            } ?? []
    }
}
