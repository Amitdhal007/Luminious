import Foundation

/// Domain entity representing a Route in the system.
///
/// A Route defines a path between a source and destination,
/// and tracks its lifecycle (created → running → completed).
final class Route {

    let id: UUID
    let routeName: String
    let totalDistance: Double
    let estimatedDuration: Double
    let createdAt: Date

    let sourceAddress: String?
    let destinationAddress: String?
    let routePoints: [RoutePoint]

    private(set) var status: RouteStatus
    private(set) var startedAt: Date?
    private(set) var completedAt: Date?

    init(
        id: UUID,
        routeName: String,
        totalDistance: Double,
        estimatedDuration: Double,
        createdAt: Date,
        sourceAddress: String?,
        destinationAddress: String?,
        status: RouteStatus,
        startedAt: Date?,
        completedAt: Date?,
        routePoints: [RoutePoint]
    ) {
        self.id = id
        self.routeName = routeName
        self.totalDistance = totalDistance
        self.estimatedDuration = estimatedDuration
        self.createdAt = createdAt
        self.sourceAddress = sourceAddress
        self.destinationAddress = destinationAddress
        self.status = status
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.routePoints = routePoints
    }
}

extension Route {

    /// Starts the route if it is not already running or completed.
    func start() {

        guard status == .created else { return }

        status = .running
        startedAt = startedAt ?? Date()
    }

    /// Marks the route as completed if it is currently running.
    func complete() {

        guard status == .running else { return }

        status = .completed
        completedAt = Date()
    }
}
