import Foundation

enum RouteMapper {

    static func toDomain(
        entity: RouteEntity
    ) -> Route {

        guard
            let id = entity.id,
            let routeName = entity.routeName,
            let createdAt = entity.createdAt,
            let status =
                RouteStatus(
                    rawValue:
                        entity.status
                )
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
            totalDistance:
                entity.totalDistance,
            estimatedDuration:
                entity.estimatedDuration,
            createdAt:
                createdAt,
            sourceAddress:
                entity.sourceAddress,
            destinationAddress:
                entity.destinationAddress,
            status:
                status,
            startedAt:
                entity.startedAt,
            completedAt:
                entity.completedAt,
            routePoints:
                points
        )
    }

    static func updateEntity(
        _ entity: RouteEntity,
        with route: Route
    ) {

        entity.id =
            route.id

        entity.routeName =
            route.routeName

        entity.totalDistance =
            route.totalDistance

        entity.estimatedDuration =
            route.estimatedDuration

        entity.createdAt =
            route.createdAt

        entity.sourceAddress =
            route.sourceAddress

        entity.destinationAddress =
            route.destinationAddress

        entity.status =
            route.status.rawValue

        entity.startedAt =
            route.startedAt

        entity.completedAt =
            route.completedAt
    }
}
