import Foundation

/// Represents a session that tracks a trip lifecycle and vehicle allocation.
///
/// Design intent:
/// - Encapsulates session lifecycle (created → running → completed)
/// - Maintains consistent timestamps for state transitions
/// - Ensures domain behavior is controlled through methods
final class Session {

    let id: UUID
    let name: String
    let createdAt: Date

    private(set) var status: SessionStatus
    private(set) var vehicleCount: Int
    private(set) var updatedAt: Date

    // MARK: - Trip Lifecycle

    private(set) var tripStartedAt: Date?
    private(set) var tripEndedAt: Date?

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
}
extension Session {

    /// Starts the trip if session is in valid state
    func startTrip() {

        guard status == .created else { return }

        status = .running
        tripStartedAt = Date()
        updatedAt = Date()
    }

    /// Ends the trip if currently running
    func endTrip() {

        guard status == .running else { return }

        status = .completed
        tripEndedAt = Date()
        updatedAt = Date()
    }

    /// Updates vehicle count safely
    func updateVehicleCount(_ count: Int) {
        vehicleCount = count
        updatedAt = Date()
    }
}
