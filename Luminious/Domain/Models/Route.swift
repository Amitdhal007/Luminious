import Foundation

final class Route {

    let id: UUID

    let routeName: String

    let totalDistance: Double

    let estimatedDuration: Double

    let createdAt: Date

    let sourceAddress: String?

    let destinationAddress: String?

    var status: RouteStatus

    let routePoints: [RoutePoint]

    var startedAt: Date?

    var completedAt: Date?

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

// MARK: - Actions

extension Route {

    public func start() {

        status = .running

        if startedAt == nil {
            startedAt = .now
        }
    }

    public func complete() {

        status = .completed
        completedAt = .now
    }
}
