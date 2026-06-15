import Foundation

final class Session {

    let id: UUID

    let name: String

    var status: SessionStatus

    var vehicleCount: Int

    let createdAt: Date

    var updatedAt: Date

    // MARK: - Trip Lifecycle

    var tripStartedAt: Date?

    var tripEndedAt: Date?

    init(
        id: UUID,
        name: String,
        status: SessionStatus,
        vehicleCount: Int,
        createdAt: Date,
        updatedAt: Date,
        tripStartedAt: Date?,
        tripEndedAt: Date?
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.vehicleCount = vehicleCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tripStartedAt = tripStartedAt
        self.tripEndedAt = tripEndedAt
    }

    // MARK: - Actions

    public func startTrip() {
        status = .running
        tripStartedAt = Date()
        updatedAt = Date()
    }

    public func endTrip() {
        status = .completed
        tripEndedAt = Date()
        updatedAt = Date()
    }
}
