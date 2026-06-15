import Foundation

/// Repository responsible for managing Vehicle persistence.
///
/// Design intent:
/// - Abstracts persistence layer (CoreData / API / cache)
/// - Ensures Vehicles are scoped to a Session
/// - Provides CRUD operations for Vehicle entity
///
/// Assumptions:
/// - A Vehicle belongs to exactly one Session
/// - Session scoping is required for retrieval operations
protocol VehicleRepository {

    /// Creates a new vehicle under a specific session
    func create(vehicle: Vehicle, sessionId: UUID) async throws

    /// Fetches all vehicles belonging to a session
    func fetchVehicles(sessionId: UUID) async throws -> [Vehicle]

    /// Updates an existing vehicle
    func update(vehicle: Vehicle) async throws

    /// Deletes a vehicle by identifier
    func delete(vehicleId: UUID) async throws
}
