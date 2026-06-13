import Foundation

protocol VehicleRepository {

    func create(
        vehicle: Vehicle,
        sessionId: UUID
    ) async throws

    func fetchVehicles(
        sessionId: UUID
    ) async throws -> [Vehicle]

    func update(
        vehicle: Vehicle
    ) async throws

    func delete(
        vehicleId: UUID
    ) async throws
}
