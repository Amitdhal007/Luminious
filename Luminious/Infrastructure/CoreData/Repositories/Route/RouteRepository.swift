import Foundation

protocol RouteRepository {

    func create(
        route: Route,
        vehicleId: UUID
    ) async throws

    func fetchRoute(
        vehicleId: UUID
    ) async throws -> Route?

    func update(
        route: Route
    ) async throws

    func delete(
        routeId: UUID
    ) async throws
}
