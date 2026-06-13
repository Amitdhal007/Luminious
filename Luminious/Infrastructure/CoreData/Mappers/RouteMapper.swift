import Foundation

enum RouteMapper {

    static func toDomain(
        entity: RouteEntity
    ) -> Route {

        guard
            let id = entity.id,
            let routeName = entity.routeName,
            let createdAt = entity.createdAt
        else {
            fatalError(
                "Invalid RouteEntity state"
            )
        }

        let points =
            ((entity.routePoints as? Set<RoutePointEntity>) ?? [])
            .sorted {
                $0.sequence < $1.sequence
            }
            .map {
                RoutePointMapper.toDomain(
                    entity: $0
                )
            }

        return Route(
            id: id,
            routeName: routeName,
            totalDistance: entity.totalDistance,
            estimatedDuration: entity.estimatedDuration,
            createdAt: createdAt,
            routePoints: points
        )
    }

    static func updateEntity(
        _ entity: RouteEntity,
        with route: Route
    ) {

        entity.id = route.id
        entity.routeName = route.routeName
        entity.totalDistance = route.totalDistance
        entity.estimatedDuration =
            route.estimatedDuration
        entity.createdAt = route.createdAt
    }
}
