import Foundation

/// Repository responsible for managing Route persistence.
///
/// Design intent:
/// - Abstracts persistence layer (CoreData / API / cache)
/// - Provides domain-level access to Route entities
/// - Hides implementation details from business logic
protocol RouteRepository {

    /// Creates a new route for a specific vehicle
    func create(route: Route, for vehicleId: UUID) async throws

    /// Fetches the active route for a vehicle
    func fetchRoute(for vehicleId: UUID) async throws -> Route?

    /// Updates an existing route
    func update(route: Route) async throws

    /// Deletes a route by identifier
    func delete(routeId: UUID) async throws
}
