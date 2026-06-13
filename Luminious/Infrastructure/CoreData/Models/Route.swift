import Foundation

final class Route {

    let id: UUID

    let routeName: String

    let totalDistance: Double

    let estimatedDuration: Double

    let createdAt: Date

    let routePoints: [RoutePoint]

    init(
        id: UUID,
        routeName: String,
        totalDistance: Double,
        estimatedDuration: Double,
        createdAt: Date,
        routePoints: [RoutePoint]
    ) {
        self.id = id
        self.routeName = routeName
        self.totalDistance = totalDistance
        self.estimatedDuration = estimatedDuration
        self.createdAt = createdAt
        self.routePoints = routePoints
    }
}
