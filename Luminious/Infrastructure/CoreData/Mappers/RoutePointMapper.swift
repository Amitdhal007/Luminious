import Foundation

enum RoutePointMapper {

    static func toDomain(
        entity: RoutePointEntity
    ) -> RoutePoint {

        guard let id = entity.id else {
            fatalError(
                "Invalid RoutePointEntity state"
            )
        }

        return RoutePoint(
            id: id,
            latitude: entity.latitude,
            longitude: entity.longitude,
            heading: entity.heading,
            sequence: Int(entity.sequence)
        )
    }

    static func updateEntity(
        _ entity: RoutePointEntity,
        with point: RoutePoint
    ) {

        entity.id = point.id
        entity.latitude = point.latitude
        entity.longitude = point.longitude
        entity.heading = point.heading
        entity.sequence = Int32(
            point.sequence
        )
    }
}
